# Dossier: Brownfield Adoption

**Protocol Version**: 1.0 ([_PROTOCOL.md](./_PROTOCOL.md))

**Purpose**: Safely integrate MI6 into an existing project without disrupting current workflows.

**When to use**: You have an existing codebase and want to add MI6's task management, worktree workflows, and AI context control.

---

## Objective

Add MI6 capabilities to an existing project while:
- Preserving existing code and git history
- Avoiding conflicts with current setup
- Allowing partial adoption (choose features you want)
- Providing rollback capability if needed
- Coordinating with team if multi-developer project

---

## Prerequisites

- ✅ Existing project with code
- ✅ MI6 is installed (`$MI6_PATH` is set)
- ✅ User is in project root directory
- ✅ User has backed up project (git commit or branch)

**Validation**:
```bash
echo $MI6_PATH      # MI6 installed
git status          # Check current state
git log -1          # Recent commit (backup point)
```

---

## Context to Gather

### 1. Safety Backup

**CRITICAL: Create backup before proceeding**:
```bash
# Create backup branch
git checkout -b pre-mi6-backup
git checkout -  # Return to original branch

# Or ensure latest work is committed
git status  # Should show clean working tree
```

**If uncommitted changes**:
- ⚠️ **Stop**: Commit or stash before proceeding
- MI6 adds files - don't want conflicts

### 2. Existing Project Analysis

**Scan for existing MI6-like files**:
```bash
ls -la .ai-project.json AI_GUIDE.md .aicontextignore tasks/ scripts/ 2>/dev/null
```

**If any exist**:
- ⚠️ Partial MI6 setup detected
- Ask: Overwrite? Merge? Skip?

**Check for conflicting files**:
```bash
ls -la .gitignore package.json  # Common conflicts
```

**Detect existing task systems**:
```bash
ls -la TODO.md TASKS.md tasks.txt .github/ISSUE_TEMPLATE/ 2>/dev/null
```

**Check git structure**:
- Single repo? Multiple nested repos? Monorepo?
- See: `find . -maxdepth 2 -name ".git" -type d`

### 3. Team Considerations

**Ask user**:
- **Solo or team project?**
  - Solo: Can adopt immediately
  - Team: Need communication plan

- **Shared or forked?**
  - Shared: Team will all use MI6
  - Forked: Just you using MI6 (your fork only)

**If team project**:
- ⚠️ Plan communication before making changes
- Suggest: Create proposal branch, show team before merging

---

## Decision Points

### Decision 1: Adoption Strategy

**Options**:

**A. Full Adoption** (All MI6 features):
- ✅ Complete `.ai-project.json`, `AI_GUIDE.md`, task management, worktrees
- ✅ Use when: Fresh start, want full MI6 benefits
- ⚠️ Most changes to project structure

**B. Partial Adoption** (Pick features):
- ✅ Just task management? Just worktrees? Just AI context control?
- ✅ Use when: Want to try MI6 gradually
- ✅ Less risky, easier rollback

**C. Trial Branch** (Test first):
- ✅ Adopt on separate branch, test, then merge
- ✅ Use when: Team project or high-stakes codebase
- ✅ Safest approach

**Recommendation**: Trial branch for teams, partial adoption for solo

### Decision 2: File Conflict Resolution

**For each conflicting file**:

**.gitignore conflict**:
- **Merge**: Combine existing + MI6 patterns (recommended)
- **Replace**: Use MI6 version (risky - might break builds)
- **Skip**: Keep existing (MI6 might not work correctly)

**package.json conflict**:
- **Merge scripts**: Add MI6 task scripts to existing (recommended)
- **Replace**: Use MI6 version (breaks existing scripts!)
- **Skip**: Keep existing (can't use `npm run task:*`)

**Existing docs conflict**:
- **Integrate**: Move existing docs into `core/` or `tasks/`
- **Archive**: Rename to `docs-old/`, start fresh
- **Preserve**: Keep alongside MI6 docs

**Recommendation**: Always merge, never replace without backup

### Decision 3: Existing Task Migration

**If existing task system found**:

**Options**:
- **Import**: Convert existing tasks to MI6 format
- **Archive**: Move old system to `legacy-tasks/`
- **Run parallel**: Use both systems temporarily
- **Skip**: Ignore old tasks, start fresh

**Recommendation**: Archive old, import important tasks manually

---

## Actions to Perform

### Step 1: Create Backup Branch

**Safety first**:
```bash
git checkout -b mi6-adoption
```

**All changes happen on this branch** - can review before merging

**Validation**:
```bash
git branch --show-current
# Should show: mi6-adoption
```

### Step 2: Scan and Report Conflicts

**Check for existing files**:
```bash
for file in .ai-project.json AI_GUIDE.md .aicontextignore .gitignore package.json; do
  if [ -f "$file" ]; then
    echo "⚠️  Exists: $file"
  fi
done
```

**If conflicts found**, ask user for each:
- Merge (combine old + new)
- Replace (backup old, use MI6 version)
- Skip (keep existing, don't add MI6 version)

### Step 3: Merge .gitignore (If Exists)

**If .gitignore exists**:
```bash
# Backup original
cp .gitignore .gitignore.pre-mi6

# Append MI6 patterns (don't replace!)
cat $MI6_PATH/templates/.gitignore >> .gitignore

# Remove duplicates
sort .gitignore | uniq > .gitignore.tmp
mv .gitignore.tmp .gitignore
```

**Validation**: Check file contains both old and new patterns

### Step 4: Merge package.json (If Exists)

**If package.json exists**:
```bash
# Backup original
cp package.json package.json.pre-mi6

# Add MI6 task scripts (preserve existing scripts)
# This requires JSON manipulation - use Node.js or manual edit
```

**Manual merge approach**:
```json
{
  "scripts": {
    ...existing scripts...,
    "task:start": "node scripts/task-manager.js start",
    "task:pause": "node scripts/task-manager.js pause",
    "task:resume": "node scripts/task-manager.js resume",
    "task:complete": "node scripts/task-manager.js complete",
    "task:list": "node scripts/task-manager.js list"
  }
}
```

### Step 5: Run Project-Init with Merge Mode

**Execute project-init dossier** with awareness of existing files:
```
"Use project-init dossier to add MI6 to this existing project.
Merge with existing files, don't replace."
```

The project-init dossier will:
- Detect existing structure
- Add missing MI6 files
- Customize based on detected code
- Preserve existing setup

### Step 6: Archive Existing Task System (If Any)

**If user has existing tasks**:
```bash
# Archive old task system
mkdir -p archive/legacy-tasks
mv TODO.md tasks.txt TASKS/ archive/legacy-tasks/ 2>/dev/null || true
```

**Import important tasks** to MI6:
```bash
# Manually create critical tasks in tasks/planned/
# Example:
echo "# Production Bug Fix" > tasks/planned/BUG_PROD_FIX.md
```

### Step 7: Test MI6 Integration

**Verify MI6 works without breaking existing functionality**:
```bash
# Test task manager
npm run task:list

# Test existing commands still work
npm test          # Should still pass
npm run dev       # Should still start
npm run build     # Should still build
```

### Step 8: Commit MI6 Adoption

**If tests pass and everything works**:
```bash
git add .
git commit -m "Add MI6 framework for task and worktree management

- Added .ai-project.json configuration
- Added AI_GUIDE.md for AI assistants
- Added task lifecycle management
- Merged .gitignore with MI6 patterns
- Added task management scripts to package.json
- Preserved all existing functionality

Powered by MI6: https://github.com/imboard-ai/mi6"
```

### Step 9: Review and Merge (If Trial Branch)

**Review changes**:
```bash
git diff main..mi6-adoption
```

**If satisfied, merge**:
```bash
git checkout main
git merge mi6-adoption
```

**If team project**: Create PR for review first

---

## Validation

### MI6 Files Exist
```bash
ls .ai-project.json AI_GUIDE.md tasks/ scripts/task-manager.js
# All should exist
```

### Existing Functionality Preserved
```bash
npm test          # Tests still pass
npm run dev       # Dev server still works
git log           # History preserved
```

### No Conflicts
```bash
git status        # Should show clean or only expected changes
```

### Task Manager Works
```bash
npm run task:list
# Should run without errors
```

---

## Success Criteria

1. ✅ All MI6 files added
2. ✅ Existing code unchanged
3. ✅ Existing workflows still work (build, test, dev)
4. ✅ No git conflicts
5. ✅ Task manager functional
6. ✅ Team aligned (if applicable)
7. ✅ Backup branch exists for rollback

---

## Example

### Before (Existing Project):
```
my-existing-app/
├── .git/
├── .gitignore           # Custom patterns
├── package.json         # Existing scripts
├── README.md            # Project docs
├── TODO.md              # Old task list
├── backend/
│   ├── src/
│   └── package.json
└── frontend/
    ├── src/
    └── package.json
```

### After MI6 Adoption:
```
my-existing-app/
├── .git/
├── .ai-project.json          # ✨ MI6 config
├── AI_GUIDE.md               # ✨ AI assistant guide
├── .aicontextignore          # ✨ Context control
├── .gitignore                # ✨ Merged with MI6 patterns
├── .gitignore.pre-mi6        # ✨ Backup
├── package.json              # ✨ Added task scripts
├── package.json.pre-mi6      # ✨ Backup
├── README.md                 # Preserved
├── tasks/                    # ✨ MI6 task structure
│   ├── planned/
│   ├── active/
│   ├── stashed/
│   └── completed/
├── scripts/
│   └── task-manager.js       # ✨ Task automation
├── archive/
│   └── legacy-tasks/
│       └── TODO.md           # ✨ Archived
├── backend/                  # Preserved
└── frontend/                 # Preserved
```

---

## Troubleshooting

### Issue: MI6 breaks existing build

**Symptoms**: `npm run build` fails after MI6 adoption

**Causes**:
- `.gitignore` now ignores build dependencies
- `package.json` scripts overwritten
- File conflicts

**Solution**:
```bash
# Rollback to backup branch
git checkout main
git reset --hard pre-mi6-backup

# Try again with merge strategy (not replace)
```

### Issue: Team doesn't want MI6

**Solution**: Use MI6 only in your fork
```bash
# Work on your fork
git checkout -b mi6-adoption
# Add MI6
# Don't merge to main
# Use personally for task management
```

### Issue: Too many changes at once

**Solution**: Partial adoption
```
"Use project-init dossier but only add task management, skip worktrees"
```

Configure `.ai-project.json` with minimal features:
```json
{
  "taskManagement": { "enabled": true },
  "mi6": { "features": ["task-lifecycle"] }
}
```

---

## Notes for LLM Execution

- **Always create backup branch first** - Safety critical
- **Ask before overwriting** - Existing files might be important
- **Merge, don't replace** - Preserve existing setup where possible
- **Test after adoption** - Verify existing commands still work
- **Explain what changed** - User needs to understand modifications
- **Provide rollback instructions** - User might want to undo

---

## Related Dossiers

**Alternative journeys**:
- [greenfield-start.md](./greenfield-start.md) - For brand new projects
- [project-uninstall.md](./project-uninstall.md) - Remove MI6 if adoption fails

**Next steps after adoption**:
- [dependency-install.md](./dependency-install.md) - Install dependencies
- [team-sync.md](./team-sync.md) - Sync configuration across team
- [task-create.md](./task-create.md) - Create your first MI6 task

---

**🕵️ MI6 Brownfield Adoption Dossier**
*Add MI6 to existing projects safely*
