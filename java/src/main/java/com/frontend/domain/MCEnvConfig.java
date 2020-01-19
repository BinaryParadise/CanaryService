package com.frontend.domain;

import java.sql.Timestamp;
import java.util.List;

public class MCEnvConfig {
    int id;
    String name;
    int type;
    Timestamp updateTime;
    int appId;
    String author;
    String comment;
    List<MCEnvConfigItem> subItems;
    int subItemsCount;
    boolean isDefault;
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

    public Timestamp getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Timestamp updateTime) {
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

    public boolean isDefault() {
        return isDefault;
    }

    public void setDefault(boolean aDefault) {
        isDefault = aDefault;
    }

    public int getSubItemsCount() {
        return subItemsCount;
    }

    public void setSubItemsCount(int subItemsCount) {
        this.subItemsCount = subItemsCount;
    }
}
