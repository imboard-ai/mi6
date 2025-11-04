# MI6 Environment Setup Guide

Complete guide to setting up MI6 for both operators (contributors) and citizens (users).

---

## Table of Contents

1. [Quick Start](#quick-start)
2. [MI6-Operator Setup](#mi6-operator-setup)
3. [MI6-Citizen Setup](#mi6-citizen-setup)
4. [Environment Variable Details](#environment-variable-details)
5. [Verification](#verification)
6. [Troubleshooting](#troubleshooting)

---

## Quick Start

### For Contributors (MI6-Operators)

```bash
# Clone MI6
git clone https://github.com/imboard-ai/mi6.git ~/projects/mi6

# Run setup
cd ~/projects/mi6/scripts/admin
./setup-env.sh

# Reload shell
source ~/.bashrc  # or ~/.zshrc

# Verify
./verify-setup.sh
```

### For Users (MI6-Citizens)

**Option A - Local Installation** (recommended for offline use):
```bash
git clone https://github.com/imboard-ai/mi6.git ~/projects/mi6
cd ~/projects/mi6/scripts/admin && ./setup-env.sh
source ~/.bashrc
```

**Option B - Direct Usage** (no local clone needed):
```bash
# Use scripts directly from GitHub
curl -sSL https://raw.githubusercontent.com/imboard-ai/mi6/main/templates/AI_GUIDE.md > AI_GUIDE.md

# Or download specific scripts
curl -sSL https://raw.githubusercontent.com/imboard-ai/mi6/main/scripts/task-manager/task-manager.js > task-manager.js
```

---

## MI6-Operator Setup

### What is an MI6-Operator?

An **MI6-Operator** is someone who:
- Contributes to MI6 framework itself
- Develops new scripts, templates, or workflows
- Maintains and improves MI6 infrastructure
- Works directly in the MI6 repository

### Setup Steps

#### 1. Clone the Repository

```bash
cd ~/projects
git clone https://github.com/imboard-ai/mi6.git
cd mi6
```

#### 2. Run Environment Setup

```bash
cd scripts/admin
./setup-env.sh
```

This will:
- Detect your shell (bash/zsh)
- Add `MI6_PATH` to your shell configuration
- Point `MI6_PATH` to your cloned directory

#### 3. Reload Your Shell

```bash
source ~/.bashrc  # for bash
# or
source ~/.zshrc   # for zsh
```

#### 4. Verify Setup

```bash
./verify-setup.sh
```

Should output:
```
✓ MI6_PATH is set: /home/username/projects/mi6
✓ MI6_PATH directory exists
✓ All core directories present
✅ MI6 environment verification complete!
```

#### 5. Start Contributing

```bash
cd $MI6_PATH

# View current structure
ls -la

# Make changes directly on main (you're the maintainer)
git status
git add .
git commit -m "Add new feature"
git push origin main
```

### Operator Workflow

As an operator, your workflow is:

1. **Develop**: Edit files in `~/projects/mi6/`
2. **Test**: Use your changes immediately (via `$MI6_PATH`)
3. **Commit**: Push changes to GitHub
4. **Release**: Changes are instantly available to all citizens via GitHub

No separate development environment needed - what you use is what citizens get.

---

## MI6-Citizen Setup

### What is an MI6-Citizen?

An **MI6-Citizen** is someone who:
- Uses MI6 templates and scripts in their projects
- Consumes MI6 resources without modifying MI6 itself
- Wants structure for AI-assisted development
- May have multiple projects using MI6

### Setup Options

#### Option A: Local Clone (Recommended)

**Advantages**:
- Works offline
- Faster access to scripts
- Can pin to specific version
- Easy to browse templates

**Setup**:
```bash
# Clone to standard location
git clone https://github.com/imboard-ai/mi6.git ~/projects/mi6

# Run setup
cd ~/projects/mi6/scripts/admin
./setup-env.sh

# Reload shell
source ~/.bashrc  # or ~/.zshrc

# Verify
echo $MI6_PATH
# Output: /home/username/projects/mi6
```

**Usage**:
```bash
# Copy templates to your project
cd ~/projects/my-project
cp $MI6_PATH/templates/AI_GUIDE.md .
cp $MI6_PATH/templates/.ai-project.json .

# Run scripts
$MI6_PATH/scripts/task-manager/task-manager.js list

# View workflows
cat $MI6_PATH/workflows/task-lifecycle.md
```

#### Option B: Direct GitHub Reference

**Advantages**:
- No local storage needed
- Always latest version
- Minimal setup
- Good for CI/CD environments

**Setup**:
```bash
# No setup needed! Just use curl/wget
```

**Usage**:
```bash
# Download templates
curl -sSL https://raw.githubusercontent.com/imboard-ai/mi6/main/templates/AI_GUIDE.md > AI_GUIDE.md

# Download and run scripts
curl -sSL https://raw.githubusercontent.com/imboard-ai/mi6/main/scripts/task-manager/task-manager.js | node - list

# View workflows
curl -sSL https://raw.githubusercontent.com/imboard-ai/mi6/main/workflows/task-lifecycle.md
```

### Citizen Workflow

As a citizen, your workflow is:

1. **Reference**: Use `$MI6_PATH` or curl to access resources
2. **Copy**: Copy templates to your project and customize
3. **Use**: Run MI6 scripts in your project context
4. **Update**: `git pull` in `$MI6_PATH` to get latest MI6 changes

**Do not**:
- Modify files in `$MI6_PATH` directly
- Commit changes to MI6 repo (you don't have write access anyway)
- Create project-specific content in MI6 directory

**Instead**:
- Copy MI6 templates to your project
- Customize copied files for your needs
- Keep your project files separate from MI6

---

## Environment Variable Details

### What is MI6_PATH?

`MI6_PATH` is an environment variable that points to your MI6 installation directory.

**Example**:
```bash
export MI6_PATH="/home/username/projects/mi6"
```

### Why Use Environment Variable Instead of Symlinks?

| Approach | Pros | Cons |
|----------|------|------|
| **Environment Variable** (MI6 approach) | ✅ Works anywhere<br>✅ Doesn't break if MI6 moves<br>✅ Easy to update<br>✅ Cross-platform | ⚠️ Requires one-time setup |
| **Symlinks** (old approach) | ✅ No setup needed | ❌ Breaks if directory moves<br>❌ Hard to maintain<br>❌ Platform-specific |

### Setting MI6_PATH Manually

If you prefer manual setup or need to update the path:

**Bash** (`~/.bashrc`):
```bash
export MI6_PATH="$HOME/projects/mi6"
```

**Zsh** (`~/.zshrc`):
```bash
export MI6_PATH="$HOME/projects/mi6"
```

**Fish** (`~/.config/fish/config.fish`):
```bash
set -x MI6_PATH "$HOME/projects/mi6"
```

After editing, reload:
```bash
source ~/.bashrc  # or ~/.zshrc or ~/.config/fish/config.fish
```

---

## Verification

### Check MI6_PATH is Set

```bash
echo $MI6_PATH
```

Should output: `/home/username/projects/mi6` (or your custom path)

### Check MI6 Directory Structure

```bash
ls $MI6_PATH
```

Should show:
```
scripts/  workflows/  templates/  prompts/  docs/  LICENSE  README.md
```

### Run Verification Script

```bash
$MI6_PATH/scripts/admin/verify-setup.sh
```

Should show:
```
✓ MI6_PATH is set
✓ MI6_PATH directory exists
✓ All core directories present
✅ MI6 environment verification complete!
```

### Test Using MI6 Resources

```bash
# List templates
ls $MI6_PATH/templates

# View a workflow
cat $MI6_PATH/workflows/task-lifecycle.md

# Run a script
$MI6_PATH/scripts/task-manager/task-manager.js --help
```

---

## Troubleshooting

### Issue: MI6_PATH not set after running setup

**Symptoms**:
```bash
echo $MI6_PATH
# (empty output)
```

**Solutions**:

1. **Reload your shell**:
   ```bash
   source ~/.bashrc  # or ~/.zshrc
   ```

2. **Check if setup actually added it**:
   ```bash
   grep MI6_PATH ~/.bashrc  # or ~/.zshrc
   ```

3. **If missing, run setup again**:
   ```bash
   cd ~/projects/mi6/scripts/admin
   ./setup-env.sh
   ```

4. **Try a new terminal window** (sometimes source doesn't work in all terminals)

---

### Issue: Command not found when running scripts

**Symptoms**:
```bash
$MI6_PATH/scripts/admin/verify-setup.sh
# bash: permission denied
```

**Solution**:
```bash
# Make scripts executable
chmod +x $MI6_PATH/scripts/admin/*.sh
chmod +x $MI6_PATH/scripts/task-manager/*.js
chmod +x $MI6_PATH/scripts/worktree/*.sh
```

---

### Issue: MI6_PATH points to wrong directory

**Solution**:
```bash
# Edit your shell config manually
nano ~/.bashrc  # or ~/.zshrc

# Find the line:
export MI6_PATH="/old/path/mi6"

# Change to:
export MI6_PATH="/new/path/mi6"

# Save and reload
source ~/.bashrc
```

---

### Issue: Scripts work but show "No such file or directory"

**Cause**: MI6 might not be cloned completely or directories are missing

**Solution**:
```bash
# Re-clone MI6
cd ~/projects
rm -rf mi6
git clone https://github.com/imboard-ai/mi6.git

# Run setup again
cd mi6/scripts/admin
./setup-env.sh
source ~/.bashrc
```

---

### Issue: Want to use MI6 from different location

**Scenario**: You cloned MI6 to `/opt/mi6` instead of `~/projects/mi6`

**Solution**:
```bash
# Run setup from the new location
cd /opt/mi6/scripts/admin
./setup-env.sh

# It will auto-detect the new path
# Then reload your shell
source ~/.bashrc
```

---

### Issue: Multiple projects need different MI6 versions

**Solution**: Use per-project MI6 references

**Approach 1 - Git Submodules**:
```bash
cd ~/projects/my-project
git submodule add https://github.com/imboard-ai/mi6.git .mi6

# Use relative path in project
./mi6/scripts/task-manager/task-manager.js
```

**Approach 2 - Project-specific environment**:
```bash
# In project's .envrc or .env
export PROJECT_MI6_PATH="$PWD/.mi6"

# Use in scripts
$PROJECT_MI6_PATH/scripts/task-manager/task-manager.js
```

---

## Next Steps

### For Operators:
1. ✅ Environment set up
2. Read [CONTRIBUTING.md](../CONTRIBUTING.md)
3. Explore [docs/architecture.md](./architecture.md)
4. Start developing new features

### For Citizens:
1. ✅ Environment set up
2. Copy templates: `cp $MI6_PATH/templates/* .`
3. Read [workflows/task-lifecycle.md](../workflows/task-lifecycle.md)
4. Start using MI6 in your projects

---

## See Also

- [Admin Scripts README](../scripts/admin/README.md)
- [Task Lifecycle Workflow](../workflows/task-lifecycle.md)
- [Templates Guide](./templates-guide.md)
- [Main README](../README.md)
