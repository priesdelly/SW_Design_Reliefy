using Reliefy.Application.Interfaces;
using Reliefy.Domain.Entities;

namespace Reliefy.Application.Services;

public class AvailableTimeService : GenericService<AvailableTime>
{
	public AvailableTimeService(IApplicationDbContext context) : base(context)
	{
	}
}