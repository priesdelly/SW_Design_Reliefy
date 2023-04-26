using MediatR;
using Reliefy.Application.Model.User;
using Reliefy.Application.Services;

namespace Reliefy.Application.BL.Appointment.Commands;

public record CreateReviewCommand : IRequest<ReviewDto>
{
    public string AppointmentId { get; set; }

    public int Score { get; set; }
}

public class CreateReviewCommandHandler : IRequestHandler<CreateReviewCommand, ReviewDto>
{
    private readonly AppointmentService _appointmentService;
    
    public CreateReviewCommandHandler(AppointmentService appointmentService)
    {
        _appointmentService = appointmentService;
    }
    
    public Task<ReviewDto> Handle(CreateReviewCommand request, CancellationToken cancellationToken)
    {
        var result = _appointmentService.SetAppointmentReviewScore(request.AppointmentId,request.Score);
        return result;
    }
}