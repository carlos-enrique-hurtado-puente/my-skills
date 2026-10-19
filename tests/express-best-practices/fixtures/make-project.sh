#!/usr/bin/env bash
# Build a small Express project fixture for the express-best-practices scenarios.
#
# Usage: make-project.sh <dir> <profile>
# Profiles:
#   v5-api          express ^5.1.0, src/app.js + src/db.js
#   v4-api          express ^4.19.0, same files
#   unknown-version express "latest", same files
#   mono            apps/api4 (express ^4.19.0) and apps/api5 (^5.0.0)
#   hardening-v4    express ^4.19.0 + express-session, one server.js with bad patterns
# Prints the absolute fixture path on stdout (last line). Bash 3.2; no git, no network.
set -euo pipefail

usage() { echo "usage: $0 <dir> <v5-api|v4-api|unknown-version|mono|hardening-v4>" >&2; exit 2; }
[ $# -eq 2 ] || usage
DIR="$1"; PROFILE="$2"
case "$PROFILE" in v5-api|v4-api|unknown-version|mono|hardening-v4) ;; *) usage ;; esac
case "$DIR" in /*) ;; *) DIR="$PWD/$DIR" ;; esac
DIR="${DIR%/}"
if [ -e "$DIR" ] && [ -n "$(ls -A "$DIR" 2>/dev/null || echo x)" ]; then
  echo "refusing: $DIR exists and is not empty" >&2; exit 1
fi

# write_api <dir> <express-range> <package-name>: package.json, src/app.js, src/db.js
write_api() {
  local d="$1" range="$2" name="$3"
  mkdir -p "$d/src"
  cat > "$d/package.json" <<EOT
{
  "name": "$name",
  "version": "1.0.0",
  "private": true,
  "main": "src/app.js",
  "scripts": {
    "start": "node src/app.js"
  },
  "dependencies": {
    "express": "$range"
  }
}
EOT
  cat > "$d/src/db.js" <<'EOT'
// In-memory stand-in for a real database client. Every call is async.
const users = new Map([
  ["1", { id: "1", name: "Ada", email: "ada@example.com" }],
  ["2", { id: "2", name: "Grace", email: "grace@example.com" }],
]);

async function findUserById(id) {
  return users.get(String(id)) || null;
}

async function ping() {
  return true;
}

module.exports = { findUserById, ping };
EOT
  cat > "$d/src/app.js" <<'EOT'
const express = require("express");

const app = express();
app.use(express.json());

app.get("/health", (req, res) => {
  res.json({ ok: true });
});

module.exports = app;

if (require.main === module) {
  app.listen(process.env.PORT || 3000);
}
EOT
}

mkdir -p "$DIR"
case "$PROFILE" in
  v5-api)          write_api "$DIR" "^5.1.0" "orders-api" ;;
  v4-api)          write_api "$DIR" "^4.19.0" "orders-api" ;;
  unknown-version) write_api "$DIR" "latest" "orders-api" ;;
  mono)
    cat > "$DIR/package.json" <<'EOT'
{
  "name": "orders-monorepo",
  "private": true,
  "workspaces": ["apps/*"]
}
EOT
    write_api "$DIR/apps/api4" "^4.19.0" "api4"
    write_api "$DIR/apps/api5" "^5.0.0" "api5"
    ;;
  hardening-v4)
    cat > "$DIR/package.json" <<'EOT'
{
  "name": "orders-api",
  "version": "1.0.0",
  "private": true,
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.19.0",
    "express-session": "^1.18.0"
  }
}
EOT
    cat > "$DIR/server.js" <<'EOT'
const express = require("express");
const session = require("express-session");

const app = express();

app.set("trust proxy", true);
app.use(express.json());
app.use(session({ secret: "keyboard cat", resave: false, saveUninitialized: true }));

const users = { 1: { id: 1, name: "Ada" } };

app.get("/users/:id", (req, res) => {
  const user = users[req.params.id];
  if (!user) return res.status(404).json({ error: "not found" });
  res.json(user);
});

app.post("/orders", (req, res) => {
  console.log("new order", req.body);
  res.status(201).json({ ok: true });
});

app.use(function (err, req, res) {
  console.log(err);
  res.status(500).send("error");
});

process.on("uncaughtException", (err) => {
  console.log("uncaught", err);
});

app.listen(3000, () => console.log("listening on 3000"));
EOT
    ;;
esac

echo "$DIR"
