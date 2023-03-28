using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Reliefy.Application.Interfaces;
using Reliefy.Domain.Entities;
using Reliefy.Infrastructure.Persistence;

namespace Reliefy.Infrastructure;

public static class ConfigureServices
{
	public static IServiceCollection AddInfrastructureServices(this IServiceCollection services,
		IConfiguration configuration)
	{
		services.AddDbContext<ApplicationDbContext>(option =>
		{
			option.UseNpgsql(configuration.GetConnectionString("ReliefyDB"),
				builder => builder.MigrationsAssembly(typeof(ApplicationDbContext).Assembly.FullName));
		});

		services.AddScoped<IApplicationDbContext>(provider => provider.GetRequiredService<ApplicationDbContext>());

		return services;
	}

	public static IServiceCollection AddIdentityService(this IServiceCollection services, IConfiguration configuration)
	{
		services.AddDefaultIdentity<User>()
			.AddRoles<Role>()
			.AddRoleManager<RoleManager<Role>>()
			.AddSignInManager<SignInManager<User>>()
			.AddRoleValidator<RoleValidator<Role>>()
			.AddEntityFrameworkStores<ApplicationDbContext>();

		services.AddAuthentication()
			.AddCookie(options =>
			{
				options.LoginPath = "/Account/Unauthorized/";
				options.AccessDeniedPath = "/Account/Forbidden/";
			})
			.AddGoogle(options =>
			{
				IConfigurationSection googleAuthNSection = configuration.GetSection("Authentication:Google");
				options.ClientId = googleAuthNSection["ClientId"]!;
				options.ClientSecret = googleAuthNSection["ClientSecret"]!;
			});
		return services;
	}
}