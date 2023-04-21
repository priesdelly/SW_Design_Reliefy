using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Reliefy.Domain.Entities;

public class AvailableTime
{
	[Key]
	[DatabaseGenerated(DatabaseGeneratedOption.Identity)]
	public Guid Id { get; set; }
	
	[Column(TypeName = "timestamp with time zone")]
	public DateTime StartTime { get; set; }
	
	[Column(TypeName = "timestamp with time zone")]
	public DateTime ToTime { get; set; }
	
	[ForeignKey("Doctor")]
	public Guid DoctorId { get; set; }

	public User Doctor { get; set; }
}