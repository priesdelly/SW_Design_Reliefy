using System.Text.Json.Serialization;

namespace Reliefy.Application.Model.User
{
    public class ReviewDto
    {
        [JsonPropertyName("score")]
        public int Score { get; set; }
    }
}