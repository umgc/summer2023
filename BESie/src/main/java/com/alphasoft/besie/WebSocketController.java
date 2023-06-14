package com.alphasoft.besie;

import com.alphasoft.besie.models.GenericWebForm;
import com.alphasoft.besie.models.OutboundMessage;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;
import org.springframework.web.util.HtmlUtils;

import java.util.Map;


@Controller
public class WebSocketController {

    private ObjectMapper objectMapper;
    @MessageMapping("/fill")
    @SendTo("/topic/form-model")
    public OutboundMessage greeting(String message) throws Exception {
        objectMapper = new ObjectMapper();
        Map<String, Object> payload = objectMapper.readValue(message, Map.class);
        Thread.sleep(1000); // simulated delay
        return new OutboundMessage("MESSAGE RECEIVED FROM TOPIC -> " + HtmlUtils.htmlEscape(payload.toString()) + " -- Original string payload: " + HtmlUtils.htmlEscape(message));
    }
}