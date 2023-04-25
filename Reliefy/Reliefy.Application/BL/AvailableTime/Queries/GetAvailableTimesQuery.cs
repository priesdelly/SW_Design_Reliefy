using MediatR;
using Reliefy.Application.Services;

namespace Reliefy.Application.BL.AvailableTime.Queries;

public record GetAvailableTimesQuery : IRequest<List<AvailableTimeDto>>
{
	public string DoctorId { get; set; }
}

public class GetAvailableTimesQueryHandler : IRequestHandler<GetAvailableTimesQuery, List<AvailableTimeDto>>
{
	private readonly AppointmentService _appointmentService;

	public GetAvailableTimesQueryHandler(AppointmentService appointmentService)
	{
		_appointmentService = appointmentService;
	}

	public async Task<List<AvailableTimeDto>> Handle(GetAvailableTimesQuery request,
		CancellationToken cancellationToken)
	{
		var result = await _appointmentService.GetAvailableTime(request.DoctorId);
		return result;
	}
}