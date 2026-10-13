#!/bin/sh
set -e

file="/etc/searxng/settings.yml"

if [ ! -f "$file" ]; then
    echo "No settings.yml found, waiting for template generation..."
    exit 0
fi

echo "Processing: ${file} with filter: ${SEARXNG_ENV_REGEX_FILTER:-none}"

# Use awk to substitute ${VAR} patterns using environment variables matching the filter
awk -v filter="${SEARXNG_ENV_REGEX_FILTER:-.*}" '
BEGIN {
    # Load matching environment variables into an awk associative array
    # We inspect ENVIRON which contains all environment variables
    for (env_name in ENVIRON) {
        if (env_name ~ filter) {
            val[env_name] = ENVIRON[env_name]
        }
    }
}
{
    # Find and replace ${VAR_NAME} patterns in the current line
    line = $0
    while (match(line, /\$\{([A-Za-z_][A-Za-z0-9_]*)\}/)) {
        var_name = substr(line, RSTART + 2, RLENGTH - 3)
        replacement = (var_name in val) ? val[var_name] : ""
        line = substr(line, 1, RSTART - 1) replacement substr(line, RSTART + RLENGTH)
    }
    print line
}
' "${file}" > "${file}.tmp"

mv "${file}.tmp" "${file}"

# Run searxng
exec /usr/local/searxng/entrypoint.sh
