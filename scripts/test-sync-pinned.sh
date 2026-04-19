#!/usr/bin/env bash
# scripts/test-sync-pinned.sh
#
# Deterministic test: runs sync-pinned.sh against the fixture and diffs
# the resulting README against the golden expected file.

set -euo pipefail

cd "$(dirname "$0")/.."

# Work in a temp dir so we don't touch the real README.
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

cp scripts/fixtures/readme-before.md "$tmp_dir/README.md"

# Pin "now" so the status logic is deterministic regardless of when
# the test runs. We do this by faketime if available, otherwise we
# warn and continue (the fixture dates are far enough apart that
# boundaries are only crossed quarterly).
if command -v faketime >/dev/null 2>&1; then
  FAKE_CMD=(faketime '2026-04-16 12:00:00')
else
  echo "warning: faketime not installed; using real system clock" >&2
  FAKE_CMD=()
fi

PINNED_FIXTURE="$(pwd)/scripts/fixtures/pinned-sample.json" \
README_PATH="$tmp_dir/README.md" \
  "${FAKE_CMD[@]}" bash scripts/sync-pinned.sh

if diff -u scripts/fixtures/pinned-expected.md "$tmp_dir/README.md"; then
  echo "PASS: sync-pinned.sh output matches golden file."
else
  echo "FAIL: output differs from golden file." >&2
  exit 1
fi
