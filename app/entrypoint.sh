#!/bin/sh
set -e

# VM_HOSTNAME is expected to be passed in at "docker run" time, e.g.:
#   docker run -d -e VM_HOSTNAME=$(whoami) -p 8080:8080 breakout-lb-demo
#
# We sanitize it down to only what a Linux whoami can legally contain
# (letters, digits, hyphen) before writing it into a JS file. This avoids
# any chance of breaking the generated script or injecting something
# unexpected into the page.
SAFE_HOSTNAME=$(printf '%s' "${VM_HOSTNAME:-unknown}" | tr -cd 'A-Za-z0-9-')

if [ -z "$SAFE_HOSTNAME" ]; then
  SAFE_HOSTNAME="unknown"
fi

# personalize per user
if [ -d "/usr/share/nginx/html/${SAFE_HOSTNAME}" ]; then
  cp -r "/usr/share/nginx/html/${SAFE_HOSTNAME}/." /usr/share/nginx/html/
fi

echo "Starting TEAM 06 PORTO, whoami injected as: ${SAFE_HOSTNAME}"

exec nginx -g "daemon off;"
