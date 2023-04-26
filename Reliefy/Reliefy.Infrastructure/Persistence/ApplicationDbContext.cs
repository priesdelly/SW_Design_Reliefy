using MediatR;
using Microsoft.EntityFrameworkCore;
using Reliefy.Application.Interfaces;
using Reliefy.Domain.Entities;
using Reliefy.Infrastructure.Persistence.Interceptors;

namespace Reliefy.Infrastructure.Persistence;

public class ApplicationDbContext : DbContext, IApplicationDbContext
{
    private readonly AuditableEntitySaveChangesInterceptor _auditableEntitySaveChangesInterceptor;

    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options, AuditableEntitySaveChangesInterceptor auditableEntitySaveChangesInterceptor) : base(options)
    {
        _auditableEntitySaveChangesInterceptor = auditableEntitySaveChangesInterceptor;
    }

    public DbSet<User> Users => Set<User>();
    public DbSet<Role> Roles => Set<Role>();
    public DbSet<UserRole> UserRoles => Set<UserRole>();
    public DbSet<Appointment> Appointments => Set<Appointment>();
    public DbSet<AvailableTime> AvailableTime => Set<AvailableTime>();
    public DbSet<TwoFactor> TwoFactor => Set<TwoFactor>();

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        optionsBuilder.AddInterceptors(_auditableEntitySaveChangesInterceptor);
    }
}