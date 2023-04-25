using Reliefy.Application.Model.User;
using Reliefy.Domain.Enum;

namespace Reliefy.Application.BL.Appointment.Queries;

public class AppointmentDto
{
	public string Id { get; set; }
	public DateTime StartTime { get; set; }
	public DateTime EndTime { get; set; }
	public AppointmentStatus Status { get; set; }
	public string PatientId { get; set; }
	public UserDto Patient { get; set; }
	public string DoctorId { get; set; }
	public UserDto Doctor { get; set; }
}