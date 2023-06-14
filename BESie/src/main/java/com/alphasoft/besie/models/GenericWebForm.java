package com.alphasoft.besie.models;

import java.util.Map;

public class GenericWebForm {
    // Map<String Object>payload field
    private String payload;

    GenericWebForm() {
    }

    GenericWebForm(String payload) {
        this.payload = payload;
    }

    public String getPayload() {
        return this.payload;
    }

    public void setPayload(String payload) {
        this.payload = payload;
    }
}
