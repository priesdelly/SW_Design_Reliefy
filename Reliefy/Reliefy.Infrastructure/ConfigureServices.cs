using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.IdentityModel.Tokens;
using Reliefy.Infrastructure.Persistence;

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
		
		return services;
	}
	
	public static IServiceCollection AddFirebaseAuthService(this IServiceCollection services, IConfiguration configuration)
	{
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
			});

		return services;
	}
}