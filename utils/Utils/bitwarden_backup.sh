#!/bin/bash

OUTPUT_DIR="${1:-.}"
TEMP_FILE="/dev/shm/bw_backup_temp.json"
ENCRYPTED_FILE="$OUTPUT_DIR/bw_backup.json.gpg"

if ! command -v bw &> /dev/null; then
    echo "Error: Bitwarden CLI (bw) is not installed."
    exit 1
fi

if ! command -v gpg &> /dev/null; then
    echo "Error: GnuPG (gpg) is not installed."
    exit 1
fi

BW_STATUS=$(bw status)

if echo "$BW_STATUS" | grep -q '"status":"unauthenticated"'; then
    echo "Not logged in to Bitwarden. Initiating login..."
    export BW_SESSION=$(bw login --raw)

elif echo "$BW_STATUS" | grep -q '"status":"locked"'; then
    echo "Unlocking Bitwarden vault..."
    export BW_SESSION=$(bw unlock --raw)

elif echo "$BW_STATUS" | grep -q '"status":"unlocked"'; then
    echo "Vault is currently unlocked, but the session key is not in this environment."
    echo "Locking vault to secure a fresh session key..."
    bw lock > /dev/null
    export BW_SESSION=$(bw unlock --raw)
    
else
    echo "Error: Could not determine Bitwarden status."
    exit 1
fi

if [ -z "$BW_SESSION" ]; then
    echo "Error: Failed to authenticate or unlock vault. Please check your credentials."
    exit 1
fi

echo "Syncing vault..."
bw sync --session "$BW_SESSION" > /dev/null

echo "Exporting vault to temporary file..."
bw export --output "$TEMP_FILE" --format json --session "$BW_SESSION" > /dev/null

echo "Encrypting backup (Overwriting previous copy)..."
# The --yes flag forces GPG to overwrite the existing file
gpg --yes --symmetric --cipher-algo AES256 --output "$ENCRYPTED_FILE" "$TEMP_FILE"

if [ $? -eq 0 ]; then
    echo "Bitwarden vault securely backed up to: $ENCRYPTED_FILE"
else
    echo "Error: Encryption failed."
fi

# Securely delete the temporary file
if command -v shred &> /dev/null; then
    shred -u "$TEMP_FILE" 2>/dev/null
else
    rm "$TEMP_FILE"
fi

bw lock > /dev/null
