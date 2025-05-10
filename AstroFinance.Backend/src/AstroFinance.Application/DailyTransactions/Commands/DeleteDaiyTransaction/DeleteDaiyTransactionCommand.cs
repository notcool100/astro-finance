using AstroFinance.Application.Common.Exceptions;
using AstroFinance.Application.Common.Interfaces;
using FluentValidation.Results;
using MediatR;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace AstroFinance.Application.DailyTransactions.Commands.DeleteDailyTransaction
{
    public class DeleteDailyTransactionCommand : IRequest
    {
        public Guid Id { get; set; }
    }

    public class DeleteDailyTransactionCommandHandler : IRequestHandler<DeleteDailyTransactionCommand>
    {
        private readonly IApplicationDbContext _context;

        public DeleteDailyTransactionCommandHandler(IApplicationDbContext context)
        {
            _context = context;
        }

        public async Task Handle(DeleteDailyTransactionCommand request, CancellationToken cancellationToken)
        {
            var transaction = await _context.Transactions
                .FirstOrDefaultAsync(t => t.Id == request.Id, cancellationToken);

            if (transaction == null)
            {
                throw new NotFoundException("Transaction", request.Id);
            }

            // Check if there are any journal entries associated with this transaction
            var hasJournalEntries = await _context.JournalEntries
                .AnyAsync(je => je.TransactionId == transaction.Id.ToString(), cancellationToken);

            if (hasJournalEntries)
            {
                var failures = new List<ValidationFailure>
                {
                    new ValidationFailure("Transaction", "Cannot delete transaction with associated journal entries")
                };
                throw new ValidationException(failures);
            }

            _context.Transactions.Remove(transaction);
            await _context.SaveChangesAsync(cancellationToken);
        }
    }
}