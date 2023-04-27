using Mapster;
using MediatR;
using Reliefy.Application.BL.Appointment.Queries;
using Reliefy.Application.Model.User;
using Reliefy.Application.Services;

namespace Reliefy.Application.BL.Appointment.Commands;

public record CreateReviewCommand : IRequest<AppointmentDto>
{
	public string AppointmentId { get; set; }

	public float Score { get; set; }
}

internal class CreateReviewCommandHandler : IRequestHandler<CreateReviewCommand, AppointmentDto>
{
	private readonly AppointmentService _appointmentService;

	public CreateReviewCommandHandler(AppointmentService appointmentService)
	{
		_appointmentService = appointmentService;
	}

	public async Task<AppointmentDto> Handle(CreateReviewCommand request, CancellationToken cancellationToken)
	{
		var appointment =
			await _appointmentService.Get(x => x.Id == Guid.Parse(request.AppointmentId), cancellationToken);
		appointment.Score = request.Score;
		await _appointmentService.UpdateWithSave(appointment, cancellationToken);
		return appointment.Adapt<AppointmentDto>();
	}
}