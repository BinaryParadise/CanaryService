// 应用管理
import React from 'react'
import { message, Breadcrumb } from 'antd'

import axios from '../../component/axios'
import { Link } from 'react-router-dom'

import EnvList from './env-list'
import EnvDetail from './env-add'

export default class RemoteConfigPage extends React.Component {
  state = {
    listData: [],
    title: '配置详情',
    tableLoading: false,
    modal: {
      visible: false,
      loading: false,
      envid: this.props.match.params.envid >> 0,
      key: 0
    },
    record: {},
    params: {
      pageIndex: 1,
      pageSize: 20,
    }
  }

  componentDidMount() {
    const params = this.props.match.params
    //this.query(params.envid)
  }

  onMessage = obj => {
    console.log(obj)
  }

  onChange = key => {
    this.query(key)
  }

  render() {
    const { listData, tableLoading, modal, params, title } = this.state
    return (
      <div>
        <Breadcrumb style={{ marginBottom: 12 }}>
          <Breadcrumb.Item>
            <a href="/">首页</a>
          </Breadcrumb.Item>
          <Breadcrumb.Item>环境配置</Breadcrumb.Item>
        </Breadcrumb>

        <div className="m-content">
          <EnvList
            onShowModal={this.onShowModal}
            listData={listData}
            loading={tableLoading}
            onChange={this.onChange}
            pageSize={params.pageSize}
            pageIndex={params.pageIndex}
            onRemove={this.onRemove}
            config={this.props.location.state}
          />

          <EnvDetail modal={modal} onChange={this.onChange} onCancel={this.onModalCancel} />
        </div>
      </div>
    )
  }

  // 环境列表
  query = (envid) => {
    this.setState({ tableLoading: true })
    const newParams = Object.assign(this.state.params, { envid })
    return axios
      .get(`/envitem/list`, { params: newParams })
      .then(result => this.setState({ listData: result, tableLoading: false }))
      .finally(() => this.setState({ tableLoading: false, params: newParams }))
  }

  // 保存
  onModalOk = () => {
    this.refs.detail.validateFields((errors, data) => {
      if (!errors) {
        this.setState({ modal: { ...this.state.modal, loading: true } })
        data.id = this.state.record.id || ''
        const url = data.id ? '/app/update' : '/app/add'

        return axios
          .post(url, data)
          .then(() => {
            message.success('保存成功')
            this.query()
            this.setState({ modal: { ...this.state.modal, visible: false } })
          })
          .finally(() => {
            this.setState({ modal: { ...this.state.modal, loading: false } })
          })
      }
    })
  }

  // 关闭弹窗
  onModalCancel = () => {
    this.setState({ modal: { ...this.state.modal, visible: false } })
  }

  // 显示弹窗
  onShowModal = (record = {}) => {
    const { modal } = this.state
    this.setState({
      modal: { ...modal, visible: true, key: modal.key + 1 }
    })
  }

  // 删除
  onRemove = id => {
    return axios.post(`/envitem/delete/${id}`).then(result => {
      message.success('删除成功！')
      this.query(this.state.modal.envid)
    })
  }
}
