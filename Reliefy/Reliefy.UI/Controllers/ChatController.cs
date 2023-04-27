using Microsoft.AspNetCore.Mvc;
using Reliefy.Application.BL.ChatSession.Queries;

namespace Reliefy.UI.Controllers;

public class ChatController : ApiControllerBase
{
	[HttpGet("GetSession/{appointmentId}")]
	public async Task<ActionResult<ChatSessionDto>> GetSession(string appointmentId)
	{
		var command = new GetChatSessionQuery { AppointmentId = appointmentId };
		var result = await Mediator.Send(command);
		return Ok(result);
	}
}