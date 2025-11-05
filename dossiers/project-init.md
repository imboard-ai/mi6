# Dossier: Project Initialization

**Protocol Version**: 1.0 ([_PROTOCOL.md](./_PROTOCOL.md))

**Purpose**: Initialize a new project with complete MI6 structure, intelligently customized for the specific project type and technology stack.

---

*Before executing, review `_PROTOCOL.md` for self-improvement protocol - you may identify enhancements based on this project's specific context.*

---

**When to use**: Starting a new project or adding MI6 to an existing project.

---

## Objective

Transform a project directory into a fully MI6-enabled workspace with:
- Complete template files (`.ai-project.json`, `AI_GUIDE.md`, etc.)
- Task management structure
- AI context control (`.aicontextignore`)
- Task manager script
- Git repository (if not already initialized)
- All files customized based on detected project structure

---

## Prerequisites

- ✅ MI6 is installed and `$MI6_PATH` environment variable is set
- ✅ User is in the project directory they want to initialize
- ✅ User has write permissions in current directory

**Validation**:
```bash
echo $MI6_PATH  # Should show path like /home/user/projects/mi6
pwd             # Shows current project directory
```

---

## Context to Gather

Before proceeding, analyze the current project to understand what needs to be set up.

### 1. Project Structure Analysis

**Check for existing repositories**:
```bash
# Look for nested git repos
find . -maxdepth 2 -name ".git" -type d
```

**Determine project type**:
- **Single-repo**: Only one `.git` directory (or none yet)
- **Multi-repo**: Multiple nested git repos (e.g., `backend/.git`, `frontend/.git`)
- **Monorepo**: One `.git` with multiple packages (check for `packages/` or `apps/`)

### 2. Technology Stack Detection

**Check for language/framework indicators**:
- `package.json` → Node.js/JavaScript/TypeScript
- `requirements.txt` or `pyproject.toml` → Python
- `go.mod` → Go
- `Cargo.toml` → Rust
- `pom.xml` or `build.gradle` → Java

**Within each repo, identify**:
- **Backend indicators**: Express, NestJS, FastAPI, Django, Spring, etc.
- **Frontend indicators**: React, Vue, Svelte, Next.js, Vite, etc.
- **Testing tools**: Jest, Playwright, pytest, etc.
- **Build tools**: npm, yarn, pnpm, cargo, make, etc.

### 3. Existing MI6 Configuration

**Check if already initialized**:
```bash
ls -la .ai-project.json AI_GUIDE.md .aicontextignore tasks/ 2>/dev/null
```

If any exist, ask user:
- **Overwrite existing files?**
- **Merge with existing configuration?**
- **Abort to avoid conflicts?**

### 4. Git Status

```bash
git status 2>/dev/null || echo "Not a git repository"
```

If not a git repo: **Should we initialize one?**

---

## Decision Points

### Decision 1: Project Structure Type

**Based on**: Number of git repositories found

**Options**:
- **Single-repo**: One codebase, one git repo
  - Use when: Simple API, single service, library
  - Template: `structure: "single-repo"`

- **Multi-repo**: Multiple separate git repos in subdirectories
  - Use when: Backend + Frontend + Shared types
  - Template: `structure: "multi-repo"`
  - **Important**: Each repo has its own `.git`

- **Monorepo**: One git repo with multiple packages
  - Use when: Using Nx, Turb

orepo, Lerna, or similar
  - Template: `structure: "mono-repo"`

**Recommendation**: Based on detected structure

### Decision 2: Template Customization Level

**Options**:
- **Minimal**: Just copy templates, minimal customization
- **Smart**: Auto-fill known values, leave TODOs for user
- **Complete**: Fully customize all templates (recommended)

**Recommendation**: Complete customization

### Decision 3: Git Initialization

**If not a git repo**:
- **Initialize git**: Create new repo with initial commit
- **Skip git**: User will initialize manually later

**Recommendation**: Initialize git (safer to version control docs)

---

## Actions to Perform

### Step 1: Copy Base Templates

**Copy all core templates from MI6**:
```bash
cp $MI6_PATH/templates/.ai-project.json .
cp $MI6_PATH/templates/AI_GUIDE.md .
cp $MI6_PATH/templates/.aicontextignore .
cp $MI6_PATH/templates/.gitignore .
cp $MI6_PATH/templates/package.json .
```

**Expected outcome**: 5 template files in current directory

**Validation**:
```bash
ls -la .ai-project.json AI_GUIDE.md .aicontextignore .gitignore package.json
```

### Step 2: Create Task Structure

**Copy task folders**:
```bash
cp -R $MI6_PATH/templates/task-structure/tasks .
```

**Expected outcome**: Task lifecycle folders created

**Validation**:
```bash
ls -d tasks/{planned,active,stashed,completed}
```

### Step 3: Copy Task Manager Script

**Create scripts directory and copy task manager**:
```bash
mkdir -p scripts
cp $MI6_PATH/scripts/task-manager/task-manager.js scripts/
chmod +x scripts/task-manager.js
```

**Expected outcome**: Executable task manager in scripts/

**Validation**:
```bash
ls -l scripts/task-manager.js  # Should show -rwxr-xr-x
```

### Step 4: Generate `.ai-project.json`

**Based on detected structure, create configuration**.

**Example for Multi-Repo (Backend + Frontend)**:
```json
{
  "name": "[project-directory-name]",
  "description": "[Ask user or infer from README]",
  "structure": "multi-repo",
  "repos": [
    {
      "name": "backend",
      "type": "backend",
      "language": "typescript",
      "framework": "express",
      "tests": "jest",
      "path": "./backend"
    },
    {
      "name": "frontend",
      "type": "frontend",
      "language": "typescript",
      "framework": "react-vite",
      "tests": "playwright",
      "path": "./frontend"
    }
  ],
  "workflows": {
    "worktree": "multi-repo-linked",
    "testing": "parallel-per-repo",
    "deployment": "backend-triggers-frontend"
  },
  "taskManagement": {
    "enabled": true,
    "autoCommit": true,
    "taskFolders": {
      "planned": "tasks/planned",
      "active": "tasks/active",
      "stashed": "tasks/stashed",
      "completed": "tasks/completed"
    }
  },
  "context": {
    "alwaysInclude": [
      "AI_GUIDE.md",
      "README.md",
      "core/**/*.md"
    ],
    "conditionalInclude": [
      "tasks/active/**/*.md"
    ],
    "exclude": [
      "tasks/planned/**",
      "tasks/stashed/**",
      "tasks/completed/**",
      "node_modules/**",
      ".git/**"
    ]
  },
  "mi6": {
    "version": "v1",
    "features": [
      "task-lifecycle",
      "worktree-management",
      "context-hygiene"
    ]
  }
}
```

**Customization**:
- Replace `[project-directory-name]` with actual name
- Add all detected repos to `repos` array
- Set correct language/framework for each repo
- Adjust paths based on actual structure

### Step 5: Customize `AI_GUIDE.md`

**Replace placeholders with actual values**:

- `[Project Name]` → Detected project name
- `[multi-repo | mono-repo | single-repo]` → Detected structure
- Build commands → Actual commands from detected package.json
- Tech stack → Detected languages/frameworks
- Code style → Infer from existing code or use defaults

**Example customization**:
```markdown
# My Project AI Guide

## Project Structure

This project uses a **multi-repo** structure:
- **`backend/`** - Express.js API with TypeScript
- **`frontend/`** - React + Vite frontend with TypeScript

## Build & Development

### Backend
```bash
cd backend/
npm run dev           # Start dev server on port 3000
npm run build         # Build for production
npm test              # Run Jest tests
```

### Frontend
```bash
cd frontend/
npm run dev           # Start dev server on port 5173
npm run build         # Build for production
npm test              # Run Playwright tests
```
```

### Step 6: Customize `.aicontextignore`

**Add tech-specific patterns** based on detected stack:

**For Node.js projects**, ensure:
```
node_modules/
dist/
build/
.next/
```

**For Python projects**, add:
```
__pycache__/
*.py[cod]
venv/
.venv/
```

**For multi-repo**, add nested repo paths:
```
backend/
frontend/
shared-types/
```

### Step 7: Update `package.json`

**Set project-specific values**:
```json
{
  "name": "[project-name]-docs",
  "version": "1.0.0",
  "description": "Documentation and task management for [project-name]",
  "private": true,
  "scripts": {
    "task:start": "node scripts/task-manager.js start",
    "task:pause": "node scripts/task-manager.js pause",
    "task:resume": "node scripts/task-manager.js resume",
    "task:complete": "node scripts/task-manager.js complete",
    "task:list": "node scripts/task-manager.js list"
  }
}
```

### Step 8: Initialize Git (if needed)

**If not already a git repo**:
```bash
git init
git add .
git commit -m "Initial commit: MI6 project structure

- Core documentation (AI_GUIDE.md, .ai-project.json)
- Task lifecycle folders
- Task manager script
- AI context control (.aicontextignore)

🕵️ Initialized with MI6 (https://github.com/imboard-ai/mi6)"
```

### Step 9: Create First Task (Optional)

**Suggest creating a welcome task**:
```bash
cat > tasks/planned/WELCOME_TO_MI6.md << 'EOF'
# Welcome to MI6

## Goal
Get familiar with MI6 task lifecycle and workflows

## Getting Started

1. Review AI_GUIDE.md for project overview
2. Try: `npm run task:start WELCOME_TO_MI6`
3. This task will move to tasks/active/
4. When done: `npm run task:complete WELCOME_TO_MI6`

## Resources
- Task Lifecycle: $MI6_PATH/workflows/task-lifecycle.md
- Git Worktrees: $MI6_PATH/workflows/git-worktree.md
- Templates: $MI6_PATH/templates/

## Next Steps
- Create your first real task
- Start developing!
EOF
```

---

## Validation

### File Existence Check

```bash
# Verify all files created
ls .ai-project.json AI_GUIDE.md .aicontextignore .gitignore package.json scripts/task-manager.js
ls -d tasks/{planned,active,stashed,completed}
```

### JSON Validation

```bash
# Verify .ai-project.json is valid
cat .ai-project.json | python -m json.tool || node -e "JSON.parse(require('fs').readFileSync('.ai-project.json'))"
```

### Script Execution Test

```bash
# Verify task manager works
npm run task:list
```

### Git Status Check

```bash
git status
# Should show initialized repo with files added (or ready to commit)
```

---

## Success Criteria

1. ✅ All template files copied and customized
2. ✅ `.ai-project.json` contains accurate project structure
3. ✅ `AI_GUIDE.md` has real commands (not placeholders)
4. ✅ Task structure created
5. ✅ Task manager script executable and working
6. ✅ `.aicontextignore` has appropriate patterns
7. ✅ Git repository initialized (if applicable)
8. ✅ User can run `npm run task:list` successfully

---

## Example

### Before:
```
my-project/
├── backend/
│   ├── src/
│   ├── package.json
│   └── .git/
├── frontend/
│   ├── src/
│   ├── package.json
│   └── .git/
└── README.md
```

### After:
```
my-project/
├── .ai-project.json          # ✨ Multi-repo config
├── AI_GUIDE.md               # ✨ Customized guide
├── .aicontextignore          # ✨ Context control
├── .gitignore                # ✨ Docs repo ignore patterns
├── package.json              # ✨ Task scripts
├── tasks/                    # ✨ Task lifecycle
│   ├── planned/
│   │   └── WELCOME_TO_MI6.md
│   ├── active/
│   ├── stashed/
│   └── completed/
├── scripts/
│   └── task-manager.js       # ✨ Task automation
├── backend/                  # Existing (gitignored)
├── frontend/                 # Existing (gitignored)
└── README.md                 # Existing
```

### Generated `.ai-project.json`:
```json
{
  "name": "my-project",
  "structure": "multi-repo",
  "repos": [
    {
      "name": "backend",
      "type": "backend",
      "language": "typescript",
      "framework": "express",
      "path": "./backend"
    },
    {
      "name": "frontend",
      "type": "frontend",
      "language": "typescript",
      "framework": "react-vite",
      "path": "./frontend"
    }
  ],
  "taskManagement": {
    "enabled": true,
    "autoCommit": true
  },
  "mi6": {
    "version": "v1"
  }
}
```

---

## Troubleshooting

### Issue: Files already exist

**Symptoms**: Error when copying templates (files exist)

**Solution**: Ask user what to do:
- **Overwrite**: `cp -f` to replace existing files
- **Skip**: Keep existing, only copy missing files
- **Abort**: Stop and let user resolve manually

### Issue: Can't detect project type

**Symptoms**: No clear single/multi/mono repo pattern

**Solution**:
- Ask user directly: "Is this a single repo, multi-repo, or monorepo?"
- Use default: single-repo (safest assumption)
- Let user edit `.ai-project.json` after initialization

### Issue: Git init fails

**Symptoms**: `git init` errors (permission, existing repo, etc.)

**Solution**:
- Skip git initialization
- Note to user: "Git not initialized, do manually if needed"
- Continue with rest of setup

### Issue: npm run task:list fails

**Symptoms**: "command not found" or script errors

**Solution**:
- Verify Node.js installed: `node --version`
- Check script copied: `ls scripts/task-manager.js`
- Check permissions: `chmod +x scripts/task-manager.js`
- Try direct: `node scripts/task-manager.js list`

---

## Notes for LLM Execution

- **Show progress**: Report each step as you execute it
- **Handle errors gracefully**: If a step fails, explain and suggest fixes
- **Ask for input**: When detection is ambiguous, ask the user
- **Validate continuously**: Check each step succeeded before moving on
- **Be thorough**: Don't skip customization - the goal is a fully working setup

---

## Related Dossiers

- [worktree-multi-repo.md](./worktree-multi-repo.md) - Set up worktrees after initialization
- [task-create.md](./task-create.md) - Create your first task
- [config-optimize.md](./config-optimize.md) - Improve configuration later

---

**🕵️ MI6 Project Initialization Dossier**
*Transform any directory into an MI6-powered workspace*
