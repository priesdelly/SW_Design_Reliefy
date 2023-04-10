using System.Collections.Immutable;
using System.Security.Claims;
using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using OpenIddict.Abstractions;
using OpenIddict.Server.AspNetCore;

namespace Reliefy.Client.Controllers;

public class AuthorizationController : Controller
{
	private readonly SignInManager<Domain.Entities.User> _signInManager;
	private readonly UserManager<Domain.Entities.User> _userManager;

	public AuthorizationController(
		SignInManager<Domain.Entities.User> signInManager,
		UserManager<Domain.Entities.User> userManager)
	{
		_signInManager = signInManager;
		_userManager = userManager;
	}

	[HttpPost("~/connect/token"), IgnoreAntiforgeryToken, Produces("application/json")]
	public async Task<IActionResult> Exchange()
	{
		var request = HttpContext.GetOpenIddictServerRequest();
		if (request.IsPasswordGrantType())
		{
			var user = await _userManager.FindByNameAsync(request.Username);
			if (user == null)
			{
				var properties = new AuthenticationProperties(new Dictionary<string, string>
				{
					[OpenIddictServerAspNetCoreConstants.Properties.Error] = OpenIddictConstants.Errors.InvalidGrant,
					[OpenIddictServerAspNetCoreConstants.Properties.ErrorDescription] =
						"The username/password couple is invalid."
				});

				return Forbid(properties, OpenIddictServerAspNetCoreDefaults.AuthenticationScheme);
			}

			// Validate the username/password parameters and ensure the account is not locked out.
			var result = await _signInManager.CheckPasswordSignInAsync(user, request.Password, lockoutOnFailure: true);
			if (!result.Succeeded)
			{
				var properties = new AuthenticationProperties(new Dictionary<string, string>
				{
					[OpenIddictServerAspNetCoreConstants.Properties.Error] = OpenIddictConstants.Errors.InvalidGrant,
					[OpenIddictServerAspNetCoreConstants.Properties.ErrorDescription] =
						"The username/password couple is invalid."
				}!);

				return Forbid(properties, OpenIddictServerAspNetCoreDefaults.AuthenticationScheme);
			}

			// Create the claims-based identity that will be used by OpenIddict to generate tokens.
			var identity = new ClaimsIdentity(
				authenticationType: TokenValidationParameters.DefaultAuthenticationType,
				nameType: OpenIddictConstants.Claims.Name,
				roleType: OpenIddictConstants.Claims.Role);

			// Add the claims that will be persisted in the tokens.
			identity.SetClaim(OpenIddictConstants.Claims.Subject, await _userManager.GetUserIdAsync(user))
				.SetClaim(OpenIddictConstants.Claims.Email, await _userManager.GetEmailAsync(user))
				.SetClaim(OpenIddictConstants.Claims.Name, await _userManager.GetUserNameAsync(user))
				.SetClaims(OpenIddictConstants.Claims.Role,
					(await _userManager.GetRolesAsync(user)).ToImmutableArray());

			// Note: in this sample, the granted scopes match the requested scope
			// but you may want to allow the user to uncheck specific scopes.
			// For that, simply restrict the list of scopes before calling SetScopes.
			identity.SetScopes(request.GetScopes());
			identity.SetDestinations(GetDestinations);

			// Returning a SignInResult will ask OpenIddict to issue the appropriate access/identity tokens.
			return SignIn(new ClaimsPrincipal(identity), OpenIddictServerAspNetCoreDefaults.AuthenticationScheme);
		}

		else if (request.IsRefreshTokenGrantType())
		{
			// Retrieve the claims principal stored in the refresh token.
			var result = await HttpContext.AuthenticateAsync(OpenIddictServerAspNetCoreDefaults.AuthenticationScheme);

			// Retrieve the user profile corresponding to the refresh token.
			var user = await _userManager.FindByIdAsync(result.Principal.GetClaim(OpenIddictConstants.Claims.Subject));
			if (user == null)
			{
				var properties = new AuthenticationProperties(new Dictionary<string, string>
				{
					[OpenIddictServerAspNetCoreConstants.Properties.Error] = OpenIddictConstants.Errors.InvalidGrant,
					[OpenIddictServerAspNetCoreConstants.Properties.ErrorDescription] =
						"The refresh token is no longer valid."
				});

				return Forbid(properties, OpenIddictServerAspNetCoreDefaults.AuthenticationScheme);
			}

			// Ensure the user is still allowed to sign in.
			if (!await _signInManager.CanSignInAsync(user))
			{
				var properties = new AuthenticationProperties(new Dictionary<string, string>
				{
					[OpenIddictServerAspNetCoreConstants.Properties.Error] = OpenIddictConstants.Errors.InvalidGrant,
					[OpenIddictServerAspNetCoreConstants.Properties.ErrorDescription] =
						"The user is no longer allowed to sign in."
				});

				return Forbid(properties, OpenIddictServerAspNetCoreDefaults.AuthenticationScheme);
			}

			var identity = new ClaimsIdentity(result.Principal.Claims,
				authenticationType: TokenValidationParameters.DefaultAuthenticationType,
				nameType: OpenIddictConstants.Claims.Name,
				roleType: OpenIddictConstants.Claims.Role);

			// Override the user claims present in the principal in case they changed since the refresh token was issued.
			identity.SetClaim(OpenIddictConstants.Claims.Subject, await _userManager.GetUserIdAsync(user))
				.SetClaim(OpenIddictConstants.Claims.Email, await _userManager.GetEmailAsync(user))
				.SetClaim(OpenIddictConstants.Claims.Name, await _userManager.GetUserNameAsync(user))
				.SetClaims(OpenIddictConstants.Claims.Role,
					(await _userManager.GetRolesAsync(user)).ToImmutableArray());

			identity.SetDestinations(GetDestinations);

			return SignIn(new ClaimsPrincipal(identity), OpenIddictServerAspNetCoreDefaults.AuthenticationScheme);
		}

		throw new NotImplementedException("The specified grant type is not implemented.");
	}

	private static IEnumerable<string> GetDestinations(Claim claim)
	{
		// Note: by default, claims are NOT automatically included in the access and identity tokens.
		// To allow OpenIddict to serialize them, you must attach them a destination, that specifies
		// whether they should be included in access tokens, in identity tokens or in both.

		switch (claim.Type)
		{
			case OpenIddictConstants.Claims.Name:
				yield return OpenIddictConstants.Destinations.AccessToken;

				if (claim.Subject.HasScope(OpenIddictConstants.Permissions.Scopes.Profile))
					yield return OpenIddictConstants.Destinations.IdentityToken;

				yield break;

			case OpenIddictConstants.Claims.Email:
				yield return OpenIddictConstants.Destinations.AccessToken;

				if (claim.Subject.HasScope(OpenIddictConstants.Permissions.Scopes.Email))
					yield return OpenIddictConstants.Destinations.IdentityToken;

				yield break;

			case OpenIddictConstants.Claims.Role:
				yield return OpenIddictConstants.Destinations.AccessToken;

				if (claim.Subject.HasScope(OpenIddictConstants.Permissions.Scopes.Roles))
					yield return OpenIddictConstants.Destinations.IdentityToken;

				yield break;

			// Never include the security stamp in the access and identity tokens, as it's a secret value.
			case "AspNet.Identity.SecurityStamp": yield break;

			default:
				yield return OpenIddictConstants.Destinations.AccessToken;
				yield break;
		}
	}
}