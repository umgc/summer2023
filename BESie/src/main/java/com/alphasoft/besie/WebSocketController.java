package com.alphasoft.besie;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;
import org.springframework.web.util.HtmlUtils;

@Controller
public class WebSocketController {

    @MessageMapping("/fill")
    @SendTo("/topic/form-model")
    public OutboundMessage greeting(HelloMessage message) throws Exception {
        Thread.sleep(1000); // simulated delay
        return new OutboundMessage("MODEL -> " + HtmlUtils.htmlEscape(message.getName()) + "!");
    }
}

