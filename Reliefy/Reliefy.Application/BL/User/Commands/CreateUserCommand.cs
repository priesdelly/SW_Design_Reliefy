using Mapster;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Reliefy.Application.Interfaces;
using Reliefy.Application.Model.User;
using Reliefy.Domain.Entities;

namespace Reliefy.Application.BL.User.Commands;

public record CreateUserCommand : IRequest<UserDto>
{
	public string Uid { get; set; }
	public string Email { get; set; }
	public string SignInType { get; set; }
}

public class CreateUserCommandHandler : IRequestHandler<CreateUserCommand, UserDto>
{
	private readonly IApplicationDbContext _context;

	public CreateUserCommandHandler(IApplicationDbContext context)
	{
		_context = context;
	}
	
	public async Task<UserDto> Handle(CreateUserCommand request, CancellationToken cancellationToken)
	{
		var role = _context.Roles.FirstOrDefault(x => x.NormalizedName == "PATIENT");
		if (role == null)
		{
			role = new()
			{
				Name = "Patient",
				NormalizedName = "PATIENT"
			};
			_context.Roles.Add(role);
			await _context.SaveChangesAsync(cancellationToken);
		}

		var user = await _context.Users.FirstOrDefaultAsync(x => x.Uid == request.Uid, cancellationToken: cancellationToken);
		if (user == null)
		{
			user = new()
			{
				Uid = request.Uid,
				Email = request.Email,
				SignInType = request.SignInType,
				CreatedDate = DateTime.Now,
				CreatedBy = request.Email,
				UpdatedDate = DateTime.Now,
				UpdatedBy = request.Email,
			};
			await _context.Users.AddAsync(user, cancellationToken);
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