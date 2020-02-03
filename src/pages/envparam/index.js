// 应用管理
import React from 'react'
import { message, Breadcrumb } from 'antd'

import axios from '../../component/axios'
import { Link } from 'react-router-dom'

import EnvList from './env-list'
import EnvItemAdd from './modify'

export default class RemoteConfigPage extends React.Component {
  state = {
    listData: [],
    tableLoading: false,
    modal: {
      visible: false,
      loading: false,
      key: 0,
      envid: this.props.location.state.id
    },
    record: {},
    params: {
      pageIndex: 1,
      pageSize: 20,
      envid: this.props.location.state.id
    }
  }

  componentDidMount() {
    this.query()
  }

  onMessage = obj => {
    console.log(obj)
  }

  onChange = key => {
    this.query(key)
  }

  render() {
    const { listData, tableLoading, modal, params } = this.state
    const { name } = this.props.location.state
    return (
      <div>
        <Breadcrumb style={{ marginBottom: 12 }}>
          <Breadcrumb.Item>
            <a href="/">首页</a>
          </Breadcrumb.Item>
          <Breadcrumb.Item><a href="/env">环境配置</a></Breadcrumb.Item>
          <Breadcrumb.Item>{name}</Breadcrumb.Item>
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

          <EnvItemAdd modal={modal} data={this.state.record} onChange={this.onChange} onCancel={this.onModalCancel} />
        </div>
      </div>
    )
  }

  // 环境列表
  query = () => {
    this.setState({ tableLoading: true })
    const newParams = Object.assign(this.state.params)
    return axios
      .get(`/envitem/list`, { params: newParams })
      .then(result => this.setState({ listData: result.data, tableLoading: false }))
      .finally(() => this.setState({ tableLoading: false, params: newParams }))
  }

  // 保存
  onModalOk = () => {
    this.refs.detail.validateFields((errors, data) => {
      if (!errors) {
        this.setState({ modal: { ...this.state.modal, loading: true } })
        return axios
          .post('/app/update/' + data.id, data)
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
