using FirebaseAdmin.Auth;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Reliefy.Application.BL.User.Commands;
using Reliefy.Application.BL.User.Queries.DoctorList;
using Reliefy.Application.Model.User;

namespace Reliefy.UI.Controllers;

public class UserController : ApiControllerBase
{
	[AllowAnonymous]
	[HttpPost("CreateUser")]
	public async Task<ActionResult<UserDto>> CreateUser(CreateUserCommand command)
	{
		command.RoleType = "PATIENT";
		var result = await Mediator.Send(command);
		if (result == null)
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
}