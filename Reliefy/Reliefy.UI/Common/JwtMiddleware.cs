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
		if (!string.IsNullOrEmpty(token))
		{
			var data = await FirebaseAuth.DefaultInstance.VerifyIdTokenAsync(token);
			if (data != null)
			{
				var user = await userService.Get<UserDto>(x => x.Uid == data!.Uid);
				if (user != null)
				{
					context.Items["UserId"] = user.Id;
					context.Items["User"] = user;
				}
			}
		}
		else
		{
			token = context.Request.Query.FirstOrDefault(x => x.Key == "access_token").Value.ToString();
			if (!string.IsNullOrEmpty(token))
			{
				var data = await FirebaseAuth.DefaultInstance.VerifyIdTokenAsync(token);
				if (data != null)
				{
					var user = await userService.Get<UserDto>(x => x.Uid == data!.Uid);
					if (user != null)
					{
						context.Items["UserId"] = user.Id;
						context.Items["User"] = user;
					}
				}
			}
		}

		await _next(context);
	}
}