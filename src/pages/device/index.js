import styles from './index.less'
import React from 'react'
import axios from '../../component/axios'
import { routerURL } from '../../common/util'

import { Table, Button, Badge, Tag, Breadcrumb, Layout, message } from 'antd';
import { Resizable } from 'react-resizable';
import { Link } from 'react-router-dom'
import ExtraPage from './component/extra'
import WebSocket from '../../component/websocket'

const wsInstance = WebSocket.create("9BB08FF2-06BE-456F-A6CD-583260A244F5")

export default class IndexPage extends React.Component {
  state = {
    loading: false,
    visible: false,
    device: null,
    isProfile: false,
    columns: [
      {
        title: '名称',
        dataIndex: 'name',
        width: 280,
        render: (text, record) => {
          return <Badge status="processing" text={text}></Badge>
        }
      },
      {
        title: '设备类型',
        dataIndex: 'modelName',
        width: 180,
        render: (text, record) => {
          return <span><Tag color="#87d068">{text}</Tag> <Badge status={text ? 'warning' : 'success'} text={text ? '模拟器' : '真机'} /></span>
        }
      },
      {
        title: '唯一标识',
        dataIndex: 'deviceId',
        width: 380,
        render: (text, record) => {
          return <Tag color="purple">{record.deviceId}</Tag>
        }
      },
      {
        title: '操作系统/版本',
        dataIndex: 'osVersion',
        width: 150,
        render: (text, record) => {
          return record.osName + '/' + record.osVersion;
        }
      },
      {
        title: 'App版本',
        dataIndex: 'appVersion',
        width: 100,
      },
      {
        title: 'IP地址',
        dataIndex: 'ipAddrs',
        width: 200,
        render: (text, record) => {
          return (<div><span style={{ color: "orange", marginRight: 6 }}> {typeof text == "object" ? text.ipv4.en0 : text}</span> <Button onClick={() => this.showDrawer(record, false)}>查看</Button></div>)
        }
      },
      {
        title: '扩展信息',
        dataIndex: 'profile',
        render: (text, record) => {
          return <Button onClick={() => this.showDrawer(record, true)}>查看</Button>;
        }
      },
      {
        title: '操作',
        key: 'action',
        render: (text, record) => {
          return (<Link to={routerURL('/device/log', record)}>日志监控</Link>);
        }
      }
    ],
    devices: []
  }

  showDrawer = (device, isProfile) => {
    this.setState({
      visible: true,
      device,
      isProfile
    });
  };

  componentDidMount() {
    wsInstance.connect(this.onMessage)
  }

  onMessage = (msg) => {
    if (msg.code == 0) {
      switch (msg.type) {
        case 1:
          this.getDeviceList()
          break;
        case 11:
          this.setState({ devices: msg.data, loading: false })
          break;
        default:
          break;
      }
    } else {
      message.error(msg.error)
    }
  }

  // 获取设备列表
  getDeviceList = () => {
    this.setState({ loading: true });
    wsInstance.sendMessage({ type: 11, appKey: window.__config__.projectInfo.identify })
  }

  render() {
    const { devices, loading, columns } = this.state;
    return <Layout>
      <Breadcrumb style={{ marginBottom: 12 }}>
        <Breadcrumb.Item>
          <a href="/">首页</a>
        </Breadcrumb.Item>
        <Breadcrumb.Item>设备列表</Breadcrumb.Item>
      </Breadcrumb>
      <Button style={{ width: 125, marginBottom: 6 }} type="primary" onClick={this.getDeviceList}>刷新</Button>
      <Table
        bordered
        loading={loading}
        size='small'
        className='custom-table'
        rowKey='deviceId'
        columns={columns} dataSource={devices} />
      <ExtraPage
        onClose={() => this.setState({ visible: false })}
        visible={this.state.visible}
        device={this.state.device}
        isProfile={this.state.isProfile}></ExtraPage>
    </Layout>;
  }
}
