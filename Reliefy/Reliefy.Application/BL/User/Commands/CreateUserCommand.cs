using Mapster;
using MediatR;
using Reliefy.Application.Interfaces;
using Reliefy.Application.Model.User;
using Reliefy.Application.Services;
using Reliefy.Domain.Entities;

namespace Reliefy.Application.BL.User.Commands;

public record CreateUserCommand : IRequest<UserDto>
{
	public string Uid { get; set; }
	public string Email { get; set; }
	public string SignInType { get; set; }
	public string RoleType { get; set; } = "PATIENT";
}

public class CreateUserCommandHandler : IRequestHandler<CreateUserCommand, UserDto>
{
	private readonly IApplicationDbContext _context;
	private readonly UserService _userService;

	public CreateUserCommandHandler(IApplicationDbContext context, UserService userService)
	{
		_context = context;
		_userService = userService;
	}

	public async Task<UserDto> Handle(CreateUserCommand request, CancellationToken cancellationToken)
	{
		var role = _context.Roles.FirstOrDefault(x => x.NormalizedName == request.RoleType);
		if (role == null)
		{
			return default;
		}

		var user = await _userService.Get(x => x.Uid == request.Uid, cancellationToken);

		if (user == null)
		{
			user = new()
			{
				Uid = request.Uid,
				Email = request.Email,
				SignInType = request.SignInType,
			};

			_userService.Add(user);

			UserRole userRole = new()
			{
				RoleId = role.Id,
				UserId = user.Id
			};

			_context.UserRoles.Add(userRole);
			await _context.SaveChangesAsync(cancellationToken);
		}

		return user.Adapt<UserDto>();
	}
}