using Reliefy.Application.Model.User;

namespace Reliefy.Application.Interfaces;

public interface ICurrentUserService
{
	public string UserId { get; }
	public UserDto User { get; }
	public Task<string> GetEmail();
}