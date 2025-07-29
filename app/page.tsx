"use client"

import { useState, useEffect, useCallback } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { TaskCard } from "@/components/task-card"
import { TaskForm } from "@/components/task-form"
import { apiFetch } from "@/lib/api"
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card"

interface Task {
  id: string
  text: string
  completed: boolean
}

export default function HomePage() {
  const [tasks, setTasks] = useState<Task[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const router = useRouter()

  const fetchTasks = useCallback(async () => {
    setLoading(true)
    setError(null)
    try {
      const data = await apiFetch("/items")
      setTasks(data)
    } catch (err: any) {
      setError(err.message || "Failed to fetch tasks.")
      if (err.message === "Unauthorized") {
        router.push("/login")
      }
    } finally {
      setLoading(false)
    }
  }, [router])

  useEffect(() => {
    const token = localStorage.getItem("authToken")
    if (!token) {
      router.push("/login")
      return
    }
    fetchTasks()
  }, [fetchTasks, router])

  const handleAddTask = async (text: string) => {
    try {
      const newTask = await apiFetch("/items", {
        method: "POST",
        body: JSON.stringify({ text }),
      })
      setTasks((prevTasks) => [...prevTasks, newTask])
    } catch (err: any) {
      setError(err.message || "Failed to add task.")
    }
  }

  const handleUpdateTask = async (id: string, updatedFields: Partial<Task>) => {
    try {
      const updatedTask = await apiFetch(`/items/${id}`, {
        method: "PUT",
        body: JSON.stringify(updatedFields),
      })
      setTasks((prevTasks) => prevTasks.map((task) => (task.id === id ? updatedTask : task)))
    } catch (err: any) {
      setError(err.message || "Failed to update task.")
    }
  }

  const handleDeleteTask = async (id: string) => {
    try {
      await apiFetch(`/items/${id}`, {
        method: "DELETE",
      })
      setTasks((prevTasks) => prevTasks.filter((task) => task.id !== id))
    } catch (err: any) {
      setError(err.message || "Failed to delete task.")
    }
  }

  const handleLogout = () => {
    localStorage.removeItem("authToken")
    router.push("/login")
  }

  if (loading) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-gray-100 dark:bg-gray-950">
        <p>Loading tasks...</p>
      </div>
    )
  }

  if (error && error !== "Unauthorized") {
    return (
      <div className="flex min-h-screen flex-col items-center justify-center gap-4 bg-gray-100 p-4 dark:bg-gray-950">
        <p className="text-red-500">Error: {error}</p>
        <Button onClick={fetchTasks}>Retry</Button>
        <Button variant="outline" onClick={handleLogout}>
          Logout
        </Button>
      </div>
    )
  }

  return (
    <div className="flex min-h-screen flex-col items-center gap-6 bg-gray-100 p-4 dark:bg-gray-950">
      <header className="flex w-full max-w-md items-center justify-between py-4">
        <h1 className="text-3xl font-bold">Task Manager</h1>
        <Button onClick={handleLogout} variant="outline">
          Logout
        </Button>
      </header>

      <Card className="w-full max-w-md">
        <CardHeader>
          <CardTitle>Add New Task</CardTitle>
        </CardHeader>
        <CardContent>
          <TaskForm onSave={handleAddTask} />
        </CardContent>
      </Card>

      <Card className="w-full max-w-md">
        <CardHeader>
          <CardTitle>Your Tasks</CardTitle>
        </CardHeader>
        <CardContent className="space-y-3">
          {tasks.length === 0 ? (
            <p className="text-center text-muted-foreground">No tasks yet. Add one above!</p>
          ) : (
            tasks.map((task) => (
              <TaskCard key={task.id} task={task} onUpdate={handleUpdateTask} onDelete={handleDeleteTask} />
            ))
          )}
        </CardContent>
      </Card>
    </div>
  )
}
