console.log('content script executed');
chrome.runtime.onMessage.addListener((obj, sender, sendResponse) => {

    const {mode, data} = obj;

    if (mode === 'FORM_SCRAPE') {
        // convert form to JSON
        let form = document.querySelector('form');
        let formData = new FormData(form);
        let formFields = [];
        for (const key of formData.keys()) { 
            console.log(key + " : " + formData.get(key)); 
            formFields.push(formData.get(key));
        }

        sendResponse({"formFields": formFields});
        return true;
    } else if (mode === 'FORM_FILL') {
        // fill form
    }
});
