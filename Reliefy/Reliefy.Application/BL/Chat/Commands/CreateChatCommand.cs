using Mapster;
using MediatR;
using Reliefy.Application.BL.Chat.Queries;
using Reliefy.Application.Services;

namespace Reliefy.Application.BL.Chat.Commands;

public record CreateChatCommand : IRequest<ChatDto>
{
	public string Message { get; set; }
	public string ChatSessionId { get; set; }
	public string SenderId { get; set; }
	public string ReceiverId { get; set; }
	public bool? IsRead { get; set; } = false;
}

public class CreateChatCommandCommand : IRequestHandler<CreateChatCommand, ChatDto>
{
	private readonly ChatService _chatService;

	public CreateChatCommandCommand(ChatService chatService)
	{
		_chatService = chatService;
	}

	public async Task<ChatDto> Handle(CreateChatCommand request, CancellationToken cancellationToken)
	{
		var entity = request.Adapt<Domain.Entities.Chat>();
		await _chatService.AddWithSave(entity, cancellationToken);
		return entity.Adapt<ChatDto>();
	}
}