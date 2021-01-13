package com.frontend.models;

import com.alibaba.fastjson.annotation.JSONField;
import com.frontend.utils.MessageType;
import com.frontend.utils.MessageTypeCodec;

public class MCMessage {
	/**
	 * 0、成功 其它、失败
	 */
	int code;
	/**
	 * 消息类型
	 */
	@JSONField(serializeUsing = MessageTypeCodec.class, deserializeUsing = MessageTypeCodec.class)
	MessageType type;

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

	public MessageType getType() {
		return type;
	}

	public void setType(MessageType type) {
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
