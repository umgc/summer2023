var stompClient = null;

function setConnected(connected) {
  $("#connect").prop("disabled", connected);
  $("#disconnect").prop("disabled", !connected);
  if (connected) {
    $("#consoleContent").show();
  } else {
    $("#consoleContent").hide();
  }
  $("#greetings").html("");
}

function connect() {
  var socket = new SockJS("/ws");
  stompClient = Stomp.over(socket);
  stompClient.connect({}, function (frame) {
    setConnected(true);
    console.log("Connected: " + frame);
    stompClient.subscribe("/topic/logs", function (greeting) {
      showLogs(JSON.parse(greeting.body).content);
    });
  });
}

function disconnect() {
  if (stompClient !== null) {
    stompClient.disconnect();
  }
  setConnected(false);
  console.log("Disconnected");
}

var logCounter = 0;

function showLogs(message) {
  var template = `<div class="panel panel-default">
    <div class="panel-heading">
      <div class="panel-title">
        <a role="button" data-toggle="collapse" href="#collapseEntry${logCounter}">
          <pre class="title-pre">
            ${message}
          >
        </a>
      </div>
    </div>
    <div id="collapseEntry${logCounter}" class="panel-collapse collapse">
      <div class="panel-body">
        ${message}
      </div>
    </div>
  </div>`;
  $("#consoleContent").append(template);
  logCounter++;
}

$(function () {
  $("form").on("submit", function (e) {
    e.preventDefault();
  });
  $("#connect").click(function () {
    connect();
  });
  $("#disconnect").click(function () {
    disconnect();
  });
  $("#clear").click(function () {
    $("#consoleContent").empty();
  });
  connect();
});
