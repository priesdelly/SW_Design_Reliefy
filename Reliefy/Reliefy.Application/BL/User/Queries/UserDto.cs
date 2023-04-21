namespace Reliefy.Application.Model.User;

public class UserDto
{
	public string Id { get; set; }
	public string GoogleUid { get; set; }
	public string SignInType { get; set; }
	public string Firstname { get; set; }
	public string Lastname { get; set; }
	public string Email { get; set; }
	public string PhoneNumber { get; set; }
}