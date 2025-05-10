"use client"
import React, { useState, useEffect } from "react"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu"
import { customerService } from "@/lib/api/services/customerService"
import { MoreHorizontal } from "lucide-react"
import { Customer } from "@/lib/api/types"

export function RecentUsersTable() {
  const [customer, setCustomer] = useState<Customer[]>([])

  // Fetch data from API
  useEffect(() => {
    async function fetchCustomer() {
      try {
        console.log("Fetching customers...");
        const response = await customerService.getCustomers();
        console.log("API response:", response);

        // Debugging logs
        console.log("Response data:", response);
        console.log("Customers:", response?.customers);
        console.log("Is customers an array:", Array.isArray(response?.customers));

        // Ensure response.success is explicitly checked
        if (response.success === false) {
          throw new Error("Failed to fetch users");
        }

        // Validate the customers array
        if (!response || !response.customers || !Array.isArray(response.customers)) {
          console.log("Invalid customers data in the API response.");
          setCustomer([]); // Set an empty array if the data is invalid
          return;
        }

        if (response.customers.length === 0) {
          console.log("No customers found in the API response.");
          setCustomer([]); // Set an empty array if no customers are found
          return;
        }

        console.log("Setting customer data:", response.customers);
        setCustomer(response.customers); // Correctly set the customers array
      } catch (error) {
        console.error("Error fetching users:", error);
      }
    }

    fetchCustomer();
  }, []);
  useEffect(() => {
    console.log("Customer data:", customer)
  }, [customer])

  return (
    <div className="overflow-x-auto">
      {customer && customer.length > 0 ? (
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-slate-200 dark:border-slate-700">
              <th className="text-left py-3 px-4 font-medium text-slate-500 dark:text-slate-400">User</th>
              <th className="text-left py-3 px-4 font-medium text-slate-500 dark:text-slate-400">Account Type</th>
              <th className="text-left py-3 px-4 font-medium text-slate-500 dark:text-slate-400">Status</th>
              <th className="text-left py-3 px-4 font-medium text-slate-500 dark:text-slate-400">Date Created</th>
              <th className="text-right py-3 px-4 font-medium text-slate-500 dark:text-slate-400">Actions</th>
            </tr>
          </thead>
          <tbody>
            {customer.map((customer) => (
              <tr
                key={customer.id}
                className="border-b border-slate-200 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-800/50"
              >
                <td className="py-3 px-4">
                  <div className="flex items-center gap-3">
                    <Avatar className="h-8 w-8">
                      <AvatarImage
                        src={`/placeholder.svg?height=32&width=32&text=${customer.firstName.charAt(0)}`}
                        alt={customer.firstName}
                      />
                      <AvatarFallback>{customer.firstName.charAt(0)}</AvatarFallback>
                    </Avatar>
                    <div>
                      <p className="font-medium text-slate-800 dark:text-slate-200">{customer.firstName + " " + customer.lastName}</p>
                      <p className="text-xs text-slate-500 dark:text-slate-400">{customer.email}</p>
                    </div>
                  </div>
                </td>
                <td className="py-3 px-4">
                  <Badge variant="outline" className="text-xs font-normal">
                    {customer.accountType === "SB"
                      ? "Sadaran Bachat"
                      : customer.accountType === "BB"
                        ? "Baal Bachat"
                        : "Masik Bachat"}
                  </Badge>
                </td>
                <td className="py-3 px-4">
                  <Badge
                    variant={customer.status === "active" ? "default" : customer.status === "pending" ? "secondary" : "destructive"}
                  >
                    {customer.status}
                  </Badge>
                </td>
                <td className="py-3 px-4 text-slate-700 dark:text-slate-300">{customer.createdAt}</td>
                <td className="py-3 px-4 text-right">
                  <DropdownMenu>
                    <DropdownMenuTrigger asChild>
                      <Button variant="ghost" size="icon">
                        <MoreHorizontal className="h-4 w-4" />
                        <span className="sr-only">Actions</span>
                      </Button>
                    </DropdownMenuTrigger>
                    <DropdownMenuContent align="end">
                      <DropdownMenuLabel>Actions</DropdownMenuLabel>
                      <DropdownMenuSeparator />
                      <DropdownMenuItem>View Details</DropdownMenuItem>
                      <DropdownMenuItem>Edit User</DropdownMenuItem>
                      <DropdownMenuSeparator />
                      <DropdownMenuItem className="text-red-600 dark:text-red-400">Delete User</DropdownMenuItem>
                    </DropdownMenuContent>
                  </DropdownMenu>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      ) : (
        <p className="text-center text-slate-500 dark:text-slate-400 py-4">No Customer Found</p>
      )}
    </div>
  )
}
