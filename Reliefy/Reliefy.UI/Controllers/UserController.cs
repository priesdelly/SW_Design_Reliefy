using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Reliefy.Application.BL.User.Commands;
using Reliefy.Application.BL.User.Queries;
using Reliefy.Application.BL.User.Queries.DoctorList;
using Reliefy.Application.Model.User;
using Reliefy.Application.BL;

namespace Reliefy.UI.Controllers;

public class UserController : ApiControllerBase
{
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
	public async Task<ActionResult<ResponseMessage>> SendOtp(SendTwoFactorCommand command)
	{
		var result = await Mediator.Send(command);
		return Ok(result);
	}

	[HttpPost("CheckOtp")]
	public async Task<ActionResult<ResponseMessage>> CheckOtp(CheckTwoFactorCommand command)
	{
		var result = await Mediator.Send(command);
		return Ok(result);
	}
}