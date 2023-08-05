import json
import time
import logging
import boto3
import urllib.parse
from urllib.parse import urlparse
import websocket
from threading import Thread

Byte = {
    'LF': '\x0A',
    'NULL': '\x00'
}


class Frame:

    def __init__(self, command, headers, body):
        self.command = command
        self.headers = headers
        self.body = '' if body is None else body

    def __str__(self):
        lines = [self.command]
        skipContentLength = 'content-length' in self.headers
        if skipContentLength:
            del self.headers['content-length']

        for name in self.headers:
            value = self.headers[name]
            lines.append("" + name + ":" + value)

        if self.body is not None and not skipContentLength:
            lines.append("content-length:" + str(len(self.body)))

        lines.append(Byte['LF'] + self.body)
        return Byte['LF'].join(lines)

    @staticmethod
    def unmarshall_single(data):
        lines = data.split(Byte['LF'])

        command = lines[0].strip()
        headers = {}

        # get all headers
        i = 1
        while lines[i] != '':
            # get key, value from raw header
            (key, value) = lines[i].split(':')
            headers[key] = value
            i += 1

        # set body to None if there is no body
        body = None if lines[i + 1] == Byte['NULL'] else lines[i + 1][:-1]

        return Frame(command, headers, body)

    @staticmethod
    def marshall(command, headers, body):
        return str(Frame(command, headers, body)) + Byte['NULL']





VERSIONS = '1.0,1.1'


class Client:

    def __init__(self, url):

        self.url = url
        self.ws = websocket.WebSocketApp(self.url)
        self.ws.on_open = self._on_open
        self.ws.on_message = self._on_message
        self.ws.on_error = self._on_error
        self.ws.on_close = self._on_close

        self.opened = False

        self.connected = False

        self.counter = 0
        self.subscriptions = {}

        self._connectCallback = None
        self.errorCallback = None

    def _connect(self, timeout=0):
        thread = Thread(target=self.ws.run_forever)
        thread.daemon = True
        thread.start()

        total_ms = 0
        while self.opened is False:
            time.sleep(.25)
            total_ms += 250
            if 0 < timeout < total_ms:
                raise TimeoutError(f"Connection to {self.url} timed out")

    def _on_open(self, ws_app, *args):
        self.opened = True

    def _on_close(self, ws_app, *args):
        self.connected = False
        logging.debug("Whoops! Lost connection to " + self.ws.url)
        self._clean_up()

    def _on_error(self, ws_app, error, *args):
        logging.debug(error)

    def _on_message(self, ws_app, message, *args):
        logging.debug("\n<<< " + str(message))
        frame = Frame.unmarshall_single(message)
        _results = []
        if frame.command == "CONNECTED":
            self.connected = True
            logging.debug("connected to server " + self.url)
            if self._connectCallback is not None:
                _results.append(self._connectCallback(frame))
        elif frame.command == "MESSAGE":

            subscription = frame.headers['subscription']

            if subscription in self.subscriptions:
                onreceive = self.subscriptions[subscription]
                messageID = frame.headers['message-id']

                def ack(headers):
                    if headers is None:
                        headers = {}
                    return self.ack(messageID, subscription, headers)

                def nack(headers):
                    if headers is None:
                        headers = {}
                    return self.nack(messageID, subscription, headers)

                frame.ack = ack
                frame.nack = nack

                _results.append(onreceive(frame))
            else:
                info = "Unhandled received MESSAGE: " + str(frame)
                logging.debug(info)
                _results.append(info)
        elif frame.command == 'RECEIPT':
            pass
        elif frame.command == 'ERROR':
            if self.errorCallback is not None:
                _results.append(self.errorCallback(frame))
        else:
            info = "Unhandled received MESSAGE: " + frame.command
            logging.debug(info)
            _results.append(info)

        return _results

    def _transmit(self, command, headers, body=None):
        out = Frame.marshall(command, headers, body)
        logging.debug("\n>>> " + out)
        self.ws.send(out)

    def connect(self, login=None, passcode=None, headers=None, connectCallback=None, errorCallback=None,
                timeout=0):

        logging.debug("Opening web socket...")
        self._connect(timeout)

        headers = headers if headers is not None else {}
        headers['host'] = self.url
        headers['accept-version'] = VERSIONS
        headers['heart-beat'] = '10000,10000'

        if login is not None:
            headers['login'] = login
        if passcode is not None:
            headers['passcode'] = passcode

        self._connectCallback = connectCallback
        self.errorCallback = errorCallback

        self._transmit('CONNECT', headers)

    def disconnect(self, disconnectCallback=None, headers=None):
        if headers is None:
            headers = {}

        self._transmit("DISCONNECT", headers)
        self.ws.on_close = None
        self.ws.close()
        self._clean_up()

        if disconnectCallback is not None:
            disconnectCallback()

    def _clean_up(self):
        self.connected = False

    def send(self, destination, headers=None, body=None):
        if headers is None:
            headers = {}
        if body is None:
            body = ''
        headers['destination'] = destination
        return self._transmit("SEND", headers, body)

    def subscribe(self, destination, callback=None, headers=None):
        if headers is None:
            headers = {}
        if 'id' not in headers:
            headers["id"] = "sub-" + str(self.counter)
            self.counter += 1
        headers['destination'] = destination
        self.subscriptions[headers["id"]] = callback
        self._transmit("SUBSCRIBE", headers)

        def unsubscribe():
            self.unsubscribe(headers["id"])

        return headers["id"], unsubscribe

    def unsubscribe(self, id):
        del self.subscriptions[id]
        return self._transmit("UNSUBSCRIBE", {
            "id": id
        })

    def ack(self, message_id, subscription, headers):
        if headers is None:
            headers = {}
        headers["message-id"] = message_id
        headers['subscription'] = subscription
        return self._transmit("ACK", headers)

    def nack(self, message_id, subscription, headers):
        if headers is None:
            headers = {}
        headers["message-id"] = message_id
        headers['subscription'] = subscription
        return self._transmit("NACK", headers)



def print_frame(frame):
    print(json.loads(frame.body))


def lambda_handler(event, context):
    #define s3 client
    s3_client = boto3.client('s3')
    
    
    #get bucket and key from event trigger
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    key = urllib.parse.unquote_plus(key, encoding='utf8')
    
    
    #read json file contents
    file = s3_client.get_object(Bucket=bucket, Key=key)
    file_content = file["Body"].read().decode()
    transcript_body = json.loads(file_content)
    print(json.dumps(transcript_body))
    
    #establish websocket connection
    LOG_FORMAT = "%(asctime)s - %(levelname)s - %(message)s"
    logging.basicConfig(level=logging.DEBUG, format=LOG_FORMAT)
    # client = Client("ws://44.202.25.184:8080/ws/websocket")
    client = Client("wss://besie.servehttp.com:443/ws/websocket")

    # connect to the endpoint
    client.connect(login="name",
                   passcode="45C82C421EBA87C8131E220F878E4145",
                   timeout=0)


    # send msg to channel for transcription
    client.send("/app/transcript", body=json.dumps(transcript_body))


    client.disconnect()
    

    
    
    
    
    return {
        'statusCode': 200,
        'body': json.dumps(transcript_body)
    }
