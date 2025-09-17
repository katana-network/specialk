#!/usr/bin/env node

import { existsSync, mkdirSync, readdirSync, statSync, rmSync, copyFileSync, readSync as fsReadSync } from 'node:fs';
import { join } from 'node:path';
import { execSync } from 'node:child_process';

const repoRoot = process.cwd();
const srcDir = join(repoRoot, 'src');
const examplesDir = join(repoRoot, 'examples');
const backupsDir = join(repoRoot, '.fork-backups');

function listExamples() {
  if (!existsSync(examplesDir)) return [];
  return readdirSync(examplesDir).filter(d => {
    try { return statSync(join(examplesDir, d)).isDirectory(); } catch { return false; }
  });
}

function usage(examples) {
  console.log('Usage: bun run fork <example> [--yes] [--no-build] [--list]');
  console.log('\nOptions:');
  console.log('  --yes        Proceed without interactive confirmation');
  console.log('  --no-build   Skip running "bun run build" after forking');
  console.log('  --list       List available examples and exit');
  if (examples.length) {
    console.log('\nAvailable examples:');
    for (const ex of examples) console.log(`  - ${ex}`);
  }
}

function ensureDir(path) {
  try { mkdirSync(path, { recursive: true }); } catch {}
}

function copyDirRecursive(src, dest) {
  ensureDir(dest);
  for (const entry of readdirSync(src)) {
    const srcPath = join(src, entry);
    const destPath = join(dest, entry);
    const st = statSync(srcPath);
    if (st.isDirectory()) {
      copyDirRecursive(srcPath, destPath);
    } else {
      ensureDir(join(destPath, '..'));
      copyFileSync(srcPath, destPath);
    }
  }
}

function clearDirContents(dir) {
  if (!existsSync(dir)) return;
  for (const entry of readdirSync(dir)) {
    const p = join(dir, entry);
    rmSync(p, { recursive: true, force: true });
  }
}

function promptYesNo(msg) {
  if (!process.stdin.isTTY) return false;
  process.stdout.write(msg);
  try {
    const buf = Buffer.alloc(1);
    const n = fsReadSync(0, buf, 0, 1, null);
    const ch = String.fromCharCode(buf[0] ?? 110).toLowerCase();
    return ch === 'y';
  } catch {
    return false;
  }
}

function main() {
  const args = process.argv.slice(2);
  const examples = listExamples();

  if (args.includes('--list')) {
    usage(examples);
    process.exit(0);
  }

  const exIdx = args.findIndex(a => a === '--example');
  const exampleFlag = exIdx >= 0 ? (args[exIdx + 1] || '') : '';
  const exampleArg = exampleFlag || args.find(a => !a.startsWith('-'));
  const yes = args.includes('--yes');
  const noBuild = args.includes('--no-build');

  if (!exampleArg) {
    console.error('Error: missing <example> argument.\n');
    usage(examples);
    process.exit(1);
  }

  const exampleName = exampleArg;
  const exampleDir = join(examplesDir, exampleName);
  if (!existsSync(exampleDir) || !statSync(exampleDir).isDirectory()) {
    console.error(`Error: example "${exampleName}" not found at ${exampleDir}`);
    console.error('\nUse "--list" to see available examples.');
    process.exit(1);
  }


  if (!yes) {
    const ok = promptYesNo(`This will replace contents of ./src with example "${exampleName}". Continue? [y/N]: `);
    if (!ok) {
      console.log('Aborted.');
      process.exit(1);
    }
  }

  const hasSrc = existsSync(srcDir) && statSync(srcDir).isDirectory();
  const stamp = new Date().toISOString().replace(/[:.]/g, '-');
  const backupDir = join(backupsDir, `src-${stamp}`);
  ensureDir(backupsDir);
  if (hasSrc) {
    console.log(`Backing up current src to ${backupDir}`);
    ensureDir(backupDir);
    copyDirRecursive(srcDir, backupDir);
  }

  console.log(`Forking example "${exampleName}" into ./src`);
  ensureDir(srcDir);
  clearDirContents(srcDir);
  copyDirRecursive(exampleDir, srcDir);

  if (!noBuild) {
    console.log('Building app (bun run build)...');
    try {
      execSync('bun run build', { stdio: 'inherit' });
      console.log('✅ Build complete.');
    } catch {
      console.error('❌ Build failed.');
      process.exit(1);
    }
  } else {
    console.log('Skipping build (--no-build specified).');
  }

  console.log('\nDone.');
  console.log(`- Example: ${exampleName}`);
  console.log(`- Backup: ${backupDir}`);
  console.log('- Next steps:');
  console.log('  bun run dev    # serves dist/ at http://localhost:8080');
  console.log('  bun run build  # rebuild if you change files');
}

main();