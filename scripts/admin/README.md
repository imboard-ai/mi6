# MI6 Admin Scripts

Administrative utilities for setting up and maintaining MI6 environment.

## Scripts

### setup-env.sh

**Purpose**: Configure `MI6_PATH` environment variable for your shell

**Usage**:
```bash
./setup-env.sh
```

**What it does**:
1. Detects your shell type (bash or zsh)
2. Finds the MI6 installation directory automatically
3. Adds `MI6_PATH` environment variable to your shell configuration
4. Provides instructions for reloading your shell

**After running**:
```bash
# Reload your shell
source ~/.bashrc  # or ~/.zshrc

# Verify it works
echo $MI6_PATH
```

---

### verify-setup.sh

**Purpose**: Verify MI6 environment is configured correctly

**Usage**:
```bash
./verify-setup.sh
```

**What it checks**:
- MI6_PATH environment variable is set
- MI6_PATH directory exists
- Core directories are present (scripts, workflows, templates, etc.)
- Git repository information (if applicable)

**When to use**:
- After running setup-env.sh
- When troubleshooting MI6 issues
- After cloning MI6 to a new machine

---

### repair-symlinks.sh

**Purpose**: Find and fix broken symlinks in your project

**Usage**:
```bash
cd /path/to/your/project
$MI6_PATH/scripts/admin/repair-symlinks.sh
```

**What it does**:
1. Scans current directory for broken symlinks
2. Lists all broken links found
3. Optionally removes broken symlinks
4. Recommends using MI6_PATH instead of symlinks

**When to use**:
- When moving MI6 to a different directory
- When symlinks break after directory restructuring
- As part of project cleanup

**Note**: MI6 recommends using `MI6_PATH` environment variable instead of symlinks for better portability.

---

## For MI6-Operators (Contributors)

If you're developing MI6 itself:

1. **Clone MI6**: `git clone https://github.com/imboard-ai/mi6.git`
2. **Run setup**: `cd mi6/scripts/admin && ./setup-env.sh`
3. **Verify**: `./verify-setup.sh`
4. **Develop**: Make changes and commit directly to main

## For MI6-Citizens (Users)

If you're using MI6 in your projects:

1. **Option A - Local clone**:
   ```bash
   git clone https://github.com/imboard-ai/mi6.git ~/projects/mi6
   cd ~/projects/mi6/scripts/admin && ./setup-env.sh
   source ~/.bashrc  # or ~/.zshrc
   ```

2. **Option B - Direct GitHub reference** (no local clone):
   ```bash
   # Download and run scripts on-demand
   curl -sSL https://raw.githubusercontent.com/imboard-ai/mi6/main/scripts/admin/setup-env.sh | bash

   # Or use scripts directly
   curl -sSL https://raw.githubusercontent.com/imboard-ai/mi6/main/templates/AI_GUIDE.md > AI_GUIDE.md
   ```

---

## Troubleshooting

### MI6_PATH not found after setup

```bash
# Make sure you reloaded your shell
source ~/.bashrc  # or ~/.zshrc

# Check if it's in your config
grep MI6_PATH ~/.bashrc  # or ~/.zshrc

# If still not working, run setup again
./setup-env.sh
```

### Directory not found errors

```bash
# Verify MI6 is cloned correctly
ls $MI6_PATH

# Should show: scripts/ workflows/ templates/ prompts/ docs/
```

### Permission denied errors

```bash
# Make sure scripts are executable
chmod +x $MI6_PATH/scripts/admin/*.sh
```
