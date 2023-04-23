using Reliefy.Application.Interfaces;
using Reliefy.Domain.Entities;

namespace Reliefy.Application.Services;

public class AppointmentService : GenericService<Appointment>
{
	public AppointmentService(IApplicationDbContext context) : base(context)
	{
	}
}