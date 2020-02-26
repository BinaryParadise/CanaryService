import React from 'react'
import axios from '../component/axios'
import DevicePage from './device'
import { Breadcrumb, Layout } from 'antd'

export default class IndexPage extends React.Component {

  componentDidMount() {
  }

  render() {
    return (
      <Layout>
        <Breadcrumb style={{ marginBottom: 12 }}>
          <Breadcrumb.Item>
            <a href="">首页</a>
          </Breadcrumb.Item>
          <Breadcrumb.Item>概览</Breadcrumb.Item>
        </Breadcrumb>

        <DevicePage></DevicePage>
      </Layout>
    );
  }
}
