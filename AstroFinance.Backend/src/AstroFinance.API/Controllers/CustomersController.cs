using AstroFinance.Application.Customers.Commands.CreateCustomer;
using AstroFinance.Application.Customers.Commands.DeleteCustomer;
using AstroFinance.Application.Customers.Commands.UpdateCustomer;
using AstroFinance.Application.Customers.Queries.GetCustomerById;
using AstroFinance.Application.Customers.Queries.GetCustomersList;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Threading.Tasks;

namespace AstroFinance.API.Controllers
{
    [Authorize]
    public class CustomersController : ApiControllerBase
    {

        [HttpGet]
        public async Task<IActionResult> GetAll([FromQuery] GetCustomersListQuery query)
        {
            var result = await Mediator.Send(query);
            return Ok(result);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(Guid id)
        {
            var result = await Mediator.Send(new GetCustomerByIdQuery { Id = id });
            return Ok(result);
        }

        [HttpPost]
        public async Task<IActionResult> Create(CreateCustomerCommand command)
        {
            var result = await Mediator.Send(command);
            return CreatedAtAction(nameof(GetById), new { id = result.Id }, result);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(Guid id, UpdateCustomerCommand command)
        {
            if (id != command.Id)
            {
                return BadRequest();
            }

            await Mediator.Send(command);
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(Guid id)
        {
            await Mediator.Send(new DeleteCustomerCommand { Id = id });
            return NoContent();
        }
    }
}