#!/usr/bin/env bash
# Build a deterministic fixture git repo for testing the stack-code-review skill.
#
# Usage: make-local-repo.sh <dir> [--no-origin] [--from-main] [--uncommitted]
#                                 [--state feature|detached|on-base]
#                                 [--stack gcp|angular|express|mixed]
# Prints the absolute fixture path on stdout (last line). Works on bash 3.2.
#
# History (default):
#   main     : m1
#   develop  : m1 -> d1 (adds docs/order spec.md) -> d2 (touches unrelated.ts, AFTER the branch point)
#   feature/orders-pubsub (from develop at d1): f1 add handler, f2 package.json, f3 delete legacy.ts
# With --from-main the feature branches from main (m1) instead; origin/HEAD points to origin/develop
# (so main can only win base detection via the tie-break on HEAD..<base>).
# --stack (default gcp = the history above, unchanged):
#   angular : main has web/package.json (Angular 18 + karma); feature adds web/src/app/orders.component.ts
#   express : main has a root package.json (express); feature adds src/routes.js
#   mixed   : gcp skeleton + web/package.json on main; feature = the 3 gcp commits + the angular commit
# Same main -> develop -> feature layout, d1 spec, d2 on develop touching the "unrelated" file
# (functions/src/unrelated.ts for gcp/mixed, src/unrelated.js for express, web/src/unrelated.ts for angular).
# Note: --uncommitted modifies onOrderCreated.ts; with --state on-base (file absent) it modifies unrelated.ts instead.
set -euo pipefail

usage() { echo "usage: $0 <dir> [--no-origin] [--from-main] [--uncommitted] [--state feature|detached|on-base] [--stack gcp|angular|express|mixed]" >&2; exit 2; }

[ $# -ge 1 ] || usage
DIR="$1"; shift
NO_ORIGIN=0; FROM_MAIN=0; UNCOMMITTED=0; STATE=feature; STACK=gcp
while [ $# -gt 0 ]; do
  case "$1" in
    --no-origin) NO_ORIGIN=1 ;;
    --from-main) FROM_MAIN=1 ;;
    --uncommitted) UNCOMMITTED=1 ;;
    --state) shift; [ $# -ge 1 ] || usage; STATE="$1" ;;
    --stack) shift; [ $# -ge 1 ] || usage; STACK="$1" ;;
    *) usage ;;
  esac
  shift
done
case "$STATE" in feature|detached|on-base) ;; *) usage ;; esac
case "$STACK" in gcp|angular|express|mixed) ;; *) usage ;; esac
case "$STACK" in
  gcp|mixed) UNREL="functions/src/unrelated.ts" ;;
  angular)   UNREL="web/src/unrelated.ts" ;;
  express)   UNREL="src/unrelated.js" ;;
esac

case "$DIR" in /*) ;; *) DIR="$PWD/$DIR" ;; esac
DIR="${DIR%/}"
ORIGIN="$DIR.origin.git"

if [ -e "$DIR" ] && [ -n "$(ls -A "$DIR" 2>/dev/null || echo x)" ]; then
  echo "refusing: $DIR exists and is not empty" >&2; exit 1
fi
if [ "$NO_ORIGIN" -eq 0 ] && [ -e "$ORIGIN" ]; then
  echo "refusing: $ORIGIN already exists" >&2; exit 1
fi
mkdir -p "$DIR"

# Deterministic identity; ignore the user's git config (signing, hooks, templates).
export GIT_AUTHOR_NAME="Fixture Author" GIT_AUTHOR_EMAIL="fixture@example.com"
export GIT_COMMITTER_NAME="Fixture Author" GIT_COMMITTER_EMAIL="fixture@example.com"
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null GIT_CONFIG_NOSYSTEM=1
G() { git -C "$DIR" -c commit.gpgsign=false -c core.hooksPath=/dev/null "$@"; }

n=0
commit() { # commit <message>
  n=$((n + 1))
  local d; d=$(printf '2026-01-%02dT12:00:00+0000' "$n")
  GIT_AUTHOR_DATE="$d" GIT_COMMITTER_DATE="$d" G commit -q -m "$1"
}

git -c init.defaultBranch=main init -q "$DIR"

# ---- main: m1 ----
if [ "$STACK" = gcp ] || [ "$STACK" = mixed ]; then
mkdir -p "$DIR/functions/src"
cat > "$DIR/README.md" <<'EOT'
# orders-api
Cloud Functions backend for orders.
EOT
cat > "$DIR/functions/package.json" <<'EOT'
{
  "name": "functions",
  "main": "lib/index.js",
  "dependencies": {
    "firebase-admin": "^12.0.0",
    "firebase-functions": "^5.0.0"
  }
}
EOT
cat > "$DIR/functions/src/legacy.ts" <<'EOT'
export function legacyTotal(items: number[]): number {
  return items.reduce((a, b) => a + b, 0);
}
EOT
cat > "$DIR/functions/src/unrelated.ts" <<'EOT'
export const VERSION = "1.0.0";
EOT
fi
if [ "$STACK" = angular ] || [ "$STACK" = mixed ]; then
  mkdir -p "$DIR/web/src/app"
  cat > "$DIR/web/package.json" <<'EOT'
{
  "name": "web",
  "dependencies": {
    "@angular/core": "^18.0.0",
    "@angular/common": "^18.0.0",
    "rxjs": "~7.8.0"
  },
  "devDependencies": {
    "karma": "~6.4.0",
    "jasmine-core": "~5.1.0"
  }
}
EOT
  [ "$STACK" = angular ] && printf '%s\n' '# orders-web' 'Angular frontend for orders.' > "$DIR/README.md"
  [ "$STACK" = angular ] && printf 'export const VERSION = "1.0.0";\n' > "$DIR/web/src/unrelated.ts"
fi
if [ "$STACK" = express ]; then
  mkdir -p "$DIR/src"
  printf '%s\n' '# orders-api' 'Express backend for orders.' > "$DIR/README.md"
  cat > "$DIR/package.json" <<'EOT'
{
  "name": "orders-api",
  "main": "src/routes.js",
  "dependencies": {
    "express": "^4.19.0"
  }
}
EOT
  printf 'exports.VERSION = "1.0.0";\n' > "$DIR/src/unrelated.js"
fi
G add -A
commit "chore: initial functions skeleton"

G branch develop

if [ "$FROM_MAIN" -eq 1 ]; then
  # feature branches from main; develop gets its own commits on the side
  G checkout -q -b feature/orders-pubsub
  G checkout -q develop
fi

# ---- develop: d1 (spec, before the feature branch point) ----
G checkout -q develop
mkdir -p "$DIR/docs"
cat > "$DIR/docs/order spec.md" <<'EOT'
# ORD-1: Process order-created events

Orders published to the `orders` Pub/Sub topic must be persisted in Firestore.

## Acceptance criteria
1. A valid order event creates a document in the `orders` collection.
2. A malformed order event is rejected and surfaced as an error (not silently dropped).
3. Processing the same order event twice must not create a second Firestore document (idempotent by orderId).
EOT
G add -A
commit "docs: add ORD-1 order spec"

if [ "$FROM_MAIN" -eq 0 ]; then
  G checkout -q -b feature/orders-pubsub
fi

# ---- feature: f1..f3 ----
G checkout -q feature/orders-pubsub
if [ "$STACK" = gcp ] || [ "$STACK" = mixed ]; then
cat > "$DIR/functions/src/onOrderCreated.ts" <<'EOT'
import { onMessagePublished } from "firebase-functions/v2/pubsub";
import { getFirestore } from "firebase-admin/firestore";

export const onOrderCreated = onMessagePublished("orders", async (event) => {
  const order = event.data.message.json;
  try {
    await getFirestore().collection("orders").add({
      ...order,
      receivedAt: Date.now(),
    });
  } catch {}
});
EOT
G add -A
commit "feat: add onOrderCreated Pub/Sub handler"

cat > "$DIR/functions/package.json" <<'EOT'
{
  "name": "functions",
  "main": "lib/index.js",
  "dependencies": {
    "firebase-admin": "^12.0.0",
    "firebase-functions": "^5.0.0",
    "zod": "^3.23.0"
  }
}
EOT
G add -A
commit "chore: add zod dependency"

G rm -q functions/src/legacy.ts
commit "refactor: remove legacy total helper"
fi

if [ "$STACK" = angular ] || [ "$STACK" = mixed ]; then
  cat > "$DIR/web/src/app/orders.component.ts" <<'EOT'
import { Component, OnInit } from "@angular/core";
import { OrdersService } from "./orders.service";

@Component({
  selector: "app-orders",
  template: `<p>Total: {{ total() }}</p>`,
})
export class OrdersComponent implements OnInit {
  items: { amount: number }[] = [];

  constructor(private svc: OrdersService) {}

  ngOnInit(): void {
    this.svc.orders$.subscribe((orders) => {
      this.items = orders;
    });
  }

  total(): number {
    return this.items.reduce((sum, i) => sum + i.amount, 0);
  }
}
EOT
  G add -A
  commit "feat: add orders component"
fi

if [ "$STACK" = express ]; then
  cat > "$DIR/src/routes.js" <<'EOT'
const express = require("express");
const app = express();
app.use(express.json());

app.post("/orders", async (req, res) => {
  try {
    const amount = req.body.amount;
    await saveOrder({ amount, createdAt: Date.now() });
    res.status(201).json({ ok: true, amount });
  } catch (e) {}
});

module.exports = app;
EOT
  G add -A
  commit "feat: add orders route"
fi

# ---- develop: d2 (leak check, after the branch point) ----
G checkout -q develop
mkdir -p "$DIR/$(dirname "$UNREL")"
cat > "$DIR/$UNREL" <<'EOT'
export const VERSION = "1.1.0";
export const BUILD = "develop-only";
EOT
G add -A
commit "chore: bump unrelated version on develop"

# ---- origin ----
if [ "$NO_ORIGIN" -eq 0 ]; then
  git -c init.defaultBranch=main init -q --bare "$ORIGIN"
  G remote add origin "$ORIGIN"
  G push -q origin main develop feature/orders-pubsub
  G fetch -q origin
  if [ "$FROM_MAIN" -eq 1 ]; then G remote set-head origin develop; else G remote set-head origin main; fi
fi

# ---- final state ----
case "$STATE" in
  feature)  G checkout -q feature/orders-pubsub ;;
  detached) G checkout -q feature/orders-pubsub; G checkout -q --detach HEAD~1 ;;
  on-base)  G checkout -q develop ;;
esac

if [ "$UNCOMMITTED" -eq 1 ]; then
  if [ -f "$DIR/functions/src/onOrderCreated.ts" ]; then
    echo "// TODO: wip, not committed" >> "$DIR/functions/src/onOrderCreated.ts"
  else
    echo "// wip, not committed" >> "$DIR/$UNREL"
  fi
fi

echo "$DIR"
