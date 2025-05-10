"use client";

import React, { useEffect, useState } from "react";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { customerService } from "@/lib/api/services/customerService";

interface TransactionFormProps {
  open: boolean;
  onClose: () => void;
  onSubmit: (transaction: NewTransaction) => void;
}

export interface NewTransaction {
  customerId: string;
  type: "deposit" | "withdrawal";
  amount: number;
  accountType: "SB" | "BB" | "MB";
  notes: string;
}

export default function TransactionForm({ open, onClose, onSubmit }: TransactionFormProps) {
  const [customers, setCustomers] = useState<{ id: string; name: string }[]>([]);
  const [customerId, setCustomerId] = useState<string>("");
  const [type, setType] = useState<"deposit" | "withdrawal">("deposit");
  const [amount, setAmount] = useState<number>(0);
  const [accountType, setAccountType] = useState<"SB" | "BB" | "MB">("SB");
  const [notes, setNotes] = useState<string>("");

  useEffect(() => {
    async function fetchCustomers() {
      try {
        const response = await customerService.getCustomers(1, 100);
        if (response && response.data && response.data) {
          setCustomers(response.data.map((c: any) => ({ id: c.id, name: c.fullName})));
        }
      } catch (error) {
        console.error("Failed to fetch customers", error);
      }
    }
    if (open) {
      fetchCustomers();
    }
  }, [open]);

  function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    if (!customerId || amount <= 0) {
      alert("Please select a customer and enter a valid amount.");
      return;
    }
    onSubmit({
      customerId,
      type,
      amount,
      accountType,
      notes,
    });
    // Reset form
    setCustomerId("");
    setType("deposit");
    setAmount(0);
    setAccountType("SB");
    setNotes("");
    onClose();
  }

  return (
    <Dialog open={open} onOpenChange={(open: boolean) => !open && onClose()}>
      <DialogContent className="sm:max-w-lg">
        <DialogHeader>
          <DialogTitle>New Transaction</DialogTitle>
        </DialogHeader>
        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <Label htmlFor="customer">Customer</Label>
            <Select value={customerId} onValueChange={setCustomerId} id="customer" required>
              <SelectTrigger>
                <SelectValue placeholder="Select a customer" />
              </SelectTrigger>
              <SelectContent>
                {customers.map((customer) => (
                  <SelectItem key={customer.id} value={customer.id}>
                    {customer.name}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
          <div>
            <Label htmlFor="type">Transaction Type</Label>
            <Select value={type} onValueChange={(value: string) => setType(value as "deposit" | "withdrawal")} id="type" required>
              <SelectTrigger>
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="deposit">Deposit</SelectItem>
                <SelectItem value="withdrawal">Withdrawal</SelectItem>
              </SelectContent>
            </Select>
          </div>
          <div>
            <Label htmlFor="amount">Amount</Label>
            <Input
              type="number"
              id="amount"
              value={amount}
              onChange={(e: React.ChangeEvent<HTMLInputElement>) => setAmount(Number(e.target.value))}
              min={0}
              step={0.01}
              required
            />
          </div>
          <div>
            <Label htmlFor="accountType">Account Type</Label>
            <Select
              value={accountType}
              onValueChange={(value: string) => setAccountType(value as "SB" | "BB" | "MB")}
              id="accountType"
              required
            >
              <SelectTrigger>
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="SB">Sadaran Bachat (SB)</SelectItem>
                <SelectItem value="BB">Baal Bachat (BB)</SelectItem>
                <SelectItem value="MB">Masik Bachat (MB)</SelectItem>
              </SelectContent>
            </Select>
          </div>
          <div>
            <Label htmlFor="notes">Notes</Label>
            <Input
              type="text"
              id="notes"
              value={notes}
              onChange={(e: React.ChangeEvent<HTMLInputElement>) => setNotes(e.target.value)}
              placeholder="Optional notes"
            />
          </div>
          <DialogFooter>
            <Button type="submit" className="mr-2">
              Submit
            </Button>
            <Button variant="outline" onClick={onClose} type="button">
              Cancel
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
