import React from 'react'
import PropTypes from 'prop-types'
import { Form, Input, Icon, Select, Popconfirm, List, message, Modal } from 'antd'
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
        groups: null,
        visible: false,
        data: this.props.data,
        appid: (window.__config__.projectInfo || {}).id
    }

    componentDidMount() {
        this.queryAll()
    }

    showGroup = (visible) => {
        this.setState({
            visible: !visible,
        });
    };

    onGroupChange = (id) => {
        this.props.form.setFieldsValue({ groupid: id })
    }

    queryAll() {
        return axios.get('/mock/group/list', { params: { appid: this.state.appid } }).then(result => {
            if (result.code != 0) {
                return
            }
            const { data } = this.state
            this.setState({ groups: result.data, data: { ...data, groupid: data.groupid || result.data[0].id } })
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
                message.error(result.msg)
                return
            }

            this.props.form.setFieldsValue({ groupname: "" })
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



    onSave = () => {
        const { form } = this.props;
        form.validateFields((err, values) => {
            if (err) {
                return;
            }

            this.submit(values, () => {
                form.resetFields()
                if (this.props.onClose) {
                    this.props.onClose()
                }
                this.onCancel()
            });
        });
    }

    onCancel = () => {
        this.setState({ data: { visible: false } })
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

    render() {
        const { getFieldDecorator } = this.props.form
        const { groups, data, visible } = this.state
        if (groups == null || !data.visible) {
            return <div></div>
        }
        const methodSelecor = getFieldDecorator('method', {
            initialValue: data.method || "GET",
            rules: [{ required: true, message: '选择方法' }],
        })(<Select placeholder="请选择方法" style={{ width: 80 }}>
            <Select.Option key="GET">GET</Select.Option>
            <Select.Option key="POST">POST</Select.Option>
        </Select>)

        return (
            <Modal
                title={data.id == undefined ? "新增" : "修改"}
                visible={data.visible}
                cancelText="取消"
                okText="保存"
                width={900}
                onCancel={this.onCancel}
                onOk={this.onSave}
                destroyOnClose={true}
            >
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
                        })(<div><Select defaultValue={data.groupid} placeholder="请选择分类" style={{ width: 245 }} onChange={(e) => this.onGroupChange(e)}>
                            {
                                groups.map(item => (
                                    <Select.Option key={item.id} value={item.id}>{item.name}</Select.Option>
                                ))
                            }
                        </Select><a style={{ marginLeft: 8 }} onClick={() => this.showGroup(visible)}>管理分类</a></div>)}
                    </Form.Item>
                    {
                        visible && <Form.Item>
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
            </Modal>
        )
    }
}
export default Form.create()(MockEditForm)