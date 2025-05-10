"use client"

import { useState } from "react"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Tabs, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { Badge } from "@/components/ui/badge"
import { formatNepaliCurrency } from "@/lib/format"
import TransactionForm, { NewTransaction } from "@/components/transaction/transaction-form"
import { ArrowDownLeft, ArrowUpRight, Calendar, Download, Filter, Printer, Search } from "lucide-react"

// Sample transaction data
const transactionsData = [
  {
    id: "1",
    clientName: "Rajesh Kumar",
    type: "deposit",
    amount: 15000,
    accountType: "SB",
    time: "09:15 AM",
    date: "2023-05-01",
    reference: "DEP-2023-001",
    notes: "Monthly savings deposit",
  },
  {
    id: "2",
    clientName: "Priya Sharma",
    type: "withdrawal",
    amount: 8000,
    accountType: "BB",
    time: "10:30 AM",
    date: "2023-05-01",
    reference: "WIT-2023-001",
    notes: "Education expenses",
  },
  {
    id: "3",
    clientName: "Amit Singh",
    type: "deposit",
    amount: 25000,
    accountType: "MB",
    time: "11:45 AM",
    date: "2023-05-01",
    reference: "DEP-2023-002",
    notes: "Business income deposit",
  },
  {
    id: "4",
    clientName: "Sunita Patel",
    type: "withdrawal",
    amount: 12500,
    accountType: "SB",
    time: "01:20 PM",
    date: "2023-05-01",
    reference: "WIT-2023-002",
    notes: "Medical expenses",
  },
  {
    id: "5",
    clientName: "Rahul Verma",
    type: "deposit",
    amount: 5000,
    accountType: "BB",
    time: "03:45 PM",
    date: "2023-04-30",
    reference: "DEP-2023-003",
    notes: "Child education savings",
  },
  {
    id: "6",
    clientName: "Deepika Reddy",
    type: "deposit",
    amount: 18000,
    accountType: "SB",
    time: "04:30 PM",
    date: "2023-04-30",
    reference: "DEP-2023-004",
    notes: "Salary deposit",
  },
  {
    id: "7",
    clientName: "Vikram Joshi",
    type: "withdrawal",
    amount: 30000,
    accountType: "MB",
    time: "11:15 AM",
    date: "2023-04-29",
    reference: "WIT-2023-003",
    notes: "Business expenses",
  },
  {
    id: "8",
    clientName: "Neha Gupta",
    type: "deposit",
    amount: 10000,
    accountType: "SB",
    time: "02:45 PM",
    date: "2023-04-29",
    reference: "DEP-2023-005",
    notes: "Regular savings",
  },
]

export default function TransactionsPage() {
  const [selectedType, setSelectedType] = useState<string | null>(null)
  const [transactions, setTransactions] = useState(transactionsData)
  const [isTransactionFormOpen, setIsTransactionFormOpen] = useState(false)

  const filteredTransactions = selectedType ? transactions.filter((t) => t.type === selectedType) : transactions

  // Calculate totals
  const totalDeposits = transactions.filter((t) => t.type === "deposit").reduce((sum, t) => sum + t.amount, 0)

  const totalWithdrawals = transactions.filter((t) => t.type === "withdrawal").reduce((sum, t) => sum + t.amount, 0)

  function handleNewTransactionClick() {
    setIsTransactionFormOpen(true)
  }

  function handleTransactionFormClose() {
    setIsTransactionFormOpen(false)
  }

  function handleTransactionSubmit(newTransaction: NewTransaction) {
    // Add new transaction to the list with generated id, reference, date, time
    const now = new Date()
    const id = (transactions.length + 1).toString()
    const referencePrefix = newTransaction.type === "deposit" ? "DEP" : "WIT"
    const reference = `${referencePrefix}-${now.getFullYear()}-${id.padStart(3, "0")}`
    const date = now.toISOString().split("T")[0]
    const time = now.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" })

    const customerName = "Unknown"
    // For simplicity, we can keep customerName as Unknown or fetch from customers list if needed

    const transaction = {
      id,
      clientName: customerName,
      type: newTransaction.type,
      amount: newTransaction.amount,
      accountType: newTransaction.accountType,
      time,
      date,
      reference,
      notes: newTransaction.notes,
    }
    setTransactions([transaction, ...transactions])
    setIsTransactionFormOpen(false)
  }

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-3xl font-bold tracking-tight text-slate-900 dark:text-slate-100">Transactions</h1>
          <p className="text-muted-foreground">Manage client deposits and withdrawals</p>
        </div>
        <div className="flex gap-2">
          <Button variant="outline">
            <Calendar className="h-4 w-4 mr-2" />
            Select Date
          </Button>
          <Button className="bg-emerald-600 hover:bg-emerald-700" onClick={handleNewTransactionClick}>
            <ArrowUpRight className="h-4 w-4 mr-2" />
            New Transaction
          </Button>
        </div>
      </div>
      <TransactionForm open={isTransactionFormOpen} onClose={handleTransactionFormClose} onSubmit={handleTransactionSubmit} />

      <div className="grid gap-6 md:grid-cols-3">
        <Card>
          <CardHeader className="pb-2">
            <CardTitle>Total Deposits</CardTitle>
            <CardDescription>All time deposits</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="flex items-center justify-between">
              <div className="space-y-1">
                <span className="text-sm font-medium text-slate-500 dark:text-slate-400">Amount:</span>
                <p className="text-2xl font-bold text-emerald-600 dark:text-emerald-400">
                  {formatNepaliCurrency(totalDeposits)}
                </p>
              </div>
              <div className="h-12 w-12 rounded-full bg-emerald-100 dark:bg-emerald-900/20 flex items-center justify-center">
                <ArrowUpRight className="h-6 w-6 text-emerald-600 dark:text-emerald-400" />
              </div>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="pb-2">
            <CardTitle>Total Withdrawals</CardTitle>
            <CardDescription>All time withdrawals</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="flex items-center justify-between">
              <div className="space-y-1">
                <span className="text-sm font-medium text-slate-500 dark:text-slate-400">Amount:</span>
                <p className="text-2xl font-bold text-red-600 dark:text-red-400">
                  {formatNepaliCurrency(totalWithdrawals)}
                </p>
              </div>
              <div className="h-12 w-12 rounded-full bg-red-100 dark:bg-red-900/20 flex items-center justify-center">
                <ArrowDownLeft className="h-6 w-6 text-red-600 dark:text-red-400" />
              </div>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="pb-2">
            <CardTitle>Net Balance</CardTitle>
            <CardDescription>Deposits - Withdrawals</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="flex items-center justify-between">
              <div className="space-y-1">
                <span className="text-sm font-medium text-slate-500 dark:text-slate-400">Amount:</span>
                <p className="text-2xl font-bold text-slate-900 dark:text-slate-100">
                  {formatNepaliCurrency(totalDeposits - totalWithdrawals)}
                </p>
              </div>
              <div className="flex gap-2">
                <Button variant="outline" size="sm">
                  <Printer className="h-4 w-4 mr-2" />
                  Print
                </Button>
                <Button variant="outline" size="sm">
                  <Download className="h-4 w-4 mr-2" />
                  Export
                </Button>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>

      <Tabs defaultValue="all" className="space-y-4">
        <div className="flex justify-between items-center">
          <TabsList>
            <TabsTrigger value="all" onClick={() => setSelectedType(null)}>
              All Transactions
            </TabsTrigger>
            <TabsTrigger value="deposits" onClick={() => setSelectedType("deposit")}>
              Deposits
            </TabsTrigger>
            <TabsTrigger value="withdrawals" onClick={() => setSelectedType("withdrawal")}>
              Withdrawals
            </TabsTrigger>
          </TabsList>

          <div className="flex gap-2">
            <div className="relative">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-slate-400" />
              <Input placeholder="Search transactions..." className="pl-10 w-[250px]" />
            </div>
            <Button variant="outline" size="icon">
              <Filter className="h-4 w-4" />
            </Button>
          </div>
        </div>

        <Card>
          <CardContent className="p-0">
            <div className="rounded-md border border-slate-200 dark:border-slate-700">
              <div className="overflow-x-auto">
                <table className="w-full text-sm">
                  <thead>
                    <tr className="bg-slate-50 dark:bg-slate-800">
                      <th className="text-left py-3 px-4 font-medium text-slate-500 dark:text-slate-400">Client</th>
                      <th className="text-left py-3 px-4 font-medium text-slate-500 dark:text-slate-400">Type</th>
                      <th className="text-left py-3 px-4 font-medium text-slate-500 dark:text-slate-400">Account</th>
                      <th className="text-left py-3 px-4 font-medium text-slate-500 dark:text-slate-400">Reference</th>
                      <th className="text-left py-3 px-4 font-medium text-slate-500 dark:text-slate-400">
                        Date & Time
                      </th>
                      <th className="text-left py-3 px-4 font-medium text-slate-500 dark:text-slate-400">Notes</th>
                      <th className="text-right py-3 px-4 font-medium text-slate-500 dark:text-slate-400">Amount</th>
                    </tr>
                  </thead>
                  <tbody>
                    {filteredTransactions.map((transaction) => (
                      <tr
                        key={transaction.id}
                        className="border-t border-slate-200 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-800/50"
                      >
                        <td className="py-3 px-4">
                          <div className="flex items-center gap-3">
                            <Avatar className="h-8 w-8">
                              <AvatarImage
                                src={`/placeholder.svg?height=32&width=32&text=${transaction.clientName.charAt(0)}`}
                                alt={transaction.clientName}
                              />
                              <AvatarFallback>{transaction.clientName.charAt(0)}</AvatarFallback>
                            </Avatar>
                            <span className="font-medium">{transaction.clientName}</span>
                          </div>
                        </td>
                        <td className="py-3 px-4">
                          <div className="flex items-center gap-2">
                            <div
                              className={`flex h-6 w-6 items-center justify-center rounded-full ${
                                transaction.type === "deposit"
                                  ? "bg-emerald-100 dark:bg-emerald-900/20"
                                  : "bg-red-100 dark:bg-red-900/20"
                              }`}
                            >
                              {transaction.type === "deposit" ? (
                                <ArrowUpRight className={`h-3 w-3 text-emerald-600 dark:text-emerald-400`} />
                              ) : (
                                <ArrowDownLeft className={`h-3 w-3 text-red-600 dark:text-red-400`} />
                              )}
                            </div>
                            <span className="capitalize">{transaction.type}</span>
                          </div>
                        </td>
                        <td className="py-3 px-4">
                          <Badge variant="outline" className="text-xs font-normal">
                            {transaction.accountType === "SB"
                              ? "Sadaran Bachat"
                              : transaction.accountType === "BB"
                                ? "Baal Bachat"
                                : "Masik Bachat"}
                          </Badge>
                        </td>
                        <td className="py-3 px-4 text-slate-700 dark:text-slate-300">{transaction.reference}</td>
                        <td className="py-3 px-4 text-slate-700 dark:text-slate-300">
                          {transaction.date} at {transaction.time}
                        </td>
                        <td className="py-3 px-4 text-slate-700 dark:text-slate-300">{transaction.notes}</td>
                        <td className="py-3 px-4 text-right font-medium">
                          <span
                            className={`${
                              transaction.type === "deposit"
                                ? "text-emerald-600 dark:text-emerald-400"
                                : "text-red-600 dark:text-red-400"
                            }`}
                          >
                            {transaction.type === "deposit" ? "+" : "-"}
                            {formatNepaliCurrency(transaction.amount)}
                          </span>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
              <div className="flex items-center justify-between px-4 py-3 border-t border-slate-200 dark:border-slate-700">
                <div className="text-sm text-slate-500 dark:text-slate-400">
                  Showing <span className="font-medium">{filteredTransactions.length}</span> of{" "}
                  <span className="font-medium">{transactionsData.length}</span> transactions
                </div>
                <div className="flex items-center space-x-2">
                  <Button variant="outline" size="sm" disabled>
                    Previous
                  </Button>
                  <Button variant="outline" size="sm">
                    Next
                  </Button>
                </div>
              </div>
            </div>
          </CardContent>
        </Card>
      </Tabs>
    </div>
  )
}
