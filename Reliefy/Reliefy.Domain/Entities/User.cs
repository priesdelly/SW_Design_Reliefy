using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Reliefy.Domain.Entities;

public class User : Auditable
{
	[Key]
	[DatabaseGenerated(DatabaseGeneratedOption.Identity)]
	public Guid Id { get; set; }

	[MaxLength(100)]
	[Column(TypeName = "character varying")]
	public string Uid { get; set; }
	
	[MaxLength(20)]
	[Column(TypeName = "character varying")]
	public string SignInType { get; set; }
	
	[MaxLength(100)]
	[Column(TypeName = "character varying")]
	public string Firstname { get; set; }
	
	[MaxLength(100)]
	[Column(TypeName = "character varying")]
	public string Lastname { get; set; }
	
	[Required]
	[MaxLength(200)]
	[Column(TypeName = "character varying")]
	public string Email { get; set; }
	
	[MaxLength(10)]
	[Column(TypeName = "character varying")]
	public string PhoneNumber { get; set; }
	
	public bool IsVerified { get; set; }
	
	public bool IsCompleteInfo { get; set; }

	public List<UserRole> UserRoles { get; set; }
}