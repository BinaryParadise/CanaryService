package com.frontend.domain;

import java.sql.Timestamp;

public class MCPacket {
	int id;

	String title;

	String comment;

	String version;

	int build;

	Timestamp time;

	long fileLength;

	private String mainfest;
	public Timestamp getUpdateDate() {
		return time;
	}
	public void setUpdateDate(Timestamp updateDate) {
		this.time = updateDate;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getComment() {
		return comment;
	}
	public void setComment(String comment) {
		this.comment = comment;
	}
	public int getBuild() {
		return build;
	}
	public void setBuild(int build) {
		this.build = build;
	}
	public Timestamp getTime() {
		return time;
	}
	public void setTime(Timestamp time) {
		this.time = time;
	}
	public String getVersion() {
		return version;
	}
	public void setVersion(String version) {
		this.version = version;
	}
	public long getFileLength() {
		return fileLength;
	}
	public void setFileLength(long fileLength) {
		this.fileLength = fileLength;
	}
	public String getMainfest() {
		return mainfest;
	}
	public void setMainfest(String mainfest) {
		this.mainfest = mainfest;
	}
}
