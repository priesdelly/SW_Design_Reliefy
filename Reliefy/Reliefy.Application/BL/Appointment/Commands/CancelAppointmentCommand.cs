using Mapster;
using MediatR;
using Reliefy.Application.BL.Appointment.Queries;
using Reliefy.Application.BL.Email.Commands;
using Reliefy.Application.Interfaces;
using Reliefy.Application.Services;
using Reliefy.Domain.Enum;

namespace Reliefy.Application.BL.Appointment.Commands;

public record CancelAppointmentCommand : IRequest<AppointmentDto>
{
	public string AppointmentId { get; set; }
}

internal class CancelAppointmentCommandHandler : IRequestHandler<CancelAppointmentCommand, AppointmentDto>
{
	private readonly AppointmentService _appointmentService;
	private readonly ICurrentUserService _currentUserService;
	private readonly IMediator _mediator;
	private readonly UserService _userService;

	public CancelAppointmentCommandHandler(AppointmentService appointmentService,
		ICurrentUserService currentUserService, IMediator mediator, UserService userService)
	{
		_appointmentService = appointmentService;
		_currentUserService = currentUserService;
		_mediator = mediator;
		_userService = userService;
	}

	public async Task<AppointmentDto> Handle(CancelAppointmentCommand request, CancellationToken cancellationToken)
	{
		var entity = await _appointmentService.Get(x => x.Id == Guid.Parse(request.AppointmentId), cancellationToken);
		entity.Status = AppointmentStatus.Canceled;
		await _appointmentService.UpdateWithSave(entity, cancellationToken: cancellationToken);

		if (entity.PatientId == Guid.Parse(_currentUserService.UserId))
		{
			var doctor = await _userService.Get(x => x.Id == entity.DoctorId, cancellationToken);
			var sendMailCommand = new SendMailCommand
			{
				Email = doctor.Email,
				Subject = "Patient cancel an appointment",
				Body = $"Patient name : {_currentUserService.User.Firstname} {_currentUserService.User.Lastname} time {entity.StartTime}"
			};

			await _mediator.Send(sendMailCommand, cancellationToken);
		}
		
		if (entity.DoctorId == Guid.Parse(_currentUserService.UserId))
		{
			var patient = await _userService.Get(x => x.Id == entity.PatientId, cancellationToken);
			var sendMailCommand = new SendMailCommand
			{
				Email = patient.Email,
				Subject = "Doctor cancel an appointment",
				Body = $"Doctor name : {_currentUserService.User.Firstname} {_currentUserService.User.Lastname} time {entity.StartTime}"
			};

			await _mediator.Send(sendMailCommand, cancellationToken);
		}

		return entity.Adapt<AppointmentDto>();
	}
}