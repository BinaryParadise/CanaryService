package com.frontend.mockable;

import java.sql.Timestamp;

/**
 * 历史日志筛选条件
 */
public class MCLogCondition {
    private Integer appId;
    private Integer type;
    private String deviceId;
    private String uid;
    private String platform;
    private String appVersion;
    private String message;
    private Timestamp beginDate;
    private Timestamp endDate;
    private Integer pageSize;
    private Integer pageIndex;
    private Integer from;
    private Integer to;

    public Integer getAppId() {
        return appId;
    }

    public Integer getType() {
        return type;
    }

    public String getDeviceId() {
        return deviceId;
    }

    public String getUid() {
        return uid;
    }

    public String getPlatform() {
        return platform;
    }

    public Timestamp getBeginDate() {
        return beginDate;
    }

    public Timestamp getEndDate() {
        return endDate;
    }

    public Integer getPageSize() {
        return pageSize;
    }

    public Integer getPageIndex() {
        return pageIndex;
    }

    public void setAppId(Integer appId) {
        this.appId = appId;
    }

    public void setType(Integer type) {
        this.type = type;
    }

    public void setDeviceId(String deviceId) {
        this.deviceId = deviceId;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public void setPlatform(String platform) {
        this.platform = platform;
    }

    public void setBeginDate(Timestamp beginDate) {
        this.beginDate = beginDate;
    }

    public void setEndDate(Timestamp endDate) {
        this.endDate = endDate;
    }

    public void setPageSize(Integer pageSize) {
        this.pageSize = pageSize;
    }

    public void setPageIndex(Integer pageIndex) {
        this.pageIndex = pageIndex;
    }

    public String getAppVersion() {
        return appVersion;
    }

    public void setAppVersion(String appVersion) {
        this.appVersion = appVersion;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Integer getFrom() {
        if (this.pageIndex == null) {
            return 0;
        }
        return this.pageSize * Math.max(this.pageIndex - 1, 0);
    }

    public Integer getTo() {
        if (this.pageIndex == null) {
            return 0;
        }
        return this.pageSize * Math.max(this.pageIndex, 1);
    }

    public void setFrom(Integer from) {
        this.from = from;
    }

    public void setTo(Integer to) {
        this.to = to;
    }
}
