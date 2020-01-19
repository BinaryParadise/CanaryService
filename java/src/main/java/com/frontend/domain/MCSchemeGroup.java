package com.frontend.domain;

import java.util.List;

public class MCSchemeGroup extends MCSchemeItem {
    int appId;
    List<MCSchemeItem> subItems;

    public int getAppId() {
        return appId;
    }

    public void setAppId(int appId) {
        this.appId = appId;
    }

    public List<MCSchemeItem> getSubItems() {
        return subItems;
    }

    public void setSubItems(List<MCSchemeItem> subItems) {
        this.subItems = subItems;
    }
}
