import { getActiveTabURL } from "./helper.js";

$(document).ready(async function(){

    const activeTab = await getActiveTabURL();
    
    await chrome.scripting.executeScript({
        target: { tabId: activeTab.id },
        files: ["js/contentScript.js"]
    });

    $('#fillFormButton').click(function(e) {

        // send msg to contentScript requesting page scrape
        chrome.tabs.sendMessage(activeTab.id, {
            mode: "FORM_SCRAPE",
            data: null
        }).then((response) => {
            console.log("data from content script: " + response.formFields);
            window.formData = response.formFields;
        })
        // contentScript sends response back with form fields in JSON format (maybe with data types?)
        // and add to JSON payload

       
        // Get PIN number from popup UI and add to JSON payload

        // open websocket connection and send JSON payload to correct topic

        // receive response from topic and send message back to contentScript
        // contentScript populate form with values from the reponse
    
    });

});

