using System.Linq.Expressions;
using Mapster;
using Microsoft.EntityFrameworkCore;
using Reliefy.Application.Interfaces;

namespace Reliefy.Application.Services;

public class GenericService<TEntity> : IDisposable where TEntity : class
{
	protected IApplicationDbContext _context;
	protected DbSet<TEntity> _dbSet;

	public GenericService(IApplicationDbContext context)
	{
		_context = context;
		_dbSet = context.Set<TEntity>();
	}

	public async Task<List<TEntity>> GetList(Expression<Func<TEntity, bool>> filter = null,
		Func<IQueryable<TEntity>, IOrderedQueryable<TEntity>> orderBy = null)
	{
		IQueryable<TEntity> query = _dbSet;

		if (filter != null)
		{
			query = query.Where(filter);
		}

		if (orderBy != null)
		{
			return await orderBy(query).ToListAsync();
		}

		return await query.ToListAsync();
	}

	public async Task<List<TReadDto>> GetList<TReadDto>(Expression<Func<TEntity, bool>> filter = null,
		Func<IQueryable<TEntity>, IOrderedQueryable<TEntity>> orderBy = null,
		CancellationToken cancellationToken = default)
	{
		IQueryable<TEntity> query = _dbSet;

		if (filter != null)
		{
			query = query.Where(filter);
		}

		if (orderBy != null)
		{
			return await orderBy(query).ProjectToType<TReadDto>().ToListAsync(cancellationToken);
		}

		return await query.ProjectToType<TReadDto>().ToListAsync(cancellationToken);
	}

	public async Task<TEntity> Get(Expression<Func<TEntity, bool>> filter,
		CancellationToken cancellationToken = default)
	{
		return await _dbSet.FirstOrDefaultAsync(filter, cancellationToken);
	}

	public async Task<TReadDto> Get<TReadDto>(Expression<Func<TEntity, bool>> filter,
		CancellationToken cancellationToken = default)
	{
		return await _dbSet.Where(filter).ProjectToType<TReadDto>().FirstOrDefaultAsync(cancellationToken);
	}

	public async Task<TEntity> GetById(object id, CancellationToken cancellationToken = default)
	{
		return await _dbSet.FindAsync(id, cancellationToken);
	}

	public TEntity Add(TEntity entity)
	{
		_dbSet.Add(entity);
		return entity;
	}

	public async Task<TEntity> AddWithSave(TEntity entity, CancellationToken cancellationToken = default)
	{
		await _dbSet.AddAsync(entity, cancellationToken);
		await _context.SaveChangesAsync(cancellationToken);
		return entity;
	}

	public TEntity Update(TEntity entity)
	{
		_dbSet.Attach(entity);
		_context.Entry(entity).State = EntityState.Modified;
		return entity;
	}

	public async Task<TEntity> UpdateWithSave(TEntity entity, CancellationToken cancellationToken = default)
	{
		_dbSet.Attach(entity);
		_context.Entry(entity).State = EntityState.Modified;
		await _context.SaveChangesAsync(cancellationToken);
		return entity;
	}

	public void Delete(TEntity entityToDelete)
	{
		if (_context.Entry(entityToDelete).State == EntityState.Detached)
		{
			_dbSet.Attach(entityToDelete);
		}

		_dbSet.Remove(entityToDelete);
	}

	public async Task DeleteWithSave(TEntity entityToDelete, CancellationToken cancellationToken = default)
	{
		if (_context.Entry(entityToDelete).State == EntityState.Detached)
		{
			_dbSet.Attach(entityToDelete);
		}

		_dbSet.Remove(entityToDelete);
		await _context.SaveChangesAsync(cancellationToken);
	}

	public async Task Save(CancellationToken cancellationToken = default)
	{
		await _context.SaveChangesAsync(cancellationToken);
	}

	private bool disposed = false;

	protected virtual void Dispose(bool disposing)
	{
		if (!this.disposed)
		{
			if (disposing)
			{
				_context.Dispose();
			}
		}

		this.disposed = true;
	}

	public void Dispose()
	{
		Dispose(true);
		GC.SuppressFinalize(this);
	}
}