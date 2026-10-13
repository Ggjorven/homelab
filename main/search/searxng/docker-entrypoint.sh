#!/bin/sh
set -e

file="/etc/searxng/settings.yml"

# Check if settings.yml exists (if not, let SearXNG generate its template first)
if [ ! -f "$file" ]; then
    echo "No settings.yml found, waiting for template generation..."
	exec /usr/local/searxng/entrypoint.sh
fi

# Substitute variables safely using a temporary file
echo "Processing: ${file}."
envsubst "${SEARXNG_ENVSUBST_FILTER:-}" < "${file}" > "${file}.tmp"
mv "${file}.tmp" "${file}"

# Run searxng
exec /usr/local/searxng/entrypoint.sh
