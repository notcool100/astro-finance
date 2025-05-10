using AstroFinance.Application.Common.Interfaces;
using AstroFinance.Domain.Audit.Entities;
using AstroFinance.Domain.Auth.Entities;
using AstroFinance.Domain.Common;
using AstroFinance.Domain.Customers.Entities;
using AstroFinance.Domain.Loans.Entities;
using AstroFinance.Domain.Sms.Entities;
using AstroFinance.Domain.Transactions.Entities;
using AstroFinance.Domain.DailyTransactions.Entities;
using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;
using System.Reflection;
using System.Threading;
using System.Threading.Tasks;

namespace AstroFinance.Infrastructure.Persistence
{
    public class ApplicationDbContext : DbContext, IApplicationDbContext
    {
        private readonly ICurrentUserService _currentUserService;
        private readonly IDateTime _dateTime;

        public ApplicationDbContext(
            DbContextOptions<ApplicationDbContext> options,
            ICurrentUserService currentUserService,
            IDateTime dateTime) : base(options)
        {
            _currentUserService = currentUserService;
            _dateTime = dateTime;
        }

        // Auth
        public DbSet<User> Users => Set<User>();

        // Customers
        public DbSet<Customer> Customers => Set<Customer>();

        // Loans
        public DbSet<Loan> Loans => Set<Loan>();
        public DbSet<PaymentSchedule> PaymentSchedules => Set<PaymentSchedule>();

        // Transactions
        public DbSet<Transaction> Transactions => Set<Transaction>();
        public DbSet<DailyTransaction> DailyTransactions => Set<DailyTransaction>();

        public DbSet<AstroFinance.Domain.Transactions.Entities.JournalEntry> JournalEntries => Set<AstroFinance.Domain.Transactions.Entities.JournalEntry>();
        public DbSet<AstroFinance.Domain.Transactions.Entities.JournalEntryDetail> JournalEntryDetails => Set<AstroFinance.Domain.Transactions.Entities.JournalEntryDetail>();
        public DbSet<AstroFinance.Domain.Transactions.Entities.ChartOfAccount> ChartOfAccounts => Set<AstroFinance.Domain.Transactions.Entities.ChartOfAccount>();

        // SMS
        public DbSet<SmsTemplate> SmsTemplates => Set<SmsTemplate>();
        public DbSet<SmsHistory> SmsHistories => Set<SmsHistory>();

        // Audit
        public DbSet<AuditLog> AuditLogs => Set<AuditLog>();

        public override async Task<int> SaveChangesAsync(CancellationToken cancellationToken = default)
        {
           foreach (var entry in ChangeTracker.Entries<BaseAuditableEntity>())
{
    switch (entry.State)
{
    case EntityState.Added:
        entry.Entity.CreatedBy = _currentUserService.UserId ?? Guid.Empty;
        entry.Entity.CreatedAt = _dateTime.Now;
        break;

    case EntityState.Modified:
        entry.Entity.LastModifiedBy = _currentUserService.UserId ?? Guid.Empty;
        entry.Entity.LastModifiedAt = _dateTime.Now;
        break;
}
}

            return await base.SaveChangesAsync(cancellationToken);
        }

        protected override void OnModelCreating(ModelBuilder builder)
        {
            base.OnModelCreating(builder);

            // Configure the User entity explicitly
            builder.Entity<User>(entity =>
            {
                entity.ToTable("users");

                entity.Property(e => e.Id).HasColumnName("id");
                entity.Property(e => e.Email).HasColumnName("email");
                entity.Property(e => e.FirstName).HasColumnName("first_name");
                entity.Property(e => e.LastName).HasColumnName("last_name");
                entity.Property(e => e.PasswordHash).HasColumnName("password_hash");
                entity.Property(e => e.Role).HasColumnName("role");
                entity.Property(e => e.IsActive).HasColumnName("is_active");
                entity.Property(e => e.LastLoginDate).HasColumnName("last_login_date");

                entity.Property(e => e.CreatedAt).HasColumnName("created_at");
                entity.Property(e => e.CreatedBy).HasColumnName("created_by");
                entity.Property(e => e.LastModifiedAt).HasColumnName("last_modified_at");
                entity.Property(e => e.LastModifiedBy).HasColumnName("last_modified_by");
            });

            // Configure the Customer entity
            builder.Entity<Customer>(entity =>
            {
                entity.ToTable("customers");

                entity.Property(e => e.Id).HasColumnName("id");
                entity.Property(e => e.FirstName).HasColumnName("first_name");
                entity.Property(e => e.LastName).HasColumnName("last_name");
                entity.Property(e => e.Email).HasColumnName("email");
                entity.Property(e => e.PhoneNumber).HasColumnName("phone_number");
                entity.Property(e => e.Address).HasColumnName("address");
                entity.Property(e => e.IdentificationNumber).HasColumnName("identification_number");
                entity.Property(e => e.IdentificationType).HasColumnName("identification_type");

                entity.Property(e => e.CreatedAt).HasColumnName("created_at");
                entity.Property(e => e.CreatedBy).HasColumnName("created_by");
                entity.Property(e => e.LastModifiedAt).HasColumnName("last_modified_at");
                entity.Property(e => e.LastModifiedBy).HasColumnName("last_modified_by");
            });

            // Configure the Loan entity
            builder.Entity<Loan>(entity =>
            {
                entity.ToTable("loans");
                
                // Add property mappings as needed
            });

            // Configure the PaymentSchedule entity
            builder.Entity<PaymentSchedule>(entity =>
            {
                entity.ToTable("payment_schedules");
                
                // Add property mappings as needed
            });

            // Configure the Transaction entity
            builder.Entity<Transaction>(entity =>
            {
                entity.ToTable("transactions");
                
                // Add property mappings as needed
            });

            // Configure the JournalEntry entity
            builder.Entity<AstroFinance.Domain.Transactions.Entities.JournalEntry>(entity =>
            {
                entity.ToTable("journal_entries");
                
                // Add property mappings as needed
            });

            // Configure the JournalEntryDetail entity
            builder.Entity<AstroFinance.Domain.Transactions.Entities.JournalEntryDetail>(entity =>
            {
                entity.ToTable("journal_entry_details");
                
                // Add property mappings as needed
            });

            // Configure the ChartOfAccount entity
            builder.Entity<AstroFinance.Domain.Transactions.Entities.ChartOfAccount>(entity =>
            {
                entity.ToTable("chart_of_accounts");
                
                // Add property mappings as needed
            });

            // Configure the SmsTemplate entity
            builder.Entity<SmsTemplate>(entity =>
            {
                entity.ToTable("sms_templates");
                
                // Add property mappings as needed
            });

            // Configure the SmsHistory entity
            builder.Entity<SmsHistory>(entity =>
            {
                entity.ToTable("sms_histories");
                
                // Add property mappings as needed
            });

            // Configure the AuditLog entity
            builder.Entity<AuditLog>(entity =>
            {
                entity.ToTable("audit_logs");
                
                // Add property mappings as needed
            });

            // Automatically apply all IEntityTypeConfiguration<T> configurations
            builder.ApplyConfigurationsFromAssembly(Assembly.GetExecutingAssembly());
        }
    }
}
