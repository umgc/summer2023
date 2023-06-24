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

const serviceUrl = "http://localhost:8080/ws";
var stompClient;
export async function connect() {
    let socket = new SockJS(serviceUrl);
    stompClient = Stomp.over(socket);
    stompClient.connect({'Access-Control-Allow-Origin':'*'}, function (frame) {
        stompClient.subscribe('/topic/form-model', function (frame) {
            //let data = JSON.parse(frame.content).content; 
            //console.log(data);
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
        payload: form,
        pin: pinNumber,
        formId: 112554665
    };
    console.log(JSON.stringify(payload));
    stompClient.send("/app/fill", {}, JSON.stringify(payload));
}
