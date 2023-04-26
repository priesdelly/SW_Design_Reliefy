using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Reliefy.Application.BL.Appointment.Commands;
using Reliefy.Application.BL.Appointment.Queries;
using Reliefy.Application.Interfaces;

namespace Reliefy.UI.Controllers;

public class AppointmentController : ApiControllerBase
{
	private readonly ICurrentUserService _currentUserService;

	public AppointmentController(ICurrentUserService currentUserService)
	{
		_currentUserService = currentUserService;
	}

	[HttpGet]
	public async Task<ActionResult<List<AppointmentDto>>> GetList()
	{
		var query = new GetAppointmentPatientQuery();
		var result = await Mediator.Send(query);
		return Ok(result);
	}

	[HttpPost]
	public async Task<ActionResult<AppointmentDto>> Create(CreateAppointmentCommand command)
	{
		var result = await Mediator.Send(command);
		return Ok(result);
	}
}