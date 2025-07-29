// This file simulates a very simple in-memory database for demonstration purposes.
// In a real application, you would connect to a persistent database (e.g., PostgreSQL, MongoDB).

interface Task {
  id: string
  text: string
  completed: boolean
}

let tasks: Task[] = [
  { id: "1", text: "Learn Next.js", completed: false },
  { id: "2", text: "Build a full-stack app", completed: true },
  { id: "3", text: "Deploy to Vercel", completed: false },
]

let nextId = tasks.length > 0 ? Math.max(...tasks.map((t) => Number.parseInt(t.id))) + 1 : 1

export const getTasks = (): Task[] => {
  return tasks
}

export const getTaskById = (id: string): Task | undefined => {
  return tasks.find((task) => task.id === id)
}

export const addTask = (text: string): Task => {
  const newTask: Task = {
    id: String(nextId++),
    text,
    completed: false,
  }
  tasks.push(newTask)
  return newTask
}

export const updateTask = (id: string, updatedFields: Partial<Task>): Task | undefined => {
  const index = tasks.findIndex((task) => task.id === id)
  if (index > -1) {
    tasks[index] = { ...tasks[index], ...updatedFields }
    return tasks[index]
  }
  return undefined
}

export const deleteTask = (id: string): boolean => {
  const initialLength = tasks.length
  tasks = tasks.filter((task) => task.id !== id)
  return tasks.length < initialLength
}

// --- Authentication ---
const VALID_USERNAME = "user"
const VALID_PASSWORD = "password"
const AUTH_TOKEN = "my-secret-token" // A simple hardcoded token for demonstration

export const authenticateUser = (username: string, password: string): string | null => {
  if (username === VALID_USERNAME && password === VALID_PASSWORD) {
    return AUTH_TOKEN
  }
  return null
}

export const isValidToken = (token: string): boolean => {
  return token === AUTH_TOKEN
}
