package com.frontend.domain;

import java.sql.Timestamp;

public class MCAppInfo {
  int id;
  String identify;
  String name;
  Integer orderno;
  Integer uid;
  String author;
  Boolean shared;

  public Timestamp getUpdateTime() {
    return updateTime;
  }

  public void setUpdateTime(Timestamp updateTime) {
    this.updateTime = updateTime;
  }

  Timestamp updateTime;

  public MCAppInfo() {
    orderno = 1;
  }

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

  public String getIdentify() {
    return identify;
  }

  public void setIdentify(String identify) {
    this.identify = identify;
  }

  public Integer getOrderno() {
    return orderno;
  }

  public void setOrderno(Integer orderno) {
    this.orderno = orderno;
  }

  public Integer getUid() {
    return uid;
  }

  public void setUid(Integer uid) {
    this.uid = uid;
  }

  public String getAuthor() {
    return author;
  }

  public void setAuthor(String author) {
    this.author = author;
  }

  public Boolean getShared() {
    return shared;
  }

  public void setShared(Boolean shared) {
    this.shared = shared;
  }
}
