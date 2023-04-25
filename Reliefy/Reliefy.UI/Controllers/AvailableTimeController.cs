using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Reliefy.Application.BL.AvailableTime.Commands;
using Reliefy.Application.BL.AvailableTime.Queries;

namespace Reliefy.UI.Controllers;

public class AvailableTimeController : ApiControllerBase
{
	[HttpPost]
	public async Task<ActionResult<List<AvailableTimeDto>>> Create(CreateAvailableTimesCommand command)
	{
		var result = await Mediator.Send(command);
		return Ok(result);
	}

	[HttpGet("{doctorId}")]
	public async Task<ActionResult<List<AvailableTimeDto>>> GetAvailableTimes(string doctorId)
	{
		var command = new GetAvailableTimesQuery { DoctorId = doctorId };
		var result = await Mediator.Send(command);
		return Ok(result);
	}
}