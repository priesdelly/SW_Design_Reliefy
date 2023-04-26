using Microsoft.AspNetCore.Mvc;
using Reliefy.Application.BL.User.Commands;
using Reliefy.Application.Model.User;

namespace Reliefy.UI.Controllers
{
    public class ReviewController : ApiControllerBase
    {
        [HttpGet("{appointmentId}/status")]
        public async Task<ActionResult<UserDto>> GetStatus(string appointmentId)
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
        
        
    }
}