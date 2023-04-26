using Google.Api.Gax;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using Microsoft.EntityFrameworkCore.Diagnostics;
using Reliefy.Application.Interfaces;
using Reliefy.Application.Services;
using Reliefy.Domain.Entities;

namespace Reliefy.Infrastructure.Persistence.Interceptors;

public class AuditableEntitySaveChangesInterceptor : SaveChangesInterceptor
{
	private readonly ICurrentUserService _currentUserService;

	public AuditableEntitySaveChangesInterceptor(ICurrentUserService currentUserService)
	{
		_currentUserService = currentUserService;
	}

	public override InterceptionResult<int> SavingChanges(DbContextEventData eventData, InterceptionResult<int> result)
	{
		UpdateEntities(eventData.Context);
		return base.SavingChanges(eventData, result);
	}

	public override ValueTask<InterceptionResult<int>> SavingChangesAsync(DbContextEventData eventData,
		InterceptionResult<int> result, CancellationToken cancellationToken = default)
	{
		UpdateEntities(eventData.Context);

		return base.SavingChangesAsync(eventData, result, cancellationToken);
	}

	public void UpdateEntities(DbContext context)
	{
		if (context == null) return;

		foreach (var entry in context.ChangeTracker.Entries<Auditable>())
		{
			var email = _currentUserService.User?.Email;
			if (entry.State == EntityState.Added)
			{
				entry.Entity.CreatedBy = email;
				entry.Entity.CreatedDate = DateTime.Now;
			}

			if (entry.State == EntityState.Added || entry.State == EntityState.Modified ||
			    entry.HasChangedOwnedEntities())
			{
				entry.Entity.UpdatedBy = email;
				entry.Entity.UpdatedDate = DateTime.Now;
			}
		}
	}
}

public static class Extensions
{
	public static bool HasChangedOwnedEntities(this EntityEntry entry) =>
		entry.References.Any(r =>
			r.TargetEntry != null &&
			r.TargetEntry.Metadata.IsOwned() &&
			(r.TargetEntry.State == EntityState.Added || r.TargetEntry.State == EntityState.Modified));
}