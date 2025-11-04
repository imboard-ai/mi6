# Git Worktree Workflow

Guide to using git worktrees for parallel development in multi-repo projects.

---

## Overview

Git worktrees allow you to work on multiple branches simultaneously without switching branches or stashing changes.

**Perfect for**:
- Parallel feature development
- Urgent hotfixes during feature work
- Testing different approaches
- Multi-repo coordination

---

## Basic Concepts

### What is a Worktree?

A worktree is an additional working directory linked to the same git repository.

```
project/
├── .git/              # Main git directory
├── main/              # Default worktree (main branch)
└── .worktrees/        # Additional worktrees
    └── feature-x/     # Feature branch worktree
```

### Benefits

- ✅ No branch switching
- ✅ No stashing changes
- ✅ Parallel development
- ✅ Independent build artifacts
- ✅ Isolated dependencies

---

## Single-Repo Worktrees

### Create Feature Worktree

```bash
# From main directory
git worktree add .worktrees/feature-name -b feature-name

# Work in worktree
cd .worktrees/feature-name
npm install
npm run dev
```

### List Worktrees

```bash
git worktree list
```

Output:
```
/path/to/project              abc123 [main]
/path/to/project/.worktrees/feature-name  def456 [feature-name]
```

### Remove Worktree

```bash
# Delete worktree files
rm -rf .worktrees/feature-name

# Clean up git references
git worktree prune

# Optional: Delete branch
git branch -D feature-name
```

---

## Multi-Repo Worktrees (MI6 Pattern)

For projects with multiple repos (backend, frontend, shared), create linked worktrees.

### Manual Multi-Repo Setup

```bash
# 1. Create worktree directory
mkdir -p .worktrees/feature-name

# 2. Create worktree for each repo
cd backend
git worktree add ../.worktrees/feature-name/backend -b feature-name

cd ../frontend
git worktree add ../.worktrees/feature-name/frontend -b feature-name

cd ../shared
git worktree add ../.worktrees/feature-name/shared -b feature-name

# 3. Result structure:
.worktrees/
└── feature-name/
    ├── backend/    # feature-name branch
    ├── frontend/   # feature-name branch
    └── shared/     # feature-name branch
```

### Using Multi-Repo Worktrees

```bash
# Work in feature worktrees
cd .worktrees/feature-name/backend
npm run dev

# In another terminal
cd .worktrees/feature-name/frontend
npm run dev

# All repos on feature-name branch
# Main repos still on main branch
```

---

## Workflow Examples

### Example 1: Feature Development

```bash
# 1. Start task (documentation)
npm run task:start FEATURE_X

# 2. Create worktrees for code
git worktree add .worktrees/feature-x -b feature-x

# 3. Develop in worktree
cd .worktrees/feature-x
# ... make changes ...
git add .
git commit -m "Implement feature X"

# 4. Test and merge
git checkout main
git merge feature-x

# 5. Clean up
rm -rf .worktrees/feature-x
git worktree prune
git branch -d feature-x

# 6. Complete task
npm run task:complete FEATURE_X
```

---

### Example 2: Hotfix During Feature Work

```bash
# Currently working in feature worktree
cd .worktrees/feature-x
# ... working ...

# Urgent hotfix needed!

# 1. Pause feature task
npm run task:pause FEATURE_X

# 2. Create hotfix worktree from main repo
cd ../..  # back to root
git worktree add .worktrees/hotfix-auth -b hotfix-auth

# 3. Start hotfix task
npm run task:start HOTFIX_AUTH

# 4. Fix in hotfix worktree
cd .worktrees/hotfix-auth
# ... fix issue ...
git add .
git commit -m "Fix: Auth timeout"

# 5. Merge hotfix
git checkout main
git merge hotfix-auth

# 6. Deploy hotfix
git push
# ... deployment process ...

# 7. Complete hotfix
npm run task:complete HOTFIX_AUTH

# 8. Clean up hotfix worktree
rm -rf .worktrees/hotfix-auth
git worktree prune
git branch -d hotfix-auth

# 9. Resume feature work
npm run task:resume FEATURE_X
cd .worktrees/feature-x
# Continue where you left off!
```

---

### Example 3: Comparing Approaches

```bash
# Want to try two different implementations

# Approach A
git worktree add .worktrees/approach-a -b approach-a
cd .worktrees/approach-a
# ... implement A ...

# Approach B
cd ../..
git worktree add .worktrees/approach-b -b approach-b
cd .worktrees/approach-b
# ... implement B ...

# Compare both running side-by-side
# Keep the better one, discard the other
```

---

## Best Practices

### ✅ Do:
- Create worktrees in `.worktrees/` directory (consistent location)
- Use descriptive branch names matching task names
- Clean up worktrees after merging
- Keep main repo on main branch
- Document active worktrees

### ❌ Don't:
- Create worktrees for long-lived branches (use regular workflow)
- Nest worktrees deeply
- Forget to prune after removing worktree directories
- Share worktree paths between developers (they're local)

---

## Task Lifecycle Integration

### Task Docs Stay in Main Repo

**Important**: Don't use worktrees for task documentation

```
main-repo/                    # Task docs here
├── tasks/
│   ├── active/
│   │   └── FEATURE_X.md     # ✅ Edit in main repo
│   └── ...
└── .worktrees/
    └── feature-x/            # Code changes only
        ├── backend/
        └── frontend/
```

**Why**: Task docs can cause merge conflicts if edited in multiple worktrees.

### Combined Workflow

```bash
# 1. Planning (main repo)
npm run task:start FEATURE_X
# Edit tasks/active/FEATURE_X.md

# 2. Development (worktrees)
git worktree add .worktrees/feature-x -b feature-x
cd .worktrees/feature-x
# Write code

# 3. Update task doc (main repo)
cd ../..
# Update tasks/active/FEATURE_X.md with progress

# 4. Complete (main repo)
npm run task:complete FEATURE_X

# 5. Cleanup worktrees
rm -rf .worktrees/feature-x
git worktree prune
```

---

## MI6 Worktree Scripts (Coming Soon)

MI6 will provide automated scripts for multi-repo worktree management:

```bash
# Create worktrees for all repos
$MI6_PATH/scripts/worktree/create-feature-worktree.sh feature-name

# List all worktrees
$MI6_PATH/scripts/worktree/list-worktrees.sh

# Clean up worktrees
$MI6_PATH/scripts/worktree/cleanup-worktree.sh feature-name
```

Until then, use manual commands from this guide.

---

## Troubleshooting

### Issue: Worktree already exists

**Error**:
```
fatal: '.worktrees/feature-x' already exists
```

**Solution**:
```bash
# Remove old worktree
rm -rf .worktrees/feature-x
git worktree prune

# Try again
git worktree add .worktrees/feature-x -b feature-x
```

---

### Issue: Branch already exists

**Error**:
```
fatal: a branch named 'feature-x' already exists
```

**Solutions**:

**Option 1**: Use existing branch
```bash
git worktree add .worktrees/feature-x feature-x
```

**Option 2**: Delete old branch first
```bash
git branch -D feature-x
git worktree add .worktrees/feature-x -b feature-x
```

---

### Issue: Cannot remove worktree directory

**Error**:
```
fatal: '.worktrees/feature-x' contains modified or untracked files
```

**Solution**: Commit or discard changes first
```bash
cd .worktrees/feature-x
git add .
git commit -m "Save changes"
# or
git reset --hard
```

---

### Issue: Worktree references not cleaned

**Symptom**: `git worktree list` shows removed worktrees

**Solution**:
```bash
git worktree prune
```

---

## See Also

- [Git Worktree Official Docs](https://git-scm.com/docs/git-worktree)
- [Task Lifecycle Workflow](./task-lifecycle.md)
- [MI6 Multi-Repo Patterns](../docs/multi-repo-patterns.md) (coming soon)
