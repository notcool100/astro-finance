using AstroFinance.Domain.Common;

namespace AstroFinance.Domain.DailyTransactions.Entities
{
    public class ChartOfAccount : BaseAuditableEntity
    {
        public string Code { get; set; } = string.Empty;
        public string Name { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public string Type { get; set; } = string.Empty; // Asset, Liability, Equity, Income, Expense
        public bool IsActive { get; set; } = true;
        public string? ParentAccountId { get; set; }
        
        // Navigation properties
        public ChartOfAccount? ParentAccount { get; set; }
    }
}