import { NextResponse } from "next/server"
import { getTaskById, updateTask, deleteTask, isValidToken } from "../../api/db"

// Helper to check authentication
function authenticateRequest(request: Request): boolean {
  const authHeader = request.headers.get("Authorization")
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return false
  }
  const token = authHeader.split(" ")[1]
  return isValidToken(token)
}

export async function GET(request: Request, { params }: { params: { id: string } }) {
  if (!authenticateRequest(request)) {
    return NextResponse.json({ message: "Unauthorized" }, { status: 401 })
  }
  const { id } = params
  const task = getTaskById(id)
  if (task) {
    return NextResponse.json(task, { status: 200 })
  } else {
    return NextResponse.json({ message: "Task not found" }, { status: 404 })
  }
}

export async function PUT(request: Request, { params }: { params: { id: string } }) {
  if (!authenticateRequest(request)) {
    return NextResponse.json({ message: "Unauthorized" }, { status: 401 })
  }
  const { id } = params
  const updatedFields = await request.json()
  const updatedTask = updateTask(id, updatedFields)
  if (updatedTask) {
    return NextResponse.json(updatedTask, { status: 200 })
  } else {
    return NextResponse.json({ message: "Task not found" }, { status: 404 })
  }
}

export async function DELETE(request: Request, { params }: { params: { id: string } }) {
  if (!authenticateRequest(request)) {
    return NextResponse.json({ message: "Unauthorized" }, { status: 401 })
  }
  const { id } = params
  const success = deleteTask(id)
  if (success) {
    return NextResponse.json({ message: "Task deleted successfully" }, { status: 200 })
  } else {
    return NextResponse.json({ message: "Task not found" }, { status: 404 })
  }
}
