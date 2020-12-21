package com.frontend.mockable;

import java.sql.Timestamp;
import java.util.List;

public class MCMockScene {
  Integer id;
  String name;
  String response;
  Timestamp updatetime;
  Integer mockid;

  List<MCMockParam> params;

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

  public List<MCMockParam> getParams() {
    return params;
  }

  public void setParams(List<MCMockParam> params) {
    this.params = params;
  }
}
