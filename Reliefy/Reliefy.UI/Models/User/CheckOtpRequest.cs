using System.Text.Json.Serialization;

namespace Reliefy.UI.Models;

public class CheckOtpRequest
{
    [JsonPropertyName("email")]
    public string Email { get; set; }

    [JsonPropertyName("code")]
    public string Code { get; set; }
}