#!/bin/bash

# Check if a file argument is provided; default to .env if not
env_file="${1:-.env}"

# Load the specified .env file
if [[ -f "$env_file" ]]; then
  export $(grep -v '^#' "$env_file" | xargs)
else
  echo "File $env_file not found."
  exit 1
fi

# Save the environment variables in a plist file
cat <<EOT > "${SRCROOT}/Environment.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>SUPABASE_URL</key>
  <string>$SUPABASE_URL</string>
  <key>SUPABASE_ANON_KEY</key>
  <string>$SUPABASE_ANON_KEY</string>
</dict>
</plist>
EOT
