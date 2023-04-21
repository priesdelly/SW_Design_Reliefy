using System.Reflection;
using MediatR;
using Microsoft.Extensions.DependencyInjection;

namespace Reliefy.Application;

public static class ConfigurationServices
{
	public static IServiceCollection AddApplicationServices(this IServiceCollection services)
	{
		services.AddMediatR(cfg => { cfg.RegisterServicesFromAssembly(Assembly.GetExecutingAssembly()); });

		return services;
	}
}