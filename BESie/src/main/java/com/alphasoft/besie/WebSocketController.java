package com.alphasoft.besie;

import com.alphasoft.besie.models.GenericWebForm;
import com.alphasoft.besie.models.OutboundMessage;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.log4j.Log4j2;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.util.HtmlUtils;

import java.util.Map;


@Log4j2
@Controller
//add CORS allowance for all origins
@CrossOrigin(origins = "*", allowedHeaders = "*")
public class WebSocketController {

    private ObjectMapper objectMapper;
    @MessageMapping("/fill") //this is actually /app/fill
    @SendTo("/topic/form-model")
    public OutboundMessage extensionToPhone(String form) throws InterruptedException {
        Map <String, Object> parsedJsonFormMap = parseForm(form);
        log.info("parsed json form map - extensionToPhone: {}", parsedJsonFormMap.toString());
        Thread.sleep(2000); // simulated delay
        //sending message to FORM-MODEL topic
        return new OutboundMessage(form);
    }


    @MessageMapping("/filled-form") //this is actually /app/filled-form
    @SendTo("/topic/filled-form")
    public OutboundMessage phoneToExtension(String form) throws InterruptedException {
        Map <String, Object> parsedJsonFormMap = parseForm(form);
        log.info("parsed json form map - phoneToExtension: {}", parsedJsonFormMap.toString());
        Thread.sleep(2000); // simulated delay
        //sending message to FILLED-FORM topic
        return new OutboundMessage(form);
    }

    @GetMapping("/ws/info/{t}")
    public String getInfo(@PathVariable("t") String t) {
        return "You're connected to BESsie's WebSocket server!";
    }

    private Map<String, Object> parseForm(String json) {
        objectMapper = new ObjectMapper();
        Map <String, Object> parsedJsonFormMap = null;
        try {
            parsedJsonFormMap = objectMapper.readValue(json, Map.class);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }
        return parsedJsonFormMap;
    }
}