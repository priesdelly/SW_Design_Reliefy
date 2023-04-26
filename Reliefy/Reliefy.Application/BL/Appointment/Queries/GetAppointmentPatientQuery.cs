using MediatR;
using Reliefy.Application.Interfaces;
using Reliefy.Application.Services;

namespace Reliefy.Application.BL.Appointment.Queries;

public record GetAppointmentPatientQuery : IRequest<List<AppointmentDto>>;

public class GetAppointmentPatientQueryHandler : IRequestHandler<GetAppointmentPatientQuery, List<AppointmentDto>>
{
	private readonly AppointmentService _appointmentService;
	private readonly ICurrentUserService _currentUserService;

	public GetAppointmentPatientQueryHandler(AppointmentService appointmentService,
		ICurrentUserService currentUserService)
	{
		_appointmentService = appointmentService;
		_currentUserService = currentUserService;
	}

	public async Task<List<AppointmentDto>> Handle(GetAppointmentPatientQuery request,
		CancellationToken cancellationToken)
	{
		var userId = _currentUserService.UserId;
		var list = await _appointmentService.GetList<AppointmentDto>(x => x.PatientId == Guid.Parse(userId),
			cancellationToken: cancellationToken);
		return list;
	}
}