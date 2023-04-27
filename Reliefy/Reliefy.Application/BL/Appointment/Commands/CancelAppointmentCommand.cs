using Mapster;
using MediatR;
using Reliefy.Application.BL.Appointment.Queries;
using Reliefy.Application.Services;
using Reliefy.Domain.Enum;

namespace Reliefy.Application.BL.Appointment.Commands;

public record CancelAppointmentCommand : IRequest<AppointmentDto>
{
	public string AppointmentId { get; set; }
}

public class CancelAppointmentCommandHandler : IRequestHandler<CancelAppointmentCommand, AppointmentDto>
{
	private readonly AppointmentService _appointmentService;

	public CancelAppointmentCommandHandler(AppointmentService appointmentService)
	{
		_appointmentService = appointmentService;
	}

	public async Task<AppointmentDto> Handle(CancelAppointmentCommand request, CancellationToken cancellationToken)
	{
		var entity = await _appointmentService.Get(x => x.Id == Guid.Parse(request.AppointmentId), cancellationToken);
		entity.Status = AppointmentStatus.Canceled;
		await _appointmentService.UpdateWithSave(entity, cancellationToken: cancellationToken);
		return entity.Adapt<AppointmentDto>();
	}
}