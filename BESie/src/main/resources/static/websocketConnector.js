var stompClient = null;
var stompClient2 = null;

function setConnected(connected) {
    $("#connect").prop("disabled", connected);
    $("#disconnect").prop("disabled", !connected);
    if (connected) {
        $("#conversation").show();
    }
    else {
        $("#conversation").hide();
    }
    $("#greetings").html("");
}

function connect() {
    let socket = new SockJS('/ws');
    let socket2 = new SockJS('/ws');
    stompClient = Stomp.over(socket);
    stompClient2 = Stomp.over(socket2);
    stompClient.connect({'Access-Control-Allow-Origin':'*'}, function (frame) {
        setConnected(true);
        console.log('Connected: ' + frame);
        stompClient.subscribe('/topic/form-model', function (msg) {
            showMessages("From /topic/form-model: " + JSON.parse(msg.body).content);
        });
    });
    //connection to the second pipe
    stompClient2.connect({'Access-Control-Allow-Origin':'*'}, function (frame) {
        setConnected(true);
        console.log('Connected: ' + frame);
        stompClient2.subscribe('/topic/filled-form', function (msg) {
            showMessages("From /topic/filled-form: " + JSON.parse(msg.body).content);
        });
    });
}

function disconnect() {
    if (stompClient !== null || stompClient2 !== null) {
        stompClient.disconnect();
        stompClient2.disconnect();
    }
    setConnected(false);
    console.log("Disconnected both clients");
}

function sendFormPayload() {
    let payload = {
        pin: $("#pin").val(),
        firstName: "string",
        lastName: "string",
        zipcode: "integer",
        other: $('#payload').val()
    }
    console.log(JSON.stringify(payload));
    stompClient.send("/app/fill", {}, JSON.stringify(payload));
}

function sendFormPayload2() {
    let payload = {
        firstName: "Jane",
        lastName: "Smith",
        zipcode: 21211,
        other: $('#payload2').val()
    }
    console.log(JSON.stringify(payload));
    stompClient2.send("/app/filled-form", {}, JSON.stringify(payload));
}

function showMessages(message) {
    $("#conversations").append("<tr><td>" + message + "</td></tr>");
}

$(function () {
    $("form").on('submit', function (e) {
        e.preventDefault();
    });
    $( "#connect" ).click(function() { connect(); });
    $( "#disconnect" ).click(function() { disconnect(); });
    $( "#send" ).click(function() { sendFormPayload(); });
    $( "#send2" ).click(function () {sendFormPayload2();});
});

