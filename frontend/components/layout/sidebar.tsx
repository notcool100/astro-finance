"use client"

import { useState } from "react"
import Link from "next/link"
import { usePathname } from "next/navigation"
import { cn } from "@/lib/utils"
import {
  BarChart3,
  Users,
  Percent,
  CreditCard,
  Calculator,
  MessageSquare,
  BookOpen,
  FileText,
  Printer,
  ChevronLeft,
  ChevronRight,
  Menu,
  ArrowUpDown,
  LogOut,
} from "lucide-react"
import { Button } from "@/components/ui/button"
import { Tooltip, TooltipContent, TooltipProvider, TooltipTrigger } from "@/components/ui/tooltip"
import { useAuth } from "@/lib/context/auth-context"

const navItems = [
  {
    title: "Dashboard",
    href: "/dashboard",
    icon: BarChart3,
  },
  {
    title: "Transactions",
    href: "/transactions",
    icon: ArrowUpDown,
  },
  {
    title: "User Management",
    href: "/users",
    icon: Users,
  },
  {
    title: "Staff Management",
    href: "/staff",
    icon: Users,
  },
  {
    title: "Interest Management",
    href: "/interest",
    icon: Percent,
  },
  {
    title: "Loan Management",
    href: "/loans",
    icon: CreditCard,
  },
  {
    title: "EMI Calculator",
    href: "/calculator",
    icon: Calculator,
  },
  {
    title: "SMS Banking",
    href: "/sms",
    icon: MessageSquare,
  },
  {
    title: "Journal Entry",
    href: "/journal",
    icon: BookOpen,
  },
  {
    title: "Financial Reports",
    href: "/reports",
    icon: FileText,
  },
  {
    title: "Print Preview",
    href: "/print",
    icon: Printer,
  },
]

export function Sidebar() {
  const pathname = usePathname()
  const [collapsed, setCollapsed] = useState(false)
  const [mobileOpen, setMobileOpen] = useState(false)
  const { user, logout } = useAuth()

  return (
    <>
      {/* Mobile overlay */}
      {mobileOpen && (
        <div
          className="fixed inset-0 z-40 bg-background/80 backdrop-blur-sm md:hidden"
          onClick={() => setMobileOpen(false)}
        />
      )}

      {/* Mobile menu button */}
      <Button
        variant="outline"
        size="icon"
        className="fixed left-4 top-4 z-50 md:hidden"
        onClick={() => setMobileOpen(!mobileOpen)}
      >
        <Menu className="h-5 w-5" />
      </Button>

      {/* Sidebar */}
      <aside
        className={cn(
          "fixed inset-y-0 left-0 z-40 flex w-64 flex-col border-r bg-card transition-all duration-300 ease-in-out md:relative md:z-0",
          collapsed && "md:w-16",
          mobileOpen ? "translate-x-0" : "-translate-x-full md:translate-x-0",
        )}
      >
        <div className="flex h-16 items-center justify-between border-b px-4">
          <h2 className={cn("text-lg font-semibold tracking-tight transition-all", collapsed && "md:hidden")}>
            Micro Finance
          </h2>
          <Button variant="ghost" size="icon" className="hidden md:flex" onClick={() => setCollapsed(!collapsed)}>
            {collapsed ? <ChevronRight className="h-5 w-5" /> : <ChevronLeft className="h-5 w-5" />}
          </Button>
        </div>
        <div className="flex-1 overflow-y-auto py-4">
          <nav className="grid gap-1 px-2">
            <TooltipProvider delayDuration={0}>
              {navItems.map((item) => (
                <Tooltip key={item.href}>
                  <TooltipTrigger asChild>
                    <Link
                      href={item.href}
                      className={cn(
                        "group flex items-center rounded-md px-3 py-2 text-sm font-medium hover:bg-accent hover:text-accent-foreground",
                        pathname === item.href ? "bg-accent text-accent-foreground" : "transparent",
                        collapsed && "md:justify-center md:px-2",
                      )}
                    >
                      <item.icon className={cn("mr-2 h-5 w-5", collapsed && "md:mr-0")} />
                      <span className={cn(collapsed && "md:hidden")}>{item.title}</span>
                    </Link>
                  </TooltipTrigger>
                  <TooltipContent side="right" className={cn("md:hidden", !collapsed && "hidden")}>
                    {item.title}
                  </TooltipContent>
                </Tooltip>
              ))}
            </TooltipProvider>
          </nav>
        </div>
        <div className="border-t p-4">
          <div className={cn("flex items-center gap-2", collapsed && "md:justify-center")}>
            <div className="h-8 w-8 rounded-full bg-muted" />
            <div className={cn("space-y-1", collapsed && "md:hidden")}>
              <p className="text-sm font-medium leading-none">{user?.firstName} {user?.lastName}</p>
              <p className="text-xs leading-none text-muted-foreground">{user?.email || 'admin@example.com'}</p>
            </div>
          </div>
          
          <TooltipProvider delayDuration={0}>
            <Tooltip>
              <TooltipTrigger asChild>
                <Button 
                  variant="ghost" 
                  size="sm" 
                  className={cn(
                    "mt-4 w-full justify-start text-muted-foreground hover:text-foreground",
                    collapsed && "md:justify-center"
                  )}
                  onClick={logout}
                >
                  <LogOut className={cn("mr-2 h-4 w-4", collapsed && "md:mr-0")} />
                  <span className={cn(collapsed && "md:hidden")}>Logout</span>
                </Button>
              </TooltipTrigger>
              <TooltipContent side="right" className={cn("md:hidden", !collapsed && "hidden")}>
                Logout
              </TooltipContent>
            </Tooltip>
          </TooltipProvider>
        </div>
      </aside>
    </>
  )
}
