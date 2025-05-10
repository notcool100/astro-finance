using AstroFinance.Application.Common.Exceptions;
using AstroFinance.Application.Common.Interfaces;
using AstroFinance.Application.DailyTransactions.Queries.GetDailyTransactionsList;
using MediatR;
using Microsoft.EntityFrameworkCore;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace AstroFinance.Application.DailyTransactions.Queries.GetDailyTransactionById
{
    public class GetDailyTransactionByIdQuery : IRequest<DailyTransactionDto>
    {
        public Guid Id { get; set; }
    }

    public class GetDailyTransactionByIdQueryHandler : IRequestHandler<GetDailyTransactionByIdQuery, DailyTransactionDto>
    {
        private readonly IApplicationDbContext _context;

        public GetDailyTransactionByIdQueryHandler(IApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<DailyTransactionDto> Handle(GetDailyTransactionByIdQuery request, CancellationToken cancellationToken)
        {
            var Dailytransaction = await _context.DailyTransactions
                .AsNoTracking()
                .Include(t => t.Customer)
                .FirstOrDefaultAsync(t => t.Id == request.Id, cancellationToken);

            if (Dailytransaction == null)
            {
                throw new NotFoundException("Transaction", request.Id);
            }

            return new DailyTransactionDto
            {
                Id = Dailytransaction.Id,
                CustomerName = Dailytransaction.Customer != null 
                    ? $"{Dailytransaction.Customer.FirstName} {Dailytransaction.Customer.LastName}" 
                    : (Dailytransaction.Customer != null ? $"{Dailytransaction.Customer.FirstName} {Dailytransaction.Customer.LastName}" : "Unknown"),
                Type = Dailytransaction.Type.ToString(),
                Amount = Dailytransaction.Amount,
                TransactionDate = Dailytransaction.Date,
                Description = Dailytransaction.Description
            };
        }
    }
}