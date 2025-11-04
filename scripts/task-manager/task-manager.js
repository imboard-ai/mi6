#!/usr/bin/env node

/**
 * task-manager.js - MI6 Task Lifecycle Management
 *
 * Manages task transitions between planned → active → stashed → completed
 * Automatically commits changes to git for version control
 *
 * Usage:
 *   node task-manager.js start <task-name>
 *   node task-manager.js pause <task-name>
 *   node task-manager.js resume <task-name>
 *   node task-manager.js complete <task-name>
 *   node task-manager.js list
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

// ================================
// Configuration
// ================================

const CONFIG = {
  taskFolders: {
    planned: 'tasks/planned',
    active: 'tasks/active',
    stashed: 'tasks/stashed',
    completed: 'tasks/completed'
  },
  autoCommit: true,
  verbose: true
};

// Load config from .ai-project.json if exists
function loadConfig() {
  const configPath = path.join(process.cwd(), '.ai-project.json');
  if (fs.existsSync(configPath)) {
    try {
      const projectConfig = JSON.parse(fs.readFileSync(configPath, 'utf8'));
      if (projectConfig.taskManagement?.taskFolders) {
        Object.assign(CONFIG.taskFolders, projectConfig.taskManagement.taskFolders);
      }
      if (projectConfig.taskManagement?.autoCommit !== undefined) {
        CONFIG.autoCommit = projectConfig.taskManagement.autoCommit;
      }
    } catch (error) {
      console.warn('⚠️  Warning: Could not parse .ai-project.json');
    }
  }
}

// ================================
// Utility Functions
// ================================

function log(message, level = 'info') {
  const icons = {
    info: 'ℹ️ ',
    success: '✅',
    error: '❌',
    warning: '⚠️ '
  };
  const icon = icons[level] || '';
  console.log(`${icon} ${message}`);
}

function execCommand(command, options = {}) {
  try {
    return execSync(command, { encoding: 'utf8', stdio: options.silent ? 'pipe' : 'inherit', ...options });
  } catch (error) {
    if (!options.silent) {
      log(`Command failed: ${command}`, 'error');
    }
    throw error;
  }
}

function ensureDirectoryExists(dirPath) {
  if (!fs.existsSync(dirPath)) {
    fs.mkdirSync(dirPath, { recursive: true });
    log(`Created directory: ${dirPath}`);
  }
}

function getCurrentYear() {
  return new Date().getFullYear().toString();
}

// ================================
// Task File Operations
// ================================

function findTaskFiles(directory) {
  if (!fs.existsSync(directory)) {
    return [];
  }

  const files = fs.readdirSync(directory);
  return files
    .filter(file => file.endsWith('.md') && file !== 'README.md')
    .map(file => ({
      name: file,
      nameWithoutExt: path.basename(file, '.md'),
      path: path.join(directory, file),
      fullPath: path.resolve(directory, file)
    }));
}

function findTaskByPartialName(taskName, directory) {
  const tasks = findTaskFiles(directory);
  const nameUpper = taskName.toUpperCase().replace(/\.md$/i, '');

  // Try exact match first
  let matches = tasks.filter(t => t.nameWithoutExt === nameUpper);
  if (matches.length === 1) return matches[0];

  // Try partial match
  matches = tasks.filter(t => t.nameWithoutExt.includes(nameUpper));
  if (matches.length === 0) {
    return null;
  } else if (matches.length === 1) {
    return matches[0];
  } else {
    log('Multiple tasks match. Please be more specific:', 'warning');
    matches.forEach(t => log(`  - ${t.name}`));
    process.exit(1);
  }
}

function moveTask(fromDir, toDir, taskName) {
  const task = findTaskByPartialName(taskName, fromDir);

  if (!task) {
    log(`Task not found in ${fromDir}: ${taskName}`, 'error');
    log(`\nAvailable tasks:`, 'info');
    const tasks = findTaskFiles(fromDir);
    if (tasks.length === 0) {
      log('  (none)');
    } else {
      tasks.forEach(t => log(`  - ${t.nameWithoutExt}`));
    }
    process.exit(1);
  }

  ensureDirectoryExists(toDir);

  const destPath = path.join(toDir, task.name);

  if (fs.existsSync(destPath)) {
    log(`Task already exists in ${toDir}: ${task.name}`, 'error');
    process.exit(1);
  }

  fs.renameSync(task.path, destPath);
  log(`Moved: ${task.name}`);
  log(`  From: ${fromDir}`);
  log(`  To:   ${toDir}`);

  return {
    taskName: task.name,
    fromPath: task.path,
    toPath: destPath
  };
}

// ================================
// Git Operations
// ================================

function isGitRepo() {
  try {
    execCommand('git rev-parse --git-dir', { silent: true });
    return true;
  } catch {
    return false;
  }
}

function gitCommit(message) {
  if (!CONFIG.autoCommit) {
    log('Auto-commit disabled, skipping git commit', 'warning');
    return;
  }

  if (!isGitRepo()) {
    log('Not a git repository, skipping commit', 'warning');
    return;
  }

  try {
    execCommand('git add .', { silent: true });
    execCommand(`git commit -m "${message}"`, { silent: false });
    log('Changes committed to git', 'success');
  } catch (error) {
    log('Git commit failed (this is okay if no changes to commit)', 'warning');
  }
}

// ================================
// Task Lifecycle Commands
// ================================

function startTask(taskName) {
  log(`🚀 Starting task: ${taskName}`);
  log('');

  const result = moveTask(
    CONFIG.taskFolders.planned,
    CONFIG.taskFolders.active,
    taskName
  );

  log('');
  log('Task is now active and visible to AI assistants', 'success');

  gitCommit(`Start task: ${result.taskName}\n\nMoved from planned to active\n\n🕵️  MI6 Task Manager`);
}

function pauseTask(taskName) {
  log(`⏸️  Pausing task: ${taskName}`);
  log('');

  const result = moveTask(
    CONFIG.taskFolders.active,
    CONFIG.taskFolders.stashed,
    taskName
  );

  log('');
  log('Task is now stashed and hidden from AI assistants', 'success');

  gitCommit(`Pause task: ${result.taskName}\n\nMoved from active to stashed\n\n🕵️  MI6 Task Manager`);
}

function resumeTask(taskName) {
  log(`▶️  Resuming task: ${taskName}`);
  log('');

  const result = moveTask(
    CONFIG.taskFolders.stashed,
    CONFIG.taskFolders.active,
    taskName
  );

  log('');
  log('Task is now active again and visible to AI assistants', 'success');

  gitCommit(`Resume task: ${result.taskName}\n\nMoved from stashed to active\n\n🕵️  MI6 Task Manager`);
}

function completeTask(taskName) {
  log(`🎉 Completing task: ${taskName}`);
  log('');

  const year = getCurrentYear();
  const completedDir = path.join(CONFIG.taskFolders.completed, year);

  const result = moveTask(
    CONFIG.taskFolders.active,
    completedDir,
    taskName
  );

  log('');
  log(`Task archived to ${year}/ and hidden from AI assistants`, 'success');

  gitCommit(`Complete task: ${result.taskName}\n\nArchived to completed/${year}/\n\n🕵️  MI6 Task Manager`);
}

function listTasks() {
  log('📋 MI6 Task Status');
  log('='.repeat(50));
  log('');

  const folders = [
    { name: 'PLANNED', path: CONFIG.taskFolders.planned, emoji: '📝' },
    { name: 'ACTIVE', path: CONFIG.taskFolders.active, emoji: '🚀' },
    { name: 'STASHED', path: CONFIG.taskFolders.stashed, emoji: '⏸️ ' },
    { name: 'COMPLETED', path: CONFIG.taskFolders.completed, emoji: '✅' }
  ];

  folders.forEach(folder => {
    const tasks = findTaskFiles(folder.path);
    log(`${folder.emoji} ${folder.name} (${tasks.length})`);

    if (tasks.length === 0) {
      log('  (none)');
    } else {
      tasks.forEach(task => {
        log(`  - ${task.nameWithoutExt}`);
      });
    }
    log('');
  });

  // Show completed tasks by year
  if (fs.existsSync(CONFIG.taskFolders.completed)) {
    const years = fs.readdirSync(CONFIG.taskFolders.completed)
      .filter(item => {
        const fullPath = path.join(CONFIG.taskFolders.completed, item);
        return fs.statSync(fullPath).isDirectory();
      })
      .sort()
      .reverse();

    if (years.length > 0) {
      log('📅 COMPLETED BY YEAR');
      years.forEach(year => {
        const yearPath = path.join(CONFIG.taskFolders.completed, year);
        const tasks = findTaskFiles(yearPath);
        log(`  ${year}: ${tasks.length} task(s)`);
      });
      log('');
    }
  }
}

// ================================
// CLI Interface
// ================================

function showUsage() {
  console.log(`
🕵️  MI6 Task Manager

Usage:
  node task-manager.js <command> [task-name]

Commands:
  start <task-name>     Start a planned task (planned → active)
  pause <task-name>     Pause an active task (active → stashed)
  resume <task-name>    Resume a stashed task (stashed → active)
  complete <task-name>  Complete an active task (active → completed/YYYY/)
  list                  List all tasks by status

Examples:
  node task-manager.js start DASHBOARD_REDESIGN
  node task-manager.js pause AUTH_SYSTEM
  node task-manager.js resume DASHBOARD_REDESIGN
  node task-manager.js complete DASHBOARD_REDESIGN
  node task-manager.js list

Notes:
  - Task names are case-insensitive
  - Partial names work if unambiguous (e.g., "DASH" for "DASHBOARD_REDESIGN")
  - Changes are automatically committed to git (if in a git repo)
  - Completed tasks are archived by year

Configuration:
  Edit task folder paths in .ai-project.json:
  {
    "taskManagement": {
      "taskFolders": {
        "planned": "tasks/planned",
        "active": "tasks/active",
        "stashed": "tasks/stashed",
        "completed": "tasks/completed"
      },
      "autoCommit": true
    }
  }
`);
}

function main() {
  loadConfig();

  const args = process.argv.slice(2);
  const command = args[0];
  const taskName = args[1];

  if (!command || command === 'help' || command === '--help' || command === '-h') {
    showUsage();
    process.exit(0);
  }

  try {
    switch (command) {
      case 'start':
        if (!taskName) {
          log('Error: Task name required', 'error');
          log('Usage: node task-manager.js start <task-name>');
          process.exit(1);
        }
        startTask(taskName);
        break;

      case 'pause':
        if (!taskName) {
          log('Error: Task name required', 'error');
          log('Usage: node task-manager.js pause <task-name>');
          process.exit(1);
        }
        pauseTask(taskName);
        break;

      case 'resume':
        if (!taskName) {
          log('Error: Task name required', 'error');
          log('Usage: node task-manager.js resume <task-name>');
          process.exit(1);
        }
        resumeTask(taskName);
        break;

      case 'complete':
        if (!taskName) {
          log('Error: Task name required', 'error');
          log('Usage: node task-manager.js complete <task-name>');
          process.exit(1);
        }
        completeTask(taskName);
        break;

      case 'list':
      case 'ls':
        listTasks();
        break;

      default:
        log(`Unknown command: ${command}`, 'error');
        log('Run "node task-manager.js help" for usage');
        process.exit(1);
    }
  } catch (error) {
    log(`\nFatal error: ${error.message}`, 'error');
    if (CONFIG.verbose) {
      console.error(error);
    }
    process.exit(1);
  }
}

// Run if called directly
if (require.main === module) {
  main();
}

module.exports = {
  startTask,
  pauseTask,
  resumeTask,
  completeTask,
  listTasks,
  findTaskByPartialName,
  moveTask
};
