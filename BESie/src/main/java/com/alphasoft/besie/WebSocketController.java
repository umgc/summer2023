package com.alphasoft.besie;

import com.alphasoft.besie.models.OutboundMessage;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.util.HtmlUtils;

import java.util.Map;


@Controller
//add CORS allowance for all origins
@CrossOrigin(origins = "*", allowedHeaders = "*")
public class WebSocketController {

    private ObjectMapper objectMapper;
    @MessageMapping("/fill") //this is actually /app/fill
    @SendTo("/topic/form-model")
    public OutboundMessage extensionToPhone(String message) throws Exception {
        objectMapper = new ObjectMapper();
        Map<String, Object> payload = objectMapper.readValue(message, Map.class);
        Thread.sleep(1000); // simulated delay
        return new OutboundMessage("MESSAGE RECEIVED FROM TOPIC FORM-MODEL -> " + HtmlUtils.htmlEscape(payload.toString()) + " -- Original string payload: " + HtmlUtils.htmlEscape(message));
    }


    @MessageMapping("/filled-form") //this is actually /app/filled-form
    @SendTo("/topic/filled-form")
    public String phoneToExtension(String message) throws Exception {
        objectMapper = new ObjectMapper();
        Map<String, Object> payload = objectMapper.readValue(message, Map.class);
        Thread.sleep(1000); // simulated delay
        return "MESSAGE RECEIVED FROM TOPIC FILLED-FORM -> " + HtmlUtils.htmlEscape(payload.toString()) + " -- Original string payload: " + HtmlUtils.htmlEscape(message);
    }

    @GetMapping("/ws/info/{t}")
    public String getInfo(@PathVariable("t") String t) {
        return "You're connected to BESsie's WebSocket server!";
    }
}