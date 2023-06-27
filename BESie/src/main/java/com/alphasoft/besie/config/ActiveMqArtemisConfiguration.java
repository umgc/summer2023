package com.alphasoft.besie.config;

import jakarta.jms.Connection;
import jakarta.jms.ConnectionFactory;
import jakarta.jms.JMSException;
import org.apache.activemq.artemis.api.core.TransportConfiguration;
import org.apache.activemq.artemis.jms.client.ActiveMQJMSConnectionFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.autoconfigure.jms.artemis.ArtemisConfigurationCustomizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ActiveMqArtemisConfiguration {

    @Value("${spring.artemis.broker-url}")
    private String brokerUrl;

    /**@Value("${spring.artemis.user}")
    private String user;

    @Value("${spring.artemis.password}")
    private String password;
     **/


    @Bean
    public ConnectionFactory connectionFactory() {
        //return new ActiveMQConnectionFactory(user,password,brokerUrl);
        //return new ActiveMQJMSConnectionFactory(user,password,brokerUrl);
        return new ActiveMQJMSConnectionFactory(brokerUrl);
    }

    @Bean
    public CommandLineRunner validateConnectionFactory(ConnectionFactory connectionFactory) {
        return args -> {
            try (Connection connection = connectionFactory.createConnection()) {
                System.out.println("Connected to Artemis broker at " + connection.getClientID());
            } catch (JMSException e) {
                System.err.println("Failed to connect to Artemis broker: " + e.getMessage());
                e.printStackTrace();
            }
        };
    }


}
