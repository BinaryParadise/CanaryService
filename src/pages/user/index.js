import React from 'react'
import PropTypes from 'prop-types'
import axios from '@/component/axios'
import { Popconfirm, Table, Tooltip, Dropdown, Menu, Button, Divider, Layout, Modal } from 'antd'
import moment from 'moment'
import { Auth, MD5 } from '@/common/util'
import { message } from 'antd/lib'
import { Link } from 'react-router-dom'
import UserEditorForm from './editor'
import Countdown from 'antd/lib/statistic/Countdown'
import { PlusOutlined } from '@ant-design/icons'

export class UserList extends React.Component {
    state = {
        resetPwd: false,
        data: [],
        loading: false,
        pageSize: 20,
        editData: { visible: false }
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
                dataIndex: 'app_name', title: '当前应用',
                render: (text, record) => {
                    if (text == null) {
                        return "未选择"
                    }
                    return <span style={{ color: "#56D0B3" }}>{text}</span>
                }
            },
            {
                title: '操作',
                render: (text, record) => {
                    const auth = Auth()
                    return (<div>
                        <a style={{ margin: "0px 5px" }} onClick={() => this.setState({ editData: { ...record, visible: true, key: Math.random() }, resetPwd: false })}>编辑</a>
                        <Popconfirm placement="topRight" hidden={auth.level == 0}
                            title="确定要删除该项？" onConfirm={() => this.deleteUser(record.id)}
                        >{(record.isDefault ? false : true) && <a>删除</a>}
                        </Popconfirm>
                        <Divider type="vertical" />
                        <a style={{ margin: "0px 5px", color: "#e02a31" }} onClick={() => this.setState({ editData: { ...record, visible: true, key: Math.random() }, resetPwd: true })}>重置密码</a>
                    </div>)
                }
            }
        ]

    }

    query = () => {
        this.setState({ loading: true, resetPwd: false, editData: { visible: false } })
        axios.get("/user/list", {}).then(result => {
            this.setState({ data: result.data, loading: false })
        }).finally(() => this.setState({ loading: false }))
    }

    componentDidMount() {
        this.query()
    }

    deleteUser = (id) => {
        return axios.post("/user/delete/" + id).then(result => {
            if (result.code != 0) {
                message.error(result.msg)
            } else {
                message.success("删除成功")
                this.query()
            }
        });
    }

    render() {
        const { loading, data, pageSize, editData, resetPwd } = this.state
        var total = data.length
        return (
            <Layout>
                <Button type="primary" style={{ width: 100, marginBottom: 12 }} onClick={() => this.setState({ editData: { visible: true, key: Math.random() } })}><PlusOutlined></PlusOutlined> 添加用户</Button>
                <UserEditorForm resetPwd={resetPwd} data={editData} key={editData.key} onClose={this.query}></UserEditorForm>
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
            </Layout >
        )
    }
}

export default UserList
