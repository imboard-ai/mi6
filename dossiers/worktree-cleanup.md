# Dossier: Worktree Cleanup

**Purpose**: Safely remove git worktrees when feature work is complete, cleaning up directories and branches.

**When to use**: After merging feature branches, completing work in worktrees, or abandoning a feature.

---

## Objective

Cleanly remove worktrees and optionally delete feature branches:
- Remove worktree directories from `.worktrees/`
- Clean up git references in all repos
- Optionally delete feature branches
- Verify main repos remain unaffected
- Warn about uncommitted changes before removal

---

## Prerequisites

- ✅ MI6 project with worktrees created
- ✅ User is done with the feature (or wants to abandon it)
- ✅ Current directory is the project root

**Validation**:
```bash
ls -d .worktrees/*/
# Should show worktree directories
```

---

## Context to Gather

### 1. Identify Worktree to Clean Up

**User should specify** feature name, or we can:
- List all worktrees and let user choose
- Infer from context (current directory, active task, etc.)

**List worktrees**:
```bash
ls -d .worktrees/*/
```

### 2. Check for Uncommitted Changes

**For each worktree repo, check git status**:
```bash
git -C .worktrees/[feature-name]/backend status --short
git -C .worktrees/[feature-name]/frontend status --short
git -C .worktrees/[feature-name]/shared status --short
```

**If changes exist**:
- ⚠️ **Warn user**: "You have uncommitted changes"
- **Show what would be lost**: List modified files
- **Ask**: Continue anyway? Commit first? Abort?

### 3. Check Branch Push Status

**Check if branches are pushed to remote**:
```bash
git -C .worktrees/[feature-name]/backend branch -vv
# Look for [origin/feature-name] indicator
```

**If not pushed**:
- ⚠️ **Warn**: "Branch not pushed to remote - work will be lost locally"
- **Ask**: Push now? Continue anyway? Abort?

### 4. Read Project Configuration

**Parse `.ai-project.json`** to find all repos:
```bash
cat .ai-project.json | grep -A 20 '"repos"'
```

**Need to know**: Which repos have worktrees to clean up

---

## Decision Points

### Decision 1: Handle Uncommitted Changes

**If changes detected**:

**Options**:
- **Abort**: Stop cleanup, let user commit/stash
- **Commit first**: Auto-commit with message (risky)
- **Force remove**: Delete anyway (data loss!)

**Recommendation**: Abort - safer to let user decide

### Decision 2: Delete Feature Branches

**Options**:
- **Keep branches**: Remove worktrees, preserve branches
- **Delete branches**: Remove worktrees AND delete feature branches
- **Ask per repo**: Let user decide for each repo

**Recommendation**: Ask user preference

### Decision 3: Remote Branch Handling

**If feature branches exist on remote**:

**Options**:
- **Keep remote branches**: Only delete local
- **Delete remote too**: `git push origin --delete [branch]`
- **Ask user**: Let them decide

**Recommendation**: Keep remote (safer), let user delete manually if desired

---

## Actions to Perform

### Step 1: Safety Check - Uncommitted Changes

**For each repo in worktree**:
```bash
cd .worktrees/[feature-name]/backend
git status --short
```

**If output is not empty**:
```
⚠️  WARNING: Uncommitted changes detected!

Backend:
  M src/api.ts
  ?? new-file.ts

Frontend:
  M src/App.tsx

❌ Cleanup aborted. Please:
   1. Commit your changes: cd .worktrees/[feature-name]/backend && git commit -am "message"
   2. Or stash them: git stash
   3. Then retry cleanup

Or force removal (DATA LOSS): [ask if user really wants this]
```

### Step 2: Remove Worktree Directories

**Delete worktree directories**:
```bash
rm -rf .worktrees/[feature-name]
```

**Expected outcome**: Directory `.worktrees/[feature-name]/ removed

**Validation**:
```bash
ls .worktrees/[feature-name] 2>&1
# Should show: No such file or directory
```

### Step 3: Prune Git Worktree References

**For each repo, clean up git metadata**:
```bash
git -C backend worktree prune
git -C frontend worktree prune
git -C shared-types worktree prune
```

**This removes** stale worktree references from git's internal tracking

**Validation**:
```bash
git -C backend worktree list
# Should NOT show the removed worktree
```

### Step 4: Delete Feature Branches (Optional)

**If user chose to delete branches**:

**For each repo**:
```bash
# Switch to main/master first (if currently on feature branch)
git -C backend checkout main

# Delete feature branch
git -C backend branch -D [feature-name]
```

**If branch not fully merged**, git will warn:
```
error: The branch 'feature-x' is not fully merged.
```

**Options**:
- Use `-D` (force delete) - user confirmed this is okay
- Abort - let user merge first

### Step 5: Delete Remote Branches (If Requested)

**Only if user explicitly wants to delete remote branches**:
```bash
git -C backend push origin --delete [feature-name]
git -C frontend push origin --delete [feature-name]
git -C shared-types push origin --delete [feature-name]
```

⚠️ **Warning**: This affects other developers if they're using the same branch!

### Step 6: Final Validation

**Verify cleanup succeeded**:
```bash
# Worktree directory gone
ls .worktrees/[feature-name] 2>&1 | grep "No such file"

# Git worktrees pruned
git -C backend worktree list | grep -v [feature-name]

# Branches deleted (if requested)
git -C backend branch | grep -v [feature-name]
```

**Check main repos unaffected**:
```bash
cd backend && git status
# Should show clean working tree, on main branch
```

---

## Validation

### Directory Check
```bash
ls -d .worktrees/[feature-name] 2>&1
# Should show: No such file or directory
```

### Git Status Check
```bash
git -C backend worktree list
git -C frontend worktree list
git -C shared-types worktree list
# Should NOT list the removed worktree
```

### Branch Check (if deleted)
```bash
git -C backend branch | grep [feature-name]
# Should show nothing (branch deleted)
```

### Main Repo Integrity
```bash
cd backend && git status
# Should show: On branch main, working tree clean
```

---

## Success Criteria

1. ✅ Worktree directory removed
2. ✅ Git worktree references pruned for all repos
3. ✅ Feature branches deleted (if requested)
4. ✅ Main repos unaffected and clean
5. ✅ No uncommitted changes lost (or user confirmed loss okay)

---

## Example

### Scenario: Clean Up After Feature Merged

**Starting state**:
```
my-project/
├── .worktrees/
│   └── feature-dashboard-v3/
│       ├── backend/      # On feature-dashboard-v3 branch
│       ├── frontend/     # On feature-dashboard-v3 branch
│       └── shared/       # On feature-dashboard-v3 branch
├── backend/              # On main branch
├── frontend/             # On main branch
└── shared-types/         # On main branch
```

**User action**:
```
"Use worktree-cleanup dossier to remove feature-dashboard-v3 worktrees"
```

**AI execution**:
```
1. Checking for uncommitted changes...
   ✓ Backend: Clean
   ✓ Frontend: Clean
   ✓ Shared: Clean

2. Checking branch push status...
   ✓ All branches pushed to remote

3. Should I delete the feature branches? (y/N)
   User: y

4. Removing worktree directory...
   ✓ Removed: .worktrees/feature-dashboard-v3/

5. Pruning git references...
   ✓ Backend worktree pruned
   ✓ Frontend worktree pruned
   ✓ Shared worktree pruned

6. Deleting feature branches...
   ✓ Deleted: backend/feature-dashboard-v3
   ✓ Deleted: frontend/feature-dashboard-v3
   ✓ Deleted: shared/feature-dashboard-v3

7. Validation...
   ✓ Worktree directory removed
   ✓ Git references clean
   ✓ Branches deleted
   ✓ Main repos unaffected

✅ Cleanup complete!
```

**Final state**:
```
my-project/
├── .worktrees/           # Empty or other worktrees
├── backend/              # On main branch, clean
├── frontend/             # On main branch, clean
└── shared-types/         # On main branch, clean
```

---

## Troubleshooting

### Issue: Permission denied when removing directory

**Symptoms**:
```
rm: cannot remove '.worktrees/feature-x/backend': Permission denied
```

**Causes**:
- Files owned by different user
- Read-only files
- Process holding files open

**Solutions**:

**Option 1**: Check permissions
```bash
ls -la .worktrees/feature-x/backend
# Look for ownership and permissions
```

**Option 2**: Force remove with sudo (careful!)
```bash
sudo rm -rf .worktrees/feature-x
```

**Option 3**: Close processes using the files
```bash
# Find processes using directory
lsof +D .worktrees/feature-x
# Kill or close those processes
```

---

### Issue: "Fatal: not a git repository" when pruning

**Symptoms**:
```
fatal: not a git repository (or any parent): backend
```

**Cause**: Wrong directory or repo moved

**Solution**:
```bash
# Verify repo locations
ls -d backend/.git frontend/.git shared-types/.git

# Check .ai-project.json for correct paths
cat .ai-project.json | grep path

# Navigate to correct directory
cd /path/to/project/root
```

---

### Issue: Can't delete branch - not fully merged

**Symptoms**:
```
error: The branch 'feature-x' is not fully merged.
If you are sure you want to delete it, run 'git branch -D feature-x'.
```

**Cause**: Branch has commits not in main

**Solutions**:

**Option 1**: Merge first (if work should be kept)
```bash
git -C backend checkout main
git -C backend merge feature-x
# Then retry cleanup
```

**Option 2**: Force delete (if work completed elsewhere or abandoned)
```bash
git -C backend branch -D feature-x
# This was already attempted in cleanup - confirm user wants this
```

**Option 3**: Keep branch, don't delete
```
Let user know: "Branch has unmerged commits. Keeping branch, only removing worktree."
```

---

### Issue: Uncommitted changes detected

**Symptoms**:
```
⚠️  Uncommitted changes in backend:
  M src/api.ts
```

**Solutions**:

**Option 1**: Commit changes first
```bash
cd .worktrees/feature-x/backend
git add .
git commit -m "Save changes before cleanup"
git push
# Then retry cleanup
```

**Option 2**: Stash changes
```bash
cd .worktrees/feature-x/backend
git stash
# Stash will be in main repo, can recover later
```

**Option 3**: Force remove (DATA LOSS!)
```bash
# Only if user explicitly confirms they want to lose changes
rm -rf .worktrees/feature-x
```

---

### Issue: Remote branch delete fails

**Symptoms**:
```
error: unable to delete 'feature-x': remote ref does not exist
```

**Cause**: Branch already deleted on remote

**Solution**: Not an error - continue with cleanup. Branch already removed.

---

### Issue: Multiple worktrees with same name

**Symptoms**: Found `.worktrees/feature-x/` but also `.worktrees/feature-x-old/`

**Solution**: Ask user which one to clean up, or clean both

---

## Notes for LLM Execution

- **Safety first**: Always check for uncommitted changes
- **Clear warnings**: Tell user exactly what will be lost
- **Ask before destructive operations**: Especially branch deletion
- **Show progress**: Report each repo as you clean it
- **Handle errors gracefully**: If one repo fails, continue with others
- **Verify at end**: Confirm cleanup succeeded before declaring success
- **Be specific**: Tell user exactly what was removed/kept

---

## Related Dossiers

- [worktree-multi-repo.md](./worktree-multi-repo.md) - Create worktrees (reverse operation)
- [project-init.md](./project-init.md) - Initialize MI6 project

## Related Workflows

- [Git Worktree Workflow](../workflows/git-worktree.md) - Conceptual guide
- [Task Lifecycle](../workflows/task-lifecycle.md) - Complete tasks before cleanup

---

## Advanced: Cleanup Script (Optional)

For users who want a quick script, here's a simple version:

```bash
#!/bin/bash
# Quick worktree cleanup (when no uncommitted changes)
FEATURE=$1

if [ -z "$FEATURE" ]; then
  echo "Usage: cleanup.sh feature-name"
  exit 1
fi

# Remove directory
rm -rf .worktrees/$FEATURE

# Prune all repos (from .ai-project.json)
for repo in backend frontend shared-types; do
  if [ -d "$repo/.git" ]; then
    git -C $repo worktree prune
    echo "✓ Pruned $repo"
  fi
done

echo "✅ Cleanup complete for $FEATURE"
```

**Note**: This script doesn't check for uncommitted changes - the dossier approach is safer!

---

**🕵️ MI6 Worktree Cleanup Dossier**
*Safely remove worktrees when feature work is complete*
