using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Reliefy.Domain.Entities;

public class Chat : Auditable
{
	[Key]
	[DatabaseGenerated(DatabaseGeneratedOption.Identity)]
	public Guid Id { get; set; }
	
	[Required]
	[MaxLength(1000)]
	[Column(TypeName = "character varying")]
	public string Message { get; set; }

	[ForeignKey("ChatSession")]
	public Guid ChatSessionId { get; set; }
	
	public ChatSession ChatSession { get; set; }

	[ForeignKey("Sender")]
	public Guid SenderId { get; set; }

	public User Sender { get; set; }
	
	[ForeignKey("Receiver")] 
	public Guid ReceiverId { get; set; }
	
	public User Receiver { get; set; }

	public bool IsRead { get; set; }
	
	public bool IsActive { get; set; }
}