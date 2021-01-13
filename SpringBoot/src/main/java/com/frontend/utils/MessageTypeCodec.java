package com.frontend.utils;

import com.alibaba.fastjson.parser.DefaultJSONParser;
import com.alibaba.fastjson.parser.deserializer.ObjectDeserializer;
import com.alibaba.fastjson.serializer.JSONSerializer;
import com.alibaba.fastjson.serializer.ObjectSerializer;
import com.alibaba.fastjson.util.TypeUtils;

import java.io.IOException;
import java.lang.reflect.Type;

/**
 * 消息类型序列化、反序列化
 */
public class MessageTypeCodec implements ObjectSerializer, ObjectDeserializer {

  @Override
  public <T> T deserialze(DefaultJSONParser defaultJSONParser, Type type, Object o) {
    Object value = defaultJSONParser.parse();
    return value == null ? null : (T) MessageType.convert(TypeUtils.castToInt(value));
  }

  @Override
  public int getFastMatchToken() {
    return 0;
  }

  @Override
  public void write(JSONSerializer jsonSerializer, Object o, Object o1, Type type, int i) throws IOException {
    jsonSerializer.write(((MessageType) o).getCode());
  }
}
