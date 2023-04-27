using MediatR;
using Reliefy.Application.Model.User;
using Reliefy.Application.Services;

namespace Reliefy.Application.BL.User.Queries;

public record GetUserInfoQuery : IRequest<UserDto>
{
	public string Uid { get; set; }
}

public class GetUserInfoQueryHandler : IRequestHandler<GetUserInfoQuery, UserDto>
{
	private readonly UserService _userService;

	public GetUserInfoQueryHandler(UserService userService)
	{
		_userService = userService;
	}

	public async Task<UserDto> Handle(GetUserInfoQuery request, CancellationToken cancellationToken)
	{
		var user = await _userService.Get<UserDto>(x => x.Uid == request.Uid);
		return user;
	}
}