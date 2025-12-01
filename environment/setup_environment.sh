#!/bin/bash

# Generated
# Environment Setup Script for GnoLove E2E Testing
# This script can be sourced by other scripts or run standalone

# Only set exit on error if not being sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    set -e  # Exit on any error
fi

echo "🚀 Setting up GnoLove development environment..."

# Get the current directory
CURRENT_DIR=$(pwd)
PARENT_DIR=$(dirname "$CURRENT_DIR")
E2E_DIR="$CURRENT_DIR"
PIDS=()

# Parameters
GNO_REPO="${1:-git@github.com:gnolang/gno.git}"
GNO_BRANCH="${2:-master}"
ADDRESS="${3:-g17raryfukyf7an7p5gcklru4kx4ulh7wnx44ync}"

echo "📦 Using gno repository: $GNO_REPO"
echo "🌿 Using branch: $GNO_BRANCH"
echo "📍 Using address: $ADDRESS"

# Cleanup function to kill all background processes
cleanup() {
    echo ""
    echo "🛑 Cleaning up background processes..."
    
    for pid in "${PIDS[@]}"; do
        if kill -0 "$pid" 2>/dev/null; then
            echo "Killing process $pid..."
            kill "$pid" 2>/dev/null || true
        fi
    done
    
    echo "✅ Cleanup complete!"
    exit 0
}

# Trap signals to run cleanup function
trap cleanup EXIT INT TERM

echo "📁 Working in: $CURRENT_DIR"

echo "📦 Setting up gno repository..."
cd "$E2E_DIR"

if [ ! -d "gno" ]; then
    # Directory doesn't exist, clone it
    echo "Cloning $GNO_REPO..."
    git clone "$GNO_REPO"
    cd "$E2E_DIR/gno"
    git checkout "$GNO_BRANCH"
else
    cd "$E2E_DIR/gno"
    
    # Check if it's the correct repository
    CURRENT_REMOTE=$(git config --get remote.origin.url 2>/dev/null || echo "")
    
    # Normalize URLs for comparison (remove .git suffix and convert SSH to HTTPS format for comparison)
    NORMALIZED_CURRENT=$(echo "$CURRENT_REMOTE" | sed 's/\.git$//' | sed 's|git@github.com:|https://github.com/|')
    NORMALIZED_EXPECTED=$(echo "$GNO_REPO" | sed 's/\.git$//' | sed 's|git@github.com:|https://github.com/|')
    
    if [ "$NORMALIZED_CURRENT" != "$NORMALIZED_EXPECTED" ]; then
        echo "⚠️  Existing gno directory points to different repository!"
        echo "   Current: $CURRENT_REMOTE"
        echo "   Expected: $GNO_REPO"
        echo "🗑️  Removing old repository..."
        cd "$E2E_DIR"
        rm -rf gno
        echo "Cloning $GNO_REPO..."
        git clone "$GNO_REPO"
        cd "$E2E_DIR/gno"
        git checkout "$GNO_BRANCH"
    else
        echo "✅ gno repository already exists"
        echo "🔄 Fetching latest changes..."
        git fetch origin
        git checkout "$GNO_BRANCH"
        git pull origin "$GNO_BRANCH"
    fi
fi


# Update the loader file
LOADER_FILE="./examples/gno.land/r/gov/dao/v3/loader/loader.gno"
if [ -f "$LOADER_FILE" ]; then
    echo "📝 Updating loader file with address and invitation points..."
    sed -i "s/memberstore\.Get()\.SetMember(memberstore\.T1, address(\"[^\"]*\"), &memberstore\.Member{InvitationPoints: [0-9]*})/memberstore.Get().SetMember(memberstore.T1, address(\"$ADDRESS\"), \&memberstore.Member{InvitationPoints: 100})/g" "$LOADER_FILE"
    echo "✅ Updated loader file with address: $ADDRESS and InvitationPoints: 100"
else
    echo "⚠️  Loader file not found at: $LOADER_FILE"
fi

make install

# Start gnodev
echo "🚀 Starting gnodev..."
nohup bash -c gnodev ./examples/gno.land/r/gov/dao/v3/loader &
GNODEV_PID=$!
PIDS+=($GNODEV_PID)
echo "gnodev started with PID: $GNODEV_PID"

sleep 5

echo "🌐 Opening browser page..."
if command -v firefox &> /dev/null; then
    firefox "http://localhost:8888/r/gov/dao/v3/loader" &
elif command -v google-chrome &> /dev/null; then
    google-chrome "http://localhost:8888/r/gov/dao/v3/loader" &
elif command -v chromium-browser &> /dev/null; then
    chromium-browser "http://localhost:8888/r/gov/dao/v3/loader" &
else
    echo "⚠️  No supported browser found. Please open http://localhost:8888/r/gov/dao/v3/loader manually"
fi


# If script is run directly (not sourced), keep it running
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "⏳ All services are running. Press Ctrl+C to stop everything..."
    while true; do
        sleep 1
    done
fi