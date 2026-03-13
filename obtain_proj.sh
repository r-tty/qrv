#!/bin/bash
set -euo pipefail

REPO_URL="https://github.com/vocho/openqnx"
CLONE_DIR="openqnx_clone"
PLACEMENT_FILE="placement.txt"
SEARCH_TEXT="must obtain a written license from and pay applicable license fees to QNX"

# 1) Clone the repo
if [ -d "$CLONE_DIR" ]; then
    echo "Directory $CLONE_DIR already exists, removing..."
    rm -rf "$CLONE_DIR"
fi
echo "Cloning $REPO_URL..."
git clone "$REPO_URL" "$CLONE_DIR"

# Check that placement.txt exists
if [ ! -f "$PLACEMENT_FILE" ]; then
    echo "Error: $PLACEMENT_FILE not found in current directory."
    exit 1
fi

# 2) Find all files containing the license text
echo "Searching for files with license text..."
mapfile -t matched_files < <(grep -rl "$SEARCH_TEXT" "$CLONE_DIR" 2>/dev/null || true)

echo "Found ${#matched_files[@]} file(s) with license text."

# 3) & 4) Process each matched file
for filepath in "${matched_files[@]}"; do
    filename=$(basename "$filepath")

    # Look up filename in placement.txt
    dest_dir=$(awk -v f="$filename" '$1 == f { print $2; exit }' "$PLACEMENT_FILE")

    if [ -z "$dest_dir" ]; then
        # 4) Not in placement.txt -> delete
        echo "DELETE (not in placement.txt): $filepath"
        rm -f "$filepath"
    else
        # 3) Move to destination directory
        mkdir -p "$dest_dir"
        echo "PLACE: $filename -> $dest_dir/"
        cp "$filepath" "$dest_dir/"
        rm -f "$filepath"
    fi
done

# 5) Apply patches if patches/series exists
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
        patch -p1 < "$patch_file"
    done < "patches/series"
    echo ""
    echo "All patches applied."
fi

echo "Done."
