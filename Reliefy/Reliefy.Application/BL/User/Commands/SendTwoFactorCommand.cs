using System.Net;
using System.Net.Mail;
using MediatR;
using Reliefy.Application.BL.Email.Commands;
using Reliefy.Application.Interfaces;
using Reliefy.Domain.Entities;

namespace Reliefy.Application.BL.User.Commands;

public record SendTwoFactorCommand : IRequest<ResponseMessage>
{
	public string Uid { get; set; }
	public string Email { get; set; }
}

public class SendTwoFactorCommandHandler : IRequestHandler<SendTwoFactorCommand, ResponseMessage>
{
	private readonly IApplicationDbContext _context;
	private readonly IMediator _mediator;

	public SendTwoFactorCommandHandler(IApplicationDbContext context, IMediator mediator)
	{
		_context = context;
		_mediator = mediator;
	}

	public async Task<ResponseMessage> Handle(SendTwoFactorCommand request, CancellationToken cancellationToken)
	{
		try
		{
			var code = new Random().Next(100000, 999999).ToString();
			var twoFactor = new TwoFactor
			{
				Email = request.Email,
				Code = code,
				IsUsed = false,
				ExpireAt = DateTime.Now.AddMinutes(15),
				CreatedAt = DateTime.Now
			};

			var sendMailCommand = new SendMailCommand
			{
				Email = twoFactor.Email,
				Subject = "Verify your identity",
				Body = $"Verification code: {twoFactor.Code}"
			};

			await _mediator.Send(sendMailCommand, cancellationToken);

			_context.TwoFactor.Add(twoFactor);
			await _context.SaveChangesAsync(cancellationToken);
		}
		catch (Exception ex)
		{
			return new ResponseMessage
			{
				Status = "error",
				Message = ex.Message
			};
		}

		return new ResponseMessage
		{
			Status = "success",
		};
	}
}