package com.frontend;

import com.frontend.domain.MCUserInfo;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.Optional;

public class Global {
  static String _loginSessionKey = "login_session";
  static Long updateTime = System.currentTimeMillis();

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
   * 数据最后更新时间
   * @return
   */
  public static Long getUpdateTime() {
    return updateTime;
  }

  /**
   * 更新时间
   */
  public static void update() {
    Global.updateTime = System.currentTimeMillis();
  }
}
