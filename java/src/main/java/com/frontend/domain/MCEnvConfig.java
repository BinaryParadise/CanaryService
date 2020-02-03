package com.frontend.domain;

import java.sql.Timestamp;
import java.util.Date;
import java.util.List;

public class MCEnvConfig {
  int id;
  String name;
  int type;
  Date updateTime;
  int appId;
  String author;
  String comment;
  List<MCEnvConfigItem> subItems;
  int subItemsCount;
  boolean defaulted;
  int copyid;

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

  public int getType() {
    return type;
  }

  public void setType(int type) {
    this.type = type;
  }

  public Date getUpdateTime() {
    return updateTime;
  }

  public void setUpdateTime(Date updateTime) {
    this.updateTime = updateTime;
  }

  public int getAppId() {
    return appId;
  }

  public void setAppId(int appId) {
    this.appId = appId;
  }

  public String getAuthor() {
    return author;
  }

  public void setAuthor(String author) {
    this.author = author;
  }

  public String getComment() {
    return comment;
  }

  public void setComment(String comment) {
    this.comment = comment;
  }

  public List<MCEnvConfigItem> getSubItems() {
    return subItems;
  }

  public void setSubItems(List<MCEnvConfigItem> subItems) {
    this.subItems = subItems;
  }

  public int getCopyid() {
    return copyid;
  }

  public void setCopyid(int copyid) {
    this.copyid = copyid;
  }

  public boolean isDefaulted() {
    return defaulted;
  }

  public void setDefaulted(boolean defaulted) {
    this.defaulted = defaulted;
  }

  public int getSubItemsCount() {
    return subItemsCount;
  }

  public void setSubItemsCount(int subItemsCount) {
    this.subItemsCount = subItemsCount;
  }
}
