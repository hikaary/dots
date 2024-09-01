#!/bin/bash

set -e

echo "Starting Spotify authentication setup..."

# Create a temporary directory
TMP_DIR=$(mktemp -d)
echo "Using temporary directory: $TMP_DIR"

# Ensure temporary directory is removed on exit
trap 'rm -rf "$TMP_DIR"' EXIT

# Step 1: Install Rust
if ! command -v rustc &>/dev/null; then
  echo "Installing Rust..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source $HOME/.cargo/env
else
  echo "Rust is already installed."
fi

# Change to the temporary directory
cd "$TMP_DIR"

# Step 2: Clone librespot-auth
echo "Cloning librespot-auth..."
git clone https://github.com/dspearson/librespot-auth
cd librespot-auth

# Step 3: Build the project
echo "Building librespot-auth..."
cargo build --release

# Step 4: Run the binary
echo "Running librespot-auth..."
./target/release/librespot-auth --name "Example Speaker" &
PID=$!

echo "Please open the Spotify client and select 'Example Speaker' as the output device."
echo "Waiting for credentials file to be created..."

# Wait for credentials.json to be created
while [ ! -f credentials.json ]; do
  sleep 1
done

# Kill the librespot-auth process
kill $PID

# Step 5: Copy credentials to ncspot directory
echo "Copying credentials to ncspot directory..."
mkdir -p ~/.cache/ncspot/librespot
cp credentials.json ~/.cache/ncspot/librespot/

echo "Setup complete. ncspot should now work with Spotify authentication."
