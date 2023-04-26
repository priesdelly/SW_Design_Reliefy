using MediatR;
using Microsoft.EntityFrameworkCore;
using Reliefy.Application.Interfaces;
using Reliefy.Application.Model.User;

namespace Reliefy.Application.BL.User.Commands;

public record GetAppointmentReviewStatusCommand : IRequest<ReviewDto>
{
    public string AppointmentId { get; set; }
}

public class GetAppointmentReviewStatusCommandHandler : IRequestHandler<GetAppointmentReviewStatusCommand, ReviewDto>
{
    private readonly IApplicationDbContext _context;

    public GetAppointmentReviewStatusCommandHandler(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<ReviewDto> Handle(GetAppointmentReviewStatusCommand request, CancellationToken cancellationToken)
    {
        var appointmentId = request.AppointmentId;
        var item = await _context.Appointments.FirstOrDefaultAsync(c => c.Id.ToString() == appointmentId, cancellationToken: cancellationToken);
        if (item == null)
        {
            return null;
        }

        // return new ReviewDto
        // {
        //     Score = item.Score
        // };

        return null;
    }
}