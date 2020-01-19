package com.frontend.domain;

import java.sql.Timestamp;
import java.util.List;

public class
MCEnvConfigItem {
    int id;
    String name;
    String value;
    int envid;
    Timestamp updateTime;
    String comment;
    String author;
    int type;
    /**
     * 平台
     * 0、全部 1、iOS 2、Android
     */
    int platform;
    List<MCEnvConfigItem> subItems;

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

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public int getEnvid() {
        return envid;
    }

    public void setEnvid(int envid) {
        this.envid = envid;
    }

    public Timestamp getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Timestamp updateTime) {
        this.updateTime = updateTime;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public List<MCEnvConfigItem> getSubItems() {
        return subItems;
    }

    public void setSubItems(List<MCEnvConfigItem> subItems) {
        this.subItems = subItems;
    }

    public int getPlatform() {
        return platform;
    }

    public void setPlatform(int platform) {
        this.platform = platform;
    }
}
