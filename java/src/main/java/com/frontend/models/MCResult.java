package com.frontend.models;

import com.frontend.utils.MybatisError;

/**
 * 接口返回结果
 */
public class MCResult {
    /**
     * 错误码，0表示成功
     */
    int code;
    /**
     * 错误信息，如果有
     */
    String error;
    /**
     * 返回数据
     */
    Object data;

    /**
     * 扩展数据
     */
    Object ext;

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getError() {
        return error;
    }

    public void setError(String error) {
        this.error = error;
    }

    public Object getData() {
        return data;
    }

    public void setData(Object data) {
        this.data = data;
    }

    public Object getExt() {
        return ext;
    }

    public void setExt(Object ext) {
        this.ext = ext;
    }

    /**
     * 接口请求成功
     *
     * @param data
     * @return
     */
    public static MCResult Success(Object data) {
        MCResult result = new MCResult();
        result.setData(data);
        return result;
    }

    public static MCResult Success() {
        return Success(null);
    }

    public static MCResult Failed(int code, String error) {
        return Failed(code, error, null);
    }

    /**
     * 接口请求失败
     * @param code
     * @param error
     * @param data
     * @return
     */
    public static MCResult Failed(int code, String error, Object data) {
        MCResult result = new MCResult();
        result.setCode(code);
        result.setError(error);
        result.setData(data);
        return result;
    }

    public static MCResult Failed(MybatisError error) {
        MCResult result = new MCResult();
        result.setCode(error.getCode());
        result.setError(error.getMsg());
        return result;
    }
}
