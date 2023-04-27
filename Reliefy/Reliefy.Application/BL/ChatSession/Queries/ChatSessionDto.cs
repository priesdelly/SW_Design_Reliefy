using Reliefy.Application.BL.Chat.Queries;

namespace Reliefy.Application.BL.ChatSession.Queries;

public class ChatSessionDto
{
	public Guid Id { get; set; }
	public Guid AppointmentId { get; set; }
	public List<ChatDto> Chats { get; set; }
}