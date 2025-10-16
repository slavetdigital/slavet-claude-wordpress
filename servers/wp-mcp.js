// Minimal MCP-like server (naive), wraps local CLIs: wp, theme-check, phpcs.
// NOTE: This is a lightweight stub for local use; production MCP may differ.
const { spawn } = require('child_process');
const readline = require('readline');

function run(cmd, args, opts={}) {
  return new Promise((resolve) => {
    const p = spawn(cmd, args, { shell: true, ...opts });
    let out = '', err = '';
    p.stdout.on('data', d => out += d.toString());
    p.stderr.on('data', d => err += d.toString());
    p.on('close', code => resolve({ code, out, err }));
  });
}

async function handle(req) {
  const { tool, args=[] } = req;

  if (tool === 'wp-validate-theme') {
    // e.g., args = ['theme', 'validate']
    const res = await run('wp', args, {});
    return { ok: true, code: res.code, stdout: res.out, stderr: res.err };
  }

  if (tool === 'theme-check') {
    const res = await run('theme-check', ['.', '--format', 'json'], {});
    return { ok: true, code: res.code, stdout: res.out, stderr: res.err };
  }

  if (tool === 'phpcs') {
    const res = await run('phpcs', ['-q', '--report=json', '.'], {});
    return { ok: true, code: res.code, stdout: res.out, stderr: res.err };
  }

  return { ok: false, error: 'Unknown tool' };
}

// Simple line-based JSON protocol: one JSON request per line → JSON response per line.
const rl = readline.createInterface({ input: process.stdin, output: process.stdout, terminal: false });
rl.on('line', async (line) => {
  try {
    const req = JSON.parse(line);
    const resp = await handle(req);
    process.stdout.write(JSON.stringify(resp) + "\n");
  } catch (e) {
    process.stdout.write(JSON.stringify({ ok:false, error: e.message }) + "\n");
  }
});
