console.log("we're up");
var stompClient = null;

function connect() {
    var socket = new SockJS("http://localhost:8080/ws");
    stompClient = Stomp.over(socket);
    stompClient.connect({'Access-Control-Allow-Origin':'*'}, function (frame) {
        console.log("Connected " + frame);
        //stompClient.subscribe('/topic/filled-form', function (msg) {
        //	console.log("from topic we have: " + msg);
        //});
    });
}



function sendForm(message) {
    let form = {
        id: 123456,
        first_name: "Rick",
        last_name: "Sanchez",
        zipcode: 21211,
        other: message
    };
    let formPayload = {
        payload: form
    }
    stompClient.send("/app/fill", {'key_of_header':'value_of_header'}, JSON.stringify(formPayload));
}

function disconnect() {
    stompClient.disconnect();
}

connect();
