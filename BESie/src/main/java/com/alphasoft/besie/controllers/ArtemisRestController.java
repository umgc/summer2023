package com.alphasoft.besie.controllers;

import com.alphasoft.besie.producers.JmsProducer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ArtemisRestController {

    @Autowired
    private JmsProducer jmsProducer;

    @PostMapping("/send")
    public void sendDataToJms(@RequestBody String message) {
        jmsProducer.send(message);
    }
}
