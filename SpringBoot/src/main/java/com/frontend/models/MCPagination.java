package com.frontend.models;

public class MCPagination {
  Integer begin;
  Integer end;

  public MCPagination(Integer pageIndex, Integer pageSize) {
    pageIndex = pageIndex == null ? 0 : pageIndex;
    pageSize = pageSize == null ? 20 : pageSize;
    begin = (pageIndex - 1) * pageSize;
    end = pageIndex * pageSize;
  }

  public Integer getBegin() {
    return begin;
  }

  public void setBegin(Integer begin) {
    this.begin = begin;
  }

  public Integer getEnd() {
    return end;
  }

  public void setEnd(Integer end) {
    this.end = end;
  }
}
