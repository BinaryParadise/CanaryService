import React from 'react';
import { Layout, Tabs, Descriptions } from 'antd';
import ReactJson from 'react-json-view'

const CollapseLength = 350

export default class RequestBrowserPage extends React.Component {
    state = {
        data: JSON.parse(localStorage.getItem("requestData"))

    }

    componentDidMount() {
    }

    render() {
        const { data } = this.state
        console.log(data)
        return (
            <Layout style={{ padding: 8 }}>
                <span style={{ color: 'orchid', fontWeight: 'bold', fontSize: 18 }}>{data.url}</span>
                <Tabs size="large">
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