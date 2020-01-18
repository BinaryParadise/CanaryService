import styles from './index.css';
import React from 'react'
import WebSocket from './component/websocket'

import { Breadcrumb, Row, Col, Card, Layout, Descriptions } from 'antd';

export default class IndexPage extends React.Component {

  componentDidMount() {
    WebSocket.create('1234567890').connect(this.onMessage)
  }

  render() {
    return (
      <Layout>
        <Breadcrumb>
          <Breadcrumb.Item>
            <a href="">首页</a>
          </Breadcrumb.Item>
          <Breadcrumb.Item>概览</Breadcrumb.Item>
        </Breadcrumb>
        <div style={{ marginTop: '12px' }} className={styles.shadow}>
          <Descriptions bordered title="Custom Size" size='small'>
            <Descriptions.Item label="Product">Cloud Database</Descriptions.Item>
            <Descriptions.Item label="Billing">Prepaid</Descriptions.Item>
            <Descriptions.Item label="time">18:00:00</Descriptions.Item>
            <Descriptions.Item label="Amount">$80.00</Descriptions.Item>
            <Descriptions.Item label="Discount">$20.00</Descriptions.Item>
            <Descriptions.Item label="Official">$60.00</Descriptions.Item>
            <Descriptions.Item label="Config Info">
              Data disk type: MongoDB
            <br />
              Database version: 3.4
            <br />
              Package: dds.mongo.mid
            <br />
              Storage space: 10 GB
            <br />
              Replication factor: 3
            <br />
              Region: East China 1<br />
            </Descriptions.Item>
          </Descriptions><Descriptions bordered title="Custom Size" size='small' style={{ backgroundColor: '#fff' }}>
            <Descriptions.Item label="Product">Cloud Database</Descriptions.Item>
            <Descriptions.Item label="Billing">Prepaid</Descriptions.Item>
            <Descriptions.Item label="time">18:00:00</Descriptions.Item>
            <Descriptions.Item label="Amount">$80.00</Descriptions.Item>
            <Descriptions.Item label="Discount">$20.00</Descriptions.Item>
            <Descriptions.Item label="Official">$60.00</Descriptions.Item>
            <Descriptions.Item label="Config Info">
              Data disk type: MongoDB
            <br />
              Database version: 3.4
            <br />
              Package: dds.mongo.mid
            <br />
              Storage space: 10 GB
            <br />
              Replication factor: 3
            <br />
              Region: East China 1<br />
            </Descriptions.Item>
          </Descriptions>
        </div>
      </Layout>
    );
  }

  onMessage = (obj) => {
    console.error(obj)
  }
}
