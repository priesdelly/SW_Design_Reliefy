namespace Reliefy.Application.BL.AvailableTime.Queries;

public class AvailableTimeDto
{
	public string Id { get; set; }
	public DateTime StartTime { get; set; }
	public DateTime ToTime { get; set; }
	public string DoctorId { get; set; }
}