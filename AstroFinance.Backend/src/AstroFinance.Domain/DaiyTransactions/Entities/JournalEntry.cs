using System;
using System.Collections.Generic;
using AstroFinance.Domain.Common;

namespace AstroFinance.Domain.DailyTransactions.Entities
{
    public class JournalEntry : BaseAuditableEntity
    {
        public string TransactionId { get; set; } = string.Empty;
        public DateTime EntryDate { get; set; }
        public string Description { get; set; } = string.Empty;
        
        // Navigation properties
        public DailyTransaction Transaction { get; set; } = null!;
        public ICollection<JournalEntryDetail> Details { get; set; } = new List<JournalEntryDetail>();
    }
}