using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Reliefy.Domain.Entities;

public class UserRole
{
	[Key]
	[DatabaseGenerated(DatabaseGeneratedOption.Identity)]
	public Guid Id { get; set; }

	[ForeignKey("User")]
	public Guid UserId { get; set; }
	
	public User User { get; set; }
	
	[ForeignKey("Role")] 
	public Guid RoleId { get; set; }
	
	public Role Role { get; set; }
}