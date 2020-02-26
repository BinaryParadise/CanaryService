package com.frontend.websocket;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

@Configuration
@EnableWebSocket
public class MCWebSocketConfig implements WebSocketConfigurer {
  @Override
  public void registerWebSocketHandlers(WebSocketHandlerRegistry webSocketHandlerRegistry) {
    webSocketHandlerRegistry.addHandler(myHandler(), "/channel/{source}/{deviceid}")
      .setAllowedOrigins("*")
      .addInterceptors(new MCMessageWebSocketInterceptor());
  }

  public MCWebSocketHandler myHandler() {
    return new MCWebSocketHandler();
  }
}
