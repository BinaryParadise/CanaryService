import React from 'react';
import { Layout, Tabs, Descriptions, Spin } from 'antd';
import ReactJson from 'react-json-view'
import axios from '@/component/axios'

const CollapseLength = 128

export default class LogSnapshotPage extends React.Component {
    state = {
        identify: this.props.match.params.identify,
        loading: true
    }

    componentDidMount() {
        axios.get('/net/snapshot?identify=' + this.state.identify).then(result => {
            this.setState({ data: result.data, loading: false })
        })
    }

    render() {
        const { data, loading } = this.state
        if (loading) {
            return <Spin size="large" style={{ marginLeft: 30, marginTop: 20 }}></Spin>
        }
        if (data == null || data == undefined) {
            return <div>找不到指定的快照{this.state.identify}</div>
        }
        return (
            <Layout style={{ padding: 8 }}>
                <span style={{ color: 'orchid', fontWeight: 'bold', fontSize: 18 }}>{data.url}</span>
                <Tabs>
                    <Tabs.TabPane tab="请求" key="req">
                        <Descriptions size="small" column={1} layout="vertical" bordered>
                            <Descriptions.Item label={<span style={{ fontWeight: 'bold' }}>Headers</span>}><ReactJson src={data.requestfields} name={false} collapseStringsAfterLength={CollapseLength}></ReactJson></Descriptions.Item>
                            <Descriptions.Item label={<span style={{ fontWeight: 'bold' }}>Body</span>}><ReactJson src={data.requestbody || {}} name={false} collapseStringsAfterLength={CollapseLength}></ReactJson></Descriptions.Item>
                        </Descriptions>
                    </Tabs.TabPane>
                    <Tabs.TabPane tab="响应" key="res">
                        <Descriptions size="small" column={1} layout="vertical" bordered>
                            <Descriptions.Item label={<span style={{ fontWeight: 'bold' }}>Headers</span>}><ReactJson src={data.responsefields} name={false} collapseStringsAfterLength={CollapseLength}></ReactJson></Descriptions.Item>
                            <Descriptions.Item label={<span style={{ fontWeight: 'bold' }}>Body</span>}><ReactJson src={data.responsebody || {}} name={false} collapseStringsAfterLength={CollapseLength}></ReactJson></Descriptions.Item>
                        </Descriptions>
                    </Tabs.TabPane>
                </Tabs>
            </Layout >
        );
    }
}