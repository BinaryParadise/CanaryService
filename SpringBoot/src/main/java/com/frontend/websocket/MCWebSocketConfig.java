package com.frontend.websocket;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;
import org.springframework.web.socket.server.jetty.JettyRequestUpgradeStrategy;
import org.springframework.web.socket.server.standard.ServletServerContainerFactoryBean;
import org.springframework.web.socket.server.support.DefaultHandshakeHandler;

@Configuration
@EnableWebSocket
public class MCWebSocketConfig implements WebSocketConfigurer {

  @Override
  public void registerWebSocketHandlers(WebSocketHandlerRegistry webSocketHandlerRegistry) {
    webSocketHandlerRegistry.addHandler(myHandler(), "/channel/{source}/{deviceid}")
      .setAllowedOrigins("*")
      .addInterceptors(new MCMessageWebSocketInterceptor());
  }

  @Bean
  public ServletServerContainerFactoryBean createWebSocketContainer() {
    ServletServerContainerFactoryBean container = new ServletServerContainerFactoryBean();
    container.setMaxTextMessageBufferSize(5 * 1024 * 1024);
    container.setMaxBinaryMessageBufferSize(5 * 1024 * 1024);
    container.setMaxSessionIdleTimeout(15 * 60000L);
    return container;
  }

  public MCWebSocketHandler myHandler() {
    return new MCWebSocketHandler();
  }
}
