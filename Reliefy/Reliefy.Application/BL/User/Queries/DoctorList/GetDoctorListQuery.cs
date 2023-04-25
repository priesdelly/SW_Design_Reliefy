using MediatR;
using Reliefy.Application.Interfaces;
using Reliefy.Application.Model.User;
using Reliefy.Application.Services;

namespace Reliefy.Application.BL.User.Queries.DoctorList;

public record GetDoctorListQuery : IRequest<List<UserDto>>;

public class GetDoctorListQueryHandler : IRequestHandler<GetDoctorListQuery, List<UserDto>>
{
	private readonly UserService _userService;
	private readonly ICurrentUserService _currentUserService;

	public GetDoctorListQueryHandler(UserService userService, ICurrentUserService currentUserService)
	{
		_userService = userService;
		_currentUserService = currentUserService;
	}

	public async Task<List<UserDto>> Handle(GetDoctorListQuery request, CancellationToken cancellationToken)
	{
		var result = await _userService.GetList<UserDto>(x =>
				x.UserRoles.Any(ur => ur.Role.NormalizedName == "DOCTOR") &&
				x.Id != Guid.Parse(_currentUserService.UserId)
			, cancellationToken: cancellationToken);
		return result;
	}
}