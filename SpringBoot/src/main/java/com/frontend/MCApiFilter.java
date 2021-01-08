package com.frontend;

import com.alibaba.fastjson.JSON;
import com.frontend.domain.MCUserInfo;
import com.frontend.mappers.UserRoleMapper;
import com.frontend.models.MCResult;
import eu.bitwalker.useragentutils.UserAgent;
import org.springframework.beans.BeanWrapper;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.annotation.WebFilter;
import javax.servlet.*;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.*;

@Component
@ServletComponentScan
@WebFilter(urlPatterns = "/v2/*", filterName = "ApiFilter")
public class MCApiFilter extends OncePerRequestFilter {
  @Autowired
  UserRoleMapper userMapper;

  private List<String> publicUrls;
  /*需要管理员权限页面*/
  private List<String> adminUrls;

  @Override
  protected void initFilterBean() throws ServletException {
    super.initFilterBean();
    publicUrls = Arrays.asList("/", "/conf/full", "/info", "/v2/api-docs", "/health", "/metrics", "/user/login", "/api-docs", "/env", "/mappings", "/error");
    publicUrls.replaceAll(item -> getServletContext().getContextPath() + item);

    adminUrls = Arrays.asList("/user/add", "/user/update", "/user/role/list");
    adminUrls.replaceAll(item -> getServletContext().getContextPath() + item);
  }

  Boolean shouldAuthentication(HttpServletRequest request) {
    String requestURI = request.getRequestURI();
    if (publicUrls.contains(requestURI)) {
      return false;
    } else if (requestURI.startsWith(getServletContext().getContextPath() + "/mock/app/scene")) {
      return false;
    }
    return true;
  }

  @Override
  protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws
    IOException, ServletException {
    if ("websocket".equalsIgnoreCase(request.getHeader("upgrade"))) {
      filterChain.doFilter(request, response);
      return;
    }
    if (request.getRequestURI().equalsIgnoreCase(request.getContextPath() + "/channel")) {
      response.setHeader("upgrade", "websocket");
      filterChain.doFilter(request, response);
      return;
    }

    if (shouldAuthentication(request)) {
      response.setContentType("application/json; charset=utf-8");
      String token = request.getHeader("Canary-Access-Token");
      MCUserInfo user = (MCUserInfo) request.getSession().getAttribute("user");

      Map<String, Object> data = new HashMap();
      data.put("token", token);
      data.put("stamp", System.currentTimeMillis());
      data.put("platform", UserAgent.parseUserAgentString(request.getHeader("User-Agent")).getOperatingSystem().getDeviceType().getName());

      if (user == null) {//会话失效
        user = userMapper.findByToken(data);
      }
      if (token == null || token.length() == 0 || user == null) {
        response.getWriter().write(JSON.toJSONString(MCResult.Failed(401, "登录状态失效")));
        return;
      }

      //更新有效期
      if (user.getExpire().getTime() - System.currentTimeMillis() < 86400 * 7 * 1000L) {
        user.setExpire(new Timestamp(user.getExpire().getTime() + 86400 * 7 * 1000L));
        data.put("stamp", user.getExpire());
        userMapper.updateByToken(data);
      }
      request.setAttribute("uid", user.getId());
      if (adminUrls.contains(request.getRequestURI()) && user.getRolelevel() > 0) {
        response.getWriter().write(JSON.toJSONString(MCResult.Failed(101, "您没有操作权限")));
        return;
      }
      request.getSession().setAttribute("user", user);
    }
    filterChain.doFilter(request, response);
  }
}
