package com.frontend;

import com.frontend.domain.MCUserInfo;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Optional;

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
    return user == null ? null : user.getId();
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
}
