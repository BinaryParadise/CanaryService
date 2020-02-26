package com.frontend.domain;

import java.sql.Timestamp;
import java.util.Date;
import java.util.List;

public class MCEnvConfig {
  private int id;
  private String name;
  private int type;
  private Date updateTime;
  private int appId;
  private String author;
  private int uid;
  private String comment;
  private List<MCEnvConfigItem> subItems;
  private int subItemsCount;
  private boolean defaultTag;
  private int copyid;

  public int getUid() {
    return uid;
  }

  public void setUid(int uid) {
    this.uid = uid;
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

  public int getSubItemsCount() {
    return subItemsCount;
  }

  public void setSubItemsCount(int subItemsCount) {
    this.subItemsCount = subItemsCount;
  }

  public boolean isDefaultTag() {
    return defaultTag;
  }

  public void setDefaultTag(boolean defaultTag) {
    this.defaultTag = defaultTag;
  }
}
