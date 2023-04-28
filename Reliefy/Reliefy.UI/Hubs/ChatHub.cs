using Mapster;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;
using Newtonsoft.Json;
using Reliefy.Application.BL.Appointment.Commands;
using Reliefy.Application.BL.Chat.Commands;
using Reliefy.Application.BL.Chat.Queries;
using Reliefy.Application.Interfaces;
using Reliefy.Application.Services;

namespace Reliefy.UI.Hubs;

[Authorize]
public class ChatHub : Hub
{
	private readonly ICurrentUserService _currentUserService;
	private readonly IMediator _mediator;

	private static List<UserConnected> _usersSession = new ();

	public ChatHub(ICurrentUserService currentUserService, IMediator mediator)
	{
		_currentUserService = currentUserService;
		_mediator = mediator;
	}

	public override Task OnConnectedAsync()
	{
		var userConnected = _usersSession.Where(x => x.UserId == _currentUserService.UserId).ToList();
		if (userConnected.Any())
		{
			_usersSession.Remove(userConnected.First());
		}

		var connect = new UserConnected
		{
			ConnectionId = Context.ConnectionId,
			UserId = _currentUserService.UserId
		};

		_usersSession.Add(connect);

		Console.WriteLine(connect.UserId + " Connected with " + connect.ConnectionId);
		return base.OnConnectedAsync();
	}

	public async Task CompleteAppontment(string appointmentId)
	{
		var command = new CompleteAppointmentCommand { AppointmentId = appointmentId };
		var result = await _mediator.Send(command);
		var connectionIds = _usersSession
			.Where(x => x.UserId == result.DoctorId || x.UserId == result.PatientId)
			.Select(x => x.ConnectionId).ToList();
		if (connectionIds.Count > 0)
		{
			await Clients.Clients(connectionIds).SendAsync("Complete", result);
		}
	}

	public async Task SendMessage(CreateChatCommand command)
	{
		var result = await _mediator.Send(command);
		var connectionIds = _usersSession
			.Where(x => x.UserId == result.ReceiverId.ToString() || x.UserId == result.SenderId.ToString())
			.Select(x => x.ConnectionId).ToList();
		if (connectionIds.Count > 0)
		{
			await Clients.Clients(connectionIds).SendAsync("ReceiveMessage", result);
		}
	}
}

class UserConnected
{
	public string UserId { get; set; } = null!;
	public string ConnectionId { get; set; } = null!;
}