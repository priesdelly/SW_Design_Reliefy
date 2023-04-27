using MediatR;
using Reliefy.Application.BL.Appointment.Queries;
using Reliefy.Application.Model.User;
using Reliefy.Application.Services;

namespace Reliefy.Application.BL.User.Commands;

public record GetAppointmentReviewStatusCommand : IRequest<ReviewDto>
{
    public string AppointmentId { get; set; }
}

public class GetAppointmentReviewStatusCommandHandler : IRequestHandler<GetAppointmentReviewStatusCommand, ReviewDto>
{
    private readonly AppointmentService _appointmentService;

    public GetAppointmentReviewStatusCommandHandler(AppointmentService appointmentService)
    {
        _appointmentService = appointmentService;
    }

    public async Task<ReviewDto> Handle(GetAppointmentReviewStatusCommand request, CancellationToken cancellationToken)
    {
        var result = await _appointmentService.GetAppointmentReviewScore(request.AppointmentId);
        return result;
    }
}