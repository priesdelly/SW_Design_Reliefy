using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Quartz;
using Reliefy.Application.Interfaces;
using Reliefy.Domain.Entities;
using Reliefy.Infrastructure.Persistence;

namespace Reliefy.Infrastructure;

public static class ConfigureServices
{
	public static IServiceCollection AddServices(this IServiceCollection services, IConfiguration configuration)
	{
		services.AddDbContext<ApplicationDbContext>(options =>
		{
			// Configure the context to use sqlite.
			options.UseNpgsql(configuration.GetConnectionString("ReliefyDB"),
				builder => builder.MigrationsAssembly(typeof(ApplicationDbContext).Assembly.FullName));

			// Register the entity sets needed by OpenIddict.
			// Note: use the generic overload if you need
			// to replace the default OpenIddict entities.
			options.UseOpenIddict();
		});

		// Register the Identity services.
		services.AddIdentity<User, Role>(options =>
			{
				options.Password.RequiredLength = 8;
				options.Password.RequireNonAlphanumeric = false;
			})
			.AddRoleManager<RoleManager<Role>>()
			.AddSignInManager<SignInManager<User>>()
			.AddRoleValidator<RoleValidator<Role>>()
			.AddEntityFrameworkStores<ApplicationDbContext>()
			.AddDefaultTokenProviders();

		// OpenIddict offers native integration with Quartz.NET to perform scheduled tasks
		// (like pruning orphaned authorizations/tokens from the database) at regular intervals.
		services.AddQuartz(options =>
		{
			options.UseMicrosoftDependencyInjectionJobFactory();
			options.UseSimpleTypeLoader();
			options.UseInMemoryStore();
		});

		// Register the Quartz.NET service and configure it to block shutdown until jobs are complete.
		services.AddQuartzHostedService(options => options.WaitForJobsToComplete = true);

		services.AddOpenIddict()
			// Register the OpenIddict core components.
			.AddCore(options =>
			{
				// Configure OpenIddict to use the Entity Framework Core stores and models.
				// Note: call ReplaceDefaultEntities() to replace the default OpenIddict entities.
				options.UseEntityFrameworkCore()
					.UseDbContext<ApplicationDbContext>();

				// Enable Quartz.NET integration.
				options.UseQuartz();
			})

			// Register the OpenIddict server components.
			.AddServer(options =>
			{
				// Enable the token endpoint.
				options.SetTokenEndpointUris("connect/token");

				// Enable the password and the refresh token flows.
				options.AllowPasswordFlow()
					.AllowRefreshTokenFlow();

				// Accept anonymous clients (i.e clients that don't send a client_id).
				options.AcceptAnonymousClients();

				// Register the signing and encryption credentials.
				options.AddDevelopmentEncryptionCertificate()
					.AddDevelopmentSigningCertificate();

				// Register the ASP.NET Core host and configure the ASP.NET Core-specific options.
				options.UseAspNetCore()
					.EnableTokenEndpointPassthrough();
			})

			// Register the OpenIddict validation components.
			.AddValidation(options =>
			{
				// Import the configuration from the local OpenIddict server instance.
				options.UseLocalServer();

				// Register the ASP.NET Core host.
				options.UseAspNetCore();
			});

		return services;
	}

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