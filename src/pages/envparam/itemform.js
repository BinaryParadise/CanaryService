import React from 'react'
import PropTypes from 'prop-types'
import { Form, Input, Modal, message, Switch, Icon, Radio } from 'antd'
import axios from '../../component/axios'

class EnvItemDetailForm extends React.Component {

  render() {
    const { getFieldDecorator } = this.props.form
    const { platforms } = window.__config__
    const { data } = this.props
    const formItemLayout = {
      labelCol: { span: 6 },
      wrapperCol: { span: 18 }
    }

    return (
      <Form>
        <Form.Item style={{ display: 'none' }}>¸
          {getFieldDecorator('id', {
          initialValue: data.id || 0
        })(<Input type="hidden" />)}
        </Form.Item>
        <Form.Item {...formItemLayout} label="参数名称">
          {getFieldDecorator('name', {
            rules: [{ required: true, message: '请输入参数名称!' }]
          })(<Input placeholder="请输入参数名称" />)}
        </Form.Item>
        <Form.Item {...formItemLayout} label="参数值">
          {getFieldDecorator('value', {
            rules: [{ required: true, message: '请输入参数值!' }]
          })(<Input placeholder="请输入参数值" />)}
        </Form.Item>
        <Form.Item {...formItemLayout} label="类型">
          {getFieldDecorator('platform', {
            initialValue: 0,
            rules: [{ required: false }]
          })(<Radio.Group name='envtypes'>
            {platforms.map(record => <Radio.Button key={record.platform}
              value={record.platform}>{record.title}</Radio.Button>)}
          </Radio.Group>)}
        </Form.Item>
        <Form.Item {...formItemLayout} label="描述">
          {getFieldDecorator('comment', {
            rules: [{ required: false, message: '请输入参数描述!' }]
          })(<Input placeholder="请输出参数描述" />)}
        </Form.Item>
      </Form>
    )
  }
}

export default Form.create()(EnvItemDetailForm);