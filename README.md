# Task Manager - Full Stack Application with Automated Testing

A complete full-stack web application built with **React (Next.js)** frontend and **Node.js** backend this app is generated by an  AI tool to be used for test automation Tasks, featuring comprehensive automated testing with **Robot Framework**.

## 🚀 Quick Start (2 minutes setup)

### Prerequisites
- **Node.js 18+** and **npm**
- **Python 3.8+** and **pip**
- **Chrome browser**

### 1. Run the Application

\`\`\`bash
# Clone/Download and navigate to project
cd task-manager

# Install dependencies
npm install --legacy-peer-deps

# Start the application
npm run dev
\`\`\`

**✅ App running at:** http://localhost:3000

**Login credentials:**
- Username: `user`
- Password: `password`

### 2. Run Automated Tests

\`\`\`bash
# Install Python test dependencies
pip install -r requirements.txt

# Run all tests
robot --outputdir results tests/

# Or run specific test types:
robot --outputdir results tests/api/     # API tests only
robot --outputdir results tests/ui/      # UI tests only
\`\`\`

**✅ Test results:** Open `results/report.html` in your browser

---

## 📱 Application Features

### Frontend (React/Next.js)
- **Login/Logout** with authentication
- **Create Tasks** - Add new todo items
- **Edit Tasks** - Modify existing tasks inline
- **Toggle Completion** - Mark tasks as done/undone
- **Delete Tasks** - Remove tasks
- **Responsive Design** - Works on all devices

### Backend (Node.js API)
- **Authentication:** `POST /api/auth/login`
- **Get Tasks:** `GET /api/items`
- **Create Task:** `POST /api/items`
- **Update Task:** `PUT /api/items/:id`
- **Delete Task:** `DELETE /api/items/:id`

---

## 🧪 Automated Testing

### Test Coverage
- ✅ **UI Tests (Selenium)** - Login, CRUD operations, form validation
- ✅ **API Tests (REST)** - All endpoints with positive/negative cases
- ✅ **Integration Tests** - End-to-end workflows
- ✅ **Authentication Testing** - Valid/invalid credentials
- ✅ **Error Handling** - 401, 404, 400 responses

### Test Structure
\`\`\`
tests/
├── ui/                     # Selenium UI tests
│   ├── login_tests.robot
│   └── task_management_tests.robot
├── api/                    # REST API tests
│   ├── auth_api_tests.robot
│   └── tasks_api_tests.robot
├── integration/            # End-to-end tests
│   └── end_to_end_tests.robot
└── resources/              # Shared keywords
    ├── common.robot
    ├── ui_keywords.robot
    └── api_keywords.robot
\`\`\`

### Running Specific Tests
\`\`\`bash
# Run by test type
robot --include positive --outputdir results tests/    # Positive cases only
robot --include negative --outputdir results tests/    # Negative cases only
robot --include login --outputdir results tests/       # Login tests only

# Run specific files
robot --outputdir results tests/ui/login_tests.robot
robot --outputdir results tests/api/auth_api_tests.robot
\`\`\`

---

## 🛠️ Troubleshooting

### ChromeDriver Issues
If you get ChromeDriver version errors:

**Option 1: Auto-fix (Recommended)**
\`\`\`bash
pip install webdriver-manager
# Tests will auto-download correct ChromeDriver
\`\`\`

**Option 2: Manual fix**
1. Check your Chrome version: `chrome://version/`
2. Download matching ChromeDriver: https://googlechromelabs.github.io/chrome-for-testing/
3. Replace existing ChromeDriver in your PATH

**Option 3: Use headless mode**
\`\`\`bash
robot --variable BROWSER:headlesschrome --outputdir results tests/ui/
\`\`\`

### Common Issues

| Issue | Solution |
|-------|----------|
| `npm install` fails | Use `npm install --legacy-peer-deps` |
| Port 3000 in use | Kill process: `npx kill-port 3000` |
| Tests fail - app not running | Ensure `npm run dev` is running |
| ChromeDriver errors | See ChromeDriver section above |

---

## 📊 Test Results

After running tests, check these files:
- **`results/report.html`** - High-level test summary
- **`results/log.html`** - Detailed execution log
- **`results/output.xml`** - Raw test data

### Sample Test Scenarios

**UI Tests:**
- Login with valid/invalid credentials
- Create, edit, delete tasks
- Toggle task completion
- Form validation

**API Tests:**
- Authentication endpoint testing
- CRUD operations on tasks
- Authorization validation
- Error response handling

**Integration Tests:**
- Create task via API → verify in UI
- Update task via UI → verify via API
- Cross-platform data consistency

---

## 🏗️ Architecture

### Tech Stack
- **Frontend:** React, Next.js, TypeScript, Tailwind CSS, Shadcn/UI
- **Backend:** Next.js API Routes, Node.js
- **Database:** In-memory (resets on restart)
- **Testing:** Robot Framework, Selenium, RequestsLibrary

### Project Structure
\`\`\`
task-manager/
├── app/
│   ├── api/                # Backend API routes
│   ├── login/              # Login page
│   └── page.tsx            # Main app page
├── components/             # React components
├── lib/                    # Utilities
├── tests/                  # Robot Framework tests
├── requirements.txt        # Python dependencies
└── package.json            # Node.js dependencies
\`\`\`

---

## 🔧 Development

### Adding New Features
1. **Frontend:** Add components in `components/`
2. **Backend:** Add API routes in `app/api/`
3. **Tests:** Add test cases in appropriate `tests/` folder

### Database Note
Current implementation uses **in-memory storage** - data resets when server restarts. For production, integrate with:
- PostgreSQL
- MongoDB  
- Supabase
- Neon

### Authentication Note
Uses simple token-based auth for demo. For production, consider:
- NextAuth.js
- Supabase Auth
- Auth0

---

## 📈 Next Steps

- [ ] Add persistent database
- [ ] Implement user registration
- [ ] Add task categories/tags
- [ ] Deploy to Vercel
- [ ] Set up CI/CD pipeline
- [ ] Add performance testing
- [ ] Implement real-time updates

---

## 🤝 Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature-name`
3. Add tests for new features
4. Run test suite: `robot --outputdir results tests/`
5. Submit pull request

---

## 📄 License

MIT License - feel free to use this project for learning and development.

---

**Need help?** Check the troubleshooting section above or create an issue in the repository.
