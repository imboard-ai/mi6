# MI6 Worktree Scripts

Shell scripts for managing git worktrees across multiple repositories.

---

## Overview

These scripts provide **fast, deterministic worktree automation** for projects configured with MI6.

**When to use scripts** (vs dossiers):
- ✅ Configuration is complete (`.ai-project.json` exists)
- ✅ Fast execution needed (no LLM overhead)
- ✅ CI/CD or automated workflows
- ✅ Headless environments
- ✅ Repeated operations (same command many times)

**When to use dossiers** (vs scripts):
- ✅ Project structure unclear (needs detection)
- ✅ Complex decision-making required
- ✅ Want guidance and explanations
- ✅ Edge cases or unusual setups

---

## Scripts

### create-feature-worktree.sh

**Purpose**: Create linked worktrees across all repos for parallel development

**Usage**:
```bash
$MI6_PATH/scripts/worktree/create-feature-worktree.sh <feature-name>
```

**What it does**:
1. Reads `.ai-project.json` to find all repos
2. Creates `.worktrees/<feature-name>/` directory
3. Creates worktree for each repo on branch `<feature-name>`
4. Validates repos exist and are git repositories
5. Handles existing branches gracefully

**Example**:
```bash
$ $MI6_PATH/scripts/worktree/create-feature-worktree.sh dashboard-v3

🕵️  MI6 Worktree Creation
=========================

ℹ️  Feature: dashboard-v3
ℹ️  Worktree location: .worktrees/dashboard-v3

✓ Configuration valid
✓ Found 3 repositories

📦 backend
  ✓ Created worktree with new branch

📦 frontend
  ✓ Created worktree with new branch

📦 shared
  ✓ Created worktree with new branch

✅ Worktrees created successfully!

📂 Location: .worktrees/dashboard-v3/
```

**Prerequisites**:
- `.ai-project.json` exists with `repos` array
- All repos exist at specified paths
- Repos are git repositories

---

### list-worktrees.sh

**Purpose**: Display all active worktrees with their status

**Usage**:
```bash
$MI6_PATH/scripts/worktree/list-worktrees.sh [options] [feature-name]
```

**Options**:
- `--dirty` - Show only worktrees with uncommitted changes
- `feature-name` - Filter to specific feature

**What it shows**:
- All worktrees in `.worktrees/`
- Branch name for each repo
- Clean/dirty status with change counts
- Last commit message

**Examples**:
```bash
# List all worktrees
$MI6_PATH/scripts/worktree/list-worktrees.sh

# Show only specific feature
$MI6_PATH/scripts/worktree/list-worktrees.sh dashboard-v3

# Show only worktrees with uncommitted changes
$MI6_PATH/scripts/worktree/list-worktrees.sh --dirty
```

**Output**:
```
🕵️  MI6 Worktree Status
======================

📁 dashboard-v3

  📦 backend
     🔀 Branch: dashboard-v3
     ✓ Clean
     📝 Last: a1b2c3d Add dashboard API endpoints

  📦 frontend
     🔀 Branch: dashboard-v3
     ⚠  Uncommitted changes
       - 2 modified
       - 1 untracked
     📝 Last: d4e5f6g Update dashboard UI

======================
Total worktrees: 1
```

---

### cleanup-worktree.sh

**Purpose**: Safely remove worktrees when feature work is complete

**Usage**:
```bash
$MI6_PATH/scripts/worktree/cleanup-worktree.sh [options] <feature-name>
```

**Options**:
- `--delete-branches` - Also delete feature branches
- `--force` - Skip uncommitted changes check (DANGEROUS)

**What it does**:
1. Checks for uncommitted changes (aborts if found)
2. Prompts for confirmation
3. Removes `.worktrees/<feature-name>/` directory
4. Prunes git references in all repos
5. Optionally deletes feature branches

**Examples**:
```bash
# Basic cleanup (keeps branches)
$MI6_PATH/scripts/worktree/cleanup-worktree.sh dashboard-v3

# Remove worktrees AND delete branches
$MI6_PATH/scripts/worktree/cleanup-worktree.sh dashboard-v3 --delete-branches

# Force remove (skips checks - use carefully!)
$MI6_PATH/scripts/worktree/cleanup-worktree.sh old-feature --force
```

**Safety features**:
- ✅ Detects uncommitted changes
- ✅ Requires confirmation before removal
- ✅ Shows what will be deleted
- ✅ Warns about branch deletion
- ✅ Provides escape options

---

## Complete Workflow

### 1. Start Feature Work

```bash
# Start task (documentation)
npm run task:start DASHBOARD_V3

# Create worktrees (code)
$MI6_PATH/scripts/worktree/create-feature-worktree.sh dashboard-v3

# Check status
$MI6_PATH/scripts/worktree/list-worktrees.sh
```

### 2. Develop in Worktrees

```bash
# Terminal 1: Backend
cd .worktrees/dashboard-v3/backend
npm run dev

# Terminal 2: Frontend
cd .worktrees/dashboard-v3/frontend
npm run dev

# Make changes, commit in each worktree
git add . && git commit -m "Dashboard v3 changes"
```

### 3. Merge and Deploy

```bash
# In each main repo
cd backend
git checkout main
git merge dashboard-v3
git push

cd ../frontend
git checkout main
git merge dashboard-v3
git push
```

### 4. Clean Up

```bash
# Check for uncommitted work
$MI6_PATH/scripts/worktree/list-worktrees.sh dashboard-v3

# Remove worktrees and branches
$MI6_PATH/scripts/worktree/cleanup-worktree.sh dashboard-v3 --delete-branches

# Complete task (documentation)
npm run task:complete DASHBOARD_V3
```

---

## Integration with Task Lifecycle

Combine worktrees with MI6 task management:

```bash
# 1. Planning → Active (task docs)
npm run task:start NEW_FEATURE

# 2. Create development worktrees (code)
$MI6_PATH/scripts/worktree/create-feature-worktree.sh new-feature

# 3. Develop (worktrees)
cd .worktrees/new-feature/backend
# ... code ...

# 4. Check status anytime
$MI6_PATH/scripts/worktree/list-worktrees.sh

# 5. Clean up worktrees
$MI6_PATH/scripts/worktree/cleanup-worktree.sh new-feature

# 6. Active → Completed (task docs)
npm run task:complete NEW_FEATURE
```

**Benefits**:
- Task docs stay in main tree (no merge conflicts)
- Code changes isolated in worktrees
- Full lifecycle tracked in git

---

## Troubleshooting

### Script: "command not found"

```bash
# Check MI6_PATH is set
echo $MI6_PATH

# Make scripts executable
chmod +x $MI6_PATH/scripts/worktree/*.sh
```

### Creation fails: "Branch already exists"

The script handles this automatically:
- If branch exists, uses it
- Shows warning but continues
- Check with: `$MI6_PATH/scripts/worktree/list-worktrees.sh`

### Cleanup blocked: "Uncommitted changes"

```bash
# Option 1: Commit changes
cd .worktrees/feature-x/backend
git add . && git commit -m "Save work"

# Option 2: Stash changes
git stash

# Option 3: Force remove (DATA LOSS!)
$MI6_PATH/scripts/worktree/cleanup-worktree.sh feature-x --force
```

### "No JSON parser found"

Scripts need one of: `jq`, `node`, or `python3`

```bash
# Install jq (recommended)
sudo apt install jq      # Ubuntu/Debian
brew install jq          # macOS

# Or ensure Node.js installed
node --version

# Or Python
python3 --version
```

---

## Advanced Usage

### Create Worktrees from Specific Base Branch

```bash
# Modify create script call to use different base
# (requires manual edit or script enhancement)
```

### List Only Dirty Worktrees in CI

```bash
# In CI pipeline
if $MI6_PATH/scripts/worktree/list-worktrees.sh --dirty | grep -q "Uncommitted"; then
  echo "Error: Uncommitted changes in worktrees"
  exit 1
fi
```

### Bulk Cleanup

```bash
# Clean up all worktrees
for feature in .worktrees/*/; do
  name=$(basename "$feature")
  $MI6_PATH/scripts/worktree/cleanup-worktree.sh "$name" --force
done
```

---

## See Also

- [Worktree Multi-Repo Dossier](../../dossiers/worktree-multi-repo.md) - LLM-guided alternative
- [Worktree Cleanup Dossier](../../dossiers/worktree-cleanup.md) - LLM-guided cleanup
- [Git Worktree Workflow](../../workflows/git-worktree.md) - Conceptual guide
- [Task Lifecycle](../../workflows/task-lifecycle.md) - Integrate with tasks

---

**🕵️ MI6 Worktree Scripts**
*Fast, deterministic worktree automation*
