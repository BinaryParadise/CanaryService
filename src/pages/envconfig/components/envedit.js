import React from 'react'
import PropTypes from 'prop-types'
import { Button, Form, Input, Select, message, Menu, Radio } from 'antd'
import axios from '../../../component/axios'

const Option = Select.Option
const TextArea = Input.TextArea

export class EnvEdit extends React.Component {
  static propTypes = {
    onModalShow: PropTypes.func.isRequired,
  }

  render() {
    const { onModalShow } = this.props
    return (
      <Form layout="inline" className='full-menu'>
        <Form.Item>
          <Button
            type="primary"
            className="def-margin-left"
            icon={'plus'}
            onClick={onModalShow}
          >
            添加环境
          </Button>
        </Form.Item>
      </Form>
    )
  }
}

class AddConfigForm extends React.Component {
  static propTypes = {
    data: PropTypes.object
  }

  state = {
    listData: []
  }

  componentDidMount() {

  }

  render() {
    return (<p></p>)
    const { envTypeList } = window.__config__
    const { getFieldDecorator } = this.props.form
    const { data } = this.props
    const { listData } = this.state
    const formItemLayout = {
      labelCol: { span: 5 },
      wrapperCol: { span: 16 }
    }

    return (
      <div>
        <Form>
          <Form.Item>
            <Input type={'hidden'} />
          </Form.Item>
          {data != null &&
            <Form.Item {...formItemLayout} hasFeedback label="模板">
              {getFieldDecorator('copyid', {
                rules: [{ required: false }]
              })(
                <Select placeholder="选择模板" onChange={this.handleAppChange} allowClear>
                  {
                    listData.map(g => <Select.OptGroup key={g.type} label={g.title}>{g.items.map(d => <Option
                      key={d.id}>{d.name}</Option>)}</Select.OptGroup>)
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
          <Form.Item {...formItemLayout} label="描述">
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
      </div>
    )
  }

  // 查询所有模板
  queryAll = async () => {
    const result = await axios.get('/list', { params: { appId: window.__config__.projectInfo.id } })
    return this.setState({ groupData: this.processGroupData(result) })
  }

  processGroupData = (result) => {
    const { envTypeList } = window.__config__
    var g = envTypeList.slice(0)
    g.map(p => {
      p.items = []
      result.forEach((r) => r.type == p.type && p.items.push(r))
    })
    return g
  }

  onSubmit = () => {
    this.from.validateFields((errors, data) => {
      if (!errors) {
        this.setState({ modal: { ...this.state.modal, loading: true } })
        data.appId = this.state.modal.data.appId
        data.id = this.state.modal.data.id
        var id = data.id ? data.id : 0
        axios
          .post('/update/' + id, data)
          .then(() => {
            message.success('保存成功')
            this.query(data.appId)
            this.setState({ modal: { ...this.state.modal, visible: false } })
          })
          .finally(() => {
            this.setState({ modal: { ...this.state.modal, loading: false } })
          })
      }
    })
  }

}
