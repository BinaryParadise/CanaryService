package com.frontend.mockable;

import java.sql.Timestamp;

/**
 * Mock请求参数
 */
public class MCMockParam {
  Integer id;
  String name;
  String value;
  String comment;
  Integer appid;
  Integer sceneid;
  Timestamp updatetime;

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

  public String getValue() {
    return value;
  }

  public void setValue(String value) {
    this.value = value;
  }

  public String getComment() {
    return comment;
  }

  public void setComment(String comment) {
    this.comment = comment;
  }

  public Integer getAppid() {
    return appid;
  }

  public void setAppid(Integer appid) {
    this.appid = appid;
  }

  public Integer getSceneid() {
    return sceneid;
  }

  public void setSceneid(Integer sceneid) {
    this.sceneid = sceneid;
  }

  public Timestamp getUpdatetime() {
    return updatetime;
  }

  public void setUpdatetime(Timestamp updatetime) {
    this.updatetime = updatetime;
  }
}
