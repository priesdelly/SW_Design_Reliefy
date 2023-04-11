using Microsoft.EntityFrameworkCore;

namespace Reliefy.Infrastructure.Persistence;

public class ApplicationDbContext : DbContext
{
	public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
	{
	}
}