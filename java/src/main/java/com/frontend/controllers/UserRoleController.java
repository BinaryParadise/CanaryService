package com.frontend.controllers;

import com.frontend.domain.MCUserInfo;
import com.frontend.mappers.UserRoleMapper;
import com.frontend.models.MCResult;
import com.frontend.utils.MybatisError;
import com.frontend.utils.TokenProccessor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

@Controller
public class UserRoleController {
  @Autowired
  UserRoleMapper userMapper;

  @RequestMapping(value = "/user/list")
  @ResponseBody
  MCResult list() {
    try {
      Object data = userMapper.findUserList();
      return MCResult.Success(data);
    } catch (Throwable e) {
      e.printStackTrace();
      return MCResult.Failed(MybatisError.NotFoundEntry);
    }
  }

  @RequestMapping(value = "/user/login", produces = "application/json; charset=utf-8", method = RequestMethod.POST)
  @ResponseBody
  MCResult login(@RequestBody Map<String, Object> data, HttpServletResponse response) {
    try {
      data.put("token", TokenProccessor.getInstance().makeToken());
      data.put("stamp", System.currentTimeMillis() + 3600 * 24 * 7000);
      Integer ret = userMapper.login(data);
      if (ret <= 0) {
        return MCResult.Failed(1001, "用户名或密码错误");
      }
      MCUserInfo user = userMapper.findByLogin(data);
      if (user != null) {
        response.addCookie(new Cookie("token", user.getToken()));
      }
      return MCResult.Success(user);
    } catch (Throwable e) {
      e.printStackTrace();
      return MCResult.Failed(MybatisError.NotFoundEntry);
    }
  }

  @RequestMapping(value = "/user/insert", produces = "application/json; charset=utf-8", method = RequestMethod.POST)
  @ResponseBody
  MCResult addUser(@RequestBody MCUserInfo data, HttpServletRequest request) {
    try {
      Integer ret = userMapper.insert(data);
      return ret > 0 ? MCResult.Success(data) : MCResult.Failed(MybatisError.DuplicateEntry);
    } catch (Throwable e) {
      e.printStackTrace();
      return MCResult.Failed(MybatisError.NotFoundEntry);
    }
  }

  @RequestMapping(value = "/user/update", produces = "application/json; charset=utf-8", method = RequestMethod.POST)
  @ResponseBody
  MCResult updateUser(@RequestBody MCUserInfo data, HttpServletResponse response) {
    try {
      Integer ret = userMapper.updateUser(data);
      return ret > 0 ? MCResult.Success(data) : MCResult.Failed(MybatisError.DuplicateEntry);
    } catch (Throwable e) {
      e.printStackTrace();
      return MCResult.Failed(MybatisError.NotFoundEntry);
    }
  }

  @RequestMapping(value = "/user/role/list")
  @ResponseBody
  MCResult roleList() {
    try {
      Object data = userMapper.findRoleList();
      return MCResult.Success(data);
    } catch (Throwable e) {
      e.printStackTrace();
      return MCResult.Failed(MybatisError.SelectFaield);
    }
  }
}
