package com.frontend;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.frontend.domain.MCUserInfo;
import com.frontend.models.MCDeviceInfo;
import com.frontend.models.MCMessage;
import com.frontend.utils.MessageType;
import com.frontend.websocket.MCWebSocketHandler;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.socket.BinaryMessage;
import org.springframework.web.socket.PingMessage;
import org.springframework.web.socket.WebSocketSession;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.nio.ByteBuffer;

public class Global {
  static String _loginSessionKey = "login_session";

  /**
   * 获取当前请求session
   *
   * @return
   */
  public static HttpServletRequest getHttpServletRequest() {
    HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder
      .getRequestAttributes())
      .getRequest();
    return request;
  }

  /**
   * 获取当前请求session
   *
   * @return
   */
  public static HttpSession getHttpSession() {
    return getHttpServletRequest().getSession();
  }

  public static MCUserInfo getUser() {
    return (MCUserInfo) getHttpSession().getAttribute("user");
  }

  public static Integer getAppId() {
    MCUserInfo user = getUser();
    return user == null || user.getApp() == null ? null : user.getApp().getId();
  }

  /**
   * AppSecret
   * @return
   */
  public static String getIdentify() {
    MCUserInfo user = getUser();
    if (user == null || user.getApp() == null) {
      return null;
    }
    return user.getApp().getIdentify();
  }

  /**
   * 更新时间
   */
  public static void update() {
    String appSecret = getIdentify();
    if (appSecret == null) {
      return;
    }
    for (MCDeviceInfo device: MCWebSocketHandler.devices.values()) {
      if (device.getAppKey().equalsIgnoreCase(appSecret)) {
        WebSocketSession session = MCWebSocketHandler.clientSessions.get(device.getDeviceId());
        if (session != null && session.isOpen()) {
          try {
            MCMessage message = new MCMessage();
            message.setType(MessageType.Update);
            message.setMsg("配置需要更新...");
            message.setData(JSONObject.parse("{\"updatetime\":"+System.currentTimeMillis()+"}"));
            session.sendMessage(new BinaryMessage(ByteBuffer.wrap(JSON.toJSONBytes(message))));
          } catch (IOException e) {
            e.printStackTrace();
          }
        }
      }
    }
  }
}
