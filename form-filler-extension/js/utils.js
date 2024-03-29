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

const ServiceURL_DEV = "http://localhost:8080/ws";
const serviceUrl_PROD = "https://besie.servehttp.com/ws";
const serviceUrl = serviceUrl_PROD;
export const HTML_PAYLOAD_ENABLED = false;

var stompClient;
export async function connect() {
    let socket = new SockJS(serviceUrl);
    stompClient = Stomp.over(socket);
    stompClient.connect({'Access-Control-Allow-Origin':'*'}, function (frame) {
        stompClient.subscribe('/topic/filled-form', async function (frame) {
            let data = JSON.parse(frame.body); 
            console.log(data);
            let activeTab = await getActiveTabURL();
            
            chrome.tabs.sendMessage(activeTab.id, {
                mode: "FORM_FILL",
                data: JSON.parse(data.content)
            });
        });
    });
}

function disconnect() {
    if (stompClient !== null) {
        stompClient.disconnect();
    }
    console.log("Disconnected");
}

export function sendFormPayload(pinNumber, form) {
    let payload = {
        form: form,
        pin: pinNumber,
    };
    console.log(JSON.stringify(payload));
    stompClient.send("/app/fill", {}, JSON.stringify(payload));
}

export function sendHtmlPayload(pinNumber, html) {
    let payload = {
        formHtml: html,
        pin: pinNumber,
        shouldExtractFromHtml: true
    };
    console.log(JSON.stringify(payload));
    stompClient.send("/app/fill", {}, JSON.stringify(payload));
}
