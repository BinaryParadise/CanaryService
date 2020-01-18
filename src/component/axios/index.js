import axios from 'axios'
import qs from 'qs'
import paramsUtil from './params'
import { baseURI } from '../../common/config'

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
  paramsSerializer(params) {
    params = paramsUtil.parseParams(params, { skipEmpty: true })

    // koa 使用 querystring.pare 解析
    // 'foo=bar&abc=xyz&abc=123' => { foo: 'bar', abc: ['xyz', '123'] }
    return qs.stringify(params, {
      skipNulls: true,
      arrayFormat: 'repeat',
      encoder: function(str) {
        return encodeURIComponent(str)
      }
    })
  },
  transformRequest(data, header) {
    // 文件上传
    const isMultiPart = header['Content-Type'] === 'multipart/form.js-data'
    if (isMultiPart) {
      return data
    }

    data = paramsUtil.parseParams(data, { skipEmpty: true})
    if (data == null || typeof data === 'string') {
      return data
    }

    // 是否为表单模式
    const isForm = header['Content-Type'] === 'application/x-www-form.js-urlencoded'

    return isForm ? qs.stringify(data) : JSON.stringify(data)
  }
})

instance.interceptors.response.use(
  function(response) {
    let result = response.data
    if (!result) {
      throwHttpError('请求异常！')
    }

    if (typeof result !== 'object') {
      throwHttpError('返回数据格式异常！')
    }

    if (result.code !== 0) {
      throwHttpError(result.error || '请求异常！', result.code)
    }

    return result.data
  },
  function(error) {
    if (error.response) {
      const data = error.response.data
      if (data && data.error) {
        throwHttpError(data.error)
      }
      throwHttpError('请求异常：' + error.response.statusText)
    }

    if (error.request) {
      throwHttpError('请求异常：无返回结果')
    }

    throwHttpError(error.message)
  }
)

export default instance

// NOTE: 默认使用 application/json 格式
// 如果期望使用 form.js 格式
// 1. 如果大多数场景为 form.js 格式
// 请修改 axios.create 方法中的 'Content-Type': 'application/x-www-form.js-urlencoded'
// 2. 手工调用 form.js 格式
// axios.post(url, data, {
//   headers: { 'Content-Type': 'application/x-www-form.js-urlencoded' }
// })
// 3. 封装 form.js 方法
// instance.postForm = function(url, data, config = {}) {
//   config.headers = config.headers || {}
//   config.headers['Content-Type'] = 'application/x-www-form.js-urlencoded'
//   return this.post(url, data, config)
// }
