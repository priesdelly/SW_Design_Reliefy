using Reliefy.Application.BL.User.Queries;

namespace Reliefy.Application.Model.User;

public class UserDto
{
	public string Id { get; set; }
	public string Firstname { get; set; }
	public string Lastname { get; set; }
	public string Email { get; set; }
	public string PhoneNumber { get; set; }
	public bool IsVerified { get; set; }
	public bool IsCompleteInfo { get; set; }
	public List<UserRoleDto> UserRoles { get; set; }
}