package com.alphasoft.besie.consumers;

import lombok.extern.log4j.Log4j2;
import org.springframework.jms.annotation.JmsListener;
import org.springframework.stereotype.Service;

@Service
@Log4j2
public class JmsConsumer {

    @JmsListener(destination = "/topic/form-model")
    public void receive(String message) {
        log.info("app/fill JMS Listener: Received message='{}'", message);
    }
}
