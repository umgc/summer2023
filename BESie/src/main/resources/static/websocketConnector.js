var socket = new SockJS('http://localhost:8080/ws');
var stompClient = Stomp.over(socket);

stompClient.connect({}, function(frame) {
    console.log('Connected: ' + frame);
    stompClient.subscribe('/topic/greetings', function(greeting){
        console.log(JSON.parse(greeting.body).content);
    });
});

// Send a message
stompClient.send("/app/hello", {}, JSON.stringify({'name': "MyName"}));
