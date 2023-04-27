using Reliefy.Application.Interfaces;
using Reliefy.Domain.Entities;

namespace Reliefy.Application.Services;

public class ChatService : GenericService<Chat>
{
	public ChatService(IApplicationDbContext context) : base(context)
	{
	}
}