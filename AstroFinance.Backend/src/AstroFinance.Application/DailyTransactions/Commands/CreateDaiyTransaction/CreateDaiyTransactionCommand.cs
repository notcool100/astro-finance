using AstroFinance.Application.Common.Exceptions;
using AstroFinance.Application.Common.Interfaces;
using AstroFinance.Domain.DailyTransactions.Entities;
using AstroFinance.Domain.DailyTransactions.Enums;
using MediatR;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace AstroFinance.Application.DailyTransactions.Commands.CreateDailyTransaction
{
    public class CreateDailyTransactionCommand : IRequest<Guid>
    {
        public Guid LoanId { get; set; }
        public string Type { get; set; } = string.Empty;
        public decimal Amount { get; set; }
        public DateTime? TransactionDate { get; set; }
        public string Description { get; set; } = string.Empty;
    }

    public class CreateDailyTransactionCommandHandler : IRequestHandler<CreateDailyTransactionCommand, Guid>
    {
        private readonly IApplicationDbContext _context;
        private readonly IDateTime _dateTime;
        private readonly ICurrentUserService _currentUserService;

        public CreateDailyTransactionCommandHandler(
            IApplicationDbContext context,
            IDateTime dateTime,
            ICurrentUserService currentUserService)
        {
            _context = context;
            _dateTime = dateTime;
            _currentUserService = currentUserService;
        }

        public async Task<Guid> Handle(CreateDailyTransactionCommand request, CancellationToken cancellationToken)
        {
            var loan = await _context.Loans
                .Include(l => l.Customer)
                .FirstOrDefaultAsync(l => l.Id.ToString() == request.LoanId.ToString(), cancellationToken);

            if (loan == null)
            {
                throw new NotFoundException("Loan", request.LoanId);
            }

            if (!Enum.TryParse<TransactionType>(request.Type, true, out var transactionType))
            {
                throw new ValidationException(new List<FluentValidation.Results.ValidationFailure>
                {
                    new FluentValidation.Results.ValidationFailure("Type", "Invalid transaction type")
                });
            }

            var dailyTransaction = new DailyTransaction
            {
                Id = Guid.NewGuid(),
                CustomerId = loan.CustomerId,
                Type = transactionType,
                Amount = request.Amount,
                Date = request.TransactionDate ?? _dateTime.Now,
                Description = request.Description,
                CreatedAt = _dateTime.Now,
                CreatedBy = _currentUserService.UserId
            };

_context.DailyTransactions.Add(dailyTransaction);
            await _context.SaveChangesAsync(cancellationToken);

            return dailyTransaction.Id;
            
        }
    }
}