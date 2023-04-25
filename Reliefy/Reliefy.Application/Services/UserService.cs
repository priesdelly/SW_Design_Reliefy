using Microsoft.EntityFrameworkCore;
using Reliefy.Application.Interfaces;
using Reliefy.Application.Model.User;
using Reliefy.Domain.Entities;
using Reliefy.Domain.Enum;

namespace Reliefy.Application.Services;

public class UserService : GenericService<User>
{
	public UserService(IApplicationDbContext context) : base(context)
	{
	}
}