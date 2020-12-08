package com.frontend.domain;

import java.sql.Timestamp;

public class MCMockInfo {
  Integer id;
  String name;
  String method;
  String path;
  Timestamp updatetime;
  Integer groupid;

  public Integer getId() {
    return id;
  }

  public void setId(Integer id) {
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

  public Timestamp getUpdatetime() {
    return updatetime;
  }

  public void setUpdatetime(Timestamp updatetime) {
    this.updatetime = updatetime;
  }

  public Integer getGroupid() {
    return groupid;
  }

  public void setGroupid(Integer groupid) {
    this.groupid = groupid;
  }
}
