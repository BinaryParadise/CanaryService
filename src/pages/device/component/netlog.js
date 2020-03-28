import styles from '../index.less'
import PropTypes from 'prop-types'
import ReactJson from 'react-json-view'
import { Drawer, Descriptions, Tabs } from 'antd'
import React from 'react'

export default class NetLogPage extends React.Component {
    static propTypes = {
        data: PropTypes.object,
        onClose: PropTypes.func.isRequired
    }
    render() {
        const { data } = this.props
        if (data == undefined || data == null) {
            return <p></p>
        }

        return (<Drawer
            width={800}
            height={600}
            title={'总览'}
            placement="bottom"
            closable={true}
            onClose={this.props.onClose}
            visible={data != null}
            getContainer={false}
            style={{ position: 'absolute' }}
        >
            <Tabs defaultActiveKey="1" size="small">
                <Tabs.TabPane tab="请求" key="1">
                    <Descriptions column={1} size='small' layout="horizontal" bordered>
                        <Descriptions.Item key={0} label="Url"><b>{data.url}</b></Descriptions.Item>
                        <Descriptions.Item key={1} label="Method">{data.method}</Descriptions.Item>
                        <Descriptions.Item key={2} label="Headers"><ReactJson src={data.requestfields} name={false}></ReactJson></Descriptions.Item>
                        <Descriptions.Item key={2} label="Body"><ReactJson src={data.requestbody || {}} name={false}></ReactJson></Descriptions.Item>
                    </Descriptions>
                </Tabs.TabPane>
                <Tabs.TabPane tab="响应" key="2">
                    <Descriptions column={1} size='scp small' layout="horizontal" bordered>
                        <Descriptions.Item key={1} label="StatusCode"><b style={{ color: "sandybrown" }}>{data.statusCode}</b></Descriptions.Item>
                        <Descriptions.Item key={2} label="Headers"><ReactJson src={data.responsefields} name={false}></ReactJson></Descriptions.Item>
                        <Descriptions.Item key={3} label="Body"><ReactJson src={data.responsebody || {}} name={false}></ReactJson></Descriptions.Item>
                    </Descriptions>
                </Tabs.TabPane>
            </Tabs>
        </Drawer>)
    }
}