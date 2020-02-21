import React from 'react'
import PropTypes from 'prop-types'
import axios from '../../component/axios'
import { Badge, Input, Popconfirm, Switch, Table, Tag, Tooltip, Dropdown, Menu, Button, Icon } from 'antd'
import moment from 'moment'
import { routerURL } from '../../common/util'
import { message } from 'antd/lib'
import { Link } from 'react-router-dom'

export class UserList extends React.Component {
    state = {
        data: [],
        loading: false,
        pageSize: 20
    }

    constructor(props) {
        super(props)

        this.columns = [
            {
                dataIndex: 'name', title: '昵称'
            },
            {
                dataIndex: 'username', title: '用户名'
            },
            {
                dataIndex: 'rolename', title: '角色'
            },
            {
                dataIndex: 'expire', title: '登录有效期',
                render: (text) => {
                    return new Date(text).Format("yyyy-MM-dd HH:mm:ss")
                }
            }
        ]

    }

    query = () => {
        this.setState({ loading: false })
        axios.get("/user/list", {}).then(result => {
            this.setState({ data: result.data })
        }).finally(() => this.setState({ loading: false }))
    }

    componentDidMount() {
        this.query()
    }

    render() {
        const { loading, data, pageSize } = this.state
        var total = data.length
        return (
            <Table className="env-records"
                rowKey="id"
                loading={loading}
                columns={this.columns}
                dataSource={data}
                size='small'
                pagination={{
                    total: total,
                    pageSize,
                    showSizeChanger: total > pageSize,
                    pageSizeOptions: ['20', '30', '50'],
                    size: 'midlle',
                    showQuickJumper: true,
                    showTotal: total => `共 ${total} 条`
                }}
            />
        )
    }
}

export default UserList
