#!/bin/zsh

set -u

mode="${1:---check}"
uid_value="$(/usr/bin/id -u)"

show_check() {
  print -- "macOS version:"
  /usr/bin/sw_vers

  print -- "iCloud account service flags:"
  /usr/bin/defaults read MobileMeAccounts 2>/dev/null | /usr/bin/grep -E -A4 -B2 'CLOUDDESKTOP|MOBILE_DOCUMENTS' || print -- "Unable to read iCloud service flags."

  print -- "\nRelevant processes:"
  /usr/bin/pgrep -fl '(^|/)(bird|fileproviderd|cloudd)( |$)' || print -- "No matching user sync process is currently visible."

  print -- "\nDesktop and Documents links:"
  /bin/ls -ld "$HOME/Library/Mobile Documents/com~apple~CloudDocs/Desktop" "$HOME/Library/Mobile Documents/com~apple~CloudDocs/Documents" 2>/dev/null || print -- "One or both iCloud folder links are unavailable."

  print -- "\nLocal disk capacity:"
  /bin/df -h "$HOME" | /usr/bin/tail -n 1

  print -- "\nPossible competing cloud provider:"
  if /usr/bin/pgrep -fl '/OneDrive.app/' >/dev/null 2>&1; then
    print -- "OneDrive is currently running. Treat it as a possible conflict, not a proven cause."
  else
    print -- "OneDrive is not currently running."
  fi

  if [[ -d "$HOME/Library/CloudStorage" ]]; then
    /bin/ls -1 "$HOME/Library/CloudStorage" 2>/dev/null | /usr/bin/sed 's/^/Configured provider: /' || true
  fi
}

run_repair() {
  print -- "Restarting iCloud Drive synchronization services..."
  /usr/bin/killall bird 2>/dev/null || true
  /usr/bin/killall fileproviderd 2>/dev/null || true
  /bin/launchctl kickstart -k "gui/${uid_value}/com.apple.bird"
  /bin/sleep 3

  print -- "Reopening Finder..."
  /usr/bin/killall Finder 2>/dev/null || true
  /bin/sleep 3

  print -- "\nProcess verification:"
  /usr/bin/pgrep -fl '(^|/)(bird|fileproviderd|Finder)( |$)' || true

  if /usr/bin/pgrep -x bird >/dev/null 2>&1 && /usr/bin/pgrep -x fileproviderd >/dev/null 2>&1 && /usr/bin/pgrep -x Finder >/dev/null 2>&1; then
    print -- "Repair services are running. Verify that the Local label disappears and perform a cross-Mac test."
  else
    print -- "One or more services did not relaunch. Stop here and collect fresh diagnostics."
    return 1
  fi
}

case "$mode" in
  --check)
    show_check
    ;;
  --repair)
    run_repair
    ;;
  *)
    print -u2 -- "Usage: $0 --check | --repair"
    exit 2
    ;;
esac
