import React from 'react'
import { Form, Input, Select, Radio, Modal, message } from 'antd'
import axios from '@/component/axios'

const { Option, OptGroup } = Select

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
  formRef = React.createRef();
  state = {
    data: this.props.data,
    listData: null
  }

  envTypeList = [
    { type: 0, title: '测试', key: '0' },
    { type: 1, title: '开发', key: '1' },
    { type: 2, title: '生产', key: '2' }]

  componentDidMount() {
    this.getEnvTemplate()
  }

  getEnvTemplate = () => {
    axios.get("/conf/full", {}).then(result => this.setState({ listData: result.data }))
  }

  chooseTemplate = (list) => {
    return (<Select placeholder="选择模板" allowClear>
      {
        list.map(g => <OptGroup key={g.type} label={g.name}>{g.items.map(d => <Option
          key={d.id} value={d.id}>{d.name}</Option>)}</OptGroup>)
      }
    </Select>)
  }

  onFinished = (values) => {
    values.updateTime = 0
    return axios.post(`/conf/update/${values.id}`, values).then(result => {
      if (result.code == 0) {
        message.success("保存成功")
        this.setState({ data: { visible: false } })
        if (this.onClose) {
          this.onClose()
        }
      } else {
        message.error(result.msg)
      }
    });
  }

  onCancel = () => {
    this.setState({ data: { ...this.state.data, visible: false } })
  }

  render() {
    const { listData, data } = this.state
    if (listData == null || !data.visible) {
      return <div></div>
    }
    return (
      <Modal title={data.id ? "修改" : "添加"}
        visible={data.visible}
        confirmLoading={data.loading}
        onOk={() => {
          this.formRef.current.validateFields().then(values => this.onFinished(values))
        }}
        onCancel={this.onCancel}
        maskClosable={false} >
        <Form ref={this.formRef} {...formItemLayout}>
          <Form.Item name="id" initialValue={data.id || 0} style={{ display: 'none' }}>
            <Input type="hidden" />
          </Form.Item>

          {data.id == undefined &&
            <Form.Item name="copyid" {...formItemLayout} label="模板">
              {this.chooseTemplate(listData)}
            </Form.Item>
          }

          <Form.Item name="name" initialValue={data.name} rules={[{ required: true, message: '请输入环境名称!' }]} {...formItemLayout} hasFeedback label="环境名称">
            <Input placeholder="请勿使用特殊字符" />
          </Form.Item>
          <Form.Item name="comment" initialValue={data.comment} rules={[{ required: true, message: '请输入说明' }]} {...formItemLayout} hasFeedback label="描述">
            <Input placeholder="环境说明" />
          </Form.Item>
          <Form.Item name="type" initialValue={data.type} {...formItemLayout} label="类型">
            <Radio.Group name='envtypes'>
              {this.envTypeList.map(record => <Radio.Button key={record.type}
                value={record.type}>{record.title}</Radio.Button>)}
            </Radio.Group>
          </Form.Item>
        </Form>
      </Modal>
    )
  }
}
export default EnvEditForm