using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Reliefy.Domain.Entities;

public class ChatSession : Auditable
{
	[Key]
	[DatabaseGenerated(DatabaseGeneratedOption.Identity)]
	public Guid Id { get; set; }
	
	[ForeignKey("Appointment")]
	public Guid AppointmentId { get; set; }
	
	public Appointment Appointment { get; set; }

	public List<Chat> Chats { get; set; }
}