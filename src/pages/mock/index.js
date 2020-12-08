import React from 'react'
import { Table, Popconfirm, Layout, Button, message, Modal, Dropdown, Breadcrumb, Icon, Menu } from "antd";
import axios from '../../component/axios'
import MockEditForm from './edit'
import moment from 'moment'

export default class MockIndexPage extends React.Component {
    columns = [
        {
            title: '名称',
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
            width: 300,
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
                    <a style={{ marginLeft: 5, color: "#e02a31" }} onClick={() => this.onEdit(record)}>编辑模板</a>

                </span>
                )
            }
        }
    ];

    state = {
        loading: false,
        listData: [],
        queryParam: {
            appid: (window.__config__.projectInfo || {}).id,
            groupid: null,
            pageSize: 20,
            pageIndex: 1
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
            this.setState({ groups: result.data })
        })
    }

    onGroupChange = (obj) => {
        const { groups } = this.state
        var group = groups.filter(item => item.id == parseInt(obj.key))[0]
        if (group == undefined) {
            group = { name: "全部分类", id: null }
        }
        this.state.queryParam.groupid = group.id
        this.setState({ group })
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
        this.queryAll()
        this.queryGroup()
    }

    render() {
        const { loading, listData, editItem, group, groups } = this.state
        return (
            <Layout>
                <Breadcrumb style={{ marginBottom: 12 }}>
                    <Breadcrumb.Item>
                        <a href="/">首页</a>
                    </Breadcrumb.Item>
                    <Breadcrumb.Item>Mock数据</Breadcrumb.Item>
                </Breadcrumb>

                <Button type="primary" style={{ width: 100, marginBottom: 12 }} onClick={() => this.onEdit({})}>+添加接口</Button>

                <Dropdown overlay={() => <Menu style={{ width: 180 }} onClick={this.onGroupChange}>
                    <Menu.Item key="0">全部分类</Menu.Item>
                    {
                        groups.map((item) =>
                            <Menu.Item key={item.id}>
                                {item.name}
                            </Menu.Item>
                        )
                    }
                </Menu>}>
                    <a className="ant-dropdown-link" style={{ marginBottom: 8 }} onClick={e => e.preventDefault()}>
                        {group.name} <Icon type="down" />
                    </a>
                </Dropdown>

                <Table rowKey="id" loading={loading} dataSource={listData} columns={this.columns}></Table>
                <Modal
                    visible={editItem.visible}
                    title={editItem.data == null ? "新增" : "修改"}
                    cancelText="取消"
                    okText="保存"
                    onCancel={this.onCancel}
                    onOk={this.onSave}
                    destroyOnClose={true}
                >
                    <MockEditForm wrappedComponentRef={this.saveFormRef} data={editItem.data || {}}></MockEditForm>
                </Modal>
            </Layout>
        )
    }
}