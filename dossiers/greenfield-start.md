# Dossier: Greenfield Project Start

**Protocol Version**: 1.0 ([_PROTOCOL.md](./_PROTOCOL.md))

**Purpose**: Guide users through starting a brand new project from absolute zero with MI6.

**When to use**: You have an idea for a new project but nothing exists yet - no directory, no code, nothing.

---

## Objective

Take a user from "I want to build X" to "I have a MI6-powered project ready to code" by:
- Helping choose project location and name
- Guiding tech stack decisions
- Creating the initial directory structure
- Setting up version control
- Handing off to project-init dossier for MI6 setup

---

## Prerequisites

- ✅ MI6 is installed (`$MI6_PATH` is set)
- ✅ User has an idea for what to build
- ✅ User has basic development tools (git, text editor)

**Validation**:
```bash
echo $MI6_PATH  # Should show MI6 installation path
git --version   # Should show git is installed
```

---

## Context to Gather

### 1. Project Concept

**Ask user about their project**:
- What are you building? (web app, API, CLI tool, library, etc.)
- Who is it for? (personal, startup, enterprise)
- Scale expectations? (hobby, production, high-traffic)

### 2. Technical Requirements

**Understand technical needs**:
- **Backend needed?** (API, database, business logic)
- **Frontend needed?** (Web UI, mobile app, dashboard)
- **Shared code?** (Types, utilities, common logic)
- **Other components?** (CLI tools, workers, cron jobs)

### 3. Tech Stack Preferences

**Guide decision if user unsure**:

**Backend Options**:
- **Node.js/TypeScript**: Fast development, large ecosystem, good for APIs
- **Python**: Great for data/ML, rapid prototyping, Django/FastAPI
- **Go**: Performance critical, microservices, cloud-native

**Frontend Options**:
- **React**: Most popular, huge ecosystem, job market
- **Vue**: Simpler learning curve, great docs
- **Svelte**: Modern, performant, clean syntax
- **Next.js**: React with SSR, full-stack framework

**Database**:
- **PostgreSQL**: Relational, reliable, feature-rich
- **MongoDB**: Document-based, flexible schema
- **SQLite**: Simple, embedded, good for prototypes

### 4. Development Environment

**Check what user has**:
```bash
node --version      # Node.js installed?
python3 --version   # Python installed?
go version          # Go installed?
```

If missing, note for installation later.

---

## Decision Points

### Decision 1: Project Location

**Options**:
- `~/projects/[project-name]` - Standard convention (recommended)
- `~/code/[project-name]` - Alternative common location
- `~/dev/[project-name]` - Another variant
- Custom location - User specifies

**Recommendation**: `~/projects/` (matches MI6 conventions)

### Decision 2: Project Structure

**Based on gathered requirements**:

**Single-Repo** - Use when:
- Simple API or CLI tool
- One codebase, one deployment
- Small team or solo developer

**Multi-Repo** - Use when:
- Separate backend + frontend
- Independent deployment schedules
- Different tech stacks (Node backend + React frontend)
- Want separate git histories

**Monorepo** - Use when:
- Many related packages
- Shared code reuse critical
- Coordinated releases
- Using tools like Turbo, Nx, Lerna

**Recommendation**: Multi-repo for web apps (backend + frontend), single-repo for APIs/CLIs

### Decision 3: Git Hosting

**Options**:
- **GitHub**: Most popular, great CI/CD, free private repos
- **GitLab**: Self-hosted option, integrated CI/CD
- **Bitbucket**: Atlassian integration, private repos

**Recommendation**: GitHub (best ecosystem, MI6 examples use it)

---

## Actions to Perform

### Step 1: Create Project Directory

**Create and navigate to project directory**:
```bash
mkdir -p ~/projects/[project-name]
cd ~/projects/[project-name]
```

**Example**:
```bash
mkdir -p ~/projects/my-saas-app
cd ~/projects/my-saas-app
```

**Validation**:
```bash
pwd
# Should show: /home/username/projects/my-saas-app
```

### Step 2: Create Repository Structure

**For Single-Repo**:
```bash
# Already in project directory, ready for code
pwd  # ~/projects/my-saas-app
```

**For Multi-Repo**:
```bash
# Create subdirectories for each repo
mkdir -p backend frontend shared-types
```

**For Monorepo**:
```bash
# Create packages structure
mkdir -p packages/backend packages/frontend packages/shared
# or
mkdir -p apps/web apps/api libs/shared
```

**Example (Multi-Repo)**:
```bash
cd ~/projects/my-saas-app
mkdir -p backend frontend shared-types
```

**Validation**:
```bash
ls -la
# Should show subdirectories created
```

### Step 3: Initialize Git Repositories

**For Single-Repo**:
```bash
git init
git branch -M main  # Rename to main if needed
```

**For Multi-Repo** (each repo gets its own git):
```bash
git -C backend init && git -C backend branch -M main
git -C frontend init && git -C frontend branch -M main
git -C shared-types init && git -C shared-types branch -M main
```

**For Monorepo** (one git for whole project):
```bash
git init
git branch -M main
```

**Validation**:
```bash
# Single-repo or monorepo
ls -la .git

# Multi-repo
ls backend/.git frontend/.git shared-types/.git
```

### Step 4: Create Initial README

**Create basic project README**:
```bash
cat > README.md << EOF
# [Project Name]

[Brief description of what this project does]

## Structure

[Describe your repos/structure]

## Getting Started

See AI_GUIDE.md for detailed development instructions.

## Development

[Will be filled in by MI6 project-init]

---

Powered by [MI6](https://github.com/imboard-ai/mi6)
EOF
```

**Customize**: Replace placeholders with actual project info

### Step 5: Hand Off to MI6 Project Init

**Now run the project-init dossier**:
```
"Use the MI6 project-init dossier to set up this project"
```

This will:
- Detect the structure you created
- Add all MI6 templates
- Customize for your tech stack
- Set up task management
- Complete the initialization

---

## Validation

### Directory Structure Check
```bash
pwd  # Should be in project directory
ls -la  # Should show repos (for multi-repo) or code structure
```

### Git Initialized Check
```bash
git status  # Should show initialized repo(s)
```

### Ready for MI6 Check
```bash
# Project directory exists ✓
# Git initialized ✓
# Structure created ✓
# README.md created ✓

# Ready for: project-init dossier
```

---

## Success Criteria

1. ✅ Project directory created in appropriate location
2. ✅ Repository structure established (single/multi/mono)
3. ✅ Git initialized for all repos
4. ✅ Basic README created
5. ✅ User understands next step: project-init dossier

---

## Complete Greenfield Journey

**Step-by-step for new users**:

```
1. User: "I want to build a web app with Node backend and React frontend"

2. AI: "Use greenfield-start dossier"
   → Creates: ~/projects/my-web-app/
   → Structure: backend/, frontend/, shared-types/
   → Git initialized in each
   → README.md created

3. AI: "Now use project-init dossier"
   → Detects: Multi-repo with 3 repos
   → Copies: All MI6 templates
   → Customizes: .ai-project.json, AI_GUIDE.md
   → Sets up: Task management

4. AI: "Use dependency-install dossier"
   → Runs: npm install in each repo
   → Verifies: All dependencies resolved

5. AI: "Use first-dev-session dossier"
   → Creates: First task
   → Starts: Development servers
   → Guides: First commit

Result: Fully configured MI6 project, ready to code!
```

---

## Example

### Before (Nothing):
```
User has: An idea
User wants: To build it
```

### After Greenfield-Start:
```
~/projects/my-saas-app/
├── README.md                 # ✨ Created
├── backend/
│   └── .git/                 # ✨ Initialized
├── frontend/
│   └── .git/                 # ✨ Initialized
└── shared-types/
    └── .git/                 # ✨ Initialized
```

### After Project-Init (next step):
```
~/projects/my-saas-app/
├── .ai-project.json          # ✨ MI6 config
├── AI_GUIDE.md               # ✨ Project guide
├── .aicontextignore          # ✨ Context control
├── package.json              # ✨ Task scripts
├── tasks/                    # ✨ Task management
├── scripts/
│   └── task-manager.js       # ✨ Task automation
├── README.md                 # Updated
├── backend/                  # Ready for code
├── frontend/                 # Ready for code
└── shared-types/             # Ready for code
```

---

## Troubleshooting

### Issue: Don't know where to create project

**Recommendation**: Use `~/projects/` as standard location
```bash
mkdir -p ~/projects
cd ~/projects
```

### Issue: Don't know which tech stack

**Guidance**:
- **Web app with UI**: Multi-repo (Node backend + React frontend)
- **API only**: Single-repo (Node or Python)
- **CLI tool**: Single-repo (Go or Node)
- **Library/package**: Single-repo (language of choice)

### Issue: Multi-repo vs monorepo confusion

**Multi-Repo** = Separate git repositories
- backend/.git, frontend/.git (each is independent)
- Use when: Different deployment cycles

**Monorepo** = One git repository, multiple packages
- .git at root, packages/ subdirectories
- Use when: Coordinated releases, tool support (Turbo/Nx)

---

## Related Dossiers

**Next steps**:
- [project-init.md](./project-init.md) - Complete MI6 setup
- [dependency-install.md](./dependency-install.md) - Install dependencies
- [first-dev-session.md](./first-dev-session.md) - Start coding

**Reference**:
- [brownfield-adoption.md](./brownfield-adoption.md) - For existing projects

---

**🕵️ MI6 Greenfield Start Dossier**
*From zero to MI6-powered project*
