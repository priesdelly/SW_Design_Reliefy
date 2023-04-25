using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Reliefy.Domain.Enum;

namespace Reliefy.Domain.Entities;

public class Appointment : Auditable
{
	[Key]
	[DatabaseGenerated(DatabaseGeneratedOption.Identity)]
	public Guid Id { get; set; }
	
	[Column(TypeName = "timestamp with time zone")]
	public DateTime StartTime { get; set; }
	
	[Column(TypeName = "timestamp with time zone")]
	public DateTime EndTime { get; set; }

	public AppointmentStatus Status { get; set; }
	
	public int? Score { get; set; }
	
	[ForeignKey("Patient")]
	public Guid PatientId { get; set; }

	public User Patient { get; set; }
	
	[ForeignKey("Doctor")] 
	public Guid DoctorId { get; set; }
	
	public User Doctor { get; set; }
}