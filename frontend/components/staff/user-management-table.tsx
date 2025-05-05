"use client"

import { useState } from "react"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog"
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu"
import { Edit, MoreHorizontal, Trash2 } from "lucide-react"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { formatNepaliCurrency } from "@/lib/format"
import { AddUserDialog } from "./add-user-dialog"

const userData = [
  {
    id: "1",
    name: "Rajesh Kumar",
    email: "rajesh.kumar@example.com",
    phone: "+977 9876543210",
    accountType: "SB",
    balance: 42500,
    status: "active",
    dateCreated: "2023-04-12",
  },
  {
    id: "2",
    name: "Priya Sharma",
    email: "priya.sharma@example.com",
    phone: "+977 9865432109",
    accountType: "BB",
    balance: 15800,
    status: "active",
    dateCreated: "2023-05-18",
  },
  {
    id: "3",
    name: "Amit Singh",
    email: "amit.singh@example.com",
    phone: "+977 9765432109",
    accountType: "MB",
    balance: 28650,
    status: "pending",
    dateCreated: "2023-06-02",
  },
  {
    id: "4",
    name: "Sunita Patel",
    email: "sunita.patel@example.com",
    phone: "+977 9654321098",
    accountType: "SB",
    balance: 36900,
    status: "active",
    dateCreated: "2023-06-15",
  },
  {
    id: "5",
    name: "Rahul Verma",
    email: "rahul.verma@example.com",
    phone: "+977 9543210987",
    accountType: "BB",
    balance: 8750,
    status: "inactive",
    dateCreated: "2023-07-01",
  },
  {
    id: "6",
    name: "Deepika Reddy",
    email: "deepika.reddy@example.com",
    phone: "+977 9432109876",
    accountType: "MB",
    balance: 22300,
    status: "active",
    dateCreated: "2023-07-10",
  },
  {
    id: "7",
    name: "Vikram Joshi",
    email: "vikram.joshi@example.com",
    phone: "+977 9321098765",
    accountType: "SB",
    balance: 54800,
    status: "active",
    dateCreated: "2023-08-15",
  },
]

interface UserManagementTableProps {
  filterType?: "SB" | "BB" | "MB"
  addUserOpen?: boolean
  setAddUserOpen?: (open: boolean) => void
}

export function UserManagementTable({ filterType, addUserOpen = false, setAddUserOpen }: UserManagementTableProps) {
  const [users, setUsers] = useState(userData)
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false)
  const [editDialogOpen, setEditDialogOpen] = useState(false)
  const [userToDelete, setUserToDelete] = useState<string | null>(null)
  const [userToEdit, setUserToEdit] = useState<any>(null)

  const filteredUsers = filterType ? users.filter((user) => user.accountType === filterType) : users

  const handleDeleteClick = (userId: string) => {
    setUserToDelete(userId)
    setDeleteDialogOpen(true)
  }

  const handleEditClick = (user: any) => {
    setUserToEdit({ ...user })
    setEditDialogOpen(true)
  }

  const confirmDelete = () => {
    // Delete the user from the state
    setUsers(users.filter((user) => user.id !== userToDelete))
    setDeleteDialogOpen(false)
    setUserToDelete(null)
  }

  const saveUserEdit = () => {
    // Update the user in the state
    setUsers(users.map((user) => (user.id === userToEdit.id ? userToEdit : user)))
    setEditDialogOpen(false)
    setUserToEdit(null)
  }

  const handleUserAdded = (newUser: any) => {
    setUsers([...users, newUser])
  }

  return (
    <>
      <div className="rounded-md border border-slate-200 dark:border-slate-700">
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead>
              <tr className="bg-slate-50 dark:bg-slate-800">
                <th className="text-left py-3 px-4 font-medium text-slate-500 dark:text-slate-400">Name</th>
                <th className="text-left py-3 px-4 font-medium text-slate-500 dark:text-slate-400">Phone</th>
                <th className="text-left py-3 px-4 font-medium text-slate-500 dark:text-slate-400">Account Type</th>
                <th className="text-left py-3 px-4 font-medium text-slate-500 dark:text-slate-400">Balance</th>
                <th className="text-left py-3 px-4 font-medium text-slate-500 dark:text-slate-400">Status</th>
                <th className="text-left py-3 px-4 font-medium text-slate-500 dark:text-slate-400">Date Created</th>
                <th className="text-right py-3 px-4 font-medium text-slate-500 dark:text-slate-400">Actions</th>
              </tr>
            </thead>
            <tbody>
              {filteredUsers.map((user) => (
                <tr
                  key={user.id}
                  className="border-t border-slate-200 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-800/50"
                >
                  <td className="py-3 px-4">
                    <div className="flex items-center gap-3">
                      <Avatar className="h-8 w-8">
                        <AvatarImage
                          src={`/placeholder.svg?height=32&width=32&text=${user.name.charAt(0)}`}
                          alt={user.name}
                        />
                        <AvatarFallback>{user.name.charAt(0)}</AvatarFallback>
                      </Avatar>
                      <div>
                        <p className="font-medium text-slate-800 dark:text-slate-200">{user.name}</p>
                        <p className="text-xs text-slate-500 dark:text-slate-400">{user.email}</p>
                      </div>
                    </div>
                  </td>
                  <td className="py-3 px-4 text-slate-700 dark:text-slate-300">{user.phone}</td>
                  <td className="py-3 px-4">
                    <Badge variant="outline" className="text-xs font-normal">
                      {user.accountType === "SB"
                        ? "Sadaran Bachat"
                        : user.accountType === "BB"
                          ? "Baal Bachat"
                          : "Masik Bachat"}
                    </Badge>
                  </td>
                  <td className="py-3 px-4 text-slate-700 dark:text-slate-300 font-medium">
                    {formatNepaliCurrency(user.balance)}
                  </td>
                  <td className="py-3 px-4">
                    <Badge
                      variant={
                        user.status === "active" ? "success" : user.status === "pending" ? "warning" : "destructive"
                      }
                    >
                      {user.status}
                    </Badge>
                  </td>
                  <td className="py-3 px-4 text-slate-700 dark:text-slate-300">{user.dateCreated}</td>
                  <td className="py-3 px-4 text-right">
                    <div className="flex justify-end">
                      <Button variant="ghost" size="icon" onClick={() => handleEditClick(user)}>
                        <Edit className="h-4 w-4 text-slate-500" />
                        <span className="sr-only">Edit</span>
                      </Button>
                      <DropdownMenu>
                        <DropdownMenuTrigger asChild>
                          <Button variant="ghost" size="icon">
                            <MoreHorizontal className="h-4 w-4" />
                            <span className="sr-only">More</span>
                          </Button>
                        </DropdownMenuTrigger>
                        <DropdownMenuContent align="end">
                          <DropdownMenuLabel>Actions</DropdownMenuLabel>
                          <DropdownMenuSeparator />
                          <DropdownMenuItem>View Details</DropdownMenuItem>
                          <DropdownMenuItem onClick={() => handleEditClick(user)}>Edit User</DropdownMenuItem>
                          <DropdownMenuItem>Change Status</DropdownMenuItem>
                          <DropdownMenuSeparator />
                          <DropdownMenuItem
                            className="text-red-600 dark:text-red-400"
                            onClick={() => handleDeleteClick(user.id)}
                          >
                            <Trash2 className="h-4 w-4 mr-2" />
                            Delete User
                          </DropdownMenuItem>
                        </DropdownMenuContent>
                      </DropdownMenu>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        <div className="flex items-center justify-between px-4 py-3 border-t border-slate-200 dark:border-slate-700">
          <div className="text-sm text-slate-500 dark:text-slate-400">
            Showing <span className="font-medium">{filteredUsers.length}</span> of{" "}
            <span className="font-medium">{users.length}</span> users
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

      {/* Delete Confirmation Dialog */}
      <Dialog open={deleteDialogOpen} onOpenChange={setDeleteDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Confirm Deletion</DialogTitle>
            <DialogDescription>
              Are you sure you want to delete this user? This action cannot be undone.
            </DialogDescription>
          </DialogHeader>
          <DialogFooter>
            <Button variant="outline" onClick={() => setDeleteDialogOpen(false)}>
              Cancel
            </Button>
            <Button variant="destructive" onClick={confirmDelete}>
              Delete
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Edit User Dialog */}
      {userToEdit && (
        <Dialog open={editDialogOpen} onOpenChange={setEditDialogOpen}>
          <DialogContent className="sm:max-w-[425px]">
            <DialogHeader>
              <DialogTitle>Edit User</DialogTitle>
              <DialogDescription>Make changes to the user information below.</DialogDescription>
            </DialogHeader>
            <div className="grid gap-4 py-4">
              <div className="grid grid-cols-4 items-center gap-4">
                <Label htmlFor="name" className="text-right">
                  Name
                </Label>
                <Input
                  id="name"
                  value={userToEdit.name}
                  onChange={(e) => setUserToEdit({ ...userToEdit, name: e.target.value })}
                  className="col-span-3"
                />
              </div>
              <div className="grid grid-cols-4 items-center gap-4">
                <Label htmlFor="email" className="text-right">
                  Email
                </Label>
                <Input
                  id="email"
                  value={userToEdit.email}
                  onChange={(e) => setUserToEdit({ ...userToEdit, email: e.target.value })}
                  className="col-span-3"
                />
              </div>
              <div className="grid grid-cols-4 items-center gap-4">
                <Label htmlFor="phone" className="text-right">
                  Phone
                </Label>
                <Input
                  id="phone"
                  value={userToEdit.phone}
                  onChange={(e) => setUserToEdit({ ...userToEdit, phone: e.target.value })}
                  className="col-span-3"
                />
              </div>
              <div className="grid grid-cols-4 items-center gap-4">
                <Label htmlFor="accountType" className="text-right">
                  Account Type
                </Label>
                <Select
                  value={userToEdit.accountType}
                  onValueChange={(value) => setUserToEdit({ ...userToEdit, accountType: value })}
                >
                  <SelectTrigger className="col-span-3">
                    <SelectValue placeholder="Select account type" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="SB">Sadaran Bachat</SelectItem>
                    <SelectItem value="BB">Baal Bachat</SelectItem>
                    <SelectItem value="MB">Masik Bachat</SelectItem>
                  </SelectContent>
                </Select>
              </div>
              <div className="grid grid-cols-4 items-center gap-4">
                <Label htmlFor="balance" className="text-right">
                  Balance
                </Label>
                <Input
                  id="balance"
                  type="number"
                  value={userToEdit.balance}
                  onChange={(e) => setUserToEdit({ ...userToEdit, balance: Number(e.target.value) })}
                  className="col-span-3"
                />
              </div>
              <div className="grid grid-cols-4 items-center gap-4">
                <Label htmlFor="status" className="text-right">
                  Status
                </Label>
                <Select
                  value={userToEdit.status}
                  onValueChange={(value) => setUserToEdit({ ...userToEdit, status: value })}
                >
                  <SelectTrigger className="col-span-3">
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
            <DialogFooter>
              <Button variant="outline" onClick={() => setEditDialogOpen(false)}>
                Cancel
              </Button>
              <Button onClick={saveUserEdit}>Save changes</Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>
      )}

      {/* Add User Dialog */}
      <AddUserDialog open={addUserOpen} onOpenChange={setAddUserOpen || (() => {})} onUserAdded={handleUserAdded} />
    </>
  )
}
