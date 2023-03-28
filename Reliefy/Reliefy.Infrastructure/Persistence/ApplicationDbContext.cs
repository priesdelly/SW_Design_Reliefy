using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Reliefy.Application.Interfaces;
using Reliefy.Domain.Entities;

namespace Reliefy.Infrastructure.Persistence;

public class ApplicationDbContext : IdentityDbContext<User>, IApplicationDbContext
{
	public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
	{
	}
}