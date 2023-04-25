using FirebaseAdmin.Auth;
using Reliefy.Application.Model.User;
using Reliefy.Application.Services;

namespace Reliefy.UI.Common;

public class JwtMiddleware
{
	private readonly RequestDelegate _next;

	public JwtMiddleware(RequestDelegate next)
	{
		_next = next;
	}

	public async Task Invoke(HttpContext context, UserService userService)
	{
		var token = context.Request.Headers["Authorization"].FirstOrDefault()?.Split(" ").Last();
		if (token == null)
		{
			await _next(context);
		}

		var data = await FirebaseAuth.DefaultInstance.VerifyIdTokenAsync(token);
		if (data == null)
		{
			await _next(context);
		}

		var user = await userService.Get<UserDto>(x => x.Uid == data!.Uid);
		if (user != null)
		{
			context.Items["UserId"] = user.Id;
			context.Items["User"] = user;
		}

		await _next(context);
	}
}