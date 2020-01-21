import React from 'react'
import PropTypes from 'prop-types'
import { Form, Input, Modal, message, Switch, Icon, Radio } from 'antd'
import axios from '../../component/axios'

@Form.create()
class EnvDetailForm extends React.Component {
  static propTypes = {
    form: PropTypes.object.isRequired,
    envid: PropTypes.number.isRequired
  }

  render() {
    const { getFieldDecorator } = this.props.form
    const { platforms } = window.__config__
    const formItemLayout = {
      labelCol: { span: 6 },
      wrapperCol: { span: 18 }
    }

    return (
      <Form>
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
            rules: [{required: false}]
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

export default class EnvItemAdd extends React.Component {
  static propTypes = {
    modal: PropTypes.object.isRequired,
    onChange: PropTypes.func.isRequired,
    onCancel: PropTypes.func.isRequired
  }

  onSubmit = e => {
    const { modal } = this.props

    this.refs.form.validateFields((errors, data) => {
      if (!errors) {
        data.id = 0
        data.envid = modal.envid
        data.type = data.extension ? 1 : 0;
        this.saveAdd(data)
      }
    })
  }

  onFinished = (success, props) => {
    const { modal } = this.props
    this.setState({ modal: Object.assign(modal, props) })
    if (success) {
      message.success('添加成功!')
      this.props.onChange(modal.envid)
    }
  }

  saveAdd(data) {
    const { modal } = this.props
    this.setState({ modal: Object.assign(modal, { loading: true }) })

    return axios
      .post('/envitem/update/' + data.id, Object.assign(data))
      .then(() => this.onFinished(true, { visible: false }))
      .finally(() => this.onFinished(false, { loading: false }))
  }

  render() {
    const { modal, onCancel } = this.props

    return (
      <Modal
        title={'新增'}
        visible={modal.visible}
        confirmLoading={modal.loading}
        onOk={this.onSubmit}
        onCancel={onCancel}
        key={modal.key}
        maskClosable={false}
      >
        <EnvDetailForm ref="form" envid={modal.envid} />
      </Modal>
    )
  }
}
