import styles from './index.css'
import React from 'react'
import axios from '../../component/axios'
import { routerURL } from '../../common/util'

import { Table } from 'antd';
import { Resizable } from 'react-resizable';
import { Link } from 'react-router-dom'

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
    columns: [
      {
        title: '名称',
        dataIndex: 'name',
        width: 200,
      },
      {
        title: '设备类型',
        dataIndex: 'modelName',
        width: 100,
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
        key: 'ipAddr'
      },
      {
        title: '自定义',
        key: 'action',
        render: (text, record) => {
          return (<Link to={routerURL('logger', record)}>查看</Link>);
        }
      }
    ],
    devices: []
  }

  components = {
    header: {
      cell: ResizeableTitle,
    },
  };

  componentDidMount() {
    // WebSocket.create('E7003F069F0BB9C8BC6262709758610A').connect(this.onMessage)
    this.getDeviceList();
  }

  // 获取设备列表
  getDeviceList = () => {
    if (this.state.loading) {
      return
    }
    this.setState({ loading: true });
    axios.get('/device/list?appkey=' + 'com.binaryparadise.MCFrontendKit')
      .then((result) => {
        this.setState({ devices: result.devices })
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
    const { devices, loading, columns } = this.state;
    columns.map((col, index) => ({
      ...col,
      onHeaderCell: column => ({
        width: column.width,
        onResize: this.handleResize(index),
      }),
    }));

    return <Table bordered loading={loading} size='small' className='custom-table' rowKey='deviceId' components={this.components} columns={columns} dataSource={devices} />;
  }
}
