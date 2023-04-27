using Reliefy.Application.Interfaces;
using Reliefy.Domain.Entities;

namespace Reliefy.Application.Services;

public class ChatSessionService : GenericService<ChatSession>
{
	public ChatSessionService(IApplicationDbContext context) : base(context)
	{
	}
}