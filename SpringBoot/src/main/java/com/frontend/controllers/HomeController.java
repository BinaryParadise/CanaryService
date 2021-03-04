package com.frontend.controllers;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.frontend.mappers.HomeMapper;
import com.frontend.models.MCResult;
import com.frontend.utils.MybatisError;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
public class HomeController {
  @Autowired
  private HomeMapper homeMapper;

  @PostMapping("/net/snapshot/add")
  public MCResult snapshot(@RequestBody JSONObject jsonObject) {
    homeMapper.createSnapshot((String) jsonObject.get("identify"), JSON.toJSONString(jsonObject));
    return MCResult.Success();
  }

  @GetMapping("/net/snapshot")
  public MCResult findByIdentity(String identify) {
    JSONObject jsonObject = homeMapper.findByIdentify(identify);
    if (jsonObject == null) {
      return MCResult.Failed(MybatisError.NotFoundEntry);
    }
    return MCResult.Success(JSON.parseObject(jsonObject.getString("data")));
  }
}
