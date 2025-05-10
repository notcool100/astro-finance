using AstroFinance.Domain.Audit.Entities;
using AstroFinance.Domain.Auth.Entities;
using AstroFinance.Domain.Customers.Entities;
using AstroFinance.Domain.Loans.Entities;
using AstroFinance.Domain.Sms.Entities;
using AstroFinance.Domain.Transactions.Entities;
using AstroFinance.Domain.DailyTransactions.Entities;
using Microsoft.EntityFrameworkCore;
using System.Threading;
using System.Threading.Tasks;

namespace AstroFinance.Application.Common.Interfaces
{
    public interface IApplicationDbContext
    {
        // Auth
        DbSet<User> Users { get; }

        // Customers
        DbSet<Customer> Customers { get; }

        // Loans
        DbSet<Loan> Loans { get; }
        DbSet<PaymentSchedule> PaymentSchedules { get; }

        // Transactions
        DbSet<Transaction> Transactions { get; }
        DbSet<DailyTransaction> DailyTransactions { get; }
        DbSet<AstroFinance.Domain.Transactions.Entities.JournalEntry> JournalEntries { get; }
        DbSet<AstroFinance.Domain.Transactions.Entities.JournalEntryDetail> JournalEntryDetails { get; }
        DbSet<AstroFinance.Domain.Transactions.Entities.ChartOfAccount> ChartOfAccounts { get; }

        // SMS
        DbSet<SmsTemplate> SmsTemplates { get; }
        DbSet<SmsHistory> SmsHistories { get; }

        // Audit
        DbSet<AuditLog> AuditLogs { get; }

        Task<int> SaveChangesAsync(CancellationToken cancellationToken);
    }
}