import React from 'react'
import { Table, Popconfirm, Layout, Button, message, Modal, Dropdown, Breadcrumb, Icon, Menu, Tag, Divider } from "antd";
import axios from '../../component/axios'
import MockEditForm from './edit'
import moment from 'moment'
import { routerURL } from '../../common/util'
import { Link } from 'react-router-dom'
import edit from './edit';

export default class MockIndexPage extends React.Component {
    state = {
        loading: false,
        listData: [],
        queryParam: {
            groupid: 0,
            pageSize: 200,
            pageNum: 1
        },
        editItem: { visible: false },
        groups: [],
        group: {
            name: "全部分类",
            id: 0
        }
    }

    groups = []

    filtersColumns = () => {
        var filters = []
        if (this.groups) {
            this.groups.map((group) => filters.push({ text: group.name, value: group.id }))
        }
        return [
            {
                title: '接口名称',
                dataIndex: 'name',
                width: 180
            },
            {
                title: '方法',
                width: 80,
                dataIndex: 'method'
            },
            {
                title: '路径',
                width: 555,
                dataIndex: 'path'
            },
            {
                title: '分类',
                width: 100,
                dataIndex: 'groupname',
                filters: filters,
                filterMultiple: false
            },
            {
                title: '状态',
                width: 80,
                render: (text, record) => {
                    return record.enabled ? <Tag color="#87d068">激活</Tag> : <Tag color="gray">闲置</Tag>
                }
            },
            {
                dataIndex: 'updatetime',
                title: '更新时间',
                width: 200,
                render: (text, record) => moment(text).format('YYYY-MM-DD HH:mm:ss')
            },
            {
                title: '操作',
                dataIndex: 'orderno',
                render: (text, record) => {
                    return (<span>
                        < Popconfirm title="确认删除?" onConfirm={() => this.handleDelete(record)
                        }>
                            <a>删除</a>
                        </Popconfirm >
                        <a style={{ marginLeft: 8 }} onClick={() => this.onEdit(record)}>编辑</a>
                        <Divider type="vertical"></Divider>
                        <Popconfirm title={record.enabled ? "确认关闭?" : "确认激活?"} onConfirm={() => this.onActive(record)}>
                            {record.enabled ? <a style={{ color: "gray" }}>关闭</a> : <a style={{ color: "#87d068" }}>激活</a>}
                        </Popconfirm>
                        <Link style={{ marginLeft: 8, color: "#e02a31" }} to={routerURL("/mock/scene", record)}>场景</Link>
                    </span >
                    )
                }
            }
        ];
    }

    saveFormRef = (formRef) => {
        this.formRef = formRef
    }

    queryAll = () => {
        const { queryParam } = this.state
        return axios.get('/mock/list', { params: queryParam }).then(result => {
            if (result.code != 0) {
                return
            }
            this.setState({ listData: result.data, loading: false, editItem: { visible: false } })
        })
    }

    queryGroup = () => {
        return axios.get('/mock/group/list', { params: this.state.queryParam }).then(result => {
            if (result.code != 0) {
                return
            }
            this.groups = result.data
            this.queryAll()
        })
    }

    handleChange = (pagination, filters, sorter, extra) => {
        console.log(pagination, filters, sorter, extra);
        this.state.queryParam.pageNum = pagination.current
        this.state.queryParam.pageSize = pagination.pageSize
        this.state.queryParam.groupid = (filters.groupname || [null])[0]
        this.queryAll()
    }

    onActive = (record) => {
        return axios.post('/mock/active', { mockid: record.id }).then(result => {
            if (result.code != 0) {
                message.error(result.msg)
                return
            }
            this.queryAll()
        })
    }

    onEdit = (record) => {
        this.setState({ editItem: { ...record, visible: true, key: Math.random() } })
    }

    handleDelete = (record) => {
        return axios.post('/mock/delete/' + record.id, {}).then(result => {
            if (result.code == 0) {
                message.success("保存成功")
                this.queryAll()
            } else {
                message.error(result.msg)
            }
        })
    }

    componentDidMount() {
        this.queryGroup()
    }

    render() {
        const { loading, listData, editItem, groups } = this.state
        var columns = this.filtersColumns()
        return (
            <Layout>
                <Breadcrumb style={{ marginBottom: 12 }}>
                    <Breadcrumb.Item>
                        <a href="/">首页</a>
                    </Breadcrumb.Item>
                    <Breadcrumb.Item>Mock数据</Breadcrumb.Item>
                </Breadcrumb>

                <Button type="primary" style={{ width: 100, marginBottom: 12 }} onClick={() => this.onEdit({})}>+添加接口</Button>

                <Table rowKey="id" loading={loading} pagination={{ pageSize: 200, showTotal: (total, range) => `${range[0]}-${range[1]} 共 ${total} 条` }} dataSource={listData} onChange={this.handleChange} columns={columns}></Table>
                <MockEditForm key={editItem.key} data={editItem} onClose={this.queryAll}></MockEditForm>
            </Layout >
        )
    }
}