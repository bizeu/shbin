#!/usr/bin/env bash

# 
# updates license 
set -euo pipefail
cd "$(dirname "$0")"
JETBRAINS_APPLICATIONS="$(find Applications -type d -mindepth 1 -maxdepth 1 -exec basename "{}" \;)"
JETBRAINS_NAMES="$(find config -type d -mindepth 1 -maxdepth 1 -exec basename "{}" \;)"
declare -A OPEN
JETBRAINS_APPLICATIONS="$(git rev-parse --show-toplevel)/Library"
JETBRAINS_LIBRARY="$(git rev-parse --show-toplevel)/Library"
main() {
  local file tmp
  open https://account.jetbrains.com/login
  read -n 1 -s -r -p "Safari ⌘ ,: delete JetBrains account, cookies and web form [press any key to continue]"
  open /System/Applications/Utilities/Keychain\ Access.app/
  read -n 1 -s -r -p "Keychain <-: delete JetBrains account [press any key to continue]"
  open /System/Applications/Utilities/Keychain\ Access.app/

  read -n 1 -s -r -p "PyCharm ⇧⌘A: git to 'Manage Licenses...' and log out [press any key to continue]"

  for i in ${JETBRAINS_NAMES} Toolbox; do
    pgrep -f "${i}" 2>/dev/null || true
    pkill -9 -f "${i}" 2>/dev/null || true
    pkill -9 -f "${i,,}" 2>/dev/null || true
  done

  for i in accounts.json download logs statistics; do
    rm -rf ~/.local/share/JetBrains/Toolbox/"${i}"
    # TODO: macOS
  done

  rm -f ~/Library/Preferences/com.apple.java.util.prefs.plist
  sudo rm -rf ~/.java/.userPrefs

  cd "${JETBRAINS_LIBRARY}"
  find . -type f -mindepth 2 -maxdepth 2 -name "*.key" -delete
  find . -type f -mindepth 2 -maxdepth 2 -name "*.license" -delete
  find . -type f -mindepth 2 -maxdepth 2 -name "port" -delete
  find . -type f -mindepth 2 -maxdepth 2 -name "port.lock" -delete
  find . -type f -mindepth 2 -maxdepth 2 -name "user.web.token" -delete
  tmp="$(mktemp)"
  while read -r file; do
    sed '/evlsprt/d' "${file}" >"${tmp}"
    cp "${tmp}" "${file}"
  done < <(find . -type f -path "*/options/other.xml")
  rm -rf ~/.config/JetBrains
  rm -f ~/Library/Preferences/com.jetbrains.*.plist
  rm -f ~/Library/Preferences/jetbrains.*.*.plist
  killall cfprefsd 2>/dev/null || true
  rm -f ~/.cache/log/JetBrains/*/token
  open https://www.icloud.com/mail/
  read -n 1 -s -r -p "iCloud: remove and create new alias [press any key to continue]"


}

main "$@"
