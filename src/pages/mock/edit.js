import React from 'react'
import PropTypes from 'prop-types'
import { Form, Input, Icon, Select, Popconfirm, List, message } from 'antd'
import { AuthUser } from '../../common/util'
import axios from '../../component/axios'

const formItemLayout = {
    labelCol: {
        xs: { span: 6 },
        sm: { span: 3 },
    },
    wrapperCol: {
        xs: { span: 18 },
        sm: { span: 21 },
    },
};

class MockEditForm extends React.Component {
    state = {
        visiable: false,
        groups: [],
        appid: (window.__config__.projectInfo || {}).id
    }

    componentDidMount() {
        this.queryAll()
    }

    showGroup = (visiable) => {
        this.setState({
            visiable: !visiable,
        });
    };

    queryAll() {
        return axios.get('/mock/group/list', { params: { appid: this.state.appid } }).then(result => {
            if (result.code != 0) {
                return
            }
            this.setState({ groups: result.data })
        })
    }

    onAddGroup() {
        const { value } = this.groupField.state
        if ((value || "") == "") {
            message.error("请输入分类名称")
            return
        }
        var group = { appid: this.state.appid, name: value }
        return axios.post('/mock/group/update', group).then(result => {
            if (result.code != 0) {
                message.error(result.error)
                return
            }

            this.groupField.value = ""
            this.queryAll()
        })
    }

    onDeleteGroup(item) {
        return axios.post('/mock/group/delete', item).then(result => {
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
        const { visiable, groups } = this.state
        if (data.groupid == undefined && groups.length > 0) {
            data.groupid = groups[0].id
        }
        const methodSelecor = getFieldDecorator('method', {
            initialValue: data.method || "GET",
            rules: [{ required: true, message: '选择方法' }],
        })(<Select placeholder="请选择方法" style={{ width: 80 }}>
            <Select.Option key="GET">GET</Select.Option>
            <Select.Option key="POST">POST</Select.Option>
        </Select>)

        return (<div>
            <Form {...formItemLayout} layout="horizontal">
                {data.id > 0 &&
                    <Form.Item style={{ display: 'none' }}>
                        {getFieldDecorator('id', {
                            initialValue: data.id
                        })(<Input type="hidden"></Input>)}
                    </Form.Item>
                }
                <Form.Item style={{ display: 'none' }}>
                    {getFieldDecorator('uid', {
                        initialValue: AuthUser().id
                    })(<Input type="hidden"></Input>)}
                </Form.Item>
                <Form.Item label="名称">
                    {getFieldDecorator('name', {
                        initialValue: data.name,
                        rules: [{ required: true, message: '请输入名称!' }],
                    })(<Input placeholder="请输入名称" />)}
                </Form.Item>
                <Form.Item label="方法/路径">
                    {getFieldDecorator('path', {
                        initialValue: data.path,
                        rules: [{ required: true, message: '请输入路径!' }],
                    })(<Input addonBefore={methodSelecor} placeholder="请输入路径，以相对路径/开头，并支持路径参数,例入{param0}、{param1}..." />)}
                </Form.Item>
                <Form.Item label="接口分类">
                    {getFieldDecorator('groupid', {
                        initialValue: data.groupid,
                        rules: [{ required: true, message: '请选择分类' }],
                    })(<div><Select placeholder="请选择分类" defaultValue={data.groupid} style={{ width: 245 }}>
                        {
                            groups.map(item => (
                                <Select.Option key={item.id} value={item.id} label={item.name}>{item.name}</Select.Option>
                            ))
                        }
                    </Select><a style={{ marginLeft: 8 }} onClick={() => this.showGroup(visiable)}>管理分类</a></div>)}
                </Form.Item>
                {
                    visiable && <Form.Item>
                        {getFieldDecorator('groupname', {
                            initialValue: null,
                            rules: [{ required: false }],
                        })(<div><Input ref={(ref) => this.groupField = ref} style={{ marginLeft: 118 }} allowClear addonAfter={<a onClick={() => this.onAddGroup()}>新增</a>} placeholder="新分类名称" />
                            <List style={{ marginLeft: 118 }} dataSource={groups} renderItem={item => (
                                <List.Item key={item.id} actions={[<Popconfirm title="确认删除?" onConfirm={() => this.onDeleteGroup(item)}><Icon type="delete"></Icon></Popconfirm>]}>
                                    {item.name}
                                </List.Item>
                            )}>

                            </List></div>)}
                    </Form.Item>
                }
            </Form >
        </div>
        )
    }
}
export default Form.create()(MockEditForm)