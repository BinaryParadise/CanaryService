package com.frontend.models;

import java.util.List;
import java.util.Map;

public class MCDeviceInfo  {
	private String name;
	private List<String> databases;
	private String deviceId;
	private Object ipAddrs;
	private Integer appId;
	private String appKey;
	private String appVersion;
	private String osName;
	private String osVersion;
	private String modelName;
	private boolean simulator;
	private Object profile;

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public List<String> getDatabases() {
    return databases;
  }

  public void setDatabases(List<String> databases) {
    this.databases = databases;
  }

  public String getDeviceId() {
    return deviceId;
  }

  public void setDeviceId(String deviceId) {
    this.deviceId = deviceId;
  }

  public Object getIpAddrs() {
    return ipAddrs;
  }

  public void setIpAddrs(Object ipAddrs) {
    this.ipAddrs = ipAddrs;
  }

  public Integer getAppId() {
    return appId;
  }

  public void setAppId(Integer appId) {
    this.appId = appId;
  }

  public String getAppKey() {
    return appKey;
  }

  public void setAppKey(String appKey) {
    this.appKey = appKey;
  }

  public String getAppVersion() {
    return appVersion;
  }

  public void setAppVersion(String appVersion) {
    this.appVersion = appVersion;
  }

  public String getOsName() {
    return osName;
  }

  public void setOsName(String osName) {
    this.osName = osName;
  }

  public String getOsVersion() {
    return osVersion;
  }

  public void setOsVersion(String osVersion) {
    this.osVersion = osVersion;
  }

  public String getModelName() {
    return modelName;
  }

  public void setModelName(String modelName) {
    this.modelName = modelName;
  }

  public boolean isSimulator() {
    return simulator;
  }

  public void setSimulator(boolean simulator) {
    this.simulator = simulator;
  }

  public Object getProfile() {
    return profile;
  }

  public void setProfile(Object profile) {
    this.profile = profile;
  }
}
