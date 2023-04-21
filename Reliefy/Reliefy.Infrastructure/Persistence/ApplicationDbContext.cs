using Microsoft.EntityFrameworkCore;
using Reliefy.Application.Interfaces;
using Reliefy.Domain.Entities;

namespace Reliefy.Infrastructure.Persistence;

public class ApplicationDbContext : DbContext, IApplicationDbContext
{
	public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
	{
	}

	public DbSet<User> Users => Set<User>();
	public DbSet<Role> Roles => Set<Role>();
	public DbSet<UserRole> UserRoles => Set<UserRole>();
	public DbSet<Appointment> Appointments => Set<Appointment>();
	public DbSet<AvailableTime> AvailableTime => Set<AvailableTime>();
}