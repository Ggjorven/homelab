#!/bin/bash

"$(dirname "$0")/up-networking.sh"
"$(dirname "$0")/up-monitoring.sh"
"$(dirname "$0")/up-jellyfin.sh"
"$(dirname "$0")/up-seerr.sh"
"$(dirname "$0")/up-navidrome.sh"
