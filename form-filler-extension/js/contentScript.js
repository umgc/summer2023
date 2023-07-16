chrome.runtime.onMessage.addListener((obj, sender, sendResponse) => {
    const { mode, data } = obj;

    if (mode === 'FORM_SCRAPE') {
        // Collect all input elements and put in a list of name : type
        let inputElements = document.getElementsByTagName("input");
        let textAreaInputs = document.getElementsByTagName("textarea");
        let selectInputs = document.getElementsByTagName("select");
        let allInputs = [];
        allInputs.push.apply(allInputs, inputElements);
        allInputs.push.apply(allInputs, textAreaInputs);
        allInputs.push.apply(allInputs, selectInputs);

        let formFields = [];
        for (const inputElement of allInputs) {
            let fieldEntry = {};

            // Filter out elements that are not fillable such as file select
            if (isUnfillableFieldType(inputElement)) {
                continue;
            } else if (isCheckableInputType(inputElement)) {
                // If field is radio button or checkbox, add radio/checkbox value to fieldEntry object
                let inputName = getInputName(inputElement);
                fieldEntry[inputName] = { "inputType": inputElement.type, "inputValue": inputElement.value };
                formFields.push(fieldEntry);
            } else if (isDropdownInputType(inputElement)) {
                // Handle dropdown fields
                let optionList = [];
                for (const optionElement of inputElement.children) {
                    if (optionElement.tagName.toLowerCase() === 'option'.toLowerCase()) {
                        optionList.push(optionElement.value);
                    }
                }
                let inputName = getInputName(inputElement);
                fieldEntry[inputName] = {"inputType": inputElement.tagName.toLowerCase(), "optionList": optionList}
                formFields.push(fieldEntry);

            } else {
                // All other fillable field types
                let inputName = getInputName(inputElement);
                fieldEntry[inputName] = inputElement.type;
                formFields.push(fieldEntry);
            }
        }
        sendResponse({ "formFields": formFields });
        return true;
    } else if (mode === 'FORM_FILL') {
        console.log("Populating data from BESie");
        
        for (const key of Object.keys(data.payload)) {
        
            console.log("Form field from BESie: " + key + ", " + data.payload[key]);

            const formElement = document.getElementsByName(key)[0];
            const isFormNameId = false;

            if (!formElement) {
                formElement = document.getElementById(key);
                isFormNameId = true;
            } else if (!formElement && !isFormNameId){
                continue;
            }

            if (formElement.tagName.toLowerCase() === 'input'
                || formElement.tagName.toLowerCase() === 'textarea') {

                if (isCheckableInputType(formElement)) {
                    checkElementByValue(formElement.type, data.payload[key]);
                } else {
                    formElement.value = data.payload[key];
                }

            } else if (formElement.tagName.toLowerCase() === 'select') {
                for (const optionElement of formElement.children) {
                    if (optionElement.value === data.payload[key]) {
                        optionElement.selected = true;
                        break;
                    }
                }
            }
        }
    }
});

function getInputName(inputElement) {
    return inputElement.name ? inputElement.name : inputElement.id;
}

function isUnfillableFieldType(inputElement) {
    return (inputElement.type === 'hidden'
        || inputElement.type === 'submit'
        || inputElement.type === 'button'
        || inputElement.type === 'file');
}

function isCheckableInputType(inputElement) {
    return inputElement.type === 'radio' || inputElement.type === 'checkbox';
}

function isDropdownInputType(inputElement) {
    return inputElement.tagName.toLowerCase() === 'select'.toLowerCase();
}

function checkElementByValue(type, value) {
    var elements = document.querySelectorAll('input[type="'+ type +'"]');
    for (var i = 0; i < elements.length; i++) {
        if (elements[i].value === value) {
            elements[i].checked = true;
        }
    }
}