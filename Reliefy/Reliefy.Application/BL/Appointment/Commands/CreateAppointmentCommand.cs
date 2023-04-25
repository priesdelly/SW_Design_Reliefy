using Mapster;
using MediatR;
using Reliefy.Application.BL.Appointment.Queries;
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

	public CreateAppointmentCommandHandler(AppointmentService appointmentService,
		ICurrentUserService currentUserService)
	{
		_appointmentService = appointmentService;
		_currentUserService = currentUserService;
	}

	public async Task<AppointmentDto> Handle(CreateAppointmentCommand request, CancellationToken cancellationToken)
	{
		var entity = request.Adapt<Domain.Entities.Appointment>();
		entity.Status = AppointmentStatus.Waiting;
		entity.PatientId = Guid.Parse(_currentUserService.UserId);
		await _appointmentService.AddWithSave(entity, cancellationToken);
		return entity.Adapt<AppointmentDto>();
	}
}