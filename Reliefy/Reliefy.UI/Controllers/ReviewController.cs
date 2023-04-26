using Microsoft.AspNetCore.Mvc;
using Reliefy.Application.BL.Appointment.Commands;
using Reliefy.Application.BL.User.Commands;
using Reliefy.Application.Model.User;

namespace Reliefy.UI.Controllers;

public class ReviewController : ApiControllerBase
{
    [HttpGet("{appointmentId}")]
    public async Task<ActionResult<ReviewDto>> GetStatus(string appointmentId)
    {
        var command = new GetAppointmentReviewStatusCommand
        {
            AppointmentId = appointmentId
        };

        var result = await Mediator.Send(command);
        if (result == null)
        {
            return NotFound();
        }

        return Ok(new ReviewDto()
        {
            Score = result.Score
        });
    }


    [HttpPost("{appointmentId}")]
    public async Task<ActionResult<ReviewDto>> Create(string appointmentId, ReviewDto reviewDto)
    {
        if (reviewDto.Score is > 5 or < 1)
        {
            return BadRequest();
        }

        var command = new CreateReviewCommand
        {
            AppointmentId = appointmentId,
            Score = reviewDto.Score
        };

        var result = await Mediator.Send(command);
        if (result == null)
        {
            return NotFound();
        }

        return Ok(new ReviewDto()
        {
            Score = result.Score
        });
    }
}