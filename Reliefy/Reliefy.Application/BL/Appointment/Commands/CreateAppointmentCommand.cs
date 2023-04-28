using Mapster;
using MediatR;
using Reliefy.Application.BL.Appointment.Queries;
using Reliefy.Application.BL.Email.Commands;
using Reliefy.Application.Interfaces;
using Reliefy.Application.Services;
using Reliefy.Domain.Enum;

namespace Reliefy.Application.BL.Appointment.Commands;

public record CreateAppointmentCommand : IRequest<AppointmentDto>
{
	public DateTime StartTime { get; set; }

	public DateTime EndTime { get; set; }

	public string DoctorId { get; set; }
}

public class CreateAppointmentCommandHandler : IRequestHandler<CreateAppointmentCommand, AppointmentDto>
{
	private readonly AppointmentService _appointmentService;
	private readonly ICurrentUserService _currentUserService;
	private readonly UserService _userService;
	private readonly IMediator _mediator;

	public CreateAppointmentCommandHandler(AppointmentService appointmentService,
		ICurrentUserService currentUserService, UserService userService, IMediator mediator)
	{
		_appointmentService = appointmentService;
		_currentUserService = currentUserService;
		_userService = userService;
		_mediator = mediator;
	}

	public async Task<AppointmentDto> Handle(CreateAppointmentCommand request, CancellationToken cancellationToken)
	{
		var entity = request.Adapt<Domain.Entities.Appointment>();
		entity.Status = AppointmentStatus.Waiting;
		entity.PatientId = Guid.Parse(_currentUserService.UserId);
		await _appointmentService.AddWithSave(entity, cancellationToken);

		var doctor = await _userService.Get(x => x.Id == entity.DoctorId, cancellationToken);
		
		var sendMailCommand = new SendMailCommand
		{
			Email = doctor.Email,
			Subject = "You have new appointment",
			Body = $"Patient name : {_currentUserService.User.Firstname} {_currentUserService.User.Lastname} time {entity.StartTime.ToLocalTime()}"
		};

		await _mediator.Send(sendMailCommand, cancellationToken);
		
		return entity.Adapt<AppointmentDto>();
	}
}