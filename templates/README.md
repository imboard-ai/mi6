# MI6 Templates

Reusable project templates for AI-assisted development workflows.

---

## Available Templates

### Configuration Files

| Template | Purpose | When to Use |
|----------|---------|-------------|
| `.ai-project.json` | Project structure configuration | Every MI6 project (defines repos, workflows, task management) |
| `AI_GUIDE.md` | AI assistant instructions | Every MI6 project (guides AI behavior and context) |
| `.aicontextignore` | AI context filtering | Every MI6 project (controls what AI sees) |
| `.gitignore` | Git ignore patterns | Docs repos with nested code repos |
| `package.json` | Task management scripts | Projects using MI6 task lifecycle |

### Directory Structures

| Template | Purpose | When to Use |
|----------|---------|-------------|
| `task-structure/` | Task lifecycle folders | Projects using MI6 task management |

---

## Quick Start

### For New Projects

```bash
# 1. Create your project directory
mkdir my-project
cd my-project

# 2. Copy all templates
cp $MI6_PATH/templates/.ai-project.json .
cp $MI6_PATH/templates/AI_GUIDE.md .
cp $MI6_PATH/templates/.aicontextignore .
cp $MI6_PATH/templates/.gitignore .
cp $MI6_PATH/templates/package.json .
cp -R $MI6_PATH/templates/task-structure/tasks .

# 3. Initialize git
git init

# 4. Customize templates
# - Edit .ai-project.json with your repo structure
# - Fill in AI_GUIDE.md with project details
# - Adjust .aicontextignore patterns
# - Update package.json name and description

# 5. Install dependencies (if using task manager)
npm install

# 6. Commit
git add .
git commit -m "Initial commit with MI6 templates"
```

### For Existing Projects

```bash
# Add MI6 templates to existing project
cd existing-project

# Copy only what you need
cp $MI6_PATH/templates/AI_GUIDE.md .
cp $MI6_PATH/templates/.aicontextignore .

# Merge with existing files if they exist
# Then customize for your project
```

---

## Template Details

### .ai-project.json

**Purpose**: Central configuration defining your project structure

**Key Sections**:
- `repos[]`: Array of repositories (backend, frontend, shared, etc.)
- `workflows`: Define worktree, testing, and deployment strategies
- `taskManagement`: Enable task lifecycle with folder configuration
- `context`: Control what AI assistants see
- `mi6.version`: MI6 framework version for compatibility

**Customization**:
1. Update `name` and `description`
2. Define your `repos[]` array
3. Configure task folder paths
4. Adjust context include/exclude patterns
5. Enable/disable features

**Example - Single Repo**:
```json
{
  "name": "simple-api",
  "structure": "single-repo",
  "repos": [
    {
      "name": "api",
      "type": "backend",
      "language": "typescript",
      "framework": "express"
    }
  ]
}
```

**Example - Monorepo**:
```json
{
  "name": "monorepo-app",
  "structure": "mono-repo",
  "repos": [
    {
      "name": "packages/api",
      "type": "backend"
    },
    {
      "name": "packages/web",
      "type": "frontend"
    }
  ]
}
```

---

### AI_GUIDE.md

**Purpose**: Instructions for AI assistants working on your project

**Key Sections**:
- Project Structure: Explain your repo organization
- Task Management: How to use MI6 task lifecycle
- Build & Development: Commands to run
- Code Style: Formatting, naming, import order
- Testing: Test structure and commands
- AI Guidelines: Rules for AI assistants

**Customization**:
1. Replace `[Project Name]` with your project name
2. Fill in actual commands (npm run dev, etc.)
3. Define your code style rules
4. Add project-specific patterns
5. Update security considerations
6. Link to your resources

**Tips**:
- Be specific with commands (exact npm scripts)
- Include examples of common patterns
- Explain why certain conventions exist
- Update regularly as project evolves

---

### .aicontextignore

**Purpose**: Control what files/folders AI assistants can see

**Key Patterns**:
- `tasks/planned/`, `tasks/stashed/`, `tasks/completed/`: Hide non-active work
- `node_modules/`, `dist/`, `build/`: Hide dependencies and build artifacts
- `.env*`, `*.key`: Prevent secret exposure
- `*.log`, `test-results/`: Hide logs and test output

**Customization**:
1. Add project-specific large files
2. Hide nested repos if using multi-repo
3. Exclude vendor/third-party code
4. Add patterns for generated files

**Important**:
- ⚠️ Always include `.env*` patterns (prevent secret leaks!)
- Keep active tasks visible: Don't add `tasks/active/`
- Update when adding new large directories

---

### .gitignore

**Purpose**: Prevent committing unwanted files to git (for docs repos)

**Key Differences from Standard .gitignore**:
- Ignores nested code repos (backend/, frontend/, etc.)
- Includes task management artifacts
- Focuses on docs repo needs

**Customization**:
1. Adjust nested repo paths to match your structure
2. Add project-specific ignores
3. Keep local settings ignored (.claude/settings.local.json)

**When to Use**:
- Multi-repo setup where parent is docs repo
- Root directory has nested git repositories
- Using MI6 task management scripts

**When NOT to Use**:
- Single code repo (use standard .gitignore)
- Monorepo (use monorepo-specific patterns)

---

### package.json

**Purpose**: Enable MI6 task management via npm scripts

**Key Scripts**:
- `task:start <name>`: Activate a planned task
- `task:pause <name>`: Pause an active task
- `task:resume <name>`: Resume a stashed task
- `task:complete <name>`: Archive a finished task
- `task:list`: Show all tasks and their status

**Customization**:
1. Update `name` field (e.g., "my-project-docs")
2. Update `description`
3. Add author information
4. Add additional scripts if needed

**Requirements**:
- Must have `scripts/task-manager.js` (copy from MI6)
- Node.js installed
- Git repository initialized

---

### task-structure/

**Purpose**: Provide folder structure for task lifecycle management

**Contents**:
```
tasks/
├── planned/    # Future work
├── active/     # Current focus
├── stashed/    # Paused work
└── completed/  # Historical archive
```

**Customization**:
1. Copy entire structure: `cp -R $MI6_PATH/templates/task-structure/tasks ./`
2. Adjust folder names in `.ai-project.json` if needed
3. Create initial tasks in `planned/`

**See Also**: [task-structure/README.md](./task-structure/README.md) for detailed usage

---

## Template Combinations

### Minimal Setup (AI guide only)

```bash
cp $MI6_PATH/templates/AI_GUIDE.md .
# Edit AI_GUIDE.md with project details
```

**Use Case**: Existing project, just want AI guidance

---

### Task Management Setup

```bash
cp $MI6_PATH/templates/package.json .
cp -R $MI6_PATH/templates/task-structure/tasks .
cp $MI6_PATH/templates/.aicontextignore .
npm install
npm run task:start MY_FIRST_TASK
```

**Use Case**: Want MI6 task lifecycle for project planning

---

### Full MI6 Setup

```bash
cp $MI6_PATH/templates/* .
cp -R $MI6_PATH/templates/task-structure/tasks .
# Edit all templates
git init && git add . && git commit -m "Initial commit"
```

**Use Case**: New project adopting full MI6 framework

---

### Multi-Repo Setup

```bash
# In parent directory
cp $MI6_PATH/templates/.ai-project.json .
cp $MI6_PATH/templates/AI_GUIDE.md .
cp $MI6_PATH/templates/.gitignore .  # Ignores nested repos
cp -R $MI6_PATH/templates/task-structure/tasks .

# Edit .ai-project.json with repo paths
# Clone/create nested repos (backend/, frontend/, etc.)
git init && git add . && git commit -m "Docs repo with MI6"
```

**Use Case**: Multiple repos (BE, FE, shared) with shared docs

---

## Customization Guidelines

### 1. Always Customize These Fields

In `.ai-project.json`:
- `name`: Your project name
- `repos[]`: Your actual repositories

In `AI_GUIDE.md`:
- Project name (replace `[Project Name]`)
- Build commands (replace placeholders)
- Code style rules (match your project)
- Security considerations (your auth system)

In `package.json`:
- `name`: "your-project-docs"
- `description`: Project description

### 2. Optional Customizations

- Task folder paths (if not using default `tasks/` structure)
- Context patterns (add project-specific excludes)
- Workflow strategies (worktree, testing, deployment)

### 3. Keep As-Is

- Task management scripts (they're standardized)
- Core .aicontextignore patterns (prevent security issues)
- MI6 version tracking (for compatibility)

---

## Updating Templates

### When MI6 Releases New Versions

```bash
# Pull latest MI6
cd $MI6_PATH
git pull

# Compare your project files with new templates
diff your-project/.ai-project.json $MI6_PATH/templates/.ai-project.json

# Merge improvements manually
```

### Staying Compatible

Check `mi6.version` in your `.ai-project.json`:
- `v1`: Current stable version
- Future versions may have breaking changes

---

## Best Practices

### ✅ Do:
- Copy templates to your project (don't symlink)
- Customize for your specific needs
- Keep templates updated with project evolution
- Version control all template files
- Document project-specific changes

### ❌ Don't:
- Modify templates in `$MI6_PATH` (use copies)
- Skip customization (templates are starting points)
- Commit secrets (even in .env.example)
- Ignore AI_GUIDE.md maintenance
- Copy templates blindly without reading them

---

## Troubleshooting

### Issue: Task scripts not working

**Check**:
1. `package.json` has correct scripts
2. `scripts/task-manager.js` exists
3. `tasks/` directories exist
4. Node.js is installed

### Issue: AI seeing too much context

**Solution**: Update `.aicontextignore` with more patterns

### Issue: Git ignoring wrong files

**Solution**: Check `.gitignore` nested repo paths match your structure

### Issue: Templates out of date

**Solution**: Pull latest MI6 and diff/merge templates

---

## See Also

- [Environment Setup](../docs/environment-setup.md)
- [Task Lifecycle Workflow](../workflows/task-lifecycle.md)
- [MI6 Main README](../README.md)
