# Dossier: Dependency Installation

**Purpose**: Install all dependencies across multiple repositories automatically.

**When to use**: After project initialization or when dependencies are out of sync.

---

## Objective

Install all project dependencies by:
- Reading `.ai-project.json` to find all repos
- Detecting package manager for each repo
- Running install command for each
- Verifying installations succeeded
- Reporting any failures

---

## Prerequisites

- ✅ `.ai-project.json` exists with repos defined
- ✅ Package managers installed (npm, pip, cargo, etc.)

---

## Context to Gather

### 1. Find All Repositories

**Parse `.ai-project.json`**:
```bash
cat .ai-project.json | grep -A 5 '"repos"'
```

Extract repo paths and languages.

### 2. Detect Package Managers

**For each repo, check for**:
- `package.json` → npm/yarn/pnpm
- `requirements.txt` or `pyproject.toml` → pip/poetry
- `Cargo.toml` → cargo
- `go.mod` → go modules
- `Gemfile` → bundler

**Check which package manager**:
```bash
# Node.js
ls package.json yarn.lock pnpm-lock.yaml
# Python
ls requirements.txt pyproject.toml poetry.lock
# Rust
ls Cargo.toml Cargo.lock
```

---

## Actions to Perform

### Step 1: Install for Each Repo

**For Node.js repos**:
```bash
cd [repo-path]

# Detect package manager
if [ -f "pnpm-lock.yaml" ]; then
  pnpm install
elif [ -f "yarn.lock" ]; then
  yarn install
else
  npm install
fi

cd ..
```

**For Python repos**:
```bash
cd [repo-path]

if [ -f "poetry.lock" ]; then
  poetry install
elif [ -f "requirements.txt" ]; then
  pip install -r requirements.txt
fi

cd ..
```

**For each detected repo**, run appropriate install.

### Step 2: Verify Installations

**Check for successful install**:
```bash
# Node.js
ls node_modules/  # Should be populated

# Python
python3 -c "import flask" 2>/dev/null && echo "✓ Dependencies installed"
```

### Step 3: Report Status

```
✅ Dependency Installation Complete

📦 Backend (Node.js):
   ✓ Installed 247 packages (npm)

📦 Frontend (Node.js):
   ✓ Installed 189 packages (npm)

📦 Shared (TypeScript):
   ✓ Installed 12 packages (npm)
```

---

## Example

**Multi-repo project**:
```bash
cd backend && npm install && cd ..
cd frontend && npm install && cd ..
cd shared-types && npm install && cd ..
```

**Monorepo**:
```bash
npm install  # Installs all workspaces
```

---

**🕵️ MI6 Dependency Installation Dossier**
