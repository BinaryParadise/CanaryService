import styles from './index.css'
import React from 'react'
import axios from '../../component/axios'
import { routerURL } from '../../common/util'

import { Table, Button, Badge, Tag, Breadcrumb } from 'antd';
import { Resizable } from 'react-resizable';
import { Link } from 'react-router-dom'
import ExtraPage from './component/extra'

const ResizeableTitle = props => {
  const { onResize, width, ...restProps } = props;

  if (!width) {
    return <th {...restProps} />;
  }

  return (
    <Resizable
      width={width}
      height={0}
      onResize={onResize}
      draggableOpts={{ enableUserSelectHack: false }}
    >
      <th {...restProps} />
    </Resizable>
  );
};

export default class IndexPage extends React.Component {
  state = {
    loading: false,
    visible: false,
    device: null,
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
        dataIndex: 'ipAddr',
        width: 130
      },
      {
        title: '扩展信息',
        dataIndex: 'profile',
        render: (text, record) => {
          return <Button onClick={() => this.showDrawer(record)}>查看</Button>;
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

  showDrawer = (device) => {
    this.setState({
      visible: true,
      device
    });
  };

  components = {
    header: {
      cell: ResizeableTitle,
    },
  };

  componentDidMount() {
    this.getDeviceList();
  }

  // 获取设备列表
  getDeviceList = () => {
    if (this.state.loading) {
      return
    }
    this.setState({ loading: true });
    axios.get('/device/list?appkey=' + window.__config__.projectInfo.identify)
      .then((result) => {
        this.setState({ devices: result.data.devices })
      })
      .finally(() => {
        this.setState({ loading: false })
      })
  }

  handleResize = index => (e, { size }) => {
    this.setState(({ columns }) => {
      const nextColumns = [...columns];
      nextColumns[index] = {
        ...nextColumns[index],
        width: size.width,
      };
      return { columns: nextColumns };
    });
  };

  render() {
    const { devices, loading, columns, record } = this.state;
    columns.map((col, index) => ({
      ...col,
      onHeaderCell: column => ({
        width: column.width,
        onResize: this.handleResize(index),
      }),
    }));

    return <div>
      <Breadcrumb style={{ marginBottom: 12 }}>
        <Breadcrumb.Item>
          <a href="/">首页</a>
        </Breadcrumb.Item>
        <Breadcrumb.Item>设备列表</Breadcrumb.Item>
      </Breadcrumb>
      <Table
        bordered
        loading={loading}
        size='small'
        className='custom-table'
        rowKey='deviceId'
        components={this.components}
        columns={columns} dataSource={devices} />
      <ExtraPage
        onClose={() => this.setState({ visible: false })}
        visible={this.state.visible}
        device={this.state.device}></ExtraPage>
    </div >;
  }
}
