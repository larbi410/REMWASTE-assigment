"use client"

import type React from "react"

import { useState, useEffect } from "react"
import { Input } from "@/components/ui/input"
import { Button } from "@/components/ui/button"

interface TaskFormProps {
  initialText?: string
  onSave: (text: string) => void
  onCancel?: () => void
  isEditing?: boolean
}

export function TaskForm({ initialText = "", onSave, onCancel, isEditing = false }: TaskFormProps) {
  const [text, setText] = useState(initialText)

  useEffect(() => {
    setText(initialText)
  }, [initialText])

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    if (text.trim()) {
      onSave(text)
      if (!isEditing) {
        setText("") // Clear input only for new tasks
      }
    }
  }

  return (
    <form onSubmit={handleSubmit} className="flex w-full max-w-md items-center space-x-2">
      <Input
        type="text"
        placeholder={isEditing ? "Edit task" : "Add a new task"}
        value={text}
        onChange={(e) => setText(e.target.value)}
        className="flex-1"
      />
      <Button type="submit">{isEditing ? "Save" : "Add Task"}</Button>
      {isEditing && onCancel && (
        <Button type="button" variant="outline" onClick={onCancel}>
          Cancel
        </Button>
      )}
    </form>
  )
}
