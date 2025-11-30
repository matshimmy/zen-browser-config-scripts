#!/bin/bash
# ==========================================================================
# Zen Browser Config Setup - Linux
# Creates symlinks from this repo's config files to Zen's profile directory
# ==========================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Zen profiles directory
ZEN_DIR="$HOME/.var/app/app.zen_browser.zen/.zen"
if [ ! -d "$ZEN_DIR" ]; then
    echo "Error: Zen directory not found at $ZEN_DIR"
    echo "Make sure Zen Browser is installed and has been run at least once."
    exit 1
fi

# Find the default profile
PROFILE_DIR=$(find "$ZEN_DIR" -maxdepth 1 -type d -name "*.Default (release)" | head -n 1)
if [ -z "$PROFILE_DIR" ]; then
    echo "Error: Could not find Zen profile directory"
    exit 1
fi
echo "Using profile: $PROFILE_DIR"

# Chrome directory
CHROME_DIR="$PROFILE_DIR/chrome"
if [ ! -d "$CHROME_DIR" ]; then
    echo "Error: Chrome directory not found at $CHROME_DIR"
    exit 1
fi
echo "Chrome directory: $CHROME_DIR"

# Helper function
set_symlink() {
    local target="$1"
    local source="$2"
    
    echo ""
    echo "Processing link:"
    echo "  Target: $target"
    echo "  Source: $source"
    
    if [ -e "$target" ]; then
        if [ -L "$target" ]; then
            echo "Existing symlink found, removing..."
            rm "$target"
        else
            echo "Error: existing '$target' is not a symlink. Aborting."
            exit 1
        fi
    else
        echo "No existing file at target path. Creating new link..."
    fi
    
    echo "Creating symlink..."
    ln -s "$source" "$target"
}

# Create symlinks
set_symlink "$CHROME_DIR/userChrome.css" "$SCRIPT_DIR/../userChrome.css"
set_symlink "$PROFILE_DIR/user.js" "$SCRIPT_DIR/../user.js"

echo ""
echo "Setup complete!"
echo "  userChrome.css -> $CHROME_DIR/userChrome.css"
echo "  user.js        -> $PROFILE_DIR/user.js"
echo ""
echo "Restart Zen Browser to apply changes."
