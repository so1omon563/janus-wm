#!/usr/bin/env bash
set -euo pipefail

MODE="${1:-run}"
APP_NAME="Janus"
BUNDLE_ID="dev.so1omon.Janus"
MIN_SYSTEM_VERSION="14.0"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="$ROOT_DIR/dist"
APP_BUNDLE="$DIST_DIR/$APP_NAME.app"
APP_CONTENTS="$APP_BUNDLE/Contents"
APP_MACOS="$APP_CONTENTS/MacOS"
APP_BINARY="$APP_MACOS/$APP_NAME"
INFO_PLIST="$APP_CONTENTS/Info.plist"
LOCAL_SIGNING_SCRIPT="$ROOT_DIR/script/setup_local_signing.sh"
LOCAL_KEYCHAIN="$ROOT_DIR/.local-signing/JanusLocal.keychain-db"
LOCAL_KEYCHAIN_PASSWORD="janus-local-dev"
LOCAL_IDENTITY="Janus Local Code Signing"
ORIGINAL_KEYCHAINS=()

remember_keychains() {
  ORIGINAL_KEYCHAINS=()

  while IFS= read -r keychain; do
    keychain="${keychain//\"/}"
    keychain="${keychain#"${keychain%%[![:space:]]*}"}"
    keychain="${keychain%"${keychain##*[![:space:]]}"}"

    if [[ -n "$keychain" ]]; then
      ORIGINAL_KEYCHAINS+=("$keychain")
    fi
  done < <(security list-keychains -d user)
}

restore_keychains() {
  if [[ ${#ORIGINAL_KEYCHAINS[@]} -gt 0 ]]; then
    security list-keychains -d user -s "${ORIGINAL_KEYCHAINS[@]}" >/dev/null
  fi
}

with_local_keychain_for_signing() {
  remember_keychains
  security list-keychains -d user -s "$LOCAL_KEYCHAIN" "${ORIGINAL_KEYCHAINS[@]}"
  trap restore_keychains EXIT
}

pkill -x "$APP_NAME" >/dev/null 2>&1 || true

open_app() {
  /usr/bin/open -n "$APP_BUNDLE"
}

if [[ "$MODE" == "--launch-existing" || "$MODE" == "launch-existing" ]]; then
  if [[ ! -d "$APP_BUNDLE" ]]; then
    echo "No existing app bundle found at $APP_BUNDLE. Run $0 first." >&2
    exit 1
  fi

  open_app
  exit 0
fi

swift build
BUILD_BINARY="$(swift build --show-bin-path)/$APP_NAME"

rm -rf "$APP_BUNDLE"
mkdir -p "$APP_MACOS"
cp "$BUILD_BINARY" "$APP_BINARY"
chmod +x "$APP_BINARY"

cat >"$INFO_PLIST" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleExecutable</key>
  <string>$APP_NAME</string>
  <key>CFBundleIdentifier</key>
  <string>$BUNDLE_ID</string>
  <key>CFBundleName</key>
  <string>$APP_NAME</string>
  <key>CFBundlePackageType</key>
  <string>APPL</string>
  <key>CFBundleShortVersionString</key>
  <string>0.1.0</string>
  <key>CFBundleVersion</key>
  <string>1</string>
  <key>LSMinimumSystemVersion</key>
  <string>$MIN_SYSTEM_VERSION</string>
  <key>NSHighResolutionCapable</key>
  <true/>
  <key>NSPrincipalClass</key>
  <string>NSApplication</string>
  <key>NSAccessibilityUsageDescription</key>
  <string>Janus uses Accessibility permission to discover and manage windows.</string>
</dict>
</plist>
PLIST

if [[ -x "$LOCAL_SIGNING_SCRIPT" ]]; then
  "$LOCAL_SIGNING_SCRIPT" >/dev/null
fi

if [[ -f "$LOCAL_KEYCHAIN" ]] && security find-identity -p codesigning "$LOCAL_KEYCHAIN" | grep -q "$LOCAL_IDENTITY"; then
  security unlock-keychain -p "$LOCAL_KEYCHAIN_PASSWORD" "$LOCAL_KEYCHAIN"
  with_local_keychain_for_signing
  SIGNING_HASH="$(security find-identity -p codesigning "$LOCAL_KEYCHAIN" | awk -v name="$LOCAL_IDENTITY" '$0 ~ name { print $2; exit }')"
  codesign --force --sign "$SIGNING_HASH" "$APP_BUNDLE"
else
  codesign --force --sign - "$APP_BUNDLE"
fi

case "$MODE" in
  run)
    open_app
    ;;
  --debug|debug)
    lldb -- "$APP_BINARY"
    ;;
  --logs|logs)
    open_app
    /usr/bin/log stream --info --style compact --predicate "process == \"$APP_NAME\""
    ;;
  --telemetry|telemetry)
    open_app
    /usr/bin/log stream --info --style compact --predicate "subsystem == \"$BUNDLE_ID\""
    ;;
  --verify|verify)
    open_app
    sleep 1
    pgrep -x "$APP_NAME" >/dev/null
    ;;
  *)
    echo "usage: $0 [run|--debug|--logs|--telemetry|--verify|--launch-existing]" >&2
    exit 2
    ;;
esac
