import React from 'react'
import PropTypes from 'prop-types'
import axios from '../../component/axios'
import { Popconfirm, Table, Tooltip, Dropdown, Menu, Button, Divider, Layout, Modal } from 'antd'
import moment from 'moment'
import { Auth, MD5 } from '../../common/util'
import { message } from 'antd/lib'
import { Link } from 'react-router-dom'
import UserEditorForm from './editor'

export class UserList extends React.Component {
    state = {
        data: [],
        loading: false,
        confirmLoading: false,
        pageSize: 20,
        editData: null
    }

    constructor(props) {
        super(props)

        this.columns = [
            {
                dataIndex: 'name', title: '昵称', editable: true
            },
            {
                dataIndex: 'username', title: '用户名', editable: true
            },
            {
                dataIndex: 'rolename', title: '角色', editable: true
            },
            {
                dataIndex: 'expire', title: '登录有效期',
                render: (text) => {
                    return new Date(text).Format("yyyy-MM-dd HH:mm:ss")
                }
            },
            {
                title: '操作',
                render: (text, record) => {
                    return this.renderActions(record);
                }
            }
        ]

    }

    renderActions = (record) => {
        const auth = Auth()
        return (<div>
            <a style={{ margin: "0px 5px" }} onClick={() => this.setState({ editData: record, visible: true })}>编辑</a>
            <Popconfirm placement="topRight" hidden={auth.level == 0}
                title="确定要删除该项？" onConfirm={() => this.deleteUser(record.id)}
            >{(record.isDefault ? false : true) && <a>删除</a>}
            </Popconfirm>
            <Divider type="vertical" />
            <a style={{ margin: "0px 5px", color: "#e02a31" }} onClick={() => this.setState({ visible: true, editData: record, resetPwd: true })}>重置密码</a>
        </div>)
    }

    query = () => {
        this.setState({ loading: false, visible: false, resetPwd: false, confirmLoading: false })
        axios.get("/user/list", {}).then(result => {
            this.setState({ data: result.data })
        }).finally(() => this.setState({ loading: false }))
    }

    onSave = () => {
        const { form } = this.formRef.props;
        form.validateFields((err, values) => {
            if (err) {
                return;
            }

            this.setState({ confirmLoading: true })
            this.submit(values, () => {
                form.resetFields()
                this.query()
            });
        });
    }

    submit = (values, callback) => {
        let newValues = { ...values }
        if (newValues.password) {
            newValues.password = MD5(newValues.password)
            newValues.confirm = newValues.password
        }
        return axios.post(newValues.id ? '/user/update' : '/user/add', newValues).then(result => {
            if (result.code == 0) {
                message.success("保存成功").then(callback)
            } else {
                message.error(result.error)
                this.setState({ confirmLoading: false })
            }
        });
    }

    onCancel = () => {
        this.setState({ visible: false, resetPwd: false, editData: null })
    }

    componentDidMount() {
        this.query()
    }

    deleteUser = (id) => {
        return axios.post("/user/delete/" + id).then(result => {
            if (result.code != 0) {
                message.error(result.error)
            } else {
                message.success("删除成功").then(this.query)
            }
        });
    }

    render() {
        const { loading, data, pageSize, editData, resetPwd, confirmLoading } = this.state
        var total = data.length
        return (
            <Layout>
                <Button type="primary" style={{ width: 100, marginBottom: 12 }} onClick={() => this.setState({ visible: true })}>添加用户</Button>
                <Modal
                    title={resetPwd ? "重置密码" : ((editData || {}).id ? '编辑用户' : '添加用户')}
                    visible={this.state.visible}
                    onOk={this.onSave}
                    closable={!confirmLoading}
                    confirmLoading={confirmLoading}
                    onCancel={() => this.setState({ visible: false })}
                    afterClose={this.onCancel}
                >
                    <UserEditorForm resetPwd={this.state.resetPwd} wrappedComponentRef={(formRef) => this.formRef = formRef} data={editData}></UserEditorForm>
                </Modal>
                <Table className="env-records"
                    rowKey="id"
                    loading={loading}
                    columns={this.columns}
                    dataSource={data}
                    size='default'
                    pagination={{
                        total: total,
                        pageSize,
                        showSizeChanger: total > pageSize,
                        pageSizeOptions: ['20', '30', '50'],
                        size: 'default',
                        showQuickJumper: true,
                        showTotal: total => `共 ${total} 条`
                    }}
                />
            </Layout>
        )
    }
}

export default UserList
