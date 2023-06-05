package com.alphasoft.besie;

public class OutboundMessage {
    //private variable content with getter and setter

    private String content;

    public OutboundMessage() {
    }

    public OutboundMessage(String content) {
        this.content = content;
    }

    public String getContent() {
        return this.content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String toString() {
        return "OutboundMessage[content=" + this.content + "]";
    }

    public boolean equals(Object o) {
        if (o instanceof OutboundMessage) {
            OutboundMessage other = (OutboundMessage) o;
            return this.content.equals(other.content);
        } else {
            return false;
        }
    }
}
