using Microsoft.EntityFrameworkCore;
using Reliefy.Application.Interfaces;
using Reliefy.Domain.Entities;
using System.Net;
using System.Net.Mail;

namespace Reliefy.Application.Services;

public class UserService : GenericService<User>
{
    public UserService(IApplicationDbContext context) : base(context)
    {
    }

    public async Task<TwoFactor> SendCode(string email)
    {
        var user = await _context.Users.FirstOrDefaultAsync(x => x.Email == email);
        if (user == null)
        {
            throw new Exception("User not found");
        }

        var code = new Random().Next(100000, 999999).ToString();
        var twoFactor = new TwoFactor
        {
            Email = email,
            Code = code,
            IsUsed = false,
            ExpireAt = DateTime.Now.AddMinutes(15),
            CreatedAt = DateTime.Now
        };

        var result = await sendEmail(twoFactor);
        if (!result)
        {
            throw new Exception("Failed to send email");
        }

        _context.TwoFactor.Add(twoFactor);
        await _context.SaveChangesAsync();

        twoFactor.Code = null;

        return twoFactor;
    }

    private async Task<bool> sendEmail(TwoFactor twoFactor)
    {
        try
        {
            var smtpServer = "sandbox.smtp.mailtrap.io";
            var smtpPort = 2525;
            var smtpUsername = "a43be61d75ea0d";
            var smtpPassword = "42586b73e481b9";


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
        }
        catch (Exception ex)
        {
            return false;
        }
        return true;
    }

    public async Task<TwoFactor> CheckCode(string email, string code)
    {
        var entity = await _context.TwoFactor.FirstOrDefaultAsync(x => x.Email == email && x.Code == code);
        if (entity == null)
        {
            throw new Exception("Code not found");
        }

        if (entity.IsUsed)
        {
            throw new Exception("Code already used");
        }

        if (entity.ExpireAt > DateTime.Now)
        {
            throw new Exception("Code expired");
        }

        return entity;
    }
}