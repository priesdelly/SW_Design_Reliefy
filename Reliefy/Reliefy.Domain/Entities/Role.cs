using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Reliefy.Domain.Entities;

public class Role
{
	[Key]
	[DatabaseGenerated(DatabaseGeneratedOption.Identity)]
	public Guid Id { get; set; }
	
	[Required]
	public string Name { get; set; }
	
	[Required]
	public string NormalizedName { get; set; }
	
	[Required]
	public List<UserRole> UserRoles { get; set; }
}