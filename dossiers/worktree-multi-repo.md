# Dossier: Multi-Repo Worktree Setup

**Purpose**: Create linked git worktrees across multiple repositories for parallel feature development.

**When to use**: Starting a feature that spans multiple repos (backend, frontend, shared libraries).

---

## Objective

Create a coordinated worktree structure where:
- All repos have worktrees on the same feature branch
- Worktrees are organized in a linked directory structure
- Each repo's worktree is ready for development
- User can work on all repos simultaneously without branch switching

---

## Prerequisites

- ✅ MI6 is installed and `$MI6_PATH` is set
- ✅ Project has `.ai-project.json` with repos defined
- ✅ Current directory is the project root (where `.ai-project.json` exists)
- ✅ All repos listed in config actually exist

**Validation**:
```bash
cat .ai-project.json | grep -A 10 '"repos"'
```

---

## Context to Gather

### 1. Read Project Configuration

**Parse `.ai-project.json`**:
```bash
cat .ai-project.json
```

**Extract**:
- Project name
- Structure type (multi-repo, mono-repo, single-repo)
- List of all repos with their paths
- Each repo's name and location

**Example output**:
```
Project: my-project
Structure: multi-repo
Repos:
  - backend (./backend)
  - frontend (./frontend)
  - shared (./shared-types)
```

### 2. Verify Repos Exist

**Check each repo path**:
```bash
# For each repo in config
ls -d ./backend ./frontend ./shared-types
```

**Check each has a git repo**:
```bash
git -C ./backend status
git -C ./frontend status
git -C ./shared-types status
```

### 3. Check Feature Branch Name

**User should provide** feature/branch name, or we can:
- Infer from active task (if any)
- Ask user directly
- Use a default pattern: `feature-[timestamp]`

**Validate branch name**:
- No spaces (replace with hyphens)
- Lowercase preferred
- No special characters except `-` and `_`

---

## Decision Points

### Decision 1: Worktree Directory Location

**Options**:
- `.worktrees/[feature-name]/` (recommended - clean organization)
- `../.worktrees/[feature-name]/` (outside project root)
- Custom location (user specifies)

**Recommendation**: `.worktrees/[feature-name]/` in project root

### Decision 2: Branch Creation Strategy

**If branch doesn't exist**:
- Create new branch from current HEAD
- Create from specific base branch (main, develop, etc.)

**If branch exists**:
- Use existing branch
- Warn user (might have uncommitted work)

**Recommendation**: Create fresh branches from main/master

### Decision 3: Initialization Steps

**After creating worktrees**:
- Run `npm install` in each? (slow but ensures dependencies)
- Skip install (user does manually)
- Ask user preference

**Recommendation**: Skip (let user install as needed)

---

## Actions to Perform

### Step 1: Create Worktree Base Directory

**Create organized structure**:
```bash
mkdir -p .worktrees/[feature-name]
```

**Example**:
```bash
mkdir -p .worktrees/feature-dashboard-v3
```

### Step 2: Create Worktree for Each Repo

**For each repo in `.ai-project.json`, create worktree**:

**Pattern**:
```bash
git -C [repo-path] worktree add \
  ../../.worktrees/[feature-name]/[repo-name] \
  -b [feature-name]
```

**Concrete example for 3 repos**:
```bash
# Backend worktree
git -C ./backend worktree add \
  ../.worktrees/feature-dashboard-v3/backend \
  -b feature-dashboard-v3

# Frontend worktree
git -C ./frontend worktree add \
  ../.worktrees/feature-dashboard-v3/frontend \
  -b feature-dashboard-v3

# Shared types worktree
git -C ./shared-types worktree add \
  ../.worktrees/feature-dashboard-v3/shared \
  -b feature-dashboard-v3
```

**Result**:
```
.worktrees/
└── feature-dashboard-v3/
    ├── backend/      # On feature-dashboard-v3 branch
    ├── frontend/     # On feature-dashboard-v3 branch
    └── shared/       # On feature-dashboard-v3 branch
```

### Step 3: Verify Worktrees Created

**Check each worktree**:
```bash
ls -d .worktrees/[feature-name]/*
```

**Verify branches**:
```bash
git -C .worktrees/[feature-name]/backend branch --show-current
git -C .worktrees/[feature-name]/frontend branch --show-current
git -C .worktrees/[feature-name]/shared branch --show-current
```

All should show: `[feature-name]`

### Step 4: Create Quick Access Instructions

**Generate helper script** (optional but nice):
```bash
cat > .worktrees/[feature-name]/README.md << EOF
# Worktree: [feature-name]

## Branches
All repos on branch: **[feature-name]**

## Working Directories
- Backend: \`cd backend/\`
- Frontend: \`cd frontend/\`
- Shared: \`cd shared/\`

## Development
\`\`\`bash
# Terminal 1: Backend
cd backend/ && npm run dev

# Terminal 2: Frontend
cd frontend/ && npm run dev
\`\`\`

## When Done
1. Commit changes in each repo
2. Push branches: \`git push -u origin [feature-name]\`
3. Create PRs for each repo
4. Clean up worktrees: \$MI6_PATH/dossiers/worktree-cleanup.md
EOF
```

### Step 5: Show User Next Steps

**Print summary**:
```
✅ Worktrees created for: [feature-name]

📂 Location: .worktrees/[feature-name]/

🔀 Branches created:
   - backend: [feature-name]
   - frontend: [feature-name]
   - shared: [feature-name]

📝 Start developing:
   cd .worktrees/[feature-name]/backend
   # Make changes, commit, push

💡 Tip: Each worktree is independent - no need to switch branches!
```

---

## Validation

### Check Worktree Structure

```bash
ls -la .worktrees/[feature-name]/
# Should show backend/, frontend/, shared/ (or your repos)
```

### Verify Branches

```bash
git -C .worktrees/[feature-name]/backend branch
git -C .worktrees/[feature-name]/frontend branch
git -C .worktrees/[feature-name]/shared branch
# All should show feature-name branch as active (*)
```

### Test Git Operations

```bash
# Try a test commit in one worktree
cd .worktrees/[feature-name]/backend
echo "# Test" > TEST.md
git add TEST.md
git commit -m "Test commit"
git log -1
rm TEST.md && git reset --hard HEAD~1
```

### Check Main Repos Unaffected

```bash
cd backend && git branch --show-current
# Should still be on original branch (main/master/etc.)
```

---

## Success Criteria

1. ✅ `.worktrees/[feature-name]/` directory exists
2. ✅ One worktree per repo in config
3. ✅ All worktrees on same branch name
4. ✅ Can commit in worktrees without affecting main repos
5. ✅ Original repos remain on their original branches

---

## Example

### Before (Multi-Repo Project):
```
my-project/
├── .ai-project.json
├── backend/            # On 'main' branch
│   └── .git/
├── frontend/           # On 'main' branch
│   └── .git/
└── shared-types/       # On 'main' branch
    └── .git/
```

### After Worktree Creation:
```
my-project/
├── .ai-project.json
├── .worktrees/
│   └── feature-dashboard-v3/      # ✨ New worktree structure
│       ├── backend/               # ✨ On 'feature-dashboard-v3' branch
│       ├── frontend/              # ✨ On 'feature-dashboard-v3' branch
│       ├── shared/                # ✨ On 'feature-dashboard-v3' branch
│       └── README.md              # ✨ Quick reference
├── backend/                       # Still on 'main' branch
├── frontend/                      # Still on 'main' branch
└── shared-types/                  # Still on 'main' branch
```

### Development Workflow:
```bash
# Terminal 1: Backend development
cd .worktrees/feature-dashboard-v3/backend
npm run dev
# Make changes, commit to feature-dashboard-v3 branch

# Terminal 2: Frontend development
cd .worktrees/feature-dashboard-v3/frontend
npm run dev
# Make changes, commit to feature-dashboard-v3 branch

# Both work simultaneously, no branch switching needed!
```

---

## Troubleshooting

### Issue: Branch already exists

**Symptoms**:
```
fatal: a branch named 'feature-x' already exists
```

**Causes**:
- Previously created this branch
- Branch exists in one or more repos

**Solutions**:

**Option A**: Use existing branch (if safe):
```bash
git -C [repo] worktree add [path] [existing-branch]
# (omit -b flag)
```

**Option B**: Choose different branch name:
```bash
# Add suffix: feature-x-v2
git -C [repo] worktree add [path] -b feature-x-v2
```

**Option C**: Delete old branch first (if sure):
```bash
git -C [repo] branch -D feature-x
# Then retry worktree creation
```

### Issue: Worktree path already exists

**Symptoms**:
```
fatal: '.worktrees/feature-x' already exists
```

**Solution**:
```bash
# Remove old worktree directory
rm -rf .worktrees/feature-x

# Clean up git references
git -C backend worktree prune
git -C frontend worktree prune

# Retry creation
```

### Issue: Repo not found

**Symptoms**:
```
fatal: not a git repository: './backend'
```

**Causes**:
- Path in `.ai-project.json` is wrong
- Repo doesn't exist
- Not in project root directory

**Solutions**:
- Verify current directory: `pwd`
- Check repo exists: `ls -d backend`
- Verify path in config: `cat .ai-project.json | grep path`
- Fix config or navigate to correct directory

### Issue: Permission denied

**Symptoms**:
```
fatal: unable to create '.worktrees/feature-x': Permission denied
```

**Solution**:
```bash
# Check permissions on project directory
ls -ld .
# Should show write permissions

# If not, fix permissions (careful!):
chmod u+w .
```

---

## Notes for LLM Execution

- **Dynamic repo detection**: Read repos from `.ai-project.json`, don't hardcode
- **Error handling**: If one worktree fails, report which one and why
- **Path handling**: Use relative paths consistently, adjust for nested structures
- **User feedback**: Show progress for each repo as you create its worktree
- **Idempotency**: Check if worktrees already exist before creating
- **Cleanup reminder**: Mention cleanup when user is done

---

## Related Dossiers

- [worktree-cleanup.md](./worktree-cleanup.md) - Remove worktrees when done (TODO)
- [project-init.md](./project-init.md) - Initialize MI6 first if needed
- [task-create.md](./task-create.md) - Create task for the feature

## Related Workflows

- [Git Worktree Workflow](../workflows/git-worktree.md) - Conceptual guide
- [Task Lifecycle](../workflows/task-lifecycle.md) - Coordinate with tasks

---

**🕵️ MI6 Multi-Repo Worktree Dossier**
*Parallel development across multiple repositories made easy*
