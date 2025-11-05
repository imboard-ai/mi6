# Dossier: First Development Session

**Protocol Version**: 1.0 ([_PROTOCOL.md](./_PROTOCOL.md))

**Purpose**: Guide users through their first productive development session after MI6 setup.

**When to use**: Right after project initialization and dependency installation - ready to start coding!

---

## 📋 Metadata

### Version
- **Dossier**: v1.0.0
- **Protocol**: v1.0
- **Last Updated**: 2025-01-05

### Relationships

**Preceded by**:
- [dependency-install](./dependency-install.md) - Install deps first (suggested)
- [project-init](./project-init.md) - MI6 setup (required)

**Contains** (sub-dossiers):
- [task-create](./task-create.md) - Creates first task

### Outputs

**Files created**:
- First task in `tasks/active/`
- First code changes
- First commit

**State changes**:
- Development servers running
- First task active

### Inputs

**Required**:
- MI6 project initialized
- Dependencies installed

### Coupling

**Level**: Loose
- Uses task-create dossier as component
- Otherwise independent walkthrough

---

## Objective

Get the user from "project is set up" to "actively developing" by:
- Creating their first task
- Starting development servers
- Making first code change
- Running tests
- Making first commit
- Understanding the development workflow

---

## Prerequisites

- ✅ MI6 project initialized
- ✅ Dependencies installed
- ✅ User ready to start coding

---

## Actions to Perform

### Step 1: Create First Task

**Use task-create dossier**:
```
"Use task-create dossier to create a task for: [user's first feature]"
```

Or manually:
```bash
cat > tasks/planned/GETTING_STARTED.md << 'EOF'
# Getting Started with Development

## Goal
Set up development environment and make first changes

## Acceptance Criteria
- [ ] Dev servers running
- [ ] Made first code change
- [ ] Tests passing
- [ ] First commit made
EOF
```

**Start the task**:
```bash
npm run task:start GETTING_STARTED
```

### Step 2: Start Development Servers

**Read AI_GUIDE.md for actual commands**, typically:

**Multi-repo**:
```bash
# Terminal 1: Backend
cd backend && npm run dev

# Terminal 2: Frontend
cd frontend && npm run dev
```

**Single-repo**:
```bash
npm run dev
```

### Step 3: Make First Change

**Simple test change** to verify setup:
```bash
# Example: Add a comment to main file
# User makes actual changes based on their feature
```

### Step 4: Run Tests

```bash
npm test  # Verify tests pass
```

### Step 5: First Commit

```bash
git add .
git commit -m "First development session setup"
git push
```

### Step 6: Complete Getting Started Task

```bash
npm run task:complete GETTING_STARTED
```

---

**🕵️ MI6 First Development Session**
