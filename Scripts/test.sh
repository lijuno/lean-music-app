#!/bin/zsh
set -euo pipefail

PROJECT_ROOT="${0:A:h:h}"

# Some standalone Command Line Tools installations contain Swift Testing but
# do not expose it to SwiftPM. Prefer the installed Xcode developer directory
# in that case without changing the machine-wide xcode-select setting.
if [[ -z "${DEVELOPER_DIR:-}" \
   && -d "/Applications/Xcode.app/Contents/Developer" \
   && "$(/usr/bin/xcode-select -p)" == *"/CommandLineTools" ]]; then
  export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"
fi

swift test --package-path "$PROJECT_ROOT"
