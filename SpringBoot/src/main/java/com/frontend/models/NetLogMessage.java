package com.frontend.models;

import java.sql.Timestamp;

public class NetLogMessage {
  private String identify;
  private String uid;
  private Integer type;
  private String method;
  private String url;
  private Object requestfields;
  private Object responsefield;
  private String requestBody;
  private String responseBody;
  private Timestamp timestamp;
  private Integer flag;
  private Integer statusCode;

  public String getIdentify() {
    return identify;
  }

  public void setIdentify(String identify) {
    this.identify = identify;
  }

  public String getUid() {
    return uid;
  }

  public void setUid(String uid) {
    this.uid = uid;
  }

  public Integer getType() {
    return type;
  }

  public void setType(Integer type) {
    this.type = type;
  }

  public String getMethod() {
    return method;
  }

  public void setMethod(String method) {
    this.method = method;
  }

  public String getUrl() {
    return url;
  }

  public void setUrl(String url) {
    this.url = url;
  }

  public Object getRequestfields() {
    return requestfields;
  }

  public void setRequestfields(Object requestfields) {
    this.requestfields = requestfields;
  }

  public Object getResponsefield() {
    return responsefield;
  }

  public void setResponsefield(Object responsefield) {
    this.responsefield = responsefield;
  }

  public String getRequestBody() {
    return requestBody;
  }

  public void setRequestBody(String requestBody) {
    this.requestBody = requestBody;
  }

  public String getResponseBody() {
    return responseBody;
  }

  public void setResponseBody(String responseBody) {
    this.responseBody = responseBody;
  }

  public Timestamp getTimestamp() {
    return timestamp;
  }

  public void setTimestamp(Timestamp timestamp) {
    this.timestamp = timestamp;
  }

  public Integer getFlag() {
    return flag;
  }

  public void setFlag(Integer flag) {
    this.flag = flag;
  }

  public Integer getStatusCode() {
    return statusCode;
  }

  public void setStatusCode(Integer statusCode) {
    this.statusCode = statusCode;
  }
}
