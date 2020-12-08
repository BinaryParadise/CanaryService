package com.frontend.domain;

import java.sql.Timestamp;

public class MCMockScene {
  int id;
  String name;
  String body;
  Timestamp updatetime;
  int mockid;

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

  public String getBody() {
    return body;
  }

  public void setBody(String body) {
    this.body = body;
  }

  public Timestamp getUpdatetime() {
    return updatetime;
  }

  public void setUpdatetime(Timestamp updatetime) {
    this.updatetime = updatetime;
  }

  public int getMockid() {
    return mockid;
  }

  public void setMockid(int mockid) {
    this.mockid = mockid;
  }
}
