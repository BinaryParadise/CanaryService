package com.frontend.domain;

import java.sql.Timestamp;

public class MCMockScene {
  Integer id;
  String name;
  String response;
  Timestamp updatetime;
  Integer mockid;

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

  public String getResponse() {
    return response;
  }

  public void setResponse(String response) {
    this.response = response;
  }

  public Timestamp getUpdatetime() {
    return updatetime;
  }

  public void setUpdatetime(Timestamp updatetime) {
    this.updatetime = updatetime;
  }

  public Integer getMockid() {
    return mockid;
  }

  public void setMockid(Integer mockid) {
    this.mockid = mockid;
  }
}
