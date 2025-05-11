using AstroFinance.Application.DailyTransactions.Commands.CreateDailyTransaction;
using AstroFinance.Application.DailyTransactions.Commands.DeleteDailyTransaction;
using AstroFinance.Application.DailyTransactions.Queries.GetDailyTransactionById;
using AstroFinance.Application.DailyTransactions.Queries.GetDailyTransactionsList;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Threading.Tasks;

namespace AstroFinance.API.Controllers
{
    [Authorize]
    public class DailyTransactionsController : ApiControllerBase
    {
        [HttpGet]
        public async Task<IActionResult> GetAll([FromQuery] GetDailyTransactionsListQuery query)
        {
            var result = await Mediator.Send(query);
            return Ok(result);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(Guid id)
        {
            var result = await Mediator.Send(new GetDailyTransactionByIdQuery { Id = id });
            return Ok(result);
        }

        [HttpPost]
        public async Task<IActionResult> Create(CreateDailyTransactionCommand command)
        {
            var result = await Mediator.Send(command);
            return CreatedAtAction(nameof(GetById), new { id = result }, result);
        }

        [HttpDelete("{id}")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> Delete(Guid id)
        {
            await Mediator.Send(new DeleteDailyTransactionCommand { Id = id });
            return NoContent();
        }
    }
}