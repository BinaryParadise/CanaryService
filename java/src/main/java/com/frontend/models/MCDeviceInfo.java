package com.frontend.models;

import java.util.List;
import java.util.Map;

public class MCDeviceInfo  {
	String name;
	List<String> databases;
	String deviceId;
	String ipAddr;
	Integer appId;
	String appKey;
	String appVersion;
	String osName;
	String osVersion;
	String modelName;
	boolean simulator;
	Map<String, String> profile;

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

	public String getIpAddr() {
		return ipAddr;
	}

	public void setIpAddr(String ipAddr) {
		this.ipAddr = ipAddr;
	}

  public String getAppVersion() {
		return appVersion;
	}

	public void setAppVersion(String appVersion) {
		this.appVersion = appVersion;
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

	public Map<String, String> getProfile() {
		return profile;
	}

	public void setProfile(Map<String, String> profile) {
		this.profile = profile;
	}

	public String getOsName() {
		return osName;
	}

	public void setOsName(String osName) {
		this.osName = osName;
	}

	public Integer getAppId() {
		return appId;
	}

	public void setAppId(Integer appId) {
		this.appId = appId;
	}

  public boolean isSimulator() {
    return simulator;
  }

  public void setSimulator(boolean simulator) {
    this.simulator = simulator;
  }

  public String getAppKey() {
    return appKey;
  }

  public void setAppKey(String appKey) {
    this.appKey = appKey;
  }
}
