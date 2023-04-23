using Autofac;
using Autofac.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;
using Reliefy.Application;
using Reliefy.Application.Interfaces;
using Reliefy.Application.Services;
using Reliefy.Infrastructure;
using Reliefy.UI.Services;
using Serilog;
using Serilog.Events;

var builder = WebApplication.CreateBuilder(args);
builder.Host.UseServiceProviderFactory(new AutofacServiceProviderFactory())
	.UseSerilog((ctx, lc) => lc
		.MinimumLevel.Override("Microsoft", LogEventLevel.Error)
		.Enrich.FromLogContext()
		.WriteTo.File("logs/log" + DateTime.Now.ToString("yyyy-MM-dd"))
	);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.TryAddSingleton<IHttpContextAccessor, HttpContextAccessor>();
builder.Services.AddScoped<ICurrentUserService, CurrentUserService>();
builder.Services.AddDatabaseService(builder.Configuration);
builder.Services.AddFirebaseAuthService(builder.Configuration);
builder.Services.AddApplicationServices();
builder.Host.ConfigureContainer<ContainerBuilder>(containerBuilder =>
	containerBuilder.RegisterAssemblyTypes(typeof(GenericService<>).Assembly)
		.AsClosedTypesOf(typeof(GenericService<>)));

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
	app.UseSwagger();
	app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();