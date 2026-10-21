#!/usr/bin/env python3
"""Check that a relayed reply carries a subagent report unchanged.

Usage: relay-check.py <report> <reply>
Exit 0 when the reply starts with the report (byte-identical apart from
trailing whitespace per line and leading/trailing blank lines) and anything
after it begins with a separator line (---). Prints the first mismatch otherwise.
"""
import sys


def lines(path):
    with open(path, encoding="utf-8") as f:
        out = [l.rstrip() for l in f.read().splitlines()]
    while out and not out[0]:
        out.pop(0)
    while out and not out[-1]:
        out.pop()
    return out


report, reply = lines(sys.argv[1]), lines(sys.argv[2])
for i, want in enumerate(report):
    got = reply[i] if i < len(reply) else "<end of reply>"
    if got != want:
        print(f"FAIL: line {i + 1} differs\n  report: {want!r}\n  reply:  {got!r}")
        sys.exit(1)
rest = [l for l in reply[len(report):] if l]
if rest and rest[0] != "---":
    print(f"FAIL: text after the report without a separator: {rest[0]!r}")
    sys.exit(1)
print("OK: report relayed unchanged")
