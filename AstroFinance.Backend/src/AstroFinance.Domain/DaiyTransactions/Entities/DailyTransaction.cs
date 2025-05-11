using System;
using System.Collections.Generic;
using AstroFinance.Domain.Common;
using AstroFinance.Domain.Customers.Entities;
using AstroFinance.Domain.Loans.Entities;
using AstroFinance.Domain.DailyTransactions.Enums;

namespace AstroFinance.Domain.DailyTransactions.Entities
{
    public class DailyTransaction : BaseAuditableEntity
    {
        public string CustomerId { get; set; } = string.Empty;
        public decimal Amount { get; set; }
        public TransactionType Type { get; set; }
        public string Description { get; set; } = string.Empty;
        public DateTime Date { get; set; }
        
        // Navigation properties
        public Customer Customer { get; set; } = null!;
        public ICollection<JournalEntry> JournalEntries { get; set; } = new List<JournalEntry>();
    }
}