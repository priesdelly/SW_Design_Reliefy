using MediatR;
using Reliefy.Application.BL.ChatSession.Commands;
using Reliefy.Application.Services;

namespace Reliefy.Application.BL.ChatSession.Queries;

public record GetChatSessionQuery : IRequest<ChatSessionDto>
{
	public string AppointmentId { get; set; }
}

public class GetChatSessionQueryHandler : IRequestHandler<GetChatSessionQuery, ChatSessionDto>
{
	private readonly ChatSessionService _chatSessionService;
	private readonly IMediator _mediator;

	public GetChatSessionQueryHandler(ChatSessionService chatSessionService, IMediator mediator)
	{
		_chatSessionService = chatSessionService;
		_mediator = mediator;
	}

	public async Task<ChatSessionDto> Handle(GetChatSessionQuery request, CancellationToken cancellationToken)
	{
		var session = await _chatSessionService.Get<ChatSessionDto>(x =>
			x.AppointmentId == Guid.Parse(request.AppointmentId), cancellationToken);
		if (session is null)
		{
			var createChatSessionCommand = new CreateChatSessionCommand { AppointmentId = request.AppointmentId };
			session = await _mediator.Send(createChatSessionCommand, cancellationToken);
		}
		else
		{
			session.Chats = session.Chats.OrderByDescending(x => x.CreatedDate).ToList();
		}

		return session;
	}
}