# Zen Browser Config

Personal configuration files for Zen Browser.

## Files

- `userChrome.css` - UI customizations (hide elements, context menu cleanup, compact mode)
- `user.js` - Browser preferences (devtools, UI settings)

## Setup

### Linux
```bash
./scripts/setup-linux.sh
```

### Windows
Run `scripts/setup-windows.ps1`.

Restart Zen Browser after setup. Config files are symlinked, so edits apply on browser restart.
