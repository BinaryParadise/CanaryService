import React from "react";
import { Breadcrumb, Layout, Descriptions, List } from 'antd';
import axios from '@/component/axios'
import moment from 'moment';

export default class CrashLog extends React.Component {
    state = {
        cid: this.props.match.params.id,
        data: {}
    }

    componentDidMount() {
        this.query()
    }

    query() {
        axios.get("/crash/info/" + this.state.cid, {}).then(result => {
            this.setState({ data: result.data, loading: false })
        }).finally(() => this.setState({ loading: false }))
    }

    render() {
        const { data } = this.state
        return (
            <Layout>
                <Breadcrumb style={{ marginBottom: 12 }}>
                    <Breadcrumb.Item>
                        首页
                    </Breadcrumb.Item>
                    <Breadcrumb.Item>崩溃日志</Breadcrumb.Item>
                    <Breadcrumb.Item>{data.id}（{data.deviceid}）</Breadcrumb.Item>
                </Breadcrumb>
                <List>
                    <List.Item>{data.name}</List.Item>
                    <List.Item>{moment(data.timestamp).format('YYYY-MM-DD HH:mm:ss')}</List.Item>
                    <List.Item>{data.reason}</List.Item>
                </List>
                <List dataSource={data.stackSymbols} size='small' renderItem={item => <List.Item>{item}</List.Item>}>
                </List>
            </Layout >)
    }
}