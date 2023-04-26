using Mapster;
using Microsoft.EntityFrameworkCore;
using Reliefy.Application.BL.AvailableTime.Queries;
using Reliefy.Application.Interfaces;
using Reliefy.Application.Model.User;
using Reliefy.Domain.Entities;
using Reliefy.Domain.Enum;

namespace Reliefy.Application.Services;

public class AppointmentService : GenericService<Appointment>
{
    public AppointmentService(IApplicationDbContext context) : base(context)
    { }

    public async Task<List<AvailableTimeDto>> GetAvailableTime(string doctorId)
    {
        var allAvailableTimes =
            _context.AvailableTime.Where(x => x.DoctorId == Guid.Parse(doctorId) && x.StartTime > DateTime.Now);
        var appointmentTimes = _context.Appointments
            .Where(x => x.DoctorId == Guid.Parse(doctorId) && x.StartTime > DateTime.Now)
            .Select(x => new { StartTime = x.StartTime, EndTime = x.EndTime, Status = x.Status });

        var result = await allAvailableTimes.Where(x =>
                !appointmentTimes.Any(at =>
                    (at.StartTime < x.ToTime && x.StartTime < at.EndTime)
                    && at.Status != AppointmentStatus.Canceled))
            .ProjectToType<AvailableTimeDto>()
            .OrderBy(x => x.StartTime)
            .ToListAsync();

        return result;
    }

    public async Task<ReviewDto> GetAppointmentReviewScore(string appointmentId)
    {
        var item = await _context.Appointments.FirstOrDefaultAsync(c => c.Id.ToString() == appointmentId);
        if (item == null)
        {
            return null;
        }

        item.Score ??= -1;

        return new ReviewDto
        {
            Score = item.Score.Value
        };
    }

    public async Task<ReviewDto> SetAppointmentReviewScore(string appointmentId, int score)
    {
        var item = await _context.Appointments.FirstOrDefaultAsync(c => c.Id.ToString() == appointmentId);
        if (item == null)
        {
            return null;
        }

        item.Score = score;
        _context.Entry(item).Property(x => x.Score).IsModified = true;
        await _context.SaveChangesAsync();

        return new ReviewDto
        {
            Score = item.Score.Value
        };
    }
}