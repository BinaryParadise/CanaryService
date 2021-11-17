import React from 'react'
import PropTypes from 'prop-types'
import { Form, Input, Radio } from 'antd'

const FormItem = Form.Item

const formItemLayout = {
  labelCol: { span: 6 },
  wrapperCol: { span: 18 }
}

export default class AppDetailFrom extends React.Component {
  formRef = React.createRef()

  state = {
    isEdit: !!this.props.data.id,
    data: this.props.data
  }

  render() {
    const { isEdit, data } = this.state
    return (
      <Form ref={this.formRef} initialValues={data}>
        <FormItem name="code" {...formItemLayout} rules={[{ required: true, message: '请填写编码' }]} label="Code" hasFeedback>
          <Input maxLength="32" disabled={isEdit} />
        </FormItem>

        <FormItem name="name" {...formItemLayout} rules={[{ required: true, message: '请填写应用名称' }]} label="应用名称" hasFeedback>
          <Input maxLength="32" />
        </FormItem>

        <FormItem name="status" {...formItemLayout} rules={[{ required: true, message: '请选择状态' }]} label="状态" hasFeedback>
          <Radio.Group>
            <Radio value={1}>启用</Radio>
            <Radio value={2}>停用</Radio>
          </Radio.Group>
        </FormItem>

        <FormItem name="comment" {...formItemLayout} label="描述" hasFeedback>
          <Input type="textarea" rows={2} maxLength="120" />
        </FormItem>
      </Form>
    )
  }
}