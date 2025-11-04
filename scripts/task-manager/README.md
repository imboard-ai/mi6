# MI6 Task Manager

Automates task lifecycle management with git integration.

---

## Overview

The Task Manager handles transitions between task states:

```
planned → active → stashed ↩
  ↓         ↓         ↓
  └─────────┴────→ completed/YYYY/
```

**Key Features**:
- ✅ Move tasks between lifecycle stages
- ✅ Auto-commit to git with descriptive messages
- ✅ Partial name matching (type "DASH" instead of "DASHBOARD_REDESIGN")
- ✅ Year-based archiving for completed tasks
- ✅ Configurable via `.ai-project.json`
- ✅ Works standalone (no dependencies)

---

## Quick Start

### Prerequisites

1. **Task folder structure** (copy from templates):
   ```bash
   cp -R $MI6_PATH/templates/task-structure/tasks ./
   ```

2. **package.json with scripts** (optional but recommended):
   ```bash
   cp $MI6_PATH/templates/package.json ./
   ```

3. **Copy task manager script**:
   ```bash
   mkdir -p scripts
   cp $MI6_PATH/scripts/task-manager/task-manager.js scripts/
   ```

### Basic Usage

```bash
# Create a task in planned/
echo "# My New Feature" > tasks/planned/MY_NEW_FEATURE.md

# Start working on it
npm run task:start MY_NEW_FEATURE
# or: node scripts/task-manager.js start MY_NEW_FEATURE

# Pause if needed
npm run task:pause MY_NEW_FEATURE

# Resume later
npm run task:resume MY_NEW_FEATURE

# Complete when done
npm run task:complete MY_NEW_FEATURE

# View all tasks
npm run task:list
```

---

## Commands

### start

**Purpose**: Activate a planned task

**Usage**:
```bash
npm run task:start <task-name>
# or
node scripts/task-manager.js start <task-name>
```

**What it does**:
1. Finds task in `tasks/planned/`
2. Moves to `tasks/active/`
3. Makes visible to AI assistants
4. Creates git commit

**Example**:
```bash
npm run task:start DASHBOARD_REDESIGN
```

---

### pause

**Purpose**: Pause an active task

**Usage**:
```bash
npm run task:pause <task-name>
```

**What it does**:
1. Finds task in `tasks/active/`
2. Moves to `tasks/stashed/`
3. Hides from AI assistants
4. Creates git commit

**When to use**:
- Need to work on urgent hotfix
- Switching priorities temporarily
- Waiting for external dependencies

**Example**:
```bash
npm run task:pause DASHBOARD_REDESIGN
```

---

### resume

**Purpose**: Reactivate a paused task

**Usage**:
```bash
npm run task:resume <task-name>
```

**What it does**:
1. Finds task in `tasks/stashed/`
2. Moves back to `tasks/active/`
3. Makes visible to AI again
4. Creates git commit

**Example**:
```bash
npm run task:resume DASHBOARD_REDESIGN
```

---

### complete

**Purpose**: Archive a finished task

**Usage**:
```bash
npm run task:complete <task-name>
```

**What it does**:
1. Finds task in `tasks/active/`
2. Moves to `tasks/completed/YYYY/` (current year)
3. Hides from AI assistants
4. Creates git commit

**Example**:
```bash
npm run task:complete DASHBOARD_REDESIGN
# Task archived to: tasks/completed/2025/DASHBOARD_REDESIGN.md
```

---

### list

**Purpose**: Show all tasks and their status

**Usage**:
```bash
npm run task:list
# or
npm run task:ls
```

**Output**:
```
📋 MI6 Task Status
==================================================

📝 PLANNED (2)
  - NEW_FEATURE
  - API_REFACTOR

🚀 ACTIVE (1)
  - DASHBOARD_REDESIGN

⏸️  STASHED (1)
  - AUTH_SYSTEM

✅ COMPLETED (0)
  (none)

📅 COMPLETED BY YEAR
  2025: 3 task(s)
  2024: 15 task(s)
```

---

## Task Name Matching

The task manager uses **flexible name matching**:

### Exact Match (Case Insensitive)
```bash
npm run task:start dashboard_redesign
npm run task:start DASHBOARD_REDESIGN
npm run task:start DaShBoArD_ReDeSiGn
# All match: DASHBOARD_REDESIGN.md
```

### Partial Match
```bash
npm run task:start DASH
# Matches: DASHBOARD_REDESIGN.md (if unambiguous)

npm run task:start redesign
# Matches: DASHBOARD_REDESIGN.md (if unambiguous)
```

### Ambiguous Matches
```bash
$ npm run task:start DASH

⚠️  Multiple tasks match. Please be more specific:
  - DASHBOARD_REDESIGN.md
  - DASHBOARD_V2.md
  - DASHBOARD_MOBILE.md
```

**Solution**: Be more specific
```bash
npm run task:start DASHBOARD_REDESIGN
```

---

## Configuration

### Via .ai-project.json

```json
{
  "taskManagement": {
    "enabled": true,
    "autoCommit": true,
    "taskFolders": {
      "planned": "tasks/planned",
      "active": "tasks/active",
      "stashed": "tasks/stashed",
      "completed": "tasks/completed"
    }
  }
}
```

**Options**:
- `enabled`: Enable/disable task management (default: true)
- `autoCommit`: Auto-commit task moves to git (default: true)
- `taskFolders`: Custom folder paths (useful if not using default `tasks/` structure)

### Custom Folder Paths

If your project uses different folder names:

```json
{
  "taskManagement": {
    "taskFolders": {
      "planned": "docs/backlog",
      "active": "docs/in-progress",
      "stashed": "docs/paused",
      "completed": "docs/archive"
    }
  }
}
```

Then:
```bash
npm run task:start MY_TASK
# Moves from docs/backlog/ to docs/in-progress/
```

---

## Git Integration

### Auto-Commit

By default, task transitions create git commits:

```bash
$ npm run task:start DASHBOARD_REDESIGN

✅ Moved: DASHBOARD_REDESIGN.md
  From: tasks/planned
  To:   tasks/active

✅ Changes committed to git
```

**Commit message format**:
```
Start task: DASHBOARD_REDESIGN.md

Moved from planned to active

🕵️  MI6 Task Manager
```

### Disable Auto-Commit

In `.ai-project.json`:
```json
{
  "taskManagement": {
    "autoCommit": false
  }
}
```

Then manually commit:
```bash
npm run task:start DASHBOARD_REDESIGN
git add .
git commit -m "Start dashboard redesign task"
```

---

## Integration with AI Assistants

### Context Control

Task states control AI context visibility:

| State | Folder | AI Visibility |
|-------|--------|---------------|
| **Planned** | `tasks/planned/` | ❌ Hidden (via .aicontextignore) |
| **Active** | `tasks/active/` | ✅ Visible (AI focuses here) |
| **Stashed** | `tasks/stashed/` | ❌ Hidden (via .aicontextignore) |
| **Completed** | `tasks/completed/` | ❌ Hidden (via .aicontextignore) |

### .aicontextignore Setup

Ensure your `.aicontextignore` has:
```
tasks/planned/
tasks/stashed/
tasks/completed/
```

This way:
- AI assistants only see active tasks
- Reduces context pollution
- Focuses AI on current work

### Workflow with AI

```bash
# 1. Start task (makes visible to AI)
npm run task:start FEATURE_X

# 2. Ask AI to work on it
# AI can now see tasks/active/FEATURE_X.md

# 3. Complete when done
npm run task:complete FEATURE_X

# 4. AI no longer sees it (archived)
```

---

## Advanced Usage

### Programmatic API

```javascript
const taskManager = require('./scripts/task-manager/task-manager.js');

// Start a task
taskManager.startTask('MY_TASK');

// List tasks
taskManager.listTasks();

// Find task by partial name
const task = taskManager.findTaskByPartialName('DASH', 'tasks/planned');
console.log(task.name); // DASHBOARD_REDESIGN.md
```

### Bulk Operations

```bash
# Start multiple tasks
for task in TASK1 TASK2 TASK3; do
  npm run task:start $task
done

# Complete all active tasks (use with caution!)
for file in tasks/active/*.md; do
  name=$(basename "$file" .md)
  npm run task:complete $name
done
```

### Task Templates

Create a template for new tasks:

```bash
# templates/TASK_TEMPLATE.md
cat > templates/TASK_TEMPLATE.md << 'EOF'
# [Task Name]

## Status
- Started: YYYY-MM-DD
- Completed: (not yet)

## Goal
[What this task accomplishes]

## Requirements
- [ ] Requirement 1
- [ ] Requirement 2

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2

## Notes
[Additional context]
EOF

# Create new task from template
cp templates/TASK_TEMPLATE.md tasks/planned/NEW_FEATURE.md
# Edit NEW_FEATURE.md
npm run task:start NEW_FEATURE
```

---

## Troubleshooting

### Issue: Task not found

**Error**:
```
❌ Task not found in tasks/planned: DASHBOARD
```

**Solutions**:
1. Check task exists: `ls tasks/planned/`
2. Try exact name: `npm run task:start DASHBOARD_REDESIGN`
3. List all tasks: `npm run task:list`

---

### Issue: Multiple matches

**Error**:
```
⚠️  Multiple tasks match. Please be more specific:
  - DASHBOARD_REDESIGN.md
  - DASHBOARD_V2.md
```

**Solution**: Use more specific name
```bash
npm run task:start DASHBOARD_REDESIGN
```

---

### Issue: Task already exists in destination

**Error**:
```
❌ Task already exists in tasks/active: DASHBOARD_REDESIGN.md
```

**Cause**: Task already in destination folder

**Solutions**:
1. **If task is already active**: You're done! No need to start again.
2. **If task moved manually**: Delete from destination or source before retrying
3. **Check with**: `npm run task:list`

---

### Issue: Git commit failed

**Warning**:
```
⚠️  Git commit failed (this is okay if no changes to commit)
```

**Causes**:
- Not a git repository (run `git init`)
- No changes to commit (task already moved)
- Git index locked (close other git operations)

**Not critical**: Task still moved successfully, just not committed

---

### Issue: Permission denied

**Error**:
```
Error: EACCES: permission denied
```

**Solution**:
```bash
# Make script executable
chmod +x scripts/task-manager/task-manager.js

# Or run with node directly
node scripts/task-manager/task-manager.js list
```

---

### Issue: Node.js not found

**Error**:
```
bash: node: command not found
```

**Solution**: Install Node.js
```bash
# Check if Node.js is installed
node --version

# If not, install (Ubuntu/Debian)
sudo apt install nodejs npm

# Or (macOS)
brew install node
```

---

## Best Practices

### ✅ Do:
- Start tasks when beginning work (makes visible to AI)
- Complete tasks when done (keeps context clean)
- Use descriptive task names (DASHBOARD_REDESIGN, not TASK1)
- Commit task folders to git (version control your planning)
- List tasks regularly (`npm run task:list`)

### ❌ Don't:
- Manually move task files (use task manager)
- Edit tasks in multiple folders (one active at a time)
- Delete tasks (complete them instead for history)
- Ignore completed tasks (they're archived for reference)

---

## See Also

- [Task Structure Template](../../templates/task-structure/README.md)
- [Task Lifecycle Workflow](../../workflows/task-lifecycle.md)
- [AI_GUIDE.md Template](../../templates/AI_GUIDE.md)
- [Templates README](../../templates/README.md)
