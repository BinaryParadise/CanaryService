package com.frontend.utils;

public enum MybatisError {
  AuthorityFaield(401, "您没有操作权限"),
  InsertFaield(800, "数据持久化失败!"),
  DeleteFailed(801, "啊咧，貌似删除失败了!"),
  UpdateFaield(802, "啊咧，莫名更新失败了!"),
  SelectFaield(803, "啊咧，查询也能失败 ，膜拜大神!"),
  DuplicateEntry(804, "记录已存在，换个名称试试!"),
  NotFoundEntry(805, "没有这个条记录，别想冒充"),
  InternalFailed(806, "内部逻辑错误"),
  ParamFailed(807, "缺少参数");

  private int code;
  private String msg;

  public static String getMessage(int code) {
    for (MybatisError e : MybatisError.values()) {
      if (e.getCode() == code) {
        return e.getMsg();
      }
    }
    return null;
  }

  private MybatisError(int code, String msg) {
    this.code = code;
    this.msg = msg;
  }

  public int getCode() {
    return code;
  }

  public void setCode(int code) {
    this.code = code;
  }

  public String getMsg() {
    return msg;
  }

  public void setMsg(String msg) {
    this.msg = msg;
  }
}
