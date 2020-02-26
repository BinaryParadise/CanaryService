package com.frontend.controllers;

import com.frontend.mappers.ProjectMapper;
import com.frontend.models.MCResult;
import com.frontend.websocket.WCWebSocket;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;

@RestController
@RequestMapping("/device")
@Api(tags = "设备管理")
public class DeviceController {

  @ApiOperation("获取注册设备列表")
  @GetMapping("/list")
  public MCResult deviceList(String appkey) {
    HashMap data = new HashMap();
    data.put("devices", WCWebSocket.getDevices(appkey));
    return MCResult.Success(data);
  }
}
