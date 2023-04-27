using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Reliefy.Application.BL.User.Commands;
using Reliefy.Application.BL.User.Queries;
using Reliefy.Application.BL.User.Queries.DoctorList;
using Reliefy.Application.Interfaces;
using Reliefy.Application.Model.User;
using Reliefy.Domain.Entities;
using Reliefy.UI.Models;
using System.Net;
using System.Net.Mail;

namespace Reliefy.UI.Controllers;

public class UserController : ApiControllerBase
{
    private readonly IApplicationDbContext _context;

    public UserController(IApplicationDbContext context)
    {
        _context = context;
    }

    [AllowAnonymous]
    [HttpPost("CreateUser")]
    public async Task<ActionResult<UserDto>> CreateUser(CreateUserCommand command)
    {
        var result = await Mediator.Send(command);
        if (result == null)
        {
            return NotFound();
        }

        return Ok(result);
    }

    [HttpGet("GetUserInfo")]
    public async Task<ActionResult<UserDto>> GetUserInfo([FromQuery] GetUserInfoQuery command)
    {
        var result = await Mediator.Send(command);
        if (result is null)
        {
            return NotFound();
        }

        return Ok(result);
    }

    [HttpGet("GetListDoctors")]
    public async Task<ActionResult<List<UserDto>>> GetListDoctors()
    {
        var command = new GetDoctorListQuery();
        var result = await Mediator.Send(command);
        return Ok(result);
    }

    [HttpPost("SendOtp")]
    public async Task<ActionResult<BaseModel>> SendOtp([FromBody] SendOtpRequest request)
    {
        try
        {
            var code = new Random().Next(100000, 999999).ToString();
            var twoFactor = new TwoFactor
            {
                Email = request.Email,
                Code = code,
                IsUsed = false,
                ExpireAt = DateTime.Now.AddMinutes(15),
                CreatedAt = DateTime.Now
            };

            const string smtpServer = "sandbox.smtp.mailtrap.io";
            const int smtpPort = 2525;
            const string smtpUsername = "c835ef720ce075";
            const string smtpPassword = "e25e31c356e6c7";

            // Create the SMTP client object
            var client = new SmtpClient(smtpServer, smtpPort);
            client.Credentials = new NetworkCredential(smtpUsername, smtpPassword);
            client.EnableSsl = true;

            var message = new MailMessage();
            message.From = new MailAddress("noreply@reliefy.chat");
            message.To.Add(new MailAddress(twoFactor.Email));
            message.Subject = "Verify your identity";
            message.Body = $"Verification code: {twoFactor.Code}";

            client.Send(message);

            _context.TwoFactor.Add(twoFactor);
            await _context.SaveChangesAsync();
        }
        catch (Exception ex)
        {
            return new BaseModel()
            {
                Status = "error",
                Message = ex.Message
            };
        }
        return new BaseModel()
        {
            Status = "success",
        };
    }

    [AllowAnonymous]
    [HttpPost("CheckOtp")]
    public async Task<ActionResult<BaseModel>> CheckOtp([FromBody] CheckOtpRequest request)
    {
        var entity = await _context.TwoFactor.FirstOrDefaultAsync(x => x.Email == request.Email && x.Code == request.Code);
        if (entity == null)
        {
            return new BaseModel()
            {
                Status = "error",
                Message = "Email or code is not found"
            };
        }

        if (entity.IsUsed)
        {
            return new BaseModel()
            {
                Status = "error",
                Message = "code already used"
            };
        }

        if (entity.ExpireAt >= DateTime.Now)
        {
            return new BaseModel()
            {
                Status = "error",
                Message = "code expired"
            };
        }

        entity.IsUsed = true;
        _context.Entry(entity).Property(x => x.IsUsed).IsModified = true;
        await _context.SaveChangesAsync();

        return new BaseModel()
        {
            Status = "success",
        };
    }
}