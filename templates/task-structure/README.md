# Task Structure Template

This template provides the folder structure for MI6 task lifecycle management.

## Directory Structure

```
tasks/
├── planned/      # Tasks not started yet (hidden from AI)
├── active/       # Current work (visible to AI)
├── stashed/      # Paused tasks (hidden from AI)
└── completed/    # Archived tasks by year (hidden from AI)
    └── 2025/     # Year-based archiving
```

## Usage

### Copy Structure to Your Project

```bash
# Copy task folders to your project
cp -R $MI6_PATH/templates/task-structure/tasks ./

# Or manually create
mkdir -p tasks/{planned,active,stashed,completed/2025}
```

### Add to .gitignore

If you have nested code repos, they should already be gitignored. The tasks/ directory itself should be committed to git (it's part of your docs repo).

### Configure .aicontextignore

Make sure your `.aicontextignore` hides non-active tasks:

```
tasks/planned/
tasks/stashed/
tasks/completed/
```

## Task Lifecycle

### 1. Create New Task (Planned)

```bash
# Create task document in planned/
echo "# Dashboard Redesign" > tasks/planned/DASHBOARD_REDESIGN.md

# Add task details
cat << 'EOF' >> tasks/planned/DASHBOARD_REDESIGN.md
## Goal
Redesign the main dashboard UI for better UX

## Requirements
- Modern design
- Responsive layout
- Improved performance

## Acceptance Criteria
- [ ] Design mockups approved
- [ ] Frontend implementation complete
- [ ] Tests passing
- [ ] Deployed to production
EOF
```

### 2. Start Task (Planned → Active)

```bash
npm run task:start DASHBOARD_REDESIGN
```

This:
- Moves `tasks/planned/DASHBOARD_REDESIGN.md` → `tasks/active/DASHBOARD_REDESIGN.md`
- Makes it visible to AI assistants
- Creates git commit

### 3. Pause Task (Active → Stashed)

```bash
npm run task:pause DASHBOARD_REDESIGN
```

This:
- Moves `tasks/active/DASHBOARD_REDESIGN.md` → `tasks/stashed/DASHBOARD_REDESIGN.md`
- Hides from AI context
- Creates git commit

### 4. Resume Task (Stashed → Active)

```bash
npm run task:resume DASHBOARD_REDESIGN
```

This:
- Moves `tasks/stashed/DASHBOARD_REDESIGN.md` → `tasks/active/DASHBOARD_REDESIGN.md`
- Makes visible to AI again
- Creates git commit

### 5. Complete Task (Active → Completed)

```bash
npm run task:complete DASHBOARD_REDESIGN
```

This:
- Moves `tasks/active/DASHBOARD_REDESIGN.md` → `tasks/completed/2025/DASHBOARD_REDESIGN.md`
- Archives with current year
- Hides from AI context
- Creates git commit

## Task Naming Conventions

**Recommended**:
- Use UPPER_SNAKE_CASE for task files (e.g., `DASHBOARD_REDESIGN.md`)
- Be descriptive but concise
- Match feature branch names when using worktrees

**Examples**:
- ✅ `AUTH_SYSTEM_UPGRADE.md`
- ✅ `API_RATE_LIMITING.md`
- ✅ `DASHBOARD_V3.md`
- ❌ `task1.md` (too vague)
- ❌ `this-is-a-very-long-task-name-that-describes-everything.md` (too long)

## Task Document Structure

Recommended structure for task markdown files:

```markdown
# Task Name

## Status
- Started: YYYY-MM-DD
- Completed: YYYY-MM-DD (if done)

## Goal
Brief description of what this task accomplishes

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
### API Changes
### Database Changes

## Testing Plan
- Unit tests
- Integration tests
- E2E tests

## Deployment Notes
Any special deployment considerations

## Related Tasks
- Link to related tasks
- Dependencies

## Notes
Additional context, learnings, decisions made during implementation
```

## Best Practices

### For Humans

1. **One task, one focus**: Keep tasks focused on single feature or bug fix
2. **Update as you go**: Add notes and learnings during development
3. **Check acceptance criteria**: Use checklists to track progress
4. **Archive when complete**: Don't leave tasks in active/ after completion

### For AI Assistants

1. **Check active/ first**: Always look in `tasks/active/` when starting work
2. **Focus on current work**: Don't read planned or completed tasks unless asked
3. **Reference task docs**: Use active task docs for context and requirements
4. **Update checklists**: Help user track progress by updating acceptance criteria

## Integration with Git Worktrees

When using MI6 worktree workflow:

```bash
# 1. Start task
npm run task:start FEATURE_X

# 2. Create worktrees for code repos
$MI6_PATH/scripts/worktree/create-feature-worktree.sh feature-x

# 3. Work in worktrees
cd .worktrees/feature-x/backend/
# ... development ...

# 4. When done, complete task
npm run task:complete FEATURE_X

# 5. Clean up worktrees
$MI6_PATH/scripts/worktree/cleanup-worktree.sh feature-x
```

## FAQ

**Q: Can I have multiple active tasks?**
A: Yes, but it's recommended to focus on 1-2 tasks at a time for better AI context.

**Q: Should I commit task folders to git?**
A: Yes! The tasks/ directory is part of your docs repo and should be version controlled.

**Q: What if I want to reference a completed task?**
A: You can manually read `tasks/completed/YYYY/TASK_NAME.md`, but AI won't see it by default (that's intentional to reduce context noise).

**Q: Can I rename tasks?**
A: Yes, just rename the file and update the task manager's search (it finds tasks by partial name).

**Q: What about task dependencies?**
A: Document dependencies in the task markdown under "Related Tasks" section. Task manager doesn't enforce dependencies automatically.
