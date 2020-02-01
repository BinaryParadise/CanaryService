package com.frontend.controllers;

import com.frontend.mappers.ProjectMapper;
import com.frontend.models.MCResult;
import com.frontend.websocket.WCWebSocket;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;

@Controller
public class HomeController {
	@Autowired
	private ProjectMapper appsMapper;

	/**
	 * 首页
	 *
	 * @return
	 */
	@RequestMapping(value = "/")
	public String index() {
		return "index";
	}

	@RequestMapping(value = "scheme")
	public String scheme() {
		return "scheme";
	}

	@RequestMapping(value = "japi/device/list", produces = "application/json; charset=utf-8")
	@ResponseBody
	public MCResult deviceList(String appkey) {
		HashMap data = new HashMap();
		data.put("devices", WCWebSocket.getDevices(appkey));
		return MCResult.Success(data);
	}
}
