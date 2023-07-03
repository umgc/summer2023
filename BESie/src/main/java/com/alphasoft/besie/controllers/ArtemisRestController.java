package com.alphasoft.besie.controllers;

import com.alphasoft.besie.models.OutboundMessage;
import com.alphasoft.besie.producers.JmsProducer;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jms.core.JmsTemplate;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Slf4j
public class ArtemisRestController {

    @Autowired
    private JmsTemplate jmsTemplate;

    @PostMapping("/send")
    public void sendDataToJms(@RequestBody String message) {
        jmsTemplate.convertAndSend("topic/form-model", message);
        log.info("Message {} sent successfully to topic/form-model", message);
    }
}
