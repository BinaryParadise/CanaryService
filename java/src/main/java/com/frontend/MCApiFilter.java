package com.frontend;

import com.alibaba.fastjson.JSON;
import com.frontend.domain.MCUserInfo;
import com.frontend.mappers.UserRoleMapper;
import com.frontend.models.MCResult;
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
@WebFilter(urlPatterns = "*", filterName = "ApiFilter")
public class MCApiFilter extends OncePerRequestFilter {
  @Autowired
  UserRoleMapper userMapper;

  /*需要管理员权限页面*/
  final List<String> adminUrls = Arrays.asList("/v2/user/insert", "/v2/user/update");

  @Override
  protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws IOException, ServletException {
    response.setContentType("application/json; charset=utf-8");
    String path = getServletContext().getContextPath();
    if (request.getRequestURI().equals(path + "/")
      || request.getRequestURI().startsWith(path + "/user/login")) {

    } else {
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
    filterChain.doFilter(request, response);
  }
}
