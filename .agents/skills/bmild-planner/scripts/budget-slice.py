#!/usr/bin/env python3
import json, os, re, sys
from pathlib import Path

DEFAULTS = {"target": 170000, "base": 15000, "multiplier": 1.25}
BRACKETS = {
    "small": {"max": 200, "read": 2500, "edit": 5000},
    "medium": {"max": 800, "read": 8000, "edit": 16000},
    "large": {"max": None, "read": 20000, "edit": 40000},
}
TIE_BREAK = {"small": 0, "medium": 1, "large": 2}
USAGE = """Usage: budget-slice.py [--target <tokens>] [--base <tokens>] [--multiplier <n>] [--reads <read-file>...] [--edits <edit-file>...] [--new <count> --src <dir>]

Estimate implementation-session context tokens for a set of files.
Read files are read-only context; edit files are existing files Alex will modify or extend.
New-file estimates use --new with --src to derive a representative bracket from nearby source files.

Brackets:
  small:  0-200 lines   read 2500   edit 5000
  medium: 201-800 lines read 8000   edit 16000
  large:  801+ lines    read 20000  edit 40000

Formula: (weighted_reads + weighted_edits) x multiplier + base
Fallbacks:
  missing/invalid --src -> skipped_new contains the path
  readable empty/unmeasurable --src -> skipped_new stays empty and new-file numbers stay 0
"""
def fail(message):
    print(message, file=sys.stderr)
    return 1
def round_half_up(value):
    return int(value + 0.5)
def find_bmild_toml(start_dir):
    current = Path(start_dir).resolve()
    while True:
        candidate = current / ".bmild.toml"
        if candidate.is_file():
            return candidate
        if current.parent == current:
            return None
        current = current.parent
def read_config_defaults(config_path):
    values = dict(DEFAULTS)
    mapping = {"slice_target": ("target", int), "tokenizer_base": ("base", int), "tokenizer_multiplier": ("multiplier", float)}
    if not config_path:
        return values
    try:
        lines = config_path.read_text(encoding="utf-8").splitlines()
    except OSError:
        return values
    for line in lines:
        match = re.match(r'^\s*([A-Za-z0-9_]+)\s*=\s*(.+?)\s*$', line)
        if not match or match.group(1) not in mapping:
            continue
        key, caster = mapping[match.group(1)]
        try:
            values[key] = caster(match.group(2).strip().strip('"'))
        except ValueError:
            pass
    return values
def assign_bracket(line_count):
    if line_count <= BRACKETS["small"]["max"]:
        return "small"
    if line_count <= BRACKETS["medium"]["max"]:
        return "medium"
    return "large"
def read_profile(path):
    resolved = Path(path).resolve()
    data = resolved.read_bytes()
    lines = len(data.splitlines())
    bracket = assign_bracket(lines)
    return str(resolved), lines, bracket, BRACKETS[bracket]["read"], BRACKETS[bracket]["edit"]
def collect_file_estimates(paths, mode):
    token_index, rows, skipped = (3 if mode == "reads" else 4), [], []
    for raw_path in paths:
        if not Path(raw_path).is_file():
            skipped.append(raw_path)
            continue
        try:
            path, lines, bracket, read_tokens, edit_tokens = read_profile(raw_path)
        except OSError:
            skipped.append(raw_path)
            continue
        tokens = read_tokens if token_index == 3 else edit_tokens
        rows.append({"path": path, "raw_tokens": tokens, "tokens": tokens, "lines": lines, "tier": bracket})
    total = sum(row["tokens"] for row in rows)
    return rows, skipped, total, total
def measure_source_dir_profile(src_dir):
    path = Path(src_dir)
    if not path.exists() or not path.is_dir():
        return None
    counts, measured = {"small": 0, "medium": 0, "large": 0}, 0
    try:
        for candidate in path.rglob("*"):
            if not candidate.is_file():
                continue
            with candidate.open("rb") as handle:
                if b"\0" in handle.read(4096):
                    continue
            lines = len(candidate.resolve().read_bytes().splitlines())
            counts[assign_bracket(lines)] += 1
            measured += 1
    except OSError:
        return None
    if measured == 0:
        return {"avg_raw_tokens_per_file": 0, "estimated_raw_tokens": 0, "estimated_tokens": 0}
    representative = max(("small", "medium", "large"), key=lambda name: (counts[name], TIE_BREAK[name]))
    tokens = BRACKETS[representative]["edit"]
    return {"avg_raw_tokens_per_file": tokens, "estimated_raw_tokens": 0, "estimated_tokens": 0}
def build_budget_result(target, base, multiplier, read_rows, edit_rows, skipped_reads, skipped_edits, new_file_estimate, skipped_new):
    weighted_reads = sum(row["tokens"] for row in read_rows)
    weighted_edits = sum(row["tokens"] for row in edit_rows)
    raw_file_tokens = sum(row["raw_tokens"] for row in read_rows + edit_rows)
    estimated_total = round_half_up((weighted_reads + weighted_edits) * multiplier + base)
    within = estimated_total <= target
    return {
        "status": "WITHIN BUDGET" if within else "OVER BUDGET",
        "budget": {
            "target": target, "estimated_total": estimated_total, "delta": (target - estimated_total) if within else (estimated_total - target),
            "raw_file_tokens": raw_file_tokens, "weighted_reads": weighted_reads, "weighted_edits": weighted_edits,
            "tokenizer_base": base, "tokenizer_multiplier": multiplier,
        },
        "reads": read_rows, "edits": edit_rows, "skipped_reads": skipped_reads, "skipped_new": skipped_new,
        "new_file_estimate": new_file_estimate, "skipped_edits": skipped_edits,
    }
def parse_args(argv):
    parsed, mode, i = {"reads": [], "edits": [], "new": 0, "src": ""}, "reads", 0
    value_flags = {"--target", "--base", "--multiplier", "--new", "--src"}
    while i < len(argv):
        arg = argv[i]
        if arg in ("--help", "-h"):
            print(USAGE, end="")
            return None
        if arg in ("--reads", "--edits"):
            mode, i = arg[2:], i + 1
            continue
        if arg in value_flags:
            if i + 1 >= len(argv):
                raise ValueError("Error: %s requires a value" % arg)
            parsed[arg[2:]], i = argv[i + 1], i + 2
            continue
        if arg.startswith("-"):
            raise ValueError("Error: unknown option: %s" % arg)
        parsed[mode].append(arg)
        i += 1
    return parsed
def main(argv):
    try:
        parsed = parse_args(argv)
    except ValueError as error:
        return fail(str(error))
    if parsed is None:
        return 0
    defaults = read_config_defaults(find_bmild_toml(os.getcwd()))
    try:
        target = int(parsed.get("target", defaults["target"]))
        base = int(parsed.get("base", defaults["base"]))
        multiplier = float(parsed.get("multiplier", defaults["multiplier"]))
        new_count = int(parsed["new"])
    except ValueError:
        return fail("Error: --target, --base, and --new must be integers; --multiplier must be numeric")
    if new_count < 0:
        return fail("Error: --new must be a non-negative integer")
    if not parsed["reads"] and not parsed["edits"] and new_count == 0:
        return fail("Error: no reads, edits, or new files were provided")
    if new_count > 0 and not parsed["src"]:
        return fail("Error: --new requires --src")
    read_rows, skipped_reads, _, _ = collect_file_estimates(parsed["reads"], "reads")
    edit_rows, skipped_edits, _, _ = collect_file_estimates(parsed["edits"], "edits")
    skipped_new = []
    new_file_estimate = {"count": new_count, "src": parsed["src"], "avg_raw_tokens_per_file": 0, "estimated_raw_tokens": 0, "estimated_tokens": 0}
    if new_count > 0:
        profile = measure_source_dir_profile(parsed["src"])
        if profile is None:
            skipped_new = [parsed["src"]]
        else:
            new_file_estimate.update(profile)
            new_file_estimate["estimated_raw_tokens"] = new_count * profile["avg_raw_tokens_per_file"]
            new_file_estimate["estimated_tokens"] = new_file_estimate["estimated_raw_tokens"]
            if new_file_estimate["estimated_tokens"] > 0:
                edit_rows.append({
                    "path": parsed["src"], "raw_tokens": new_file_estimate["estimated_raw_tokens"], "tokens": new_file_estimate["estimated_tokens"],
                    "lines": 0, "tier": "estimated_new_files", "new_files": new_count, "avg_raw_tokens_per_file": profile["avg_raw_tokens_per_file"],
                })
    print(json.dumps(build_budget_result(target, base, multiplier, read_rows, edit_rows, skipped_reads, skipped_edits, new_file_estimate, skipped_new), indent=2))
    return 0
if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
