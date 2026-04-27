#!/bin/bash

set -e

PROVISO_1="1. This is a one-time operation. If plans/bmad-history/ already exists, the script will abort."
PROVISO_2="2. This should be run only between development cycles — not midway through active BMAD work."
PROVISO_3="3. This preserves BMAD history only. It does not integrate BMAD state with BMILD workflow."
PROVISO_4="4. BMAD history will be searchable by BMILD personas but will not alter or steer BMILD specs or development."
PROVISO_5="5. BMAD artifacts are not converted to BMILD formats. They remain as BMAD produced them."
PROVISO_6="6. The source BMAD folders are not modified, moved, or deleted. You must delete any unwanted BMAD folders manually, after you have fully verified copy success."

usage() {
    echo "Usage: migrate-bmad.sh <bmad-project-root> <bmild-project-root>" >&2
    exit 1
}

abort() {
    echo "Error: $1" >&2
    exit 1
}

abort_exec() {
    echo "Error: $1" >&2
    exit 2
}

if [[ $# -ne 2 ]]; then
    usage
fi

BMAD_ROOT="$1"
BMILD_ROOT="$2"

if [[ ! -d "$BMAD_ROOT" ]]; then
    abort "BMAD project root not found: $BMAD_ROOT"
fi

BMAD_ROOT=$(cd "$BMAD_ROOT" && pwd)

if [[ ! -f "$BMAD_ROOT/_bmad/config.toml" ]]; then
    abort "Not a BMAD project — missing _bmad/config.toml in $BMAD_ROOT"
fi

if [[ ! -d "$BMILD_ROOT" ]]; then
    abort "BMILD project root not found: $BMILD_ROOT"
fi

BMILD_ROOT=$(cd "$BMILD_ROOT" && pwd)

OUTPUT_FOLDER=$(sed -n 's/^output_folder *= *"\(.*\)"/\1/p' "$BMAD_ROOT/_bmad/config.toml")

if [[ -z "$OUTPUT_FOLDER" ]]; then
    abort "Could not find output_folder in _bmad/config.toml"
fi

OUTPUT_FOLDER="${OUTPUT_FOLDER//\{project-root\}/$BMAD_ROOT}"

if [[ ! -d "$OUTPUT_FOLDER" ]]; then
    abort "BMAD output folder not found: $OUTPUT_FOLDER"
fi

USER_NAME=""
if [[ -f "$BMAD_ROOT/_bmad/config.user.toml" ]]; then
    USER_NAME=$(sed -n 's/^user_name *= *"\(.*\)"/\1/p' "$BMAD_ROOT/_bmad/config.user.toml")
fi

PLAN_FOLDER="plans/"
if [[ -f "$BMILD_ROOT/.bmild.toml" ]]; then
    PLAN_FOLDER_VALUE=$(sed -n 's/^plan_folder *= *"\(.*\)"/\1/p' "$BMILD_ROOT/.bmild.toml")
    if [[ -n "$PLAN_FOLDER_VALUE" ]]; then
        PLAN_FOLDER="$PLAN_FOLDER_VALUE"
    fi
fi

PLAN_FOLDER="${PLAN_FOLDER%/}"
DEST_DIR="$BMILD_ROOT/$PLAN_FOLDER"
HISTORY_DIR="$DEST_DIR/bmad-history"

if [[ -d "$HISTORY_DIR" ]]; then
    abort "bmad-history already exists in BMILD project. Migration has already been performed."
fi

declare -a SUBFOLDERS
declare -A SUBFOLDER_COUNTS
TOTAL_FILES=0

for item in "$OUTPUT_FOLDER"/*/; do
    if [[ -d "$item" ]]; then
        FOLDER_NAME=$(basename "$item")
        COUNT=$(find "$item" -type f | wc -l | tr -d ' ')
        SUBFOLDERS+=("$FOLDER_NAME")
        SUBFOLDER_COUNTS["$FOLDER_NAME"]=$COUNT
        TOTAL_FILES=$((TOTAL_FILES + COUNT))
    fi
done

STORY_COVERAGE=""
IMPL_DIR="$OUTPUT_FOLDER/implementation-artifacts"
if [[ -d "$IMPL_DIR" ]]; then
    declare -A EPIC_STORIES
    for f in "$IMPL_DIR"/*; do
        FNAME=$(basename "$f")
        if [[ "$FNAME" =~ ^([0-9]+)-([0-9]+) ]]; then
            EPIC="${BASH_REMATCH[1]}"
            STORY="${BASH_REMATCH[2]}"
            EPIC_STORIES["$EPIC"]+=" $STORY"
        fi
    done

    PARTS=()
    for EPIC in $(echo "${!EPIC_STORIES[@]}" | tr ' ' '\n' | sort -n); do
        mapfile -t NUMS < <(echo "${EPIC_STORIES[$EPIC]}" | tr ' ' '\n' | sort -n | uniq)
        if [[ ${#NUMS[@]} -gt 0 ]]; then
            FIRST=${NUMS[0]}
            LAST=${NUMS[-1]}
            if [[ "$FIRST" == "$LAST" ]]; then
                PARTS+=("Epic $EPIC: story $FIRST")
            else
                PARTS+=("Epic $EPIC: stories $FIRST to $LAST")
            fi
        fi
    done

    if [[ ${#PARTS[@]} -gt 0 ]]; then
        STORY_COVERAGE=$(IFS='; '; echo "${PARTS[*]}")
    fi
fi

SYSTEM_DIR="$DEST_DIR/_system"
TODAY=$(date +%Y-%m-%d)
BMAD_SOURCE_NAME=$(basename "$BMAD_ROOT")

echo "=== BMAD to BMILD Migration ==="
echo ""
echo "Source: $OUTPUT_FOLDER"
echo "Destination: $HISTORY_DIR"
echo ""
echo "Artifacts:"
for SF in "${SUBFOLDERS[@]}"; do
    echo "  $SF/: ${SUBFOLDER_COUNTS[$SF]} files"
done
echo "  Total: $TOTAL_FILES files"
echo ""
echo "Provisos:"
echo "  $PROVISO_1"
echo "  $PROVISO_2"
echo "  $PROVISO_3"
echo "  $PROVISO_4"
echo "  $PROVISO_5"
echo "  $PROVISO_6"
echo ""
echo -n "Proceed with migration? [y/N] "
read -r CONFIRM

if [[ "$CONFIRM" != "y" ]]; then
    echo "Migration cancelled. No changes were made."
    exit 1
fi

mkdir -p "$HISTORY_DIR"

if ! cp -R "$OUTPUT_FOLDER/." "$HISTORY_DIR/"; then
    abort_exec "File copy failed. Check disk space and permissions."
fi

CTX_CONTENT="---
scope: bmad-history
updated: $TODAY
---

## Live

## Archived
"
for SF in "${SUBFOLDERS[@]}"; do
    CTX_CONTENT+="- $SF/ (${SUBFOLDER_COUNTS[$SF]} files)
"
done

if ! echo -n "$CTX_CONTENT" > "$HISTORY_DIR/_context.md"; then
    abort_exec "Failed to write _context.md. Check directory permissions."
fi

mkdir -p "$SYSTEM_DIR"

SYS_CTX="$SYSTEM_DIR/_context.md"
if [[ -f "$SYS_CTX" ]]; then
    EXISTING=$(cat "$SYS_CTX")
    if echo "$EXISTING" | grep -q '## Archived'; then
        if ! echo "- bmad-history/_context.md" >> "$SYS_CTX"; then
            abort_exec "Failed to update _system/_context.md. Check directory permissions."
        fi
    else
        if ! printf '\n## Archived\n- bmad-history/_context.md\n' >> "$SYS_CTX"; then
            abort_exec "Failed to update _system/_context.md. Check directory permissions."
        fi
    fi
else
    SYS_CTX_CONTENT="---
scope: _system
updated: $TODAY
---

## Live

## Archived
- bmad-history/_context.md
"
    if ! echo -n "$SYS_CTX_CONTENT" > "$SYS_CTX"; then
        abort_exec "Failed to write _system/_context.md. Check directory permissions."
    fi
fi

ROLLUP="$SYSTEM_DIR/_rollup.md"
ROLLUP_ENTRY="### bmad-history
- **Status:** Archived (BMAD migration)
- **Migrated:** $TODAY
- **Source:** $BMAD_SOURCE_NAME"
for SF in "${SUBFOLDERS[@]}"; do
    ROLLUP_ENTRY+="
- **$SF:** ${SUBFOLDER_COUNTS[$SF]} files"
done

if [[ -n "$STORY_COVERAGE" ]]; then
    ROLLUP_ENTRY+="
- **Story coverage:** $STORY_COVERAGE"
fi

ROLLUP_ENTRY+="
- **BMAD config:** user_name=\"$USER_NAME\", output_folder=\"$OUTPUT_FOLDER\"
"

if [[ -f "$ROLLUP" ]]; then
    if ! printf '\n%s\n' "$ROLLUP_ENTRY" >> "$ROLLUP"; then
        abort_exec "Failed to update _system/_rollup.md. Check directory permissions."
    fi
else
    if ! printf '%s\n' "$ROLLUP_ENTRY" > "$ROLLUP"; then
        abort_exec "Failed to write _system/_rollup.md. Check directory permissions."
    fi
fi

BMILD_TOML="$BMILD_ROOT/.bmild.toml"
if [[ -f "$BMILD_TOML" ]]; then
    if ! grep -q '^user_name' "$BMILD_TOML"; then
        if [[ -n "$USER_NAME" ]]; then
            if ! echo "user_name = \"$USER_NAME\"" >> "$BMILD_TOML"; then
                abort_exec "Failed to update .bmild.toml. Check file permissions."
            fi
        fi
    fi
else
    if [[ -n "$USER_NAME" ]]; then
        if ! echo "user_name = \"$USER_NAME\"" > "$BMILD_TOML"; then
            abort_exec "Failed to create .bmild.toml. Check directory permissions."
        fi
    fi
fi

echo ""
echo "Migration complete."
echo "  Copied $TOTAL_FILES files to $HISTORY_DIR"
echo "  Registered in $SYSTEM_DIR/_context.md and $SYSTEM_DIR/_rollup.md"
exit 0
