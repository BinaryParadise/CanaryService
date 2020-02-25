package com.frontend.websocket;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.frontend.domain.MCAppInfo;
import com.frontend.mappers.ProjectMapper;
import com.frontend.models.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.websocket.*;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.concurrent.CopyOnWriteArraySet;

//@ServerEndpoint(value = "/channel/{source}/{deviceid}")
//@Component
public class WCWebSocket {
    Logger logger = LoggerFactory.getLogger(WCWebSocket.class);
    // 静态变量，用来记录当前在线连接数。应该把它设计成线程安全的。
    private static int onlineCount = 0;

    // concurrent包的线程安全Set，用来存放每个客户端对应的WCWebScoket对象。
    private static CopyOnWriteArraySet<WCWebSocket> webSocketSet = new CopyOnWriteArraySet();

    static HashMap<Integer, Session> sessions = new HashMap<>();

    /**
     * 网页端监控集合
     */
    private static HashMap<Integer, Session> webMonitors = new HashMap<>();

    /**
     * 客户端监控集合
     */
    static HashMap<String, Session> clientMonitors = new HashMap<>();

    /**
     * 设备列表
     */
    private static HashMap<String, MCDeviceInfo> devices = new HashMap<>();

    // 与某个客户端的连接会话，需要通过它来给客户端发送数据
    private Session session;
    StringBuilder strBuilder;

    private static ProjectMapper appsMapper;

    @Autowired
    public void setAppsMapper(ProjectMapper appsMapper) {
        WCWebSocket.appsMapper = appsMapper;
    }

    /**
     * 连接建立成功调用的方法
     */
    @OnOpen
    public void onOpen(@PathParam(value = "source") String source, @PathParam(value = "deviceid") String deviceid, Session session) {
        this.session = session;
        webSocketSet.add(this);
        if (source.equalsIgnoreCase("web")) {
            webMonitors.put(session.hashCode(), session);
            if (clientMonitors.containsKey(deviceid)) {
                session.getUserProperties().put("bindSession", clientMonitors.get(deviceid));
            }
        } else {
            clientMonitors.put(deviceid, session);
        }
        strBuilder = new StringBuilder();
        logger.info("["+this.hashCode() + "]-["+source+":"+session.hashCode()+"]创建新连接，当前在线：" + getOnlineCount());
    }

    /**
     * 连接关闭调用的方法
     */
    @OnClose
    public void onClose() {
        logger.info(this.session.hashCode() + "连接关闭，当前在线：" + getOnlineCount());
        String source = this.session.getPathParameters().get("source");
        sessions.remove(this.session.hashCode());
        String deviceId = session.getPathParameters().get("deviceid");
        if (source.equalsIgnoreCase("web")) {
            webMonitors.remove(this.session.hashCode());
        } else {
            devices.remove(deviceId);
        }
        webSocketSet.remove(this);
    }

    @OnError
    public void onError(Session session, Throwable error) {
        logger.error("", error);
        onClose();
    }

    /**
     * 收到客户端消息后调用的方法
     *
     * @param message 客户端发送过来的消息
     */
    @OnMessage
    public synchronized void onMessage(byte[] b, boolean last, Session session) {
        if (last) {
            strBuilder.append(new String(b));
            logger.info("客户端请求：" + strBuilder.toString());
        } else {
            strBuilder.append(new String(b));
            return;
        }
        MCMessage msg = JSON.parseObject(strBuilder.toString(), MCMessage.class);
        strBuilder.delete(0, strBuilder.length());
        if (msg != null) {
            int type = msg.getType();
            try {
                Method method = this.getClass().getDeclaredMethod("transferMessage" + type, MCMessage.class, Session.class);
                String message = (String)method.invoke(this, msg, session);
                if (message != null) {
                    logger.info("服务端响应：" + message);
                    sendMessage(message);
                }
            } catch (NoSuchMethodException e) {
                logger.error("找不到消息类型:" + type, e);
            } catch (IllegalAccessException e) {
                logger.error(e.getLocalizedMessage(), e.getCause());
            } catch (InvocationTargetException e) {
                logger.error(e.getLocalizedMessage(), e.getCause());
            }
        }
    }

    public void sendMessage(String message) {
        sendMessage(message, this.session);
    }

    public Boolean sendMessage(String message, Session session) {
        if (session != null && session.isOpen()) {
            ByteBuffer byteBuffer = ByteBuffer.wrap(message.getBytes());
            session.getAsyncRemote().sendBinary(byteBuffer);
            return true;
        }
        return false;
    }

    /**
     * 开启或关闭日志监控
     * @param msg
     * @param session
     */
    void transferMessage1(MCMessage msg, Session session) {
        Boolean logger = ((JSONObject)msg.getData()).getBoolean("logger");
        session.getUserProperties().put("logger", logger);
    }

    /**
     * 注册设备信息 - invoke
     */
    void transferMessage10(MCMessage msg, Session session) {
        MCDeviceInfo info = ((JSON) msg.getData()).toJavaObject(MCDeviceInfo.class);
        if (info.getDeviceId() == null) {
            logger.error("注册设备必须包含deviceId");
        } else {
            MCAppInfo appInfo = appsMapper.findByAppKey(info.getAppKey());
            if (appInfo!=null) {
                info.setAppId(appInfo.getId());
            }
            session.getUserProperties().put("device", info);
            devices.put(info.getDeviceId(), info);
            logger.info("设备注册成功: "+info.getDeviceId());
        }
    }

  /**
   * 查询设备信息 - invoke
   */
  void transferMessage11(MCMessage msg, Session session) {
    Session destSession = (Session) session.getUserProperties().get("bindSession");
    if (destSession != null) {
      destSession.getUserProperties().put("bindSession", session);
    }
    if (!sendMessage(JSON.toJSONString(msg), destSession)) {
      msg.setCode(-1);
      msg.setMsg("设备貌似离线了耶...");
      sendMessage(JSON.toJSONString(msg), session);
    }
  }

  /**
   * 设备查询结果 - invoke
   */
  void transferMessage12(MCMessage msg, Session session) {
    Session destSession = (Session) session.getUserProperties().get("bindSession");
    sendMessage(JSON.toJSONString(msg), destSession);
  }

    /**
     * 向设备发送数据库查询请求
     *
     * @param msg
     */
    void transferMessage20(MCMessage msg, Session session) {
        Session destSession = (Session) session.getUserProperties().get("bindSession");
        if (destSession != null) {
            destSession.getUserProperties().put("bindSession", session);
        }
        if (!sendMessage(JSON.toJSONString(msg), destSession)) {
            msg.setCode(-1);
            msg.setType(21);
            msg.setMsg("设备貌似离线了耶...");
            sendMessage(JSON.toJSONString(msg), session);
        }
    }

    /**
     * 数据库查询的结果
     *
     * @param msg
     */
    public void transferMessage21(MCMessage msg, Session session) {
        Session destSession = (Session) session.getUserProperties().get("bindSession");
        sendMessage(JSON.toJSONString(msg), destSession);
    }

    /**
     * 客户端日志
     * @param msg
     */
    public void transferMessage30(MCMessage msg, Session session) {
      LogMessage logMessage = JSONObject.parseObject(msg.getData().toString(), LogMessage.class);
      if (logMessage != null) {
        logMessage.setAppId(this.getAppId(logMessage.getDeviceId()));
        for (Session destSesion : webMonitors.values()) {
          String deviceId = session.getPathParameters().get("deviceid");
          if (deviceId.equalsIgnoreCase(destSesion.getPathParameters().get("deviceid"))
            && destSesion.isOpen()
            && (Boolean) destSesion.getUserProperties().get("logger")) {
            sendMessage(JSON.toJSONString(msg), destSesion);
          }
        }
      }
    }

    Integer getAppId(String deviceId) {
        MCDeviceInfo device = devices.get(deviceId);
        if (device != null) {
            return device.getAppId();
        }
        return 0;
    }

    public static synchronized String getOnlineCount() {
        StringBuilder sb = new StringBuilder();
        for (Session session:webMonitors.values()) {
            if (sb.length() == 0) {
                sb.append(sessions.size()+"（'"+ session.hashCode()+"'");
            } else {
                sb.append(", '"+session.hashCode()+"'");
            }
        }
        sb.append("）");
        sb.append(" 客户端"+clientMonitors.values().toArray().length);
        return sb.toString();
    }

    public static List<MCDeviceInfo> getDevices(String appKey) {
        List<MCDeviceInfo> list = new ArrayList<>();
        for(MCDeviceInfo device : devices.values()) {
            if (device.getAppKey().compareTo(appKey) == 0) {
                list.add(device);
            }
        }
        return list;
    }
}
