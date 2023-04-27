using System.Net;
using System.Net.Mail;
using MediatR;
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

	public SendTwoFactorCommandHandler(IApplicationDbContext context)
	{
		_context = context;
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

			const string smtpServer = "sandbox.smtp.mailtrap.io";
			const int smtpPort = 2525;
			const string smtpUsername = "c835ef720ce075";
			const string smtpPassword = "e25e31c356e6c7";

			// Create the SMTP client object
			var client = new SmtpClient(smtpServer, smtpPort);
			client.Credentials = new NetworkCredential(smtpUsername, smtpPassword);
			client.EnableSsl = true;

			var message = new MailMessage();
			message.From = new MailAddress("noreply@reliefy.chat");
			message.To.Add(new MailAddress(twoFactor.Email));
			message.Subject = "Verify your identity";
			message.Body = $"Verification code: {twoFactor.Code}";

			client.Send(message);

			_context.TwoFactor.Add(twoFactor);
			await _context.SaveChangesAsync();
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