#!/usr/bin/bash

# #############################################################
# Copies all existing subtitles (excluding .ffsubsync) into a
# Original Subtitles/ folder alongside each episode or movie.
# NOTE: This file was written with the help of an LLM (Claude)
# #############################################################

# #############################################################
# Configuration
# #############################################################
MEDIA_ROOTS=(
	"/mnt/media/films"
    "/mnt/media/series"
)

SUBTITLE_EXTENSIONS=("srt" "ass" "ssa" "vtt")

SUBTITLES_SAVE_FOLDER="Original Subtitles"

DRY_RUN=true # Set to false to actually copy files

# #############################################################
# Script
# #############################################################
if $DRY_RUN; then
    echo "[DRY RUN] No files will be copied. Set DRY_RUN=false to apply."
    echo ""
fi

copied=0
skipped=0
errors=0

for root in "${MEDIA_ROOTS[@]}"; do
    if [[ ! -d "$root" ]]; then
        echo "[WARN] Directory not found, skipping: $root"
        continue
    fi

    # Build the -name filter dynamically from SUBTITLE_EXTENSIONS
    find_args=()
    for i in "${!SUBTITLE_EXTENSIONS[@]}"; do
        [[ $i -gt 0 ]] && find_args+=(-o)
        find_args+=(-name "*.${SUBTITLE_EXTENSIONS[$i]}")
    done

    while IFS= read -r subtitle; do
        filename="$(basename "$subtitle")"

        # Skip anything synced by ffsubsync
        if [[ "$filename" == *.ffsubsync.* ]]; then
            echo "[SKIP] ffsubsync: $subtitle"
            ((skipped++))
            continue
        fi

        dir="$(dirname "$subtitle")"
        dest_dir="$dir/$SUBTITLES_SAVE_FOLDER"
        dest="$dest_dir/$filename"

        # Skip if already inside a subtitles/ directory
        if [[ "$dir" == */"$SUBTITLES_SAVE_FOLDER" ]]; then
            echo "[SKIP] Already in subtitles/: $subtitle"
            ((skipped++))
            continue
        fi

        # Skip if destination already exists
        if [[ -f "$dest" ]]; then
            echo "[SKIP] Already exists: $dest"
            ((skipped++))
            continue
        fi

        echo "[COPY] $subtitle"
        echo "    -> $dest"

        if ! $DRY_RUN; then
            if mkdir -p "$dest_dir" && cp "$subtitle" "$dest"; then
                ((copied++))
            else
                echo "[ERROR] Failed to copy: $subtitle"
                ((errors++))
            fi
        else
            ((copied++))
        fi

    done < <(find "$root" \( "${find_args[@]}" \) -type f)
done

echo ""
echo "─────────────────────────────────────────────"
if $DRY_RUN; then
    echo "Dry run complete, would copy: $copied | skipped: $skipped | errors: $errors"
    echo "Set DRY_RUN=false and re-run to apply."
else
    echo "Done, copied: $copied | skipped: $skipped | errors: $errors"
fi
