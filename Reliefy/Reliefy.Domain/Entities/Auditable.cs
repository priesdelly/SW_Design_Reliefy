using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Reliefy.Domain.Entities;

public class Auditable
{
	[MaxLength(100)]
	[Column(TypeName = "character varying")]
	public string CreatedBy { get; set; }
	
	[Column(TypeName = "timestamp with time zone")]
	public DateTime CreatedDate { get; set; }
	
	[MaxLength(100)]
	[Column(TypeName = "character varying")]
	public string UpdatedBy { get; set; }
	
	[Column(TypeName = "timestamp with time zone")]
	public DateTime UpdatedDate { get; set; }
}