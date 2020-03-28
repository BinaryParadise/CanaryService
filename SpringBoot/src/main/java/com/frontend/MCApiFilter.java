package com.frontend;

import com.alibaba.fastjson.JSON;
import com.frontend.domain.MCUserInfo;
import com.frontend.mappers.UserRoleMapper;
import com.frontend.models.MCResult;
import org.springframework.beans.BeanWrapper;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.annotation.WebFilter;
import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

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

  @Override
  protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws
    IOException, ServletException {
    if ("websocket".equalsIgnoreCase(request.getHeader("upgrade"))) {
      filterChain.doFilter(request, response);
      return;
    }
    if (request.getRequestURI().equalsIgnoreCase("/v2/channel")) {
      response.setHeader("upgrade", "websocket");
      filterChain.doFilter(request, response);
      return;
    }

    response.setHeader("Access-Control-Allow-Origin", request.getHeader("Origin"));
    response.setHeader("Access-Control-Allow-Headers", "Content-Type,Access-Token,x-requested-with");

    if (publicUrls.contains(request.getRequestURI())) {
      logger.info("pass filter: " + request.getRequestURI());
    } else {
      if (!request.getMethod().equalsIgnoreCase("OPTIONS")) {
        response.setContentType("application/json; charset=utf-8");
        String token = request.getHeader("Access-Token");
        MCUserInfo user = userMapper.findByToken(token, System.currentTimeMillis());
        if (token == null || token.length() == 0 || user == null) {
          response.getWriter().write(JSON.toJSONString(MCResult.Failed(401, "用户鉴权失败")));
          return;
        }
        request.setAttribute("uid", user.getId());
        if (adminUrls.contains(request.getRequestURI()) && user.getRolelevel() > 0) {
          response.getWriter().write(JSON.toJSONString(MCResult.Failed(101, "您没有操作权限")));
          return;
        }
      }
    }
    filterChain.doFilter(request, response);
  }
}
