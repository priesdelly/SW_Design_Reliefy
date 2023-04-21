using System.Reflection;
using Autofac;
using Autofac.Extensions.DependencyInjection;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Reliefy.Application;
using Reliefy.Infrastructure;

var builder = WebApplication.CreateBuilder(args);
builder.Host.UseServiceProviderFactory(new AutofacServiceProviderFactory());

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddDatabaseService(builder.Configuration);
builder.Services.AddFirebaseAuthService(builder.Configuration);
builder.Services.AddApplicationServices();
builder.Host.ConfigureContainer<ContainerBuilder>(containerBuilder =>
	containerBuilder.RegisterAssemblyTypes(Assembly.Load("Reliefy.Application")).Where(t => t.Name.EndsWith("Repository"))
		.AsImplementedInterfaces()
		.InstancePerLifetimeScope());

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