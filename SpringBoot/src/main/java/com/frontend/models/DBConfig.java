package com.frontend.models;

public class DBConfig {
	private String driver;
	private String url;
	public String getDriver() {
		return "org.sqlite.JDBC";
	}
	public void setDriver(String driver) {
		this.driver = driver;
	}
	public String getUrl() {
		return "jdbc:sqlite::resource:db/devtest.db";
	}
	public void setUrl(String url) {
		this.url = url;
	}
}
