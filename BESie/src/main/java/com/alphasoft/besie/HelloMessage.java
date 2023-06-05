package com.alphasoft.besie;

public class HelloMessage {
    // write a private field called name and getter and setter methods for it
    // write a constructor that takes a String parameter called name and sets the name field to it
    // write a default constructor that sets the name field to null
    // write a toString method that returns a String representation of the object
    // write an equals method that takes an Object parameter and returns true if the parameter is a HelloMessage object and has the same name field as this object

    private String name;

    public HelloMessage() {
        this.name = null;
    }

    public HelloMessage(String name) {
        this.name = name;
    }


    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String toString() {
        return "HelloMessage[name=" + this.name + "]";
    }

    public boolean equals(Object o) {
        if (o instanceof HelloMessage) {
            HelloMessage other = (HelloMessage) o;
            return this.name.equals(other.name);
        } else {
            return false;
        }
    }
}
