package com.frontend.mockable;

import java.sql.Timestamp;
import java.util.List;

public class MCMockInfo {
  Integer id;
  String name;
  String method;
  String path;
  Timestamp updatetime;
  Integer groupid;
  String template;
  String groupname;
  Integer uid;
  List<MCMockScene> scenes;

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

  public String getTemplate() {
    return template;
  }

  public void setTemplate(String template) {
    this.template = template;
  }

  public String getGroupname() {
    return groupname;
  }

  public void setGroupname(String groupname) {
    this.groupname = groupname;
  }

  public Integer getUid() {
    return uid;
  }

  public void setUid(Integer uid) {
    this.uid = uid;
  }

  public List<MCMockScene> getScenes() {
    return scenes;
  }

  public void setScenes(List<MCMockScene> scenes) {
    this.scenes = scenes;
  }
}
