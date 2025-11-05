# Phase 1 Completion Plan: Dossier Metadata System

**Status**: Template created, needs implementation across dossiers
**Remaining Time**: ~3-4 hours
**Created**: 2025-01-05

---

## What's Done ✅

- ✅ Created metadata-section.md template
- ✅ Updated dossier-template.md with metadata section
- ✅ Pushed metadata template to GitHub

---

## What Remains ⏳

### Task 1: Add Metadata to Each Dossier (2.5 hours)

For each dossier, insert metadata section after protocol version header.

#### project-init.md
```markdown
## 📋 Metadata

### Version
- **Dossier**: v1.0.0
- **Protocol**: v1.0
- **Last Updated**: 2025-01-05

### Relationships

**Preceded by**:
- [greenfield-start](./greenfield-start.md) - When starting from zero (optional)

**Followed by**:
- [dependency-install](./dependency-install.md) - Install dependencies (suggested)
- [first-dev-session](./first-dev-session.md) - Start coding (suggested)

**Alternatives**:
- [brownfield-adoption](./brownfield-adoption.md) - For existing projects

**Conflicts with**:
- [project-uninstall](./project-uninstall.md) - Opposite operation

### Outputs

**Files created**:
- `.ai-project.json` - Project configuration (required)
- `AI_GUIDE.md` - AI assistant guide (required)
- `.aicontextignore` - Context filtering (required)
- `tasks/` - Task lifecycle structure (required)
- `scripts/task-manager.js` - Task automation (required)

**Configuration produced**:
- `project.type` - Consumed by: worktree-multi-repo, dependency-install
- `project.repos[]` - Consumed by: worktree-multi-repo, dependency-install

**State changes**:
- Git initialized (if wasn't already)
- MI6 structure established

### Inputs

**Required**:
- `$MI6_PATH` - MI6 installation path
- Write permissions in current directory

**Optional**:
- `project_name` - Auto-detected from directory

**From other dossiers**:
- greenfield-start → `project_directory` (if used)

### Coupling

**Level**: Medium
- Produces `.ai-project.json` consumed by multiple dossiers
- Can run standalone (auto-detects if needed)
- Output schema changes affect dependents
```

#### greenfield-start.md
```markdown
## 📋 Metadata

### Version
- **Dossier**: v1.0.0
- **Protocol**: v1.0
- **Last Updated**: 2025-01-05

### Relationships

**Preceded by**:
- None (entry point for new projects)

**Followed by**:
- [project-init](./project-init.md) - Complete MI6 setup (required)

**Alternatives**:
- [brownfield-adoption](./brownfield-adoption.md) - If project already exists

### Outputs

**Files created**:
- Project directory
- `README.md` - Basic project readme

**State changes**:
- Git repositories initialized
- Directory structure created

### Inputs

**Required**:
- `$MI6_PATH` - MI6 installation
- Project concept/idea

### Coupling

**Level**: Loose
- Only creates directory and basic structure
- No shared configuration files yet
- Hands off cleanly to project-init
```

#### brownfield-adoption.md
```markdown
## 📋 Metadata

### Version
- **Dossier**: v1.0.0
- **Protocol**: v1.0
- **Last Updated**: 2025-01-05

### Relationships

**Preceded by**:
- None (alternative entry point for existing projects)

**Followed by**:
- [project-init](./project-init.md) - Complete MI6 setup with merge mode (required)

**Alternatives**:
- [greenfield-start](./greenfield-start.md) - For new projects

**Conflicts with**:
- [greenfield-start](./greenfield-start.md) - Different starting points
- [project-uninstall](./project-uninstall.md) - Opposite operation

### Outputs

**Files created**:
- Backup files (.gitignore.pre-mi6, etc.)
- Backup git branch (pre-mi6-backup)

**State changes**:
- Existing configs preserved
- MI6 files merged/added

### Inputs

**Required**:
- Existing project with code
- Git repository

### Coupling

**Level**: Medium
- Interacts with existing project structure
- Must preserve existing files
- Merger of old + new configs
```

#### worktree-multi-repo.md
```markdown
## 📋 Metadata

### Version
- **Dossier**: v1.0.0
- **Protocol**: v1.0
- **Last Updated**: 2025-01-05

### Relationships

**Preceded by**:
- [project-init](./project-init.md) - Needs .ai-project.json (required)

**Followed by**:
- [worktree-cleanup](./worktree-cleanup.md) - When feature complete (eventual)

**Conflicts with**:
- [worktree-cleanup](./worktree-cleanup.md) - Opposite operation (at same time)

### Outputs

**Files created**:
- `.worktrees/[feature-name]/` - Worktree structure
- Multiple git worktrees with branches

**State changes**:
- Git worktrees created for all repos
- Feature branches created

### Inputs

**Required**:
- `.ai-project.json` with repos array
- Feature/branch name

**From other dossiers**:
- project-init → `.ai-project.json` (required)

### Coupling

**Level**: Medium
- Tightly coupled to `.ai-project.json` schema
- Reads repos configuration
- Independent once created
```

#### worktree-cleanup.md
```markdown
## 📋 Metadata

### Version
- **Dossier**: v1.0.0
- **Protocol**: v1.0
- **Last Updated**: 2025-01-05

### Relationships

**Preceded by**:
- [worktree-multi-repo](./worktree-multi-repo.md) - Creates worktrees to clean up (required)

**Conflicts with**:
- [worktree-multi-repo](./worktree-multi-repo.md) - Opposite operation

### Outputs

**Files removed**:
- `.worktrees/[feature-name]/` - Removed directories

**State changes**:
- Git worktrees pruned
- Feature branches optionally deleted

### Inputs

**Required**:
- Existing worktree to remove
- Feature name

### Coupling

**Level**: Medium
- Depends on worktree structure created by worktree-multi-repo
- Uses .ai-project.json for repo discovery
```

#### dependency-install.md
```markdown
## 📋 Metadata

### Version
- **Dossier**: v1.0.0
- **Protocol**: v1.0
- **Last Updated**: 2025-01-05

### Relationships

**Preceded by**:
- [project-init](./project-init.md) - Creates .ai-project.json (suggested)

**Followed by**:
- [first-dev-session](./first-dev-session.md) - Start development (suggested)

**Can run in parallel with**:
- [worktree-multi-repo](./worktree-multi-repo.md) - Independent operations

### Outputs

**Files created**:
- `node_modules/` - Installed dependencies (per repo)
- Lock files (package-lock.json, yarn.lock, etc.)

**State changes**:
- Dependencies installed for all repos
- Ready for development

### Inputs

**Required**:
- `.ai-project.json` with repos list (or can auto-detect)

**From other dossiers**:
- project-init → `.ai-project.json` (optional, can auto-detect)

### Coupling

**Level**: Loose
- Can auto-detect repos without .ai-project.json
- Uses config if available for efficiency
- Graceful degradation if config missing
```

#### first-dev-session.md
```markdown
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
```

#### task-create.md
```markdown
## 📋 Metadata

### Version
- **Dossier**: v1.0.0
- **Protocol**: v1.0
- **Last Updated**: 2025-01-05

### Relationships

**Preceded by**:
- None (can run anytime after project-init)

**Followed by**:
- Task manager: `npm run task:start [TASK_NAME]`

**Can run in parallel with**:
- Most other dossiers (independent operation)

**Used by** (as sub-dossier):
- [first-dev-session](./first-dev-session.md) - Creates initial task

### Outputs

**Files created**:
- Task document in `tasks/planned/` or `tasks/active/`

### Inputs

**Required**:
- Task structure exists (`tasks/` directories)
- Task concept/description

### Coupling

**Level**: Loose
- Standalone operation
- Only requires task folders to exist
- No configuration dependencies
```

#### project-uninstall.md
```markdown
## 📋 Metadata

### Version
- **Dossier**: v1.0.0
- **Protocol**: v1.0
- **Last Updated**: 2025-01-05

### Relationships

**Preceded by**:
- Any failed MI6 adoption

**Conflicts with**:
- [project-init](./project-init.md) - Opposite operation
- [greenfield-start](./greenfield-start.md) - Opposite operation
- [brownfield-adoption](./brownfield-adoption.md) - Opposite operation
- All setup dossiers

### Outputs

**Files removed**:
- `.ai-project.json`
- `AI_GUIDE.md`
- `.aicontextignore`
- `tasks/`
- `scripts/task-manager.js`

**Files created**:
- Archived tasks in `archive/mi6-tasks-YYYYMMDD/`
- Restored original configs (.gitignore, package.json)

**State changes**:
- MI6 removed from project
- Original state restored

### Inputs

**Required**:
- MI6 currently installed in project

### Coupling

**Level**: Medium
- Must know about all MI6 files to remove
- Preserves non-MI6 files
- Reverses project-init operations
```

---

### Task 2: Create REGISTRY.md (45 min)

**File**: `dossiers/REGISTRY.md`

**Contents**:
- Complete catalog table
- Journey-based organization
- Relationship map
- Quick reference

---

### Task 3: Update Documentation (30 min)

**Files to update**:
- `dossiers/README.md` - Add metadata explanation
- `_PROTOCOL.md` - Reference metadata system

---

## Commit Message

```
Complete Phase 1: Dossier Metadata System

Add comprehensive metadata to all dossiers documenting relationships, outputs, inputs, and coupling

**Metadata added to 10 dossiers**:
- Relationship documentation (preceded by, followed by, alternatives, conflicts, parallel)
- Output taxonomy (files, configuration, state changes)
- Input declarations (required, optional, from other dossiers)
- Coupling classification (tight/medium/loose)

**Created**:
- dossiers/REGISTRY.md - Complete dossier catalog
- Updated documentation explaining metadata system

**Benefits**:
- ✅ Navigable dossier ecosystem
- ✅ Clear dependency chains
- ✅ Documented outputs and inputs
- ✅ Foundation for discovery tools
- ✅ Professional documentation

Phase 2 ready: Discovery tools and visualization
```

---

## Next Session Continuation Point

After Phase 1 complete, you'll be ready for:
- **Phase 2**: Discovery tools (graphs, CLI search)
- **Phase 3**: Coupling intelligence
- **Or**: Start using MI6 in imboard project!

---

**This plan provides everything needed to complete Phase 1**
