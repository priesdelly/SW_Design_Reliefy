using FirebaseAdmin;
using Google.Apis.Auth.OAuth2;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.IdentityModel.Tokens;
using Reliefy.Application.Interfaces;
using Reliefy.Infrastructure.Persistence;
using Reliefy.Infrastructure.Persistence.Interceptors;

namespace Reliefy.Infrastructure;

public static class ConfigureServices
{
	public static IServiceCollection AddDatabaseService(this IServiceCollection services, IConfiguration configuration)
	{
		services.AddDbContext<ApplicationDbContext>(options =>
		{
			options.UseNpgsql(configuration.GetConnectionString("ReliefyDB"),
				builder => builder.MigrationsAssembly(typeof(ApplicationDbContext).Assembly.FullName));
		});

		AppContext.SetSwitch("Npgsql.EnableLegacyTimestampBehavior", true);
		services.AddScoped<AuditableEntitySaveChangesInterceptor>();
		services.AddScoped<IApplicationDbContext>(provider => provider.GetRequiredService<ApplicationDbContext>());
		// using (ServiceProvider serviceProvider = services.BuildServiceProvider())
		// {
		// 	// Update Database.
		// 	var context = serviceProvider.GetRequiredService<IApplicationDbContext>();
		// 	if (context.Database.ProviderName != "Microsoft.EntityFrameworkCore.InMemory")
		// 	{
		// 		context.Database.Migrate();
		// 	}
		// }

		return services;
	}

	public static IServiceCollection AddFirebaseAuthService(this IServiceCollection services,
		IConfiguration configuration)
	{
		// Ref from https://dev.to/ossan/firebase-authentication-net-5-29oi
		FirebaseApp.Create(new AppOptions()
		{
			Credential = GoogleCredential.FromFile(configuration["Secrets:FirebasePath"]),
		});

		// firebase auth
		services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
			.AddJwtBearer(opt =>
			{
				opt.Authority = configuration["Jwt:Firebase:ValidIssuer"];
				opt.TokenValidationParameters = new TokenValidationParameters
				{
					ValidateIssuer = true,
					ValidateAudience = true,
					ValidateLifetime = true,
					ValidateIssuerSigningKey = true,
					ValidIssuer = configuration["Jwt:Firebase:ValidIssuer"],
					ValidAudience = configuration["Jwt:Firebase:ValidAudience"]
				};

				opt.Events = new JwtBearerEvents
				{
					OnMessageReceived = context =>
					{
						var accessToken = context.Request.Query["access_token"];

						var path = context.HttpContext.Request.Path;
						if (!string.IsNullOrEmpty(accessToken) && (path.StartsWithSegments("/chatHub")))
						{
							context.Token = accessToken;
						}

						return Task.CompletedTask;
					}
				};
			});

		return services;
	}
}