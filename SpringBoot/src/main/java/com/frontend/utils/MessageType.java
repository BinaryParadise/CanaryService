package com.frontend.utils;

import com.alibaba.fastjson.parser.DefaultJSONParser;
import com.alibaba.fastjson.parser.deserializer.ObjectDeserializer;
import com.alibaba.fastjson.serializer.JSONSerializer;
import com.alibaba.fastjson.serializer.ObjectSerializer;
import com.alibaba.fastjson.util.TypeUtils;

import java.io.IOException;
import java.lang.reflect.Type;

/* 消息类型 */
public enum MessageType {
  Connected(1),
  Update(2),
  Register(10),
  DeviceList(11),
  DBQuery(20),
  DBResult(21),
  Logger(30);

  private int code;

  private MessageType(int code) {
    this.code = code;
  }

  public int getCode() {
    return code;
  }

  public void setCode(int code) {
    this.code = code;
  }

  public static MessageType convert(int code) {
    for (MessageType e : MessageType.values()) {
      if (e.getCode() == code)
        return e;
    }
    return null;
  }
}
