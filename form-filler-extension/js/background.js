/*
chrome.action.onClicked.addListener((tab) => {
    chrome.scripting.executeScript({
      target: { tabId: tab.id },
      files: ["js/contentScript.js"]
    });
    console.log("action.onClicked triggered");
  });

  /*
    "content_scripts": [
        {
            "matches": [
                "<all_urls>"
            ],
            "js": [
                "js/contentScript.js"
            ],
            "runAt": "document_start"
        }
    ],

    "content_scripts": [
        {
            "all_frames": true,
            "matches": ["<all_urls>"],
            "js": [
                "js/contentScript.js"
            ],
            "runAt": "document_end"
        }
    ],
  */