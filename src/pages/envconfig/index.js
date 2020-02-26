// 应用管理
import React from 'react'
import { message, Modal, Menu, Layout, Button, Breadcrumb } from 'antd'

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
      appId: (window.__config__.projectInfo || {}).id,
      key: 0,
      title: "新增",
      data: null
    },
    record: {},
    params: {
      appId: (window.__config__.projectInfo || {}).id,
      type: 0,
      pageSize: 5,
      pageIndex: 1
    }
  }



  // 环境列表
  query = () => {
    this.setState({ tableLoading: true, modalData: { ...this.state.modalData, visible: false } })
    const newParams = Object.assign(this.state.params)

    axios.get('/conf/list', { params: newParams })
      .then(result => {
        if ((result||{}).code == 0) {
          this.setState({ listData: result.data })
        }
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
    const { form } = this.formRef.props;
    form.validateFields((err, values) => {
      if (err) {
        return;
      }

      this.submit(values, () => {
        form.resetFields()
        this.query()
      });
    });
    this.setState({ modalData: { ...this.state.modalData, visible: false } })
  }

  // 关闭弹窗
  onModalCancel = () => {
    this.setState({ modalData: { ...this.state.modalData, visible: false } })
  }

  submit = (values, callback) => {
    return axios.post(`/conf/update/${values.id}`, values).then(result => {
      if (result.code == 0) {
        message.success("保存成功")
        callback()
      } else {
        message.error(result.error)
      }
    });
  }

  componentDidMount() {
    this.query()
  }

  render() {
    const { listData, tableLoading, modalData, params } = this.state
    const { envTypeList } = window.__config__
    return (<Layout>
      <Breadcrumb style={{ marginBottom: 12 }}>
        <Breadcrumb.Item>
          <a href="/">首页</a>
        </Breadcrumb.Item>
        <Breadcrumb.Item>环境列表</Breadcrumb.Item>
      </Breadcrumb>
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
        <EnvEditForm wrappedComponentRef={(ref) => this.formRef = ref} data={modalData.data} >
        </EnvEditForm>
      </Modal>

    </Layout>
    )
  }
}
