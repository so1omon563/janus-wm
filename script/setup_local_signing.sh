#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SIGNING_DIR="$ROOT_DIR/.local-signing"
KEYCHAIN="$SIGNING_DIR/JanusLocal.keychain-db"
KEYCHAIN_PASSWORD="janus-local-dev"
P12_PASSWORD="janus-local-dev-p12"
IDENTITY_NAME="Janus Local Code Signing"
CERT="$SIGNING_DIR/JanusLocal.crt"
KEY="$SIGNING_DIR/JanusLocal.key"
P12="$SIGNING_DIR/JanusLocal.p12"

mkdir -p "$SIGNING_DIR"

if [[ ! -f "$KEYCHAIN" ]]; then
  security create-keychain -p "$KEYCHAIN_PASSWORD" "$KEYCHAIN"
fi

security unlock-keychain -p "$KEYCHAIN_PASSWORD" "$KEYCHAIN"

if ! security find-identity -p codesigning "$KEYCHAIN" | grep -q "$IDENTITY_NAME"; then
  openssl req \
    -x509 \
    -newkey rsa:2048 \
    -sha256 \
    -days 3650 \
    -nodes \
    -subj "/CN=$IDENTITY_NAME/" \
    -addext "basicConstraints=critical,CA:true" \
    -addext "keyUsage=critical,digitalSignature,keyCertSign" \
    -addext "extendedKeyUsage=codeSigning" \
    -keyout "$KEY" \
    -out "$CERT"

  openssl pkcs12 \
    -export \
    -legacy \
    -inkey "$KEY" \
    -in "$CERT" \
    -name "$IDENTITY_NAME" \
    -out "$P12" \
    -passout "pass:$P12_PASSWORD"

  security import "$P12" \
    -k "$KEYCHAIN" \
    -P "$P12_PASSWORD" \
    -T /usr/bin/codesign

  security set-key-partition-list \
    -S apple-tool:,apple:,codesign: \
    -s \
    -k "$KEYCHAIN_PASSWORD" \
    "$KEYCHAIN"
fi

security add-trusted-cert \
  -r trustRoot \
  -p codeSign \
  -k "$KEYCHAIN" \
  "$CERT"

security find-identity -p codesigning "$KEYCHAIN"
