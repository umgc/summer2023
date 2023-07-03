package com.alphasoft.besie;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.messaging.simp.stomp.StompReactorNettyCodec;
import org.springframework.messaging.tcp.reactor.ReactorNettyTcpClient;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;
import reactor.netty.tcp.SslProvider;

import java.net.InetSocketAddress;

@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    @Override
    public void configureMessageBroker(MessageBrokerRegistry config) {
        //config.enableSimpleBroker("/topic");
        config.setApplicationDestinationPrefixes("/app");
        config.enableStompBrokerRelay("/topic", "/queue")
                .setTcpClient(createTcpClient());
    }

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/ws")
                .setAllowedOriginPatterns("*")
                .withSockJS();
    }

    private ReactorNettyTcpClient<byte[]> createTcpClient() {
        ReactorNettyTcpClient<byte[]> client = new ReactorNettyTcpClient<>(tcpClient -> tcpClient
                .host("0.0.0.0")
                .port(61613)
                .secure(SslProvider.defaultClientProvider()), new StompReactorNettyCodec());

        return client;
    }
}

