import { readdir, readFile, rm } from "fs/promises";
import { existsSync } from "fs";
import { join } from "path";

const repoRoot = process.cwd();
const queueDir = join(repoRoot, ".phonehome", "queue");
const endpoint = process.env.PHONEHOME_ENDPOINT || "https://n8n.srv1000968.hstgr.cloud/webhook-test/3c90ca24-04d9-48bf-b8a3-de0157f61c27";
const debug = process.env.PHONEHOME_DEBUG === "1" || process.argv.includes("--debug");

function log(...args: any[]) {
  if (debug) console.log("[phonehome:flush]", ...args);
}

async function flushOnce() {
  log("cwd=", repoRoot);
  log("queueDir=", queueDir);
  if (!existsSync(queueDir)) {
    log("queueDir does not exist, nothing to flush");
    return;
  }
  let files: string[] = [];
  try {
    files = (await readdir(queueDir)).filter(f => f.endsWith(".json"));
  } catch (e) {
    log("failed to read queueDir:", (e as Error).message);
    return;
  }
  log("found", files.length, "queued files");
  if (!files.length) return;

  const batch = [] as any[];
  const used: string[] = [];
  for (const f of files.slice(0, 500)) {
    try {
      const txt = await readFile(join(queueDir, f), "utf8");
      batch.push(JSON.parse(txt));
      used.push(f);
    } catch (e) {
      log("failed to read/parse", f, ":", (e as Error).message);
    }
  }
  log("prepared batch size=", batch.length);
  if (!batch.length) {
    log("no valid events to send");
    return;
  }

  const controller = new AbortController();
  const to = setTimeout(() => controller.abort(), 800);
  try {
    log("posting to", endpoint);
    const res = await fetch(endpoint, {
      method: "POST",
      headers: { "content-type": "application/json" },
      body: JSON.stringify({ events: batch }),
      keepalive: true,
      signal: controller.signal,
    });
    clearTimeout(to);
    log("response status=", res.status);
    if (res.ok) {
      log("deleting", used.length, "flushed files");
      await Promise.all(used.map(f => rm(join(queueDir, f), { force: true })));
      log("flush complete");
    } else {
      const text = await res.text().catch(() => "");
      log("server error:", res.status, text.slice(0, 200));
    }
  } catch (e) {
    log("fetch failed:", (e as Error).name, (e as Error).message);
    // Leave files for next attempt
  }
}

flushOnce().catch((e) => {
  if (debug) console.log("[phonehome:flush] unhandled error:", (e as Error).message);
});


