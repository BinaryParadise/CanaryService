package com.frontend.domain;

import java.util.List;

public class MCEnvConfigGroup {
    /**
     * 0、测试 1、开发 2、生产
     */
    int type;
    /**
     * 分组名称
     */
    String name;
    List<MCEnvConfig> items;

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
        switch (type) {
            case 1:
                this.name = "开发";
                break;
            case 2:
                this.name = "生产";
                break;
            default:
                this.name = "测试";
                break;
        }
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public List<MCEnvConfig> getItems() {
        return items;
    }

    public void setItems(List<MCEnvConfig> items) {
        this.items = items;
    }
}
