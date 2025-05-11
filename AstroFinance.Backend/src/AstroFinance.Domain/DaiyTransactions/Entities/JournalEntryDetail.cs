using AstroFinance.Domain.Common;

namespace AstroFinance.Domain.DailyTransactions.Entities
{
    public class JournalEntryDetail : BaseAuditableEntity
    {
        public string JournalEntryId { get; set; } = string.Empty;
        public string Account { get; set; } = string.Empty;
        public bool IsDebit { get; set; }
        public decimal Amount { get; set; }
        
        // Navigation properties
        public JournalEntry JournalEntry { get; set; } = null!;
    }
}