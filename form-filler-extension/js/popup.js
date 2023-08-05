import { getActiveTabURL, connect, sendFormPayload, sendHtmlPayload, HTML_PAYLOAD_ENABLED } from "./utils.js";

$(document).ready(async function () {

    const activeTab = await getActiveTabURL();

    await chrome.scripting.executeScript({
        target: { tabId: activeTab.id },
        files: ["js/contentScript.js"]
    });

    connect();

    $('#fillFormButton').click(function (e) {
        if (validatePin()) {
            chrome.tabs.sendMessage(activeTab.id, {
                mode: "FORM_SCRAPE",
                data: null,
                enableHtmlPayload: HTML_PAYLOAD_ENABLED
            }).then(async (response) => {
                console.log("data from content script: " + response.formFields);
                let pinNumber = $("#pinNumber").val();
                if (HTML_PAYLOAD_ENABLED) {
                    sendHtmlPayload(pinNumber, response.htmlForms);
                } else {
                    sendFormPayload(pinNumber, response.formFields);
                }
            })
        }
    });

});

function validatePin() {
    let pin = $("#pinNumber").val();

    if (pin){
        return true;
    } else {
        alert("Please enter your code.");
        return false;
    }
}
