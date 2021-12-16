import React from "react";
import { Table, Tag, Breadcrumb, Layout } from 'antd';
import axios from '@/component/axios'
import moment from 'moment';
import { routerURL } from '@/common/util'
import { Link } from 'react-router-dom'

export default class CrashDevice extends React.Component {
    state = {
        deviceid: this.props.match.params.deviceid,
        crashs: [],
        loading: false
    }

    columns = [
        {
            title: '编号',
            dataIndex: 'id',
            width: 50
        },
        {
            title: '设备标识',
            dataIndex: 'deviceid',
            width: 135,
            render: (text, record) => {
                return <Tag color="purple">{record.deviceid}</Tag>
            }
        },
        {
            title: '名称',
            dataIndex: 'name',
            width: 180
        },
        {
            title: '崩溃原因',
            dataIndex: 'reason',
        },
        {
            title: '时间',
            dataIndex: 'timestamp',
            width: 155,
            render: (text) => {
                return moment(text).format('YYYY-MM-DD HH:mm:ss')
            }
        },
        {
            title: '操作',
            key: 'action',
            width: 80,
            render: (text, record) => {
                return (<span><Link to={routerURL('/crash/info/' + record.id, record)} target="_blank">详细堆栈</Link></span >);
            }
        }
    ]

    componentDidMount() {
        this.queryAll()
    }

    queryAll() {
        this.setState({ loading: true });
        axios.get("/crash/" + this.state.deviceid, {}).then(result => {
            this.setState({ crashs: result.data, loading: false })
        }).finally(() => this.setState({ loading: false }))
    }

    render() {
        const { loading, crashs } = this.state
        return (
            <Layout>
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
                    rowKey='id'
                    columns={this.columns} dataSource={crashs} />
            </Layout>)
    }
}