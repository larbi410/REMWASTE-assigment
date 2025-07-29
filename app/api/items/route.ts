import { NextResponse } from "next/server"
import { getTasks, addTask, isValidToken } from "../../api/db"

// Helper to check authentication
function authenticateRequest(request: Request): boolean {
  const authHeader = request.headers.get("Authorization")
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return false
  }
  const token = authHeader.split(" ")[1]
  return isValidToken(token)
}

export async function GET(request: Request) {
  if (!authenticateRequest(request)) {
    return NextResponse.json({ message: "Unauthorized" }, { status: 401 })
  }
  const tasks = getTasks()
  return NextResponse.json(tasks, { status: 200 })
}

export async function POST(request: Request) {
  if (!authenticateRequest(request)) {
    return NextResponse.json({ message: "Unauthorized" }, { status: 401 })
  }
  const { text } = await request.json()
  if (!text) {
    return NextResponse.json({ message: "Task text is required" }, { status: 400 })
  }
  const newTask = addTask(text)
  return NextResponse.json(newTask, { status: 201 })
}
