chrome.runtime.onMessage.addListener((obj, sender, sendResponse) => {
    const {mode, data} = obj;

    if (mode === 'FORM_SCRAPE') {
        // Collect all input elements and put in a list of name : type
        let inputElements = document.getElementsByTagName("input");
        let textAreaInputs = document.getElementsByTagName("textarea");
        let allInputs = [];
        allInputs.push.apply(allInputs, inputElements);
        allInputs.push.apply(allInputs, textAreaInputs);

        let formFields = [];
        for (const inputElement of allInputs) {
            if (inputElement.type === 'hidden' 
                || inputElement.type === 'submit' 
                || inputElement.type === 'button'
                || inputElement.type === 'radio'
                || inputElement.type === 'checkbox'
                || inputElement.type === 'file') {
                continue;
            }
            fieldEntry = {};
            fieldEntry[inputElement.name] = inputElement.type;
            formFields.push(fieldEntry);
        }
        sendResponse({"formFields": formFields});
        return true;
    } else if (mode === 'FORM_FILL') {
        console.log("Form values from BESie -> " + data.payload);
        for (const key of Object.keys(data.payload)) {
            const formElement = document.getElementsByName(key)[0];
            if (formElement) {
                formElement.value = data.payload[key];
            }
        }
    }
});
