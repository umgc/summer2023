/*
    This functions gets the current activity browser tab.

    From: https://github.com/raman-at-pieces/youtube-bookmaker-finished-code
*/
export async function getActiveTabURL() {
    const tabs = await chrome.tabs.query({
        currentWindow: true,
        active: true
    });

    return tabs[0];
}
