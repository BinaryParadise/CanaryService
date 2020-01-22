// 应用管理
import React from 'react'
import { message, Modal, Menu, Layout, Button } from 'antd'

import axios from '../../component/axios'

import EnvEditForm from './components/envedit'
import EnvList from './components/env-list'
import { routerURL } from "../../common/util"
import router from 'umi/router'

export default class EnvConfig extends React.Component {
  state = {
    listData: [],
    tableLoading: false,
    modalData: {
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
    const { modalData, params } = this.state
    this.setState({
      modalData: {
        ...modalData,
        visible: true,
        key: modalData.key + 1,
        title: '新增',
        data: { id: 0, appId: params.appId, name: '', type: 0, comment: '' }
      }
    })
  }

  onRowEdit = (record) => {
    const { modalData } = this.state
    this.setState({ modalData: { ...modalData, visible: true, title: '编辑', data: record, key: modalData.key + 1 } })
  }

  onTypeSelect = (item) => {
    this.state.params.type = item.key
    this.query()
  }

  onModalOk = () => {
    this.setState({ modalData: { ...this.state.modalData, visible: false } })
  }

  // 关闭弹窗
  onModalCancel = () => {
    this.setState({ modalData: { ...this.state.modalData, visible: false } })
  }

  componentDidMount() {
    // this.query()
  }

  render() {
    const { listData, tableLoading, modalData, params } = this.state
    const { envTypeList } = window.__config__
    return (<Layout>
      <Button
        type="primary"
        style={{ width: 150 }}
        icon={'plus'}
        onClick={this.onAdd}>
        添加环境
        </Button>

      <div style={{ margin: '6px 0' }} />

      <Menu mode="horizontal" selectedKeys={[params.type.toString()]} onClick={this.onTypeSelect}
        style={{ marginBottom: '6px' }}>
        {
          envTypeList.map(record => <Menu.Item key={record.type}>{record.title}</Menu.Item>)
        }
      </Menu>

      <EnvList
        onEdit={this.onRowEdit}
        listData={listData}
        loading={tableLoading}
        onChange={this.query}
        pageSize={params.pageSize}
        onRowClick={this.onRowClick} />

      <Modal title={modalData.title}
        visible={modalData.visible}
        confirmLoading={modalData.loading}
        onOk={this.onModalOk}
        onCancel={this.onModalCancel}
        maskClosable={false} >
        <EnvEditForm data={modalData.data} >
        </EnvEditForm>
      </Modal>

    </Layout>
    )
  }
}
