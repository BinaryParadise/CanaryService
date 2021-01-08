import React from 'react'
import { Table, Popconfirm, Layout, Button, message, Modal, Dropdown, Breadcrumb, Icon, Menu } from "antd";
import axios from '../../component/axios'
import MockEditForm from './edit'
import moment from 'moment'
import { routerURL } from '../../common/util'
import { Link } from 'react-router-dom'

export default class MockIndexPage extends React.Component {
    state = {
        loading: false,
        listData: [],
        queryParam: {
            appid: (window.__config__.projectInfo || {}).id,
            groupid: null,
            pageSize: 200,
            current: 1
        },
        editItem: {
            visible: false,
            data: {}
        },
        groups: [],
        group: {
            name: "全部分类",
            id: null
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
                width: 666,
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
                        <Link style={{ marginLeft: 8, color: "#e02a31" }} to={routerURL("/mock/scene", record)}>编辑模板</Link>
                    </span>
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
            this.setState({ listData: result.data, loading: false, editItem: { visible: false, data: {} } })
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
        this.state.queryParam.current = pagination.current
        this.state.queryParam.pageSize = pagination.pageSize
        this.state.queryParam.groupid = (filters.groupname || [null])[0]
        this.queryAll()
    }

    onEdit = (record) => {
        this.setState({ editItem: { visible: true, data: record } })
    }

    onSave = () => {
        const { form } = this.formRef.props;
        form.validateFields((err, values) => {
            if (err) {
                return;
            }

            this.submit(values, () => {
                form.resetFields()
                this.queryAll()
            });
        });
    }

    onCancel = () => {
        const { editItem } = this.state
        this.setState({ editItem: { ...editItem, visible: false } })
    }

    submit = (values, callback) => {
        return axios.post('/mock/update', values).then(result => {
            if (result.code == 0) {
                message.success("保存成功")
                callback()
            } else {
                message.error(result.error)
            }
        });
    }

    componentDidMount() {
        this.queryGroup()
    }

    render() {
        const { loading, listData, editItem, group, groups } = this.state
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
                <Modal
                    visible={editItem.visible}
                    title={editItem.data == null ? "新增" : "修改"}
                    cancelText="取消"
                    okText="保存"
                    width={900}
                    onCancel={this.onCancel}
                    onOk={this.onSave}
                    destroyOnClose={true}
                >
                    <MockEditForm wrappedComponentRef={this.saveFormRef} data={editItem.data || {}}></MockEditForm>
                </Modal>
            </Layout >
        )
    }
}