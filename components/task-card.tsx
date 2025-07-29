"use client"

import { useState } from "react"
import { Checkbox } from "@/components/ui/checkbox"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Edit, Trash } from "lucide-react"
import { TaskForm } from "./task-form"

interface Task {
  id: string
  text: string
  completed: boolean
}

interface TaskCardProps {
  task: Task
  onUpdate: (id: string, updatedFields: Partial<Task>) => void
  onDelete: (id: string) => void
}

export function TaskCard({ task, onUpdate, onDelete }: TaskCardProps) {
  const [isEditing, setIsEditing] = useState(false)

  const handleToggleComplete = () => {
    onUpdate(task.id, { completed: !task.completed })
  }

  const handleSaveEdit = (newText: string) => {
    onUpdate(task.id, { text: newText })
    setIsEditing(false)
  }

  return (
    <Card className="w-full max-w-md">
      <CardContent className="flex items-center justify-between p-4">
        {isEditing ? (
          <TaskForm initialText={task.text} onSave={handleSaveEdit} onCancel={() => setIsEditing(false)} isEditing />
        ) : (
          <div className="flex items-center space-x-3">
            <Checkbox
              id={`task-${task.id}`}
              checked={task.completed}
              onCheckedChange={handleToggleComplete}
              aria-label={`Mark task "${task.text}" as ${task.completed ? "incomplete" : "complete"}`}
            />
            <label
              htmlFor={`task-${task.id}`}
              className={`text-lg font-medium ${task.completed ? "line-through text-muted-foreground" : ""}`}
            >
              {task.text}
            </label>
          </div>
        )}
        {!isEditing && (
          <div className="flex space-x-2">
            <Button variant="ghost" size="icon" onClick={() => setIsEditing(true)} aria-label="Edit task">
              <Edit className="h-5 w-5" />
            </Button>
            <Button variant="ghost" size="icon" onClick={() => onDelete(task.id)} aria-label="Delete task">
              <Trash className="h-5 w-5" />
            </Button>
          </div>
        )}
      </CardContent>
    </Card>
  )
}
