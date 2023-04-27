using MediatR;
using Reliefy.Application.Interfaces;
using Reliefy.Application.Services;

namespace Reliefy.Application.BL.Appointment.Queries;

public record GetAppointmentDoctorQuery : IRequest<List<AppointmentDto>>;

public class GetAppointmentDoctorQueryHandler : IRequestHandler<GetAppointmentDoctorQuery, List<AppointmentDto>>
{
    private readonly AppointmentService _appointmentService;
    private readonly ICurrentUserService _currentUserService;

    public GetAppointmentDoctorQueryHandler(AppointmentService appointmentService,
        ICurrentUserService currentUserService)
    {
        _appointmentService = appointmentService;
        _currentUserService = currentUserService;
    }

    public async Task<List<AppointmentDto>> Handle(GetAppointmentDoctorQuery request, CancellationToken cancellationToken)
    {
        var userId = _currentUserService.UserId;
        var list = await _appointmentService.GetList<AppointmentDto>(x => x.DoctorId == Guid.Parse(userId), cancellationToken: cancellationToken);
        return list;
    }
}