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
        form_id: 12345,
        first_name: "Oleksiy",
        last_name: "Blavat",
        zipcode: 21211,
        other: message
    };
    let formPayload = {
        payload: form
    }
    //change the value /app/filled-form to /app/fill to send to the other pipe
    stompClient.send("/app/filled-form", {'key_of_header':'value_of_header'}, JSON.stringify(formPayload));
}

function disconnect() {
    stompClient.disconnect();
}

connect();
