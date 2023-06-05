package com.alphasoft.bessie.controllers;

import com.alphasoft.bessie.models.FilledWebFormModel;
import com.alphasoft.bessie.models.WebFormModel;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.web.util.HtmlUtils;

public class FillController {
    @MessageMapping("/fill")
    @SendTo("/topic/fill")
    public WebFormModel fill(FilledWebFormModel webFormModel) throws Exception {
        Thread.sleep(1000); // simulated delay
        return new WebFormModel("Hello, " + HtmlUtils.htmlEscape(webFormModel.getName()) + "!");
    }
}
