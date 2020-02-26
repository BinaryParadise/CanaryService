import moment from 'moment'
import _ from 'lodash'

export default {
  /**
   * 转换参数
   *
   * @param {Object} [params] - 参数对象
   * @param {Object} [options] - 选项
   * @param {Boolean} [options.skipEmpty] - 是否跳过空值
   * @returns {Object}
   */
  parseParams(params, options = {}) {
    const { skipEmpty } = options
    const filterFunc = skipEmpty ? result => result != null && result !== '' : () => true

    if (Array.isArray(params)) {
      return params.map(value => this.parseParams(value, options)).filter(filterFunc)
    }

    if (_.isPlainObject(params)) {
      const result = {}

      Object.keys(params)
        .filter(key => filterFunc(params[key]))
        .forEach(key => {
          result[key] = this.parseParams(params[key], options)
        })

      return result
    }

    return this.parseValue(params)
  },
  /**
   * 处理参数
   * 目前只处理 字符串前后空格和日期格式
   *
   * @param {any} value
   * @returns
   */
  parseValue(value) {
    let result = value

    if (typeof value === 'string') {
      result = value.trim()
    } else if (value instanceof moment) {
      // antd 日期组件默认返回 moment 格式
      result = value.format('YYYY-MM-DD')
    }

    return result
  }
}
