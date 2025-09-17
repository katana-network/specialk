import { existsSync, mkdirSync, readFileSync, writeFileSync, readSync as fsReadSync } from "fs";
import { readdir, writeFile } from "fs/promises";
import { join, dirname } from "path";
import { homedir } from "os";
import { randomUUID } from "crypto";
import { spawn } from "child_process";

type Consent = "yes" | "no" | "unset";

interface PhonehomeConfig {
  consent: Consent;
  repoId: string;
  deviceId: string;
}

const repoRoot = process.cwd();
const phonehomeDir = join(repoRoot, ".phonehome");
const queueDir = join(phonehomeDir, "queue");
const configFile = join(phonehomeDir, "config.json");
const deviceDir = join(homedir(), ".katana-phonehome");
const deviceFile = join(deviceDir, "device-id");

const envForceOn = process.env.KATANA_PHONEHOME === "1";
const envForceOff = process.env.KATANA_PHONEHOME === "0" || process.env.CI === "true" || process.env.GITHUB_ACTIONS === "true" || process.env.DO_NOT_TRACK === "1";

function ensureDir(path: string) {
  try { mkdirSync(path, { recursive: true }); } catch {}
}

function readJson<T>(path: string): T | null {
  try { return JSON.parse(readFileSync(path, "utf8")) as T; } catch { return null; }
}

function writeJson(path: string, data: unknown) {
  try {
    ensureDir(dirname(path));
    writeFileSync(path, JSON.stringify(data, null, 2) + "\n", "utf8");
  } catch {}
}

function loadOrCreateDeviceId(): string {
  try {
    if (existsSync(deviceFile)) return readFileSync(deviceFile, "utf8").trim();
  } catch {}
  const id = randomUUID();
  try {
    ensureDir(deviceDir);
    writeFileSync(deviceFile, id + "\n", "utf8");
  } catch {}
  return id;
}

function loadOrCreateConfig(): PhonehomeConfig {
  const existing = readJson<PhonehomeConfig>(configFile);
  if (existing && existing.repoId && existing.deviceId && existing.consent) return existing;
  const cfg: PhonehomeConfig = {
    consent: existing?.consent ?? "unset",
    repoId: existing?.repoId ?? randomUUID(),
    deviceId: existing?.deviceId ?? loadOrCreateDeviceId(),
  };
  writeJson(configFile, cfg);
  return cfg;
}

function promptForConsent(): Consent {
  if (!process.stdin.isTTY) return "no";
  const msg = "Help improve Katana Starter Kit by sending anonymous usage (event name, version, OS). [y/N]: ";
  process.stdout.write(msg);
  try {
    const buf = Buffer.alloc(1);
    const n = fsReadSync(0, buf, 0, 1, null);
    const ch = String.fromCharCode(buf[0] ?? 110).toLowerCase();
    return ch === "y" ? "yes" : "no";
  } catch {
    return "no";
  }
}

function getPkgVersion(): string {
  try { return JSON.parse(readFileSync(join(repoRoot, "package.json"), "utf8")).version ?? "0.0.0"; } catch { return "0.0.0"; }
}

function tryParseJson<T = any>(txt: string): T | null {
  try { return JSON.parse(txt) as T; } catch { return null; }
}

function parseKeyValueList(txt: string): Record<string, string> {
  const out: Record<string, string> = {};
  for (const part of txt.split(/[;,]/)) {
    const p = part.trim();
    if (!p) continue;
    const eq = p.indexOf("=");
    if (eq === -1) continue;
    const k = p.slice(0, eq).trim();
    const v = p.slice(eq + 1).trim();
    if (k) out[k] = v;
  }
  return out;
}

function parseMetaFromArgs(argv: string[]): Record<string, string> {
  const meta: Record<string, string> = {};
  for (let i = 0; i < argv.length; i++) {
    if (argv[i] === "--meta") {
      const val = argv[i + 1] || "";
      const eq = val.indexOf("=");
      if (eq !== -1) {
        const k = val.slice(0, eq).trim();
        const v = val.slice(eq + 1).trim();
        if (k) meta[k] = v;
      }
      i++;
    }
  }
  return meta;
}

function parseMetaFromEnv(): Record<string, string> {
  const env = process.env.PHONEHOME_META;
  if (!env) return {};
  const asJson = tryParseJson<Record<string, string>>(env);
  if (asJson && typeof asJson === "object") return asJson;
  return parseKeyValueList(env);
}

async function maybeSpawnFlusher() {
  try {
    const files = await readdir(queueDir);
    const shouldFlush = files.length >= 20 || Math.random() < 0.05;
    if (!shouldFlush) return;
    const child = spawn("bun", ["utils/phonehome_flush.ts"], { stdio: "ignore", cwd: repoRoot, detached: true });
    child.unref();
  } catch {}
}

function shouldTrack(consent: Consent): boolean {
  if (envForceOff) return false;
  if (envForceOn) return true;
  return consent === "yes";
}

async function main() {
  // parse --event <name>
  const idx = process.argv.indexOf("--event");
  const eventName = idx >= 0 ? (process.argv[idx + 1] || "") : "";
  if (!eventName) return; // nothing to do

  ensureDir(phonehomeDir);
  ensureDir(queueDir);

  const cfg = loadOrCreateConfig();

  // Resolve consent if unset
  if (cfg.consent === "unset" && !envForceOff && !envForceOn) {
    const answer = promptForConsent();
    cfg.consent = answer;
    writeJson(configFile, cfg);
  }

  if (!shouldTrack(cfg.consent)) return;

  // Build metadata (centralized; pre-scripts can enrich via env or argv)
  const meta: Record<string, any> = {
    ...parseMetaFromEnv(),
    ...parseMetaFromArgs(process.argv.slice(2)),
  };

  const payload = {
    event: eventName,
    repoId: cfg.repoId,
    deviceId: cfg.deviceId,
    version: getPkgVersion(),
    env: {
      os: process.platform,
      arch: process.arch,
      bunVersion: (process as any).versions?.bun || null,
      ci: Boolean(process.env.CI || process.env.GITHUB_ACTIONS)
    },
    ts: new Date().toISOString(),
    meta,
  };

  // Write event to queue; do not await network
  const fname = `${Date.now()}-${Math.random().toString(36).slice(2)}.json`;
  try {
    await writeFile(join(queueDir, fname), JSON.stringify(payload) + "\n", "utf8");
  } catch {}

  // Fire-and-forget flusher
  maybeSpawnFlusher();
}

main().catch(() => {});


