using AstroFinance.Application.Common.Interfaces;
using AstroFinance.Application.Customers.Commands.CreateCustomer;
using MediatR;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace AstroFinance.Application.Customers.Queries.GetCustomersList
{
    public class GetCustomersListQuery : IRequest<CustomersListVm>
    {
        public string? SearchTerm { get; set; }
        public int PageNumber { get; set; } = 1;
        public int PageSize { get; set; } = 10;
    }

    public class GetCustomersListQueryHandler : IRequestHandler<GetCustomersListQuery, CustomersListVm>
    {
        private readonly IApplicationDbContext _context;

        public GetCustomersListQueryHandler(IApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<CustomersListVm> Handle(GetCustomersListQuery request, CancellationToken cancellationToken)
        {
            var query = _context.Customers.AsNoTracking();

            // Apply search filter if provided
            if (!string.IsNullOrWhiteSpace(request.SearchTerm))
            {
                var searchTerm = request.SearchTerm.ToLower();
                query = query.Where(c => 
                    EF.Functions.Like(c.FirstName, $"%{searchTerm}%") ||
                    EF.Functions.Like(c.LastName, $"%{searchTerm}%") ||
                    EF.Functions.Like(c.PhoneNumber, $"%{searchTerm}%") ||
                    EF.Functions.Like(c.IdentificationNumber, $"%{searchTerm}%") ||
                    (c.Email != null && EF.Functions.Like(c.Email, $"%{searchTerm}%"))
                );
            }

            // Get total count for pagination
            var totalCount = await query.CountAsync(cancellationToken);

            // Apply pagination
            var customers = await query
                .OrderByDescending(c => c.CreatedAt)
                .Skip((request.PageNumber - 1) * request.PageSize)
                .Take(request.PageSize)
                .Select(c => new CustomerDto
                {
                    Id = c.Id,
                    FirstName = c.FirstName,
                    LastName = c.LastName,
                    Email = c.Email,
                    PhoneNumber = c.PhoneNumber,
                    Address = c.Address,
                    IdentificationNumber = c.IdentificationNumber,
                    IdentificationType = c.IdentificationType,
                    CreatedAt = c.CreatedAt
                })
                .ToListAsync(cancellationToken);

            return new CustomersListVm
            {
                data = customers,
                TotalCount = totalCount,
                PageNumber = request.PageNumber,
                PageSize = request.PageSize,
                TotalPages = (int)Math.Ceiling(totalCount / (double)request.PageSize)
            };
        }
    }

    public class CustomersListVm
    {
        public List<CustomerDto> data { get; set; } = new List<CustomerDto>();
        public int TotalCount { get; set; }
        public int PageNumber { get; set; }
        public int PageSize { get; set; }
        public int TotalPages { get; set; }
    }
}