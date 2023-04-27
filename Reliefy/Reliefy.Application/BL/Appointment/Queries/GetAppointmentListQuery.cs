using MediatR;
using Reliefy.Application.Interfaces;
using Reliefy.Application.Services;
using Reliefy.Domain.Enum;

namespace Reliefy.Application.BL.Appointment.Queries;

public record GetAppointmentListQuery : IRequest<List<AppointmentDto>>;

internal class GetAppointmentListQueryHandler : IRequestHandler<GetAppointmentListQuery, List<AppointmentDto>>
{
	private readonly AppointmentService _appointmentService;
	private readonly ICurrentUserService _currentUserService;

	public GetAppointmentListQueryHandler(AppointmentService appointmentService,
		ICurrentUserService currentUserService)
	{
		_appointmentService = appointmentService;
		_currentUserService = currentUserService;
	}

	public async Task<List<AppointmentDto>> Handle(GetAppointmentListQuery request,
		CancellationToken cancellationToken)
	{
		var userId = _currentUserService.UserId;
		var role = _currentUserService.Role.NormalizedName;
		var result = new List<AppointmentDto>();
		if (role == "PATIENT")
		{
			result = await _appointmentService
				.GetList<AppointmentDto>(x => x.PatientId == Guid.Parse(userId)
				                              && (x.Status == AppointmentStatus.Waiting ||
				                                  x.Status == AppointmentStatus
					                                  .Meeting) &&
				                              x.EndTime >= DateTime.Now,
					cancellationToken: cancellationToken);
			return result;
		}

		if (role == "DOCTOR")
		{
			result = await _appointmentService
				.GetList<AppointmentDto>(x => x.DoctorId == Guid.Parse(userId)
				                              && (x.Status == AppointmentStatus.Waiting ||
				                                  x.Status == AppointmentStatus
					                                  .Meeting) &&
				                              x.EndTime >= DateTime.Now,
					cancellationToken: cancellationToken);
		}

		return result;
	}
}