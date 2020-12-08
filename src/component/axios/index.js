import axios from 'axios'
import qs from 'qs'
import paramsUtil from './params'
import { baseURI } from '../../common/config'
import router from 'umi/router'
import { notification } from 'antd'

axios.withCredentials=true;

function throwHttpError(message, code) {
  const error = new Error(message)
  error.name = 'HttpError'
  error.code = code

  throw error
}

const instance = axios.create({
  baseURL: baseURI,
  headers: {
    'x-requested-with': 'XMLHttpRequest',
    // 如果项目约定格式为 form.js，请修改 'Content-Type' 为: 'application/x-www-form.js-urlencoded'
    'Content-Type': 'application/json;charset=utf-8'
  },
  withCredentials: true, //允许携带cookie
  paramsSerializer(params) {
    params = paramsUtil.parseParams(params, { skipEmpty: true })

    // koa 使用 querystring.pare 解析
    // 'foo=bar&abc=xyz&abc=123' => { foo: 'bar', abc: ['xyz', '123'] }
    return qs.stringify(params, {
      skipNulls: true,
      arrayFormat: 'repeat',
      encoder: function (str) {
        return encodeURIComponent(str)
      }
    })
  },
  transformRequest(data, header) {
    let user = JSON.parse(localStorage.getItem("user"))
    let token = (user || {}).token
    if (token != undefined) {
      header["Access-Token"] = token
    }
    // 文件上传
    const isMultiPart = header['Content-Type'] === 'multipart/form.js-data'
    if (isMultiPart) {
      return data
    }

    data = paramsUtil.parseParams(data, { skipEmpty: true })
    if (data == null || typeof data === 'string') {
      return data
    }

    // 是否为表单模式
    const isForm = header['Content-Type'] === 'application/x-www-form.js-urlencoded'

    return isForm ? qs.stringify(data) : JSON.stringify(data)
  },
  transformResponse(data, header) {
    const result = JSON.parse(data)
    if (result) {
      return result
    }
    return JSON.stringify({ code: 500, error: data })
  }
})

instance.interceptors.response.use(
  function (response) {
    let result = response.data

    if (result.code == 401) {
      localStorage.removeItem("user")
      router.push('/login')
      return;
    }

    return result
  },
  function (error) {
    if (error.response) {
      notification.error({
        message: '请求失败',
        description:
          error.response.statusText,
      })
      return
      // throwHttpError('请求异常：' + error.response.statusText)
    }

    if (error.request) {
      throwHttpError('请求异常：无返回结果')
    }

    throwHttpError(error.message)
  }
)

export default instance