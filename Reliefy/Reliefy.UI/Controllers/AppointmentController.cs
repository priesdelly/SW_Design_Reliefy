using Microsoft.AspNetCore.Mvc;
using Reliefy.Application.BL.Appointment.Commands;
using Reliefy.Application.BL.Appointment.Queries;

namespace Reliefy.UI.Controllers;

public class AppointmentController : ApiControllerBase
{
	[HttpGet]
	public async Task<ActionResult<List<AppointmentDto>>> GetList()
	{
		var queryPatient = new GetAppointmentListQuery();
		var resultPatient = await Mediator.Send(queryPatient);
		return Ok(resultPatient);
	}

	[HttpPost]
	public async Task<ActionResult<AppointmentDto>> Create(CreateAppointmentCommand command)
	{
		var result = await Mediator.Send(command);
		return Ok(result);
	}

	[HttpGet("History")]
	public async Task<ActionResult<List<AppointmentDto>>> GetHistory()
	{
		var query = new GetAppointmentHistoryQuery();
		var resultPatient = await Mediator.Send(query);
		return Ok(resultPatient);
	}

	[HttpPut("Cancel/{appointmentId}")]
	public async Task<ActionResult<AppointmentDto>> Cancel(string appointmentId)
	{
		var command = new CancelAppointmentCommand { AppointmentId = appointmentId };
		var result = await Mediator.Send(command);
		return Ok(result);
	}

	[HttpPost("Review")]
	public async Task<ActionResult<AppointmentDto>> Review(CreateReviewCommand command)
	{
		var result = await Mediator.Send(command);
		return Ok(result);
	}
}