# Dossier: Project Uninstall

**Purpose**: Cleanly remove MI6 from a project if adoption didn't work out.

**When to use**: MI6 integration failed, doesn't fit your workflow, or you're switching to a different framework.

---

## Objective

Remove all MI6 components from the project while:
- Preserving your code and git history
- Restoring original configuration files
- Cleaning up MI6-specific directories
- Leaving project in working state
- Optionally removing MI6 from environment

---

## Prerequisites

- ✅ Project has MI6 installed
- ✅ User wants to remove MI6
- ✅ Backup exists (can rollback if removal goes wrong)

**Validation**:
```bash
ls .ai-project.json  # MI6 file exists
git log -5           # Recent history available
```

---

## Context to Gather

### 1. Identify MI6 Files

**Find all MI6-added files**:
```bash
# Core MI6 files
ls -la .ai-project.json AI_GUIDE.md .aicontextignore

# Task structure
ls -d tasks/ scripts/task-manager.js

# Backups (from brownfield adoption)
ls -la .gitignore.pre-mi6 package.json.pre-mi6
```

### 2. Check for Work in Tasks

**CRITICAL: Don't lose active work**:
```bash
# Check for active tasks with content
ls -la tasks/active/
ls -la tasks/planned/
```

**If tasks exist with real work**:
- ⚠️ **Warn user**: "You have documented tasks. Archive these before removing MI6?"
- **Suggest**: Copy to `docs/archived-tasks/` or similar

### 3. Check for Worktrees

**Verify no active worktrees**:
```bash
ls -d .worktrees/*/ 2>/dev/null
```

**If worktrees exist**:
- ⚠️ **Stop**: "Active worktrees detected. Clean them up first with worktree-cleanup dossier"
- Can't safely remove MI6 with active worktrees

---

## Decision Points

### Decision 1: Preserve Task Documentation

**If tasks/ directory has content**:

**Options**:
- **Archive**: Move to `docs/legacy-tasks/` or `archive/tasks/`
- **Delete**: Remove entirely (if empty or not valuable)
- **Export**: Convert to different format (GitHub Issues, markdown list)

**Recommendation**: Archive - future reference might be valuable

### Decision 2: Restore Original Files

**If backup files exist** (.gitignore.pre-mi6, etc.):

**Options**:
- **Restore**: Use pre-MI6 versions
- **Keep MI6 versions**: Some changes might be useful
- **Merge**: Combine both (complex)

**Recommendation**: Restore originals (clean removal)

### Decision 3: Remove from Environment

**Remove MI6_PATH variable?**:

**Options**:
- **Keep**: Still have MI6 for other projects
- **Remove**: Fully uninstall MI6 from system

**Recommendation**: Keep (doesn't hurt, useful for other projects)

---

## Actions to Perform

### Step 1: Archive Active Tasks (If Any)

**Preserve task documentation**:
```bash
# Check if tasks have content
if [ -n "$(ls -A tasks/active/ 2>/dev/null)" ] || \
   [ -n "$(ls -A tasks/planned/ 2>/dev/null)" ]; then

  # Archive tasks
  mkdir -p archive/mi6-tasks-$(date +%Y%m%d)
  cp -r tasks/* archive/mi6-tasks-$(date +%Y%m%d)/ 2>/dev/null || true

  echo "✓ Tasks archived to archive/mi6-tasks-YYYYMMDD/"
fi
```

### Step 2: Remove MI6 Core Files

**Delete MI6-specific files**:
```bash
rm -f .ai-project.json
rm -f AI_GUIDE.md
rm -f .aicontextignore
```

**Validation**:
```bash
ls .ai-project.json 2>&1 | grep "No such file"
```

### Step 3: Remove Task Structure

**Delete task directories**:
```bash
rm -rf tasks/
rm -rf scripts/task-manager.js
rm -rf scripts/  # If empty
```

**Validation**:
```bash
ls -d tasks/ 2>&1 | grep "No such file"
```

### Step 4: Restore Original Config Files

**If backups exist**:
```bash
# Restore .gitignore
if [ -f ".gitignore.pre-mi6" ]; then
  mv .gitignore.pre-mi6 .gitignore
  echo "✓ Restored original .gitignore"
fi

# Restore package.json
if [ -f "package.json.pre-mi6" ]; then
  mv package.json.pre-mi6 package.json
  echo "✓ Restored original package.json"
fi
```

**If no backups**: Leave MI6 versions (safer than nothing)

### Step 5: Clean Up Git (Optional)

**Remove MI6 commits from git history** (advanced, optional):

⚠️ **Warning**: Only do this if MI6 commits are recent and isolated

```bash
# Find MI6 adoption commit
git log --oneline | grep -i mi6

# Interactive rebase to remove (ADVANCED)
git rebase -i [commit-before-mi6]
# Mark MI6 commits as 'drop'
```

**Recommendation**: Keep git history - it's a record of changes

### Step 6: Commit Removal

**Document the removal**:
```bash
git add .
git commit -m "Remove MI6 framework

Removed MI6 task management and configuration files.
Project restored to pre-MI6 state.

Archived tasks to: archive/mi6-tasks-YYYYMMDD/
Original configs restored from .pre-mi6 backups"
```

### Step 7: Verify Project Still Works

**Test existing workflows**:
```bash
npm test          # Tests should pass
npm run dev       # Dev should work
npm run build     # Build should work
git status        # Should be clean
```

---

## Validation

### MI6 Files Removed
```bash
# Should all fail (file not found)
ls .ai-project.json 2>&1 | grep "No such file"
ls AI_GUIDE.md 2>&1 | grep "No such file"
ls -d tasks/ 2>&1 | grep "No such file"
```

### Original Functionality Restored
```bash
npm test && npm run build
# Should work exactly as before MI6
```

### Backups Preserved
```bash
ls archive/mi6-tasks-*  # Archived tasks (if any)
```

### Git Clean
```bash
git status
# Should show clean working tree
```

---

## Success Criteria

1. ✅ All MI6 files removed
2. ✅ Original config files restored (if backups existed)
3. ✅ Existing functionality works (build, test, dev)
4. ✅ Important task documentation archived
5. ✅ Git commit documents removal
6. ✅ Project ready to use without MI6

---

## Example

### Before (MI6 Installed):
```
my-project/
├── .ai-project.json       # MI6
├── AI_GUIDE.md            # MI6
├── .aicontextignore       # MI6
├── .gitignore             # Modified by MI6
├── package.json           # Modified by MI6
├── tasks/                 # MI6
│   ├── active/
│   │   └── FEATURE_X.md
│   └── planned/
├── scripts/
│   └── task-manager.js    # MI6
├── backend/               # Your code
└── frontend/              # Your code
```

### After Uninstall:
```
my-project/
├── .gitignore             # ✨ Restored original
├── package.json           # ✨ Restored original
├── README.md              # Preserved
├── archive/
│   └── mi6-tasks-20250104/  # ✨ Archived tasks
│       └── active/
│           └── FEATURE_X.md
├── backend/               # Preserved
└── frontend/              # Preserved
```

---

## Troubleshooting

### Issue: Lost original .gitignore

**Symptoms**: No .gitignore.pre-mi6 backup exists

**Solution**: Manually recreate or keep MI6 version
```bash
# Keep MI6 .gitignore if no backup
# Or manually remove MI6-specific patterns
```

### Issue: Can't remove tasks - valuable documentation

**Solution**: Don't delete, just disable MI6 management
```bash
# Keep tasks/ directory
# Remove scripts/task-manager.js
# Remove task scripts from package.json
# Tasks become regular markdown docs
```

### Issue: Breaking changes in package.json

**Solution**: Review diff before committing
```bash
git diff package.json.pre-mi6 package.json
# Manually merge useful changes back
```

### Issue: Team already using MI6

**Approach**:
- Create separate branch for your uninstall
- Don't merge to main (keep MI6 for team)
- Work on your fork/branch without MI6

---

## Partial Uninstall (Alternative)

**Remove only specific MI6 features**:

**Remove task management only**:
```bash
rm -rf tasks/ scripts/task-manager.js
# Keep .ai-project.json, AI_GUIDE.md, worktrees
```

**Remove worktree support only**:
```bash
# Edit .ai-project.json - remove worktree workflow
# Keep task management
```

**Keep some MI6 features** while removing others

---

## Notes for LLM Execution

- **Create backups before any removal** - Critical safety
- **Ask about task preservation** - Don't lose user's work
- **Verify existing workflows** - Test before declaring success
- **Document what was removed** - User needs to know
- **Provide clear next steps** - How to work without MI6
- **Be supportive** - Removal doesn't mean failure, just different needs

---

## Related Dossiers

**Alternatives to full removal**:
- [brownfield-adoption.md](./brownfield-adoption.md) - Try different adoption strategy
- [project-init.md](./project-init.md) - Reinitialize with different settings

**After removal**:
- User can try MI6 again later
- Can apply learnings to new projects
- MI6 files are archived for reference

---

**🕵️ MI6 Project Uninstall Dossier**
*Clean removal with safety and dignity*
