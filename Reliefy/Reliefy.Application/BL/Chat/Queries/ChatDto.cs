namespace Reliefy.Application.BL.Chat.Queries;

public class ChatDto
{
	public Guid Id { get; set; }
	public string Message { get; set; }
	public Guid ChatSessionId { get; set; }
	public Guid SenderId { get; set; }
	public Guid ReceiverId { get; set; }
	public bool IsRead { get; set; }
	public DateTime CreatedDate { get; set; }
}