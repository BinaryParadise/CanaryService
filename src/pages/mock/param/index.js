import React from 'react'
import PropTypes from 'prop-types'
import { Form, Input, Icon, Button, Popconfirm, List, message, Table } from 'antd'
import axios from '@/component/axios'
import moment from 'moment'
import { Link } from 'react-router-dom'
import { AuthUser } from '@/common/util'

class MockParamForm extends React.Component {
    columns = [
        {
            title: '参数名称',
            dataIndex: 'name',
            width: 180
        },
        {
            title: '说明',
            width: 260,
            dataIndex: 'comment'
        },
        {
            dataIndex: 'updatetime',
            title: '更新时间',
            width: 200,
            render: (text, record) => moment(text).format('YYYY-MM-DD HH:mm:ss')
        },
        {
            title: '操作',
            dataIndex: 'id',
            render: (text, record) => {
                return (<span>
                    < Popconfirm title="确认删除?" onConfirm={() => this.onDeleteParam(record)
                    }>
                        <a>删除</a>
                    </Popconfirm >
                </span>
                )
            }
        }
    ];

    state = {
        visiable: false,
        appid: (window.__config__.projectInfo || {}).id,
        listData: []
    }

    componentDidMount() {
        this.queryAll()
    }

    queryAll() {
        return axios.get('/mock/param/list', { params: { appid: this.state.appid } }).then(result => {
            if (result.code != 0) {
                return
            }
            this.setState({ listData: result.data })
        })
    }

    onSubmit = () => {
        const { form } = this.props;
        form.validateFields((err, values) => {
            if (err) {
                return;
            }

            this.onAddParam(values, () => {
                form.resetFields()
                this.queryAll()
            });
        });
    }

    onAddParam = (values, callback) => {
        var group = { ...values, appid: this.state.appid }
        return axios.post('/mock/param/update', group).then(result => {
            if (result.code != 0) {
                message.error(result.error)
                return
            }

            callback()
        })
    }

    onDeleteParam(item) {
        return axios.post('/mock/param/delete', item).then(result => {
            if (result.code != 0) {
                message.error(result.error)
                return
            }
            this.queryAll()
        })
    }

    render() {
        const { getFieldDecorator } = this.props.form
        const { data } = this.props
        const { visiable, listData } = this.state

        return (<div>
            <Form layout="inline" style={{ marginBottom: 8 }} >
                <Form.Item>
                    {getFieldDecorator('name', {
                        rules: [{ required: true, message: '请输入参数名称' }],
                    })(
                        <Input placeholder="参数名称" />
                    )}
                </Form.Item>
                <Form.Item>
                    {getFieldDecorator('comment', {
                        rules: [{ required: false }],
                    })(
                        <Input placeholder="参数说明" />
                    )}
                </Form.Item>
                <Form.Item>
                    <Button type="primary" onClick={() => this.onSubmit()}>
                        添加</Button>
                </Form.Item>
            </Form>
            <Table dataSource={listData} columns={this.columns}>

            </Table>
        </div >
        )
    }
}
export default Form.create()(MockParamForm)