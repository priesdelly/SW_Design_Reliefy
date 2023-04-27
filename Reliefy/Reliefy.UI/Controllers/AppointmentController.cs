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
        var currentUser = _currentUserService
            .User
            .UserRoles
            .FirstOrDefault();
        if (currentUser == null)
        {
            return NotFound("User not found");
        }

        switch (currentUser.Role.NormalizedName)
        {
            case "PATIENT":
            {
                var queryPatient = new GetAppointmentPatientQuery();
                var resultPatient = await Mediator.Send(queryPatient);
                return Ok(resultPatient);
            }
            case "DOCTOR":
            {
                var queryDoctor = new GetAppointmentDoctorQuery();
                var resultDoctor = await Mediator.Send(queryDoctor);
                return Ok(resultDoctor);
            }
        }

        return NotFound("User role not found");
    }

    [HttpPost]
    public async Task<ActionResult<AppointmentDto>> Create(CreateAppointmentCommand command)
    {
        var result = await Mediator.Send(command);
        return Ok(result);
    }
    
    [HttpPut("Cancel/{appointmentId}")]
    public async Task<ActionResult<AppointmentDto>> Cancel(string appointmentId)
    {
        var command = new CancelAppointmentCommand { AppointmentId = appointmentId };
        var result = await Mediator.Send(command);
        return Ok(result);
    }
}