import React from 'react'
import PropTypes from 'prop-types'
import { Form, Input, Radio } from 'antd'

const FormItem = Form.Item

const AppDetail = ({ form, record }) => {
  const { getFieldDecorator } = form

  const formItemLayout = {
    labelCol: { span: 6 },
    wrapperCol: { span: 18 }
  }

  const isEdit = !!record.id

  return (
    <Form>
      <FormItem {...formItemLayout} label="Code" hasFeedback>
        {getFieldDecorator('code', {
          initialValue: record.code,
          rules: [{ required: true, message: '请填写编码' }]
        })(<Input maxLength="32" disabled={isEdit} />)}
      </FormItem>

      <FormItem {...formItemLayout} label="应用名称" hasFeedback>
        {getFieldDecorator('name', {
          initialValue: record.name,
          rules: [{ required: true, message: '请填写应用名称' }]
        })(<Input maxLength="32" />)}
      </FormItem>

      <FormItem {...formItemLayout} label="状态" hasFeedback>
        {getFieldDecorator('status', {
          initialValue: record.status,
          rules: [{ required: true, message: '请选择状态' }]
        })(
          <Radio.Group>
            <Radio value={1}>启用</Radio>
            <Radio value={2}>停用</Radio>
          </Radio.Group>
        )}
      </FormItem>

      <FormItem {...formItemLayout} label="描述" hasFeedback>
        {getFieldDecorator('comment', {
          initialValue: record.comment
        })(<Input type="textarea" rows={2} maxLength="120" />)}
      </FormItem>
    </Form>
  )
}

AppDetail.propTypes = {
  form: PropTypes.object.isRequired,

  record: PropTypes.object.isRequired
}

export default Form.create()(AppDetail)
