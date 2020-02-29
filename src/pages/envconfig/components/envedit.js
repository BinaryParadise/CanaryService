import React from 'react'
import PropTypes from 'prop-types'
import { Button, Form, Input, Select, message, Menu, Radio } from 'antd'
import axios from '../../../component/axios'

const Option = Select.Option
const TextArea = Input.TextArea

const formItemLayout = {
  labelCol: {
    xs: { span: 24 },
    sm: { span: 5 },
  },
  wrapperCol: {
    xs: { span: 24 },
    sm: { span: 12 },
  },
};

class EnvEditForm extends React.Component {
  constructor(props) {
    super(props)
  }
  state = {
    listData: []
  }

  componentDidMount() {
    this.getEnvTemplate()
  }

  getEnvTemplate = () => {
    axios.get("/conf/full", {
      params: {
        appkey: (window.__config__.projectInfo || {}).identify
      }
    }).then(result => this.setState({ listData: result.data }))
  }

  render() {
    const { envTypeList } = window.__config__
    const { getFieldDecorator } = this.props.form
    const { data } = this.props
    const { listData } = this.state

    return (
      <Form {...formItemLayout}>
        <Form.Item style={{ display: 'none' }}>
          {getFieldDecorator('appId', {
            initialValue: data.appId
          })(<Input type="hidden" />)}
        </Form.Item>
        <Form.Item style={{ display: 'none' }}>
          {getFieldDecorator('id', {
            initialValue: data.id
          })(<Input type="hidden" />)}
        </Form.Item>

        {data.id <= 0 &&
          <Form.Item {...formItemLayout} hasFeedback label="模板">
            {getFieldDecorator('copyid', {
              rules: [{ required: false }]
            })(
              <Select placeholder="选择模板" allowClear>
                {
                  listData.map(g => <Select.OptGroup key={g.type} label={g.name}>{g.items.map(d => <Option
                    key={d.id} value={d.id}>{d.name}</Option>)}</Select.OptGroup>)
                }

              </Select>
            )}
          </Form.Item>
        }

        <Form.Item {...formItemLayout} hasFeedback label="环境名称">
          {getFieldDecorator('name', {
            initialValue: data.name,
            rules: [{ required: true, message: '请输入环境名称!' }]
          })(<Input placeholder="请勿使用特殊字符" />)}
        </Form.Item>
        <Form.Item {...formItemLayout} hasFeedback label="描述">
          {getFieldDecorator('comment', {
            initialValue: data.comment,
            rules: [{ required: true, message: '请输入说明' }]
          })(<Input placeholder="环境说明" />)}
        </Form.Item>
        <Form.Item {...formItemLayout} label="类型">
          {getFieldDecorator('type', {
            initialValue: data.type,
            rules: [{ required: false }]
          })(<Radio.Group name='envtypes'>
            {envTypeList.map(record => <Radio.Button key={record.type}
              value={record.type}>{record.title}</Radio.Button>)}
          </Radio.Group>)}
        </Form.Item>
      </Form>
    )
  }
}
export default Form.create()(EnvEditForm)