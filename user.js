// ==========================================================================
// ZEN BROWSER - USER PREFERENCES
// ==========================================================================

// --- ENABLE DEVTOOLS --- ref: https://docs.zen-browser.app/guides/live-editing
user_pref("devtools.debugger.remote-enabled", true);
user_pref("devtools.chrome.enabled", true);
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// --- UI CUSTOMIZATION ---
user_pref("zen.view.hide-window-controls", false);  // Keep top bar visible
user_pref("browser.tabs.dragDrop.pinInteractionCue.delayMS", 99999);  // Disable drag-to-pin

// --- DISABLE FIRST-RUN STUFF ---
// user_pref("browser.aboutwelcome.enabled", false);  // Skip welcome page on new profiles
