chrome.runtime.onMessage.addListener((obj, sender, sendResponse) => {
    const {mode, data} = obj;

    if (mode === 'FORM_SCRAPE') {
        // Collect all input elements and put in a list of name : type
        let inputElements = document.getElementsByTagName("input");
        let formFields = [];
        for (const inputElement of inputElements) {
            if (inputElement.type === 'hidden' 
                || inputElement.type === 'submit' 
                || inputElement.type === 'button') {
                continue;
            }
            fieldEntry = {};
            fieldEntry[inputElement.name] = inputElement.type;
            formFields.push(fieldEntry);
        }
        sendResponse({"formFields": formFields});
        return true;
    } else if (mode === 'FORM_FILL') {
        // TODO fill form
    }
});
