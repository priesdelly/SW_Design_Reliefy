using Mapster;
using MediatR;
using Reliefy.Application.Interfaces;
using Reliefy.Application.Model.User;
using Reliefy.Application.Services;

namespace Reliefy.Application.BL.User.Commands;

public record UpdateUserInfoCommand : IRequest<UserDto>
{
	public string Firstname { get; set; }
	public string Lastname { get; set; }
	public string PhoneNumber { get; set; }
}

internal class UpdateUserInfoCommandHandler : IRequestHandler<UpdateUserInfoCommand, UserDto>
{
	private readonly UserService _userService;
	private readonly ICurrentUserService _currentUserService;

	public UpdateUserInfoCommandHandler(UserService userService, ICurrentUserService currentUserService)
	{
		_userService = userService;
		_currentUserService = currentUserService;
	}

	public async Task<UserDto> Handle(UpdateUserInfoCommand request, CancellationToken cancellationToken)
	{
		var user = await _userService.Get(x => x.Id == Guid.Parse(_currentUserService.UserId), cancellationToken);
		if (user is null)
		{
			return default;
		}

		user.Firstname = request.Firstname;
		user.Lastname = request.Lastname;
		user.PhoneNumber = request.PhoneNumber;
		user.IsCompleteInfo = true;

		await _userService.UpdateWithSave(user, cancellationToken);
		return user.Adapt<UserDto>();
	}
}