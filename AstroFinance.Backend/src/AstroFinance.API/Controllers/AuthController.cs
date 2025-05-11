using AstroFinance.Application.Auth.Commands.Login;
using AstroFinance.Application.Auth.Commands.Register;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using System.Linq;
using System.Security.Claims;

namespace AstroFinance.API.Controllers
{
    public class AuthController : ApiControllerBase
    {
        [HttpPost("login")]
        public async Task<IActionResult> Login(LoginCommand command)
        {
            var result = await Mediator.Send(command);
            
            if (!result.Success)
            {
                return Unauthorized(new { message = result.ErrorMessage });
            }

            return Ok(result);
        }

        [HttpPost("register")]
        [Authorize(Roles = "Admin")] // Only admins can register new users
        public async Task<IActionResult> Register(RegisterCommand command)
        {
            var result = await Mediator.Send(command);
            return Ok(result);
        }

        [HttpPost("logout")]
        [Authorize]
        public IActionResult Logout()
        {
            // In a token-based authentication system, the server doesn't need to do anything
            // The client is responsible for removing the token
            return Ok(new { success = true, message = "Logged out successfully" });
        }
        
        [HttpGet("me")]
        [Authorize]
        public IActionResult GetCurrentUser()
        {
            // Get the current user from the claims
           
            var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value; // OR "sub" if JWT
    var email = User.FindFirst(ClaimTypes.Email)?.Value;
    var name = User.FindFirst(ClaimTypes.Name)?.Value;
    var role = User.FindFirst(ClaimTypes.Role)?.Value;

            if (userId == null)
            {
                return Unauthorized(new { message = "User not found" });
            }
            
            // Split name into first and last name
            var nameParts = name?.Split(' ') ?? new[] { "", "" };
            var firstName = nameParts.Length > 0 ? nameParts[0] : "";
            var lastName = nameParts.Length > 1 ? string.Join(" ", nameParts.Skip(1)) : "";
            
            return Ok(new { 
                data = new {
                    id = userId,
                    email = email,
                    firstName = firstName,
                    lastName = lastName,
                    role = role
                },
                success = true
            });
        }
    }
}