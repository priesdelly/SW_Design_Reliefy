using System.Net;
using System.Net.Mail;
using MediatR;

namespace Reliefy.Application.BL.Email.Commands;

public record SendMailCommand : IRequest<bool>
{
	public string Email { get; set; }
	public string Subject { get; set; }
	public string Body { get; set; }
}

internal class SendMailCommandHandler : IRequestHandler<SendMailCommand, bool>
{
	public Task<bool> Handle(SendMailCommand request, CancellationToken cancellationToken)
	{
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
		message.To.Add(new MailAddress(request.Email));
		message.Subject = request.Subject;
		message.Body = request.Body;

		client.Send(message);
		return Task.FromResult(true);
	}
}