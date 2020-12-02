import React from 'react'
import { Table, Popconfirm, Layout, Button, message, Modal, Badge, Breadcrumb } from "antd";
import axios from '../../component/axios'
import MockEditForm from './edit'
import moment from 'moment'

export default class MockIndexPage extends React.Component {
    columns = [
        {
            title: '名称',
            dataIndex: 'name',
            width: 300
        },
        {
            title: '方法',
            width: 300,
            dataIndex: 'method'
        },
        {
            title: '路径',
            width: 100,
            dataIndex: 'path'
        },
        {
            dataIndex: 'updateTime',
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
                    <a style={{ marginLeft: 5 }} onClick={() => this.onEdit(record)}>编辑</a>
                    <Popconfirm placement="topRight"
                        title="确定重置？" onConfirm={() => this.resetAppSecret(record)}>
                        <a style={{ marginLeft: 5, color: "#e02a31" }}>重置AppSecret</a>
                    </Popconfirm>

                </span>
                )
            }
        }
    ];

    state = {
        loading: false,
        listData: [],
        queryParam: {
            pid: (window.__config__.projectInfo || {}).id,
            pageSize: 20,
            pageIndex: 1
        },
        editItem: {
            visible: false,
            data: {}
        }
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
        this.queryAll()
    }

    render() {
        const { loading, listData, editItem } = this.state
        return (
            <Layout>
                <Breadcrumb style={{ marginBottom: 12 }}>
                    <Breadcrumb.Item>
                        <a href="/">首页</a>
                    </Breadcrumb.Item>
                    <Breadcrumb.Item>Mock数据</Breadcrumb.Item>
                </Breadcrumb>

                <Button type="primary" style={{ width: 100, marginBottom: 12 }} onClick={() => this.onEdit({})}>+添加接口</Button>

                <Table rowKey="id" loading={loading} dataSource={listData} columns={this.columns}></Table>
                <Modal
                    visible={editItem.visible}
                    title={editItem.data == null ? "新增" : "修改"}
                    cancelText="取消"
                    okText="保存"
                    onCancel={this.onCancel}
                    onOk={this.onSave}
                >
                    <MockEditForm wrappedComponentRef={this.saveFormRef} data={editItem.data || {}}></MockEditForm>
                </Modal>
            </Layout>
        )
    }
}