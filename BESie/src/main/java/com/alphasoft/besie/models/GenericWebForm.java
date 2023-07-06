package com.alphasoft.besie.models;

import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.Map;

public class GenericWebForm {
    // Map<String Object>payload field
    private String payload;
    private ObjectMapper objectMapper;

    GenericWebForm() {
        this.objectMapper = new ObjectMapper();
    }

    GenericWebForm(String payload) {
        this.payload = payload;
        this.objectMapper = new ObjectMapper();
    }

    public String getPayload() {
        return this.payload;
    }

    //write a method that uses jackson to construct a generic Map<String, Object> from the payload string
    public Map<String, Object> getPayloadAsMap() {
        Map<String, Object> parsedJsonFormMap = null;
        try {
            parsedJsonFormMap = objectMapper.readValue(this.payload, Map.class);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return parsedJsonFormMap;
    }

    public void setPayload(String payload) {
        this.payload = payload;
    }
}
