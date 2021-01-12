package com.frontend.models;

public class MCMessage {
	/**
	 * 0、成功 其它、失败
	 */
	int code;
	/**
	 * 1、连接控制
   * 2、配置数据更新
	 * 10、注册设备
	 * 11、设备状态更新
	 * 12、获得注册的设备列表
	 * 20、发起数据库查询请求
	 * 21、数据查询结果
	 * 30、客户端日志
	 * 31、客户端网络日志
	 */
	int type;

	/**
	 * 提示信息
	 */
	String msg;

	/**
	 * 应用标识
	 */
	String appKey;

	/**
	 * 关联的JSON数据
	 */
	Object data;

	public Object getData() {
		return data;
	}

	public void setData(Object data) {
		this.data = data;
	}

	public int getCode() {
		return code;
	}

	public void setCode(int code) {
		this.code = code;
	}

	public int getType() {
		return type;
	}

	public void setType(int type) {
		this.type = type;
	}

	public String getMsg() {
		return msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}

	public String getAppKey() {
		return appKey;
	}

	public void setAppKey(String appKey) {
		this.appKey = appKey;
	}
}
