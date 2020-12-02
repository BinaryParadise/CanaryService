package com.frontend.domain;

import java.sql.Timestamp;

public class MCMockInfo {
  int id;
  String name;
  String method;
  String path;
  Timestamp updateTime;
  int appId;

  public int getId() {
    return id;
  }

  public void setId(int id) {
    this.id = id;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getMethod() {
    return method;
  }

  public void setMethod(String method) {
    this.method = method;
  }

  public String getPath() {
    return path;
  }

  public void setPath(String path) {
    this.path = path;
  }

  public Timestamp getUpdateTime() {
    return updateTime;
  }

  public void setUpdateTime(Timestamp updateTime) {
    this.updateTime = updateTime;
  }

  public int getAppId() {
    return appId;
  }

  public void setAppId(int appId) {
    this.appId = appId;
  }
}
