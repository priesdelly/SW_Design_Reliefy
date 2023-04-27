using System.Text.Json.Serialization;

namespace Reliefy.UI.Models;

public class SendOtpRequest
{
    [JsonPropertyName("uid")]
    public string Uid { get; set; }

    [JsonPropertyName("email")]
    public string Email { get; set; }
}