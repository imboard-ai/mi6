# Task Lifecycle Workflow

Complete guide to managing tasks in MI6 projects.

---

## Overview

MI6 provides a structured task lifecycle that keeps your work organized and AI assistants focused.

### The Lifecycle

```
┌─────────┐
│ PLANNED │  New tasks, not started yet
└────┬────┘
     │ npm run task:start
     ↓
┌─────────┐
│ ACTIVE  │  Current work (visible to AI)
└────┬────┘
     │ npm run task:pause
     ↓
┌─────────┐
│ STASHED │  Paused work
└────┬────┘
     │ npm run task:resume
     ↓
┌─────────┐
│ ACTIVE  │  (back to active)
└────┬────┘
     │ npm run task:complete
     ↓
┌──────────────┐
│ COMPLETED    │  Archived by year
│  └─ 2025/    │
│  └─ 2024/    │
└──────────────┘
```

### Key Principles

1. **One Focus at a Time**: Keep 1-2 tasks active for clarity
2. **AI Context Control**: Only active tasks visible to AI assistants
3. **Version Control**: All transitions committed to git
4. **Historical Archive**: Completed tasks preserved by year

---

## Setup

### 1. Install Task Structure

```bash
# Copy task folders from MI6 templates
cp -R $MI6_PATH/templates/task-structure/tasks ./

# Result:
tasks/
├── planned/
├── active/
├── stashed/
└── completed/
```

### 2. Copy Task Manager Script

```bash
mkdir -p scripts
cp $MI6_PATH/scripts/task-manager/task-manager.js scripts/
```

### 3. Add npm Scripts

Copy `package.json` from templates or add scripts manually:

```json
{
  "scripts": {
    "task:start": "node scripts/task-manager.js start",
    "task:pause": "node scripts/task-manager.js pause",
    "task:resume": "node scripts/task-manager.js resume",
    "task:complete": "node scripts/task-manager.js complete",
    "task:list": "node scripts/task-manager.js list"
  }
}
```

### 4. Configure AI Context

Add to `.aicontextignore`:

```
# Hide non-active tasks from AI
tasks/planned/
tasks/stashed/
tasks/completed/
```

---

## Daily Workflow

### Morning: Check Task Status

```bash
npm run task:list
```

Output shows:
- What's planned (future work)
- What's active (current focus)
- What's stashed (paused)
- What's completed (historical)

### Starting New Work

```bash
# 1. Create task document
echo "# Dashboard Redesign" > tasks/planned/DASHBOARD_REDESIGN.md

# 2. Add details
cat >> tasks/planned/DASHBOARD_REDESIGN.md << 'EOF'

## Goal
Redesign main dashboard for better UX

## Requirements
- Modern design
- Responsive layout
- Performance improvements

## Acceptance Criteria
- [ ] Design mockups approved
- [ ] Implementation complete
- [ ] Tests passing
- [ ] Deployed to production
EOF

# 3. Start the task
npm run task:start DASHBOARD_REDESIGN
```

**Result**:
- Task moves to `tasks/active/`
- Now visible to AI assistants
- Git commit created automatically

### Working with AI

```bash
# Ask AI for help
claude  # or your AI assistant

# AI can now see tasks/active/DASHBOARD_REDESIGN.md
# and will focus on this work
```

**AI Prompt Examples**:
- "Help me implement the dashboard redesign based on the task doc"
- "Review the acceptance criteria for the dashboard task"
- "What's the next step in the active task?"

### Handling Interruptions

```bash
# Urgent hotfix needed, pause current work
npm run task:pause DASHBOARD_REDESIGN

# Start hotfix
npm run task:start SECURITY_PATCH

# ... fix issue ...

# Complete hotfix
npm run task:complete SECURITY_PATCH

# Resume original work
npm run task:resume DASHBOARD_REDESIGN
```

### Completing Work

```bash
# When task is done
npm run task:complete DASHBOARD_REDESIGN
```

**Result**:
- Task moves to `tasks/completed/2025/`
- Hidden from AI context
- Git commit created
- Historical reference preserved

---

## Task Document Structure

### Recommended Template

```markdown
# Task Name

## Status
- Started: 2025-01-15
- Completed: (not yet)

## Goal
Brief description of what this accomplishes

## Context
Why this task exists, background information

## Requirements
- Requirement 1
- Requirement 2
- Requirement 3

## Implementation Plan
1. Step 1
2. Step 2
3. Step 3

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Technical Details

### Architecture Changes
[Any architectural decisions]

### API Changes
[New or modified endpoints]

### Database Changes
[Schema updates, migrations]

## Testing Plan
- Unit tests: [details]
- Integration tests: [details]
- E2E tests: [details]

## Deployment Notes
[Special deployment considerations]

## Related Tasks
- [Link to related tasks or dependencies]

## Notes
[Additional context, learnings, decisions made]
```

### Updating During Development

As you work, update the task doc:

```bash
# Update acceptance criteria
# ✓ for completed items
- [x] Design mockups approved
- [x] Implementation complete
- [ ] Tests passing
- [ ] Deployed to production

# Add notes section
## Notes

### 2025-01-15
- Decided to use MUI components for consistency
- Performance improved by 40% with React.memo

### 2025-01-16
- Tests discovered edge case with mobile view
- Added responsive breakpoints
```

---

## Advanced Patterns

### Multiple Active Tasks

While possible, it's recommended to focus on 1-2 tasks:

```bash
# Two related tasks
npm run task:start BACKEND_API
npm run task:start FRONTEND_UI

# AI sees both, but context gets split
# Better: Complete one before starting another
```

### Task Dependencies

Document in task markdown:

```markdown
## Dependencies
- Blocked by: AUTH_SYSTEM (must complete first)
- Blocks: ADMIN_PANEL (waiting on this task)
- Related: USER_PROFILE (shares components)
```

Task manager doesn't enforce dependencies (you manage manually).

### Bulk Task Creation

```bash
# Create multiple planned tasks
for task in TASK1 TASK2 TASK3; do
  echo "# $task" > tasks/planned/${task}.md
done

# Start them as needed
npm run task:start TASK1
```

### Task Templates

Create reusable templates:

```bash
# Save template
cat > templates/task-template.md << 'EOF'
# [TASK_NAME]

## Goal
[What this accomplishes]

## Requirements
- [ ] Requirement 1

## Acceptance Criteria
- [ ] Criterion 1
EOF

# Use template
cp templates/task-template.md tasks/planned/NEW_FEATURE.md
# Edit NEW_FEATURE.md
npm run task:start NEW_FEATURE
```

---

## Integration with Git Worktrees

Combine task lifecycle with worktree workflow:

```bash
# 1. Start task (planning/documentation)
npm run task:start FEATURE_X

# 2. Create worktrees for code development
$MI6_PATH/scripts/worktree/create-feature-worktree.sh feature-x

# 3. Develop in worktrees
cd .worktrees/feature-x/backend/
# ... code changes ...

# 4. Complete task when done
npm run task:complete FEATURE_X

# 5. Clean up worktrees
$MI6_PATH/scripts/worktree/cleanup-worktree.sh feature-x
```

**Benefits**:
- Task docs stay in main tree
- Code work isolated in worktrees
- No merge conflicts in planning docs

---

## Integration with CI/CD

### Pre-commit Hook

Ensure tasks are documented:

```bash
# .git/hooks/pre-commit
#!/bin/bash

# Check if active tasks exist
active_count=$(ls tasks/active/*.md 2>/dev/null | wc -l)

if [ $active_count -eq 0 ]; then
  echo "⚠️  No active tasks. Consider documenting what you're working on."
  echo "   Create a task: echo '# Work' > tasks/planned/WORK.md"
  echo "   Start it: npm run task:start WORK"
fi

# Allow commit anyway (just a warning)
exit 0
```

### Status in CI

```yaml
# .github/workflows/status.yml
name: Task Status

on: [push]

jobs:
  list-tasks:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Show Active Tasks
        run: |
          echo "📋 Active Tasks:"
          ls tasks/active/*.md 2>/dev/null || echo "  (none)"
```

---

## Best Practices

### For Humans

#### ✅ Do:
- **Start tasks when beginning work** - Makes visible to AI
- **Keep tasks focused** - One feature/bug per task
- **Update as you go** - Add notes and learnings
- **Complete when done** - Don't leave stale active tasks
- **Use descriptive names** - `DASHBOARD_REDESIGN` not `TASK1`

#### ❌ Don't:
- **Manually move files** - Use task manager scripts
- **Have too many active tasks** - Splits AI context
- **Delete completed tasks** - Archive them instead
- **Skip documentation** - Future you will thank you

### For AI Assistants

#### ✅ Do:
- **Check `tasks/active/` first** - Always look here for current work
- **Reference task docs** - Use for context and requirements
- **Help update checklists** - Mark acceptance criteria as done
- **Ask about task priorities** - If multiple active tasks

#### ❌ Don't:
- **Read planned/stashed tasks** - Unless user explicitly asks
- **Make assumptions** - Check task doc for requirements
- **Ignore task context** - It contains important decisions
- **Start work on planned tasks** - Wait for user to activate

---

## Troubleshooting

### Issue: AI Not Seeing Active Tasks

**Check**:
1. Task is in `tasks/active/`: `ls tasks/active/`
2. `.aicontextignore` doesn't block active: `grep active .aicontextignore`
3. AI assistant supports context control

**Fix**:
```bash
# Ensure .aicontextignore has correct patterns
cat > .aicontextignore << 'EOF'
tasks/planned/
tasks/stashed/
tasks/completed/
EOF
```

---

### Issue: Too Much Context for AI

**Symptoms**: AI confused, mentions old tasks, slow responses

**Solutions**:
1. **Complete active tasks**: Move to completed when done
2. **Reduce active tasks**: Keep 1-2 active max
3. **Hide large files**: Add to `.aicontextignore`

---

### Issue: Lost Track of Tasks

**Solution**: Regular audits

```bash
# Weekly review
npm run task:list

# Complete any finished work
npm run task:complete OLD_TASK

# Clean up stashed tasks
# Resume or complete them
```

---

### Issue: Merge Conflicts in Task Docs

**Cause**: Multiple people editing same task doc

**Prevention**:
- One person per task (assign ownership)
- Use separate tasks for separate work
- Commit task changes frequently

**Resolution**:
```bash
# Accept both versions and merge manually
git checkout --theirs tasks/active/TASK.md
# Or
git checkout --ours tasks/active/TASK.md

# Then edit to combine both sets of changes
```

---

## Examples

### Example 1: Bug Fix

```bash
# 1. Create bug task
cat > tasks/planned/BUG_LOGIN_TIMEOUT.md << 'EOF'
# Bug: Login Timeout

## Goal
Fix login timeout issue on slow connections

## Context
Users on slow networks can't log in - 30s timeout too short

## Requirements
- Increase timeout to 60s
- Add loading indicator
- Better error message

## Acceptance Criteria
- [ ] Timeout increased
- [ ] Loading indicator added
- [ ] Error message improved
- [ ] Tested on slow connection
- [ ] Deployed to production
EOF

# 2. Start work
npm run task:start BUG_LOGIN_TIMEOUT

# 3. Fix in code

# 4. Complete
npm run task:complete BUG_LOGIN_TIMEOUT
```

---

### Example 2: Feature Development

```bash
# 1. Create feature task
cat > tasks/planned/FEATURE_DARK_MODE.md << 'EOF'
# Feature: Dark Mode

## Goal
Add dark mode toggle to application

## Requirements
- Theme toggle in settings
- Persist user preference
- Support all pages
- Smooth transitions

## Implementation Plan
1. Add theme context
2. Create toggle component
3. Update all components for dark mode
4. Add persistence (localStorage)
5. Test all pages

## Acceptance Criteria
- [ ] Toggle works
- [ ] Preference persists
- [ ] All pages support dark mode
- [ ] No UI glitches
- [ ] Tests passing
EOF

# 2. Start work
npm run task:start FEATURE_DARK_MODE

# 3. Develop (with worktrees if needed)
$MI6_PATH/scripts/worktree/create-feature-worktree.sh dark-mode
cd .worktrees/dark-mode/frontend/
# ... implement ...

# 4. Complete
npm run task:complete FEATURE_DARK_MODE
```

---

### Example 3: Refactoring

```bash
# 1. Create refactor task
cat > tasks/planned/REFACTOR_API_CLIENT.md << 'EOF'
# Refactor: API Client

## Goal
Consolidate duplicate API client code

## Context
Multiple files implement their own axios instances

## Requirements
- Single shared axios instance
- Centralized error handling
- Token refresh logic
- Type-safe responses

## Acceptance Criteria
- [ ] Shared client created
- [ ] All files migrated
- [ ] Error handling consistent
- [ ] Tests updated
- [ ] No regressions
EOF

# 2. Start
npm run task:start REFACTOR_API_CLIENT

# 3. If interrupted by urgent bug
npm run task:pause REFACTOR_API_CLIENT
npm run task:start BUG_CRITICAL

# ... fix bug ...

npm run task:complete BUG_CRITICAL

# 4. Resume refactoring
npm run task:resume REFACTOR_API_CLIENT

# 5. Complete
npm run task:complete REFACTOR_API_CLIENT
```

---

## See Also

- [Task Manager README](../scripts/task-manager/README.md) - Detailed script documentation
- [Task Structure Template](../templates/task-structure/README.md) - Folder setup guide
- [AI_GUIDE.md Template](../templates/AI_GUIDE.md) - AI assistant instructions
- [Git Worktree Workflow](./git-worktree.md) - Parallel development with worktrees
