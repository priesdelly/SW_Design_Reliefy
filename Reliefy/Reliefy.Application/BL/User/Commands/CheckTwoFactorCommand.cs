using MediatR;
using Microsoft.EntityFrameworkCore;
using Reliefy.Application.Interfaces;
using Reliefy.Application.Services;

namespace Reliefy.Application.BL.User.Commands;

public record CheckTwoFactorCommand : IRequest<ResponseMessage>
{
	public string Email { get; set; }
	public string Code { get; set; }
}

public class CheckTwoFactorCommandHandler : IRequestHandler<CheckTwoFactorCommand, ResponseMessage>
{
	private readonly IApplicationDbContext _context;
	private readonly UserService _userService;
	private readonly ICurrentUserService _currentUserService;

	public CheckTwoFactorCommandHandler(IApplicationDbContext context, UserService userService, ICurrentUserService currentUserService)
	{
		_context = context;
		_userService = userService;
		_currentUserService = currentUserService;
	}

	public async Task<ResponseMessage> Handle(CheckTwoFactorCommand request, CancellationToken cancellationToken)
	{
		var entity = await _context.TwoFactor.FirstOrDefaultAsync(
			x => x.Email == request.Email && x.Code == request.Code, cancellationToken: cancellationToken);
		if (entity == null)
		{
			return new ResponseMessage()
			{
				Status = "error",
				Message = "Email or code is not found"
			};
		}

		if (entity.IsUsed)
		{
			return new ResponseMessage()
			{
				Status = "error",
				Message = "code already used"
			};
		}

		if (entity.ExpireAt <= DateTime.Now)
		{
			return new ResponseMessage()
			{
				Status = "error",
				Message = "code expired"
			};
		}

		entity.IsUsed = true;
		await _context.SaveChangesAsync(cancellationToken);
		var user = await _userService.Get(x => x.Id == Guid.Parse(_currentUserService.UserId), cancellationToken);
		user.IsVerified = true;
		await _userService.UpdateWithSave(user, cancellationToken);

		return new ResponseMessage()
		{
			Status = "success",
		};
	}
}