# Zen Browser Config

Personal configuration files for Zen Browser, synced across devices.

## Files

- `userChrome.css` - UI customizations (hide elements, compact mode behavior)
- `user.js` - about:config preferences (applied on browser startup)

## Setup

### Linux
```bash
chmod +x setup-linux.sh
./setup-linux.sh
```

### Windows
1. Enable Developer Mode: Settings → Privacy & Security → For developers
2. Double-click `setup-windows.bat`

Or run the .bat as Administrator.

## After Setup

Restart Zen Browser. The config files are symlinked, so any edits you make
to this repo will apply after restarting the browser.

## Manual Profile Location

If the scripts can't find your profile:

- **Linux:** `~/.zen/`
- **Windows:** `%APPDATA%\zen\`

Then look for folders ending in `.default` or `.default-release`.
Open `about:profiles` in Zen to see exactly which profile is active.
