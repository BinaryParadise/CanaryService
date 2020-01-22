// 应用管理
import React from 'react'
import { message, Modal, Menu, Layout } from 'antd'

import axios from '../../component/axios'

import { EnvEdit, AddConfigForm } from './components/envedit'
import EnvList from './components/env-list'
import { routerURL } from "../../common/util"
import router from 'umi/router'

export default class EnvConfig extends React.Component {
  state = {
    listData: [],
    tableLoading: false,
    modal: {
      visible: false,
      loading: false,
      appId: 0,
      key: 0,
      title: "新增",
      data: null
    },
    record: {},
    params: {
      appId: window.__config__.projectInfo.id,
      type: 0,
      pageSize: 15
    }
  }

  componentDidMount() {
    // this.query()
  }

  render() {
    const { listData, tableLoading, modal, params } = this.state
    const { envTypeList } = window.__config__
    return (
      <Layout>
        <Menu mode="horizontal" selectedKeys={[params.type.toString()]} onClick={this.onTypeSelect}
          style={{ marginBottom: '6px' }}>
          {
            envTypeList.map(record => <Menu.Item key={record.type}>{record.title}</Menu.Item>)
          }
        </Menu>

        <EnvEdit
          onModalShow={this.onAdd}
          onSearch={this.query}
          style={{ width: '100%' }} />

        <div style={{ margin: '6px 0' }} />

        <EnvList
          onEdit={this.onRowEdit}
          listData={listData}
          loading={tableLoading}
          onChange={this.query}
          pageSize={params.pageSize}
          onRowClick={this.onRowClick}
        />

        <Modal
          title={modal.title}
          visible={modal.visible}
          confirmLoading={modal.loading}
          onOk={this.onModalOk}
          onCancel={this.onModalCancel}
          key={modal.key}
          maskClosable={false}
        >

          <AddConfigForm data={modal.data} />
        </Modal>
      </Layout>
    )
  }

  // 环境列表
  query = () => {
    this.setState({ tableLoading: true })
    const newParams = Object.assign(this.state.params)

    return axios
      .get('/list', { params: newParams })
      .then(result => {
        this.setState({ listData: result })
      }).finally(() => this.setState({ tableLoading: false, params: newParams }))
  }

  onRowClick = (record) => {
    router.push(routerURL(record.id, record))
  }

  onAdd = (record) => {
    const { modal, params } = this.state
    this.setState({
      modal: {
        ...modal,
        visible: true,
        key: modal.key + 1,
        title: '新增',
        data: { id: 0, appId: params.appId, name: '', type: 0, comment: '' }
      }
    })
  }

  onRowEdit = (record) => {
    const { modal } = this.state
    this.setState({ modal: { ...modal, visible: true, title: '编辑', data: record, key: modal.key + 1 } })
  }

  onTypeSelect = (item) => {
    this.state.params.type = item.key
    this.query()
  }

  onModalOK = () => {

  }

  // 关闭弹窗
  onModalCancel = () => {
    this.setState({ modal: { ...this.state.modal, visible: false } })
  }
}
