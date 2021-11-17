import React from 'react'
import PropTypes from 'prop-types'
import { Form, Input, Modal, message, Switch, Icon, Radio } from 'antd'
import axios from '../../component/axios'

export default class EnvItemDetailForm extends React.Component {
  static propTypes = {
    modal: PropTypes.object.isRequired,
    data: PropTypes.object.isRequired,
    onChange: PropTypes.func.isRequired,
    onCancel: PropTypes.func.isRequired
  }

  formRef = React.createRef()
  platforms = [
    { platform: 0, title: '全部' },
    { platform: 1, title: 'iOS' },
    { platform: 2, title: 'Android' }]


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
    data = { ...data, envid: modal.envid, id: data.id || 0, updateTime: 0 }
    this.setState({ modal: Object.assign(modal, { loading: true }) })

    return axios
      .post('/env/update/' + data.id, Object.assign(data))
      .then(() => this.onFinished(true, { visible: false }))
      .finally(() => this.onFinished(false, { loading: false }))
  }

  render() {
    const { data, modal, onCancel } = this.props
    const formItemLayout = {
      labelCol: { span: 6 },
      wrapperCol: { span: 18 }
    }

    return (
      <Modal
        title={'新增'}
        visible={modal.visible}
        confirmLoading={modal.loading}
        onOk={() => {
          this.formRef.current.validateFields().then(values => this.saveAdd(values))
        }}
        onCancel={onCancel}
        key={modal.key}
        maskClosable={false}
      >
        <Form ref={this.formRef} initialValues={{ ...data, platform: data.platform || 0 }}>
          <Form.Item name="id" style={{ display: 'none' }}>¸
            <Input type="hidden" />
          </Form.Item>
          <Form.Item name="name" rules={[{ required: true, message: '请输入参数名称!' }]} {...formItemLayout} label="参数名称">
            <Input placeholder="请输入参数名称" />
          </Form.Item>
          <Form.Item name="value" rules={[{ required: true, message: '请输入参数值!' }]} {...formItemLayout} label="参数值">
            <Input placeholder="请输入参数值" />
          </Form.Item>
          <Form.Item name="platform" rules={[{ required: false }]} {...formItemLayout} label="类型">
            <Radio.Group name='envtypes'>
              {this.platforms.map(record => <Radio.Button key={record.platform}
                value={record.platform}>{record.title}</Radio.Button>)}
            </Radio.Group>
          </Form.Item>
          <Form.Item name="comment" rules={[{ required: false, message: '请输入参数描述!' }]} {...formItemLayout} label="描述">
            <Input placeholder="请输出参数描述" />
          </Form.Item>
        </Form>
      </Modal >
    )
  }
}