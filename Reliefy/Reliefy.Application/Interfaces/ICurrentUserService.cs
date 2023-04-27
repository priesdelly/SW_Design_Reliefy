using Reliefy.Application.BL.User.Queries;
using Reliefy.Application.Model.User;

namespace Reliefy.Application.Interfaces;

public interface ICurrentUserService
{
	public string UserId { get; }
	public UserDto User { get; }
	public RoleDto Role { get; }
}