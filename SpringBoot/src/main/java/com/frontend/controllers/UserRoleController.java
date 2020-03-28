package com.frontend.controllers;

import com.frontend.domain.MCUserInfo;
import com.frontend.mappers.UserRoleMapper;
import com.frontend.models.MCResult;
import com.frontend.utils.MybatisError;
import com.frontend.utils.TokenProccessor;
import io.swagger.annotations.Api;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

@RestController
@RequestMapping("/user")
@EnableSwagger2
@Api(tags = "用户中心")
public class UserRoleController {
  @Autowired
  UserRoleMapper userMapper;

  @GetMapping("/list")
  public MCResult list() {
    try {
      Object data = userMapper.findUserList();
      return MCResult.Success(data);
    } catch (Throwable e) {
      e.printStackTrace();
      return MCResult.Failed(MybatisError.NotFoundEntry);
    }
  }

  @PostMapping("/login")
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

  @PostMapping(value = "/add")
  MCResult addUser(@RequestBody MCUserInfo data, HttpServletRequest request) {
    try {
      Integer ret = userMapper.inserUser(data);
      return ret > 0 ? MCResult.Success(data) : MCResult.Failed(MybatisError.InsertFaield);
    } catch (Throwable e) {
      e.printStackTrace();
      return MCResult.Failed(MybatisError.DuplicateEntry);
    }
  }

  @PostMapping(value = "/update")
  MCResult updateUser(@RequestBody MCUserInfo data, HttpServletResponse response) {
    try {
      Integer ret = userMapper.updateUser(data);
      return ret > 0 ? MCResult.Success(data) : MCResult.Failed(MybatisError.DuplicateEntry);
    } catch (Throwable e) {
      e.printStackTrace();
      return MCResult.Failed(MybatisError.NotFoundEntry);
    }
  }

  @PostMapping(value = "/delete/{uid}")
  MCResult deleteUser(@PathVariable("uid") Integer uid) {
    try {
      return userMapper.deleteUser(uid) > 0 ? MCResult.Success() : MCResult.Failed(MybatisError.DeleteFailed);
    } catch (Throwable e) {
      e.printStackTrace();
      return MCResult.Failed(MybatisError.InsertFaield);
    }
  }

  @GetMapping(value = "/role/list")
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
