using System.Threading.Tasks;
using MediatR;
using Microsoft.AspNetCore.Mvc;
using Reliefy.Application.BL.User.Commands;
using Reliefy.Application.Interfaces;
using Reliefy.Application.Model.User;

namespace Reliefy.UI.Controllers;

public class UserController : ApiControllerBase
{
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

	[HttpPost]
	public ActionResult Get()
	{
		return Ok("Test Ok");
	}
}