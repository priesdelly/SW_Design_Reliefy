using System.Diagnostics.CodeAnalysis;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Metadata;
using Reliefy.Domain.Entities;

namespace Reliefy.Application.Interfaces;

public interface IApplicationDbContext
{
	public DbSet<User> Users { get; }
	public DbSet<Role> Roles { get; }
	DbSet<UserRole> UserRoles => Set<UserRole>();
	public DbSet<Appointment> Appointments { get; }
	public DbSet<AvailableTime> AvailableTime { get; }
	DbSet<TEntity> Set<[DynamicallyAccessedMembers(DynamicallyAccessedMemberTypes)] TEntity>() where TEntity : class;

	EntityEntry<TEntity> Entry<TEntity>(TEntity entity) where TEntity : class;
	
	Task<int> SaveChangesAsync(CancellationToken cancellationToken = default);
	
	public DatabaseFacade Database { get; }
	
	internal const DynamicallyAccessedMemberTypes DynamicallyAccessedMemberTypes =
		System.Diagnostics.CodeAnalysis.DynamicallyAccessedMemberTypes.PublicConstructors
		| System.Diagnostics.CodeAnalysis.DynamicallyAccessedMemberTypes.NonPublicConstructors
		| System.Diagnostics.CodeAnalysis.DynamicallyAccessedMemberTypes.PublicProperties
		| System.Diagnostics.CodeAnalysis.DynamicallyAccessedMemberTypes.PublicFields
		| System.Diagnostics.CodeAnalysis.DynamicallyAccessedMemberTypes.NonPublicProperties
		| System.Diagnostics.CodeAnalysis.DynamicallyAccessedMemberTypes.NonPublicFields
		| System.Diagnostics.CodeAnalysis.DynamicallyAccessedMemberTypes.Interfaces;

	void Dispose();
}