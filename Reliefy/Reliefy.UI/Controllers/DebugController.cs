using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Reliefy.UI.Controllers;

public class DebugController : ApiControllerBase
{
    private readonly IConfiguration _configuration;

    public DebugController(IConfiguration configuration)
    {
        _configuration = configuration;
    }

    [AllowAnonymous]
    [HttpGet("/env")]
    public ActionResult<string> GetEnv()
    {
        var env = _configuration["Environment"] ?? "is null";
        return Ok("Environment: " + env);
    }
}