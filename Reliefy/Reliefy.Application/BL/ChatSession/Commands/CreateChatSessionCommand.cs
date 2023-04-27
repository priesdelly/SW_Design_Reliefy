using Mapster;
using MediatR;
using Reliefy.Application.BL.ChatSession.Queries;
using Reliefy.Application.Services;

namespace Reliefy.Application.BL.ChatSession.Commands;

public record CreateChatSessionCommand : IRequest<ChatSessionDto>
{
	public string AppointmentId { get; set; }
}

public class CreateChatSessionCommandHandler : IRequestHandler<CreateChatSessionCommand, ChatSessionDto>
{
	private readonly ChatSessionService _chatSessionService;

	public CreateChatSessionCommandHandler(ChatSessionService chatSessionService)
	{
		_chatSessionService = chatSessionService;
	}

	public async Task<ChatSessionDto> Handle(CreateChatSessionCommand request, CancellationToken cancellationToken)
	{
		var entity = request.Adapt<Domain.Entities.ChatSession>();
		await _chatSessionService.AddWithSave(entity, cancellationToken);
		return entity.Adapt<ChatSessionDto>();
	}
}