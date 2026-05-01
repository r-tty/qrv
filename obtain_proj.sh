#!/bin/bash
#
# obtain_proj.sh — Obtain QNX-licensed sources and place them into
#                   the QRV-OS directory structure.
#
# Reads placement.txt which maps openqnx paths to QRV-OS paths:
#
#   trunk/services/system/ker/ker_sync.c    kernel/ker_sync.c
#
# For each entry, copies the file from the cloned openqnx repo into
# the QRV-OS destination.  Then applies patches from patches/series.
#
set -euo pipefail

REPO_URL="https://github.com/vocho/openqnx"
CLONE_DIR="openqnx_clone"
PLACEMENT_FILE="placement.txt"
DEST_DIR="os"

# Check required tools
for tool in git patch lz4cat; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo "Error: '$tool' not found. Please install it:" >&2
        case "$tool" in
            lz4cat) echo "  apt install lz4   # Debian/Ubuntu" >&2
                    echo "  dnf install lz4   # Fedora/RHEL" >&2 ;;
            *)      echo "  apt install $tool" >&2 ;;
        esac
        exit 1
    fi
done

# ---------------------------------------------------------------
# 1) Clone the openqnx repo
# ---------------------------------------------------------------
if [ -d "$CLONE_DIR" ]; then
    echo "Directory $CLONE_DIR already exists, removing..."
    rm -rf "$CLONE_DIR"
fi
echo "Cloning $REPO_URL..."
git clone --depth 1 "$REPO_URL" "$CLONE_DIR"

if [ ! -f "$PLACEMENT_FILE" ]; then
    echo "Error: $PLACEMENT_FILE not found in current directory." >&2
    exit 1
fi

# ---------------------------------------------------------------
# 2) Copy files according to placement.txt
# ---------------------------------------------------------------
echo ""
echo "Placing QNX sources according to $PLACEMENT_FILE..."

placed=0
skipped=0
missing=0

while IFS= read -r line; do
    # Skip comments and blank lines
    [[ -z "$line" || "$line" == \#* ]] && continue

    # Parse: openqnx_path  qrv_path
    oqnx_rel=$(echo "$line" | awk '{print $1}')
    qrv_path=$(echo "$line" | awk '{print $2}')

    if [ -z "$oqnx_rel" ] || [ -z "$qrv_path" ]; then
        continue
    fi

    src="$CLONE_DIR/$oqnx_rel"
    qrv_path="$DEST_DIR/$qrv_path"
    dest_dir=$(dirname "$qrv_path")

    if [ ! -f "$src" ]; then
        echo "  MISSING: $oqnx_rel"
        missing=$((missing + 1))
        continue
    fi

    # Skip if destination already exists (don't overwrite)
    if [ -f "$qrv_path" ]; then
        skipped=$((skipped + 1))
        continue
    fi

    mkdir -p "$dest_dir"
    cp "$src" "$qrv_path"
    echo "  PLACE: $oqnx_rel -> $qrv_path"
    placed=$((placed + 1))
done < "$PLACEMENT_FILE"

echo ""
echo "Placement complete: $placed placed, $skipped already present, $missing missing"

# ---------------------------------------------------------------
# 3) Clean up the clone
# ---------------------------------------------------------------
echo "Removing $CLONE_DIR..."
rm -rf "$CLONE_DIR"

# ---------------------------------------------------------------
# 4) Apply patches if patches/series exists
#
# Patches may be plain (.patch) or LZ4-compressed (.patch.lz4).
# Requires: patch, unlz4 (from the lz4 package)
# ---------------------------------------------------------------
if [ -d "patches" ] && [ -f "patches/series" ]; then
    echo ""
    echo "+----------------------------+"
    echo "| start patching QNX sources |"
    echo "+----------------------------+"
    echo ""
    while IFS= read -r patch_name; do
        # Skip blank lines and comments
        [[ -z "$patch_name" || "$patch_name" == \#* ]] && continue
        patch_file="patches/$patch_name"
        if [ ! -f "$patch_file" ]; then
            echo "WARNING: patch not found: $patch_file (skipping)"
            continue
        fi
        echo "Applying: $patch_name"
        case "$patch_file" in
            *.lz4)
                lz4cat "$patch_file" | patch -d "$DEST_DIR" -p1
                ;;
            *)
                patch -d "$DEST_DIR" -p1 < "$patch_file"
                ;;
        esac
    done < "patches/series"
    echo ""
    echo "All patches applied."
fi

# ---------------------------------------------------------------
# 5) Set +x permissions for essential executables
# ---------------------------------------------------------------
echo
executables="emu.sh host_tools/mkgpt.py"
for e in $executables; do
    echo "Setting +x permission for: os/$e"
    chmod +x os/$e
done

echo
echo "Done."
