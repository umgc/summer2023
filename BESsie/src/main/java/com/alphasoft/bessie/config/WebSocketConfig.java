package com.alphasoft.bessie.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

@Configuration
@EnableWebSocketMessageBroker //enables WebSocket message handling, backed by a message broker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {
    @Override
    public void configureMessageBroker(org.springframework.messaging.simp.config.MessageBrokerRegistry config) {
        config.enableSimpleBroker("/topic"); //enables a simple memory-based message broker to carry the greeting messages back to the client on destinations prefixed with /topic
        config.setApplicationDestinationPrefixes("/app"); //designates the /app prefix for messages that are bound for methods annotated with @MessageMapping
    }

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry){
        registry.addEndpoint("/websocket").withSockJS(); //registers the /fill endpoint, enabling SockJS fallback options so that alternate transports may be used if WebSocket is not available
    }
}
