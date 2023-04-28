using Mapster;
using MediatR;
using Reliefy.Application.BL.Appointment.Queries;
using Reliefy.Application.Services;
using Reliefy.Domain.Enum;

namespace Reliefy.Application.BL.Appointment.Commands;

public record CompleteAppointmentCommand : IRequest<AppointmentDto>
{
	public string AppointmentId { get; set; }
}

internal class CompleteAppointmentCommandHandler : IRequestHandler<CompleteAppointmentCommand, AppointmentDto>
{
	private readonly AppointmentService _appointmentService;

	public CompleteAppointmentCommandHandler(AppointmentService appointmentService)
	{
		_appointmentService = appointmentService;
	}

	public async Task<AppointmentDto> Handle(CompleteAppointmentCommand request, CancellationToken cancellationToken)
	{
		var entity = await _appointmentService.Get(x => x.Id == Guid.Parse(request.AppointmentId), cancellationToken);
		entity.Status = AppointmentStatus.Completed;
		await _appointmentService.UpdateWithSave(entity, cancellationToken: cancellationToken);
		
		return entity.Adapt<AppointmentDto>();
	}
}