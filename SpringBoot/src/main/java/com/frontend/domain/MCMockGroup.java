package com.frontend.domain;

import java.util.List;

public class MCMockGroup {
  Integer id;
  String name;
  Integer appid;

  List<MCMockInfo> mocks;

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

  public Integer getAppid() {
    return appid;
  }

  public void setAppid(Integer appid) {
    this.appid = appid;
  }

  public List<MCMockInfo> getMocks() {
    return mocks;
  }

  public void setMocks(List<MCMockInfo> mocks) {
    this.mocks = mocks;
  }
}
