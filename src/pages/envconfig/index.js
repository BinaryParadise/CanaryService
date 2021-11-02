// 应用管理
import React from 'react'
import { message, Modal, Menu, Layout, Button, Breadcrumb } from 'antd'

import axios from '../../component/axios'

import EnvEditForm from './components/envedit'
import EnvList from './components/env-list'
import { routerURL } from "../../common/util"
import { history } from 'umi'
import { PlusOutlined } from '@ant-design/icons'

export default class EnvConfig extends React.Component {
  state = {
    listData: [],
    tableLoading: false,
    data: {
      visible: false,
      key: Math.random(),
      record: null
    },
    params: {
      type: 0,
      pageSize: 5,
      pageIndex: 1,
    }
  }

  envTypeList = [
    { type: 0, title: '测试', key: '0' },
    { type: 1, title: '开发', key: '1' },
    { type: 2, title: '生产', key: '2' }]

  // 环境列表
  query = () => {
    this.setState({ tableLoading: true })
    const newParams = Object.assign(this.state.params)

    axios.get('/conf/list', { params: newParams }, { withCredentials: true })
      .then(result => {
        if ((result || {}).code == 0) {
          this.setState({ listData: result.data })
        }
      }).finally(() => this.setState({ tableLoading: false, params: newParams }))
  }

  onRowClick = (record) => {
    history.push(routerURL(record.id, record))
  }

  onAdd = () => {
    this.setState({ data: { ...this.state.data, key: Math.random(), visible: true, type: this.envTypeList[0].type } })
  }

  onRowEdit = (record) => {
    this.setState({ data: { ...record, visible: true, key: Math.random() } })
  }

  onTypeSelect = (item) => {
    this.state.params.type = item.key
    this.query()
  }

  componentDidMount() {
    this.query()
  }

  render() {
    const { listData, tableLoading, data, params } = this.state

    return (<Layout>
      <Breadcrumb style={{ marginBottom: 12 }}>
        <Breadcrumb.Item>
          <a href="/">首页</a>
        </Breadcrumb.Item>
        <Breadcrumb.Item>环境列表</Breadcrumb.Item>
      </Breadcrumb>
      <Button
        type="primary"
        style={{ width: 100 }}
        icon={<PlusOutlined></PlusOutlined>}
        onClick={this.onAdd}>
        添加环境
      </Button>

      <div style={{ margin: '6px 0' }} />

      <Menu mode="horizontal" selectedKeys={[params.type.toString()]} onClick={this.onTypeSelect}
        style={{ marginBottom: '6px' }}>
        {
          this.envTypeList.map(record => <Menu.Item key={record.type}>{record.title}</Menu.Item>)
        }
      </Menu>

      <EnvList
        onEdit={this.onRowEdit}
        listData={listData}
        loading={tableLoading}
        onChange={this.query}
        pageSize={params.pageSize}
        onRowClick={this.onRowClick} />

      <EnvEditForm onClose={this.query} key={data.key} data={data} >
      </EnvEditForm>
    </Layout>
    )
  }
}
