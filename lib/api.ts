// lib/api.ts
const API_BASE_URL = "/api" // Relative path for Next.js API routes

export async function apiFetch(endpoint: string, options?: RequestInit) {
  const token = localStorage.getItem("authToken")
  const headers = {
    "Content-Type": "application/json",
    ...(token && { Authorization: `Bearer ${token}` }),
    ...options?.headers,
  }

  const response = await fetch(`${API_BASE_URL}${endpoint}`, {
    ...options,
    headers,
  })

  if (response.status === 401) {
    // Handle unauthorized access, e.g., redirect to login
    localStorage.removeItem("authToken")
    window.location.href = "/login"
    throw new Error("Unauthorized")
  }

  if (!response.ok) {
    const errorData = await response.json().catch(() => ({ message: "An unknown error occurred" }))
    throw new Error(errorData.message || "API request failed")
  }

  return response.json()
}

export async function login(credentials: { username: string; password: string }) {
  const response = await fetch(`${API_BASE_URL}/auth/login`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(credentials),
  })

  if (!response.ok) {
    const errorData = await response.json()
    throw new Error(errorData.message || "Login failed")
  }

  const data = await response.json()
  localStorage.setItem("authToken", data.token)
  return data
}
