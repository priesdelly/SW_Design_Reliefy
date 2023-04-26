using System.Security.Claims;
using FirebaseAdmin.Auth;
using Reliefy.Application.Interfaces;
using Reliefy.Application.Model.User;

namespace Reliefy.UI.Services;

public class CurrentUserService : ICurrentUserService
{
	private readonly IHttpContextAccessor _httpContextAccessor;
	public string? UserId => _httpContextAccessor.HttpContext?.Items["UserId"]?.ToString();
	public UserDto? User => (UserDto?)_httpContextAccessor.HttpContext?.Items["User"];

	public CurrentUserService(IHttpContextAccessor httpContextAccessor)
	{
		_httpContextAccessor = httpContextAccessor;
	}

	public async Task<string?> GetEmail()
	{
		var token = _httpContextAccessor.HttpContext?.Request.Headers.Authorization.FirstOrDefault()?.Split(" ").Last();
		if (token is null)
		{
			return null;
		}

		var tokenData = await FirebaseAuth.DefaultInstance.VerifyIdTokenAsync(token);
		if (tokenData is null)
		{
			return null;
		}

		return tokenData.Uid;
	}

	public string? Email => _httpContextAccessor.HttpContext?.User?.FindFirstValue(ClaimTypes.Email);
}