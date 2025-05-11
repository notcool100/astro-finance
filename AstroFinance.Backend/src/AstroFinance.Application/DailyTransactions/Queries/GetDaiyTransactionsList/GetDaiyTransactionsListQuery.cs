using AstroFinance.Application.Common.Interfaces;
using MediatR;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace AstroFinance.Application.DailyTransactions.Queries.GetDailyTransactionsList
{
    public class GetDailyTransactionsListQuery : IRequest<DailyTransactionsListVm>
    {
        public string? SearchTerm { get; set; }
        public int PageNumber { get; set; } = 1;
        public int PageSize { get; set; } = 10;
        public Guid? LoanId { get; set; }
        public Guid? CustomerId { get; set; }
        public DateTime? FromDate { get; set; }
        public DateTime? ToDate { get; set; }
    }

    public class GetDailyTransactionsListQueryHandler : IRequestHandler<GetDailyTransactionsListQuery, DailyTransactionsListVm>
    {
        private readonly IApplicationDbContext _context;

        public GetDailyTransactionsListQueryHandler(IApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<DailyTransactionsListVm> Handle(GetDailyTransactionsListQuery request, CancellationToken cancellationToken)
        {
            // Start with a base query
            var baseQuery = _context.Transactions.AsNoTracking();
            
            // Apply filters
            if (!string.IsNullOrWhiteSpace(request.SearchTerm))
            {
                var searchTerm = request.SearchTerm.ToLower();
                baseQuery = baseQuery.Where(t => t.Description.ToLower().Contains(searchTerm));
            }

            if (request.LoanId.HasValue)
            {
                baseQuery = baseQuery.Where(t => t.LoanId == request.LoanId.Value.ToString());
            }

            if (request.CustomerId.HasValue)
            {
                baseQuery = baseQuery.Where(t => t.CustomerId == request.CustomerId.Value.ToString());
            }

            if (request.FromDate.HasValue)
            {
                baseQuery = baseQuery.Where(t => t.Date >= request.FromDate.Value);
            }

            if (request.ToDate.HasValue)
            {
                baseQuery = baseQuery.Where(t => t.Date <= request.ToDate.Value);
            }

            // Get total count for pagination
            var totalCount = await baseQuery.CountAsync(cancellationToken);

            // Apply pagination and include related entities for the final query
            var Dailytransactions = await baseQuery
                .OrderByDescending(t => t.Date)
                .Skip((request.PageNumber - 1) * request.PageSize)
                .Take(request.PageSize)
                .Include(t => t.Loan)
                .ThenInclude(l => l != null ? l.Customer : null)
                .Include(t => t.Customer)
                .ToListAsync(cancellationToken);

            // Map to DTOs
            var DailytransactionDtos = Dailytransactions.Select(t => new DailyTransactionDto
            {
                Id = t.Id,
                CustomerName = (t.Customer != null ? $"{t.Customer.FirstName} {t.Customer.LastName}" : "Unknown"),
                Type = t.Type.ToString(),
                Amount = t.Amount,
                TransactionDate = t.Date,
                Description = t.Description
            }).ToList();

            return new DailyTransactionsListVm
            {
                DailyTransactions = DailytransactionDtos,
                TotalCount = totalCount,
                PageNumber = request.PageNumber,
                PageSize = request.PageSize,
                TotalPages = (int)Math.Ceiling(totalCount / (double)request.PageSize)
            };
        }
    }

    public class DailyTransactionsListVm
    {
        public List<DailyTransactionDto> DailyTransactions { get; set; } = new List<DailyTransactionDto>();
        public int TotalCount { get; set; }
        public int PageNumber { get; set; }
        public int PageSize { get; set; }
        public int TotalPages { get; set; }
    }

    public class DailyTransactionDto
    {
        public Guid Id { get; set; }
        public string CustomerName { get; set; } = string.Empty;
        public string Type { get; set; } = string.Empty;
        public decimal Amount { get; set; }
        public DateTime TransactionDate { get; set; }
        public string Description { get; set; } = string.Empty;
    }
}