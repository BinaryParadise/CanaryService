package com.frontend.domain;

import java.sql.Timestamp;

public class MCUserInfo {
  Integer id;
  String username;
  String password;
  String name;
  String token;
  int roleid;
  String rolename;
  int rolelevel;
  Timestamp expire;
  MCAppInfo app;

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getToken() {
    return token;
  }

  public void setToken(String token) {
    this.token = token;
  }

  public Integer getRoleid() {
    return roleid;
  }

  public void setRoleid(Integer roleid) {
    this.roleid = roleid;
  }

  public String getRolename() {
    return rolename;
  }

  public void setRolename(String rolename) {
    this.rolename = rolename;
  }

  public Timestamp getExpire() {
    return expire;
  }

  public void setExpire(Timestamp expire) {
    this.expire = expire;
  }

  public Integer getId() {
    return id;
  }

  public void setId(Integer id) {
    this.id = id;
  }

  public int getRolelevel() {
    return rolelevel;
  }

  public void setRolelevel(int rolelevel) {
    this.rolelevel = rolelevel;
  }

  public String getUsername() {
    return username;
  }

  public void setUsername(String username) {
    this.username = username;
  }

  public void setRoleid(int roleid) {
    this.roleid = roleid;
  }

  public String getPassword() {
    return password;
  }

  public void setPassword(String password) {
    this.password = password;
  }

  public MCAppInfo getApp() {
    return app;
  }

  public void setApp(MCAppInfo app) {
    this.app = app;
  }
}
