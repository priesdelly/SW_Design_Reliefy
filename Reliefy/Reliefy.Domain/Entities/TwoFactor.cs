using Microsoft.EntityFrameworkCore;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema; 

namespace Reliefy.Domain.Entities;

[Index(nameof(Email), nameof(Code))]
public class TwoFactor
{
    [Key]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public Guid Id { get; set; }
    
    [Required]
    [MaxLength(200)]
    [Column(TypeName = "character varying")]
    public string Email { get; set; }
    
    [Required]
    [MaxLength(6)]
    [Column(TypeName = "character varying")]
    public string Code { get; set; }
    
    [Required]
    [DefaultValue(false)]
    public bool IsUsed { get; set; }
    
    [Required]
    public DateTime ExpireAt { get; set; }
    
    [Required]
    public DateTime CreatedAt { get; set; }
}