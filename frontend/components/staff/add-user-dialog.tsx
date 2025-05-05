"use client"

import { useState } from "react"
import { Button } from "@/components/ui/button"
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Loader2 } from "lucide-react"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"

interface AddUserDialogProps {
  open: boolean
  onOpenChange: (open: boolean) => void
  onUserAdded: (user: any) => void
}

export function AddUserDialog({ open, onOpenChange, onUserAdded }: AddUserDialogProps) {
  const [isSubmitting, setIsSubmitting] = useState(false)
  const [newUser, setNewUser] = useState({
    name: "",
    email: "",
    phone: "",
    accountType: "SB",
    balance: 0,
    status: "active",
  })
  const [avatarPreview, setAvatarPreview] = useState("")

  const handleInputChange = (field: string, value: string | number) => {
    setNewUser({ ...newUser, [field]: value })

    // Update avatar preview when name changes
    if (field === "name" && typeof value === "string") {
      setAvatarPreview(value.charAt(0).toUpperCase())
    }
  }

  const handleSubmit = () => {
    setIsSubmitting(true)

    // Simulate API call
    setTimeout(() => {
      const user = {
        ...newUser,
        id: `${Date.now()}`, // Generate a unique ID
        dateCreated: new Date().toISOString().split("T")[0], // Today's date in YYYY-MM-DD format
      }

      onUserAdded(user)
      setIsSubmitting(false)
      onOpenChange(false)

      // Reset form
      setNewUser({
        name: "",
        email: "",
        phone: "",
        accountType: "SB",
        balance: 0,
        status: "active",
      })
      setAvatarPreview("")
    }, 1000)
  }

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-[500px]">
        <DialogHeader>
          <DialogTitle>Add New User</DialogTitle>
          <DialogDescription>Fill in the details to create a new user account.</DialogDescription>
        </DialogHeader>

        <div className="grid gap-6 py-4">
          <div className="flex items-center gap-4">
            <Avatar className="h-16 w-16">
              <AvatarImage src={`/placeholder.svg?height=64&width=64&text=${avatarPreview}`} alt="Preview" />
              <AvatarFallback>{avatarPreview}</AvatarFallback>
            </Avatar>
            <div className="flex-1">
              <h3 className="text-lg font-medium">User Profile</h3>
              <p className="text-sm text-muted-foreground">Personal information and account details</p>
            </div>
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div className="space-y-2">
              <Label htmlFor="name">Full Name</Label>
              <Input
                id="name"
                placeholder="Enter full name"
                value={newUser.name}
                onChange={(e) => handleInputChange("name", e.target.value)}
                required
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="email">Email Address</Label>
              <Input
                id="email"
                type="email"
                placeholder="user@example.com"
                value={newUser.email}
                onChange={(e) => handleInputChange("email", e.target.value)}
                required
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="phone">Phone Number</Label>
              <Input
                id="phone"
                placeholder="+977 98XXXXXXXX"
                value={newUser.phone}
                onChange={(e) => handleInputChange("phone", e.target.value)}
                required
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="accountType">Account Type</Label>
              <Select value={newUser.accountType} onValueChange={(value) => handleInputChange("accountType", value)}>
                <SelectTrigger id="accountType">
                  <SelectValue placeholder="Select account type" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="SB">Sadaran Bachat</SelectItem>
                  <SelectItem value="BB">Baal Bachat</SelectItem>
                  <SelectItem value="MB">Masik Bachat</SelectItem>
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label htmlFor="balance">Initial Balance</Label>
              <Input
                id="balance"
                type="number"
                placeholder="0"
                value={newUser.balance}
                onChange={(e) => handleInputChange("balance", Number(e.target.value))}
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="status">Status</Label>
              <Select value={newUser.status} onValueChange={(value) => handleInputChange("status", value)}>
                <SelectTrigger id="status">
                  <SelectValue placeholder="Select status" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="active">Active</SelectItem>
                  <SelectItem value="pending">Pending</SelectItem>
                  <SelectItem value="inactive">Inactive</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>
        </div>

        <DialogFooter>
          <Button variant="outline" onClick={() => onOpenChange(false)}>
            Cancel
          </Button>
          <Button onClick={handleSubmit} disabled={isSubmitting} className="bg-emerald-600 hover:bg-emerald-700">
            {isSubmitting ? (
              <>
                <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                Creating...
              </>
            ) : (
              "Create User"
            )}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  )
}
