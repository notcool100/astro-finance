using AstroFinance.Domain.Common;
using AstroFinance.Domain.DailyTransactions.Entities;

namespace AstroFinance.Domain.DailyTransactions.Events
{
    public class TransactionCreatedEvent : BaseEvent
    {
        public DailyTransaction Transaction { get; }

        public TransactionCreatedEvent(DailyTransaction transaction)
        {
            Transaction = transaction;
        }
    }
}