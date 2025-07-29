import { NextResponse } from "next/server"
import { authenticateUser } from "../../api/db"

export async function POST(request: Request) {
  const { username, password } = await request.json()

  const token = authenticateUser(username, password)

  if (token) {
    return NextResponse.json({ message: "Login successful", token }, { status: 200 })
  } else {
    return NextResponse.json({ message: "Invalid credentials" }, { status: 401 })
  }
}
