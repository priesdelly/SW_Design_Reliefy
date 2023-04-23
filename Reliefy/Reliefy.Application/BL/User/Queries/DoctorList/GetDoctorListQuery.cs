using MediatR;
using Reliefy.Application.Model.User;
using Reliefy.Application.Services;

namespace Reliefy.Application.BL.User.Queries.DoctorList;

public record GetDoctorListQuery : IRequest<List<UserDto>>;

public class GetDoctorListQueryHandler : IRequestHandler<GetDoctorListQuery, List<UserDto>>
{
	private readonly UserService _userService;
	
	public GetDoctorListQueryHandler(UserService userService)
	{
		_userService = userService;
	}
	
	public async Task<List<UserDto>> Handle(GetDoctorListQuery request, CancellationToken cancellationToken)
	{
		var result = await _userService.GetList<UserDto>(x => x.UserRoles.Any(ur => ur.Role.NormalizedName == "DOCTOR"));
		return result;
	}
}