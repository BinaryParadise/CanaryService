import React from 'react'
import PropTypes from 'prop-types'
import { Form, Input, Select, Popconfirm, List, message, Modal, Row, Col, Button } from 'antd'
import { DeleteOutlined, PlusOutlined } from '@ant-design/icons'
import { AuthUser } from '@/common/util'
import axios from '@/component/axios'

const formItemLayout = {
    labelCol: {
        xs: { span: 4 },
        sm: { span: 4 },
    },
    wrapperCol: {
        xs: { span: 18 },
        sm: { span: 18 },
    },
};

const paddingItemLayout = {
    labelCol: {
        xs: { span: 4 },
        sm: { span: 4 },
    },
    wrapperCol: {
        xs: { span: 18 },
        sm: { span: 18 },
    },
}

class MockEditForm extends React.Component {
    formRef = React.createRef()
    state = {
        groups: [{ id: null }],
        visible: false,
        data: this.props.data
    }

    componentDidMount() {
        this.queryAll()
    }

    showGroup = (visible) => {
        this.setState({
            visible: !visible,
        });
    }

    queryAll() {
        return axios.get('/mock/group/list', { params: { appid: this.state.appid } }).then(result => {
            if (result.code != 0) {
                return
            }
            const { data } = this.state
            this.setState({ groups: result.data, data: { ...data, groupid: data.groupid || result.data[0].id } })
            if (this.formRef.current) {
                this.formRef.current.setFieldsValue({ "groupid": this.state.data.groupid })
            }
        })
    }

    onAddGroup = () => {
        var gname = this.formRef.current.getFieldValue("groupname")
        if ((gname || "") == "") {
            message.error("请输入分类名称")
            return
        }
        var group = { name: gname, appid: confi }
        return axios.post('/mock/group/update', group).then(result => {
            if (result.code != 0) {
                message.error(result.msg)
                return
            }
            this.formRef.current.setFieldsValue({ groupname: '' })
            this.queryAll()
        })
    }

    onDeleteGroup(item) {
        return axios.post('/mock/group/delete/' + item.id).then(result => {
            if (result.code != 0) {
                message.error(result.error)
                return
            }
            this.queryAll()
        })
    }

    onSave = (values) => {
        this.submit(values, () => {
            this.formRef.current.resetFields()
            if (this.props.onClose) {
                this.props.onClose()
            }
            this.onCancel()
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

    onGroupChanged = (value) => {
        this.formRef.current.setFieldsValue({ groupid: value })
    };

    methodSelector = (<Form.Item name="method" style={{ width: 80 }} noStyle>
        <Select placeholder="请选择方法">
            <Select.Option key="GET">GET</Select.Option>
            <Select.Option key="POST">POST</Select.Option>
        </Select>
    </Form.Item>);

    render() {
        const { groups, data, visible } = this.state
        return (
            <Modal
                title={data.id == undefined ? "新增" : "修改"}
                visible={data.visible}
                cancelText="取消"
                okText="保存"
                width={800}
                onCancel={this.onCancel}
                onOk={() => this.formRef.current.validateFields().then(values => this.onSave(values))}
                destroyOnClose={true}
            >
                <Form ref={this.formRef}
                    initialValues={{ ...data, method: data.method || "GET", groupname: "", groupid: data.groupid || groups[0].id }}
                    layout="horizontal"
                    onValuesChange={(changedValues, allValues) => {
                    }}
                    {...formItemLayout}>
                    {
                        data.id > 0 &&
                        <Form.Item name="id" style={{ display: 'none' }}>
                            <Input type="hidden"></Input>
                        </Form.Item>
                    }
                    <Form.Item name="name" rules={[{ required: true, message: '请输入名称!' }]} label="名称">
                        <Input placeholder="请输入名称" />
                    </Form.Item>
                    <Form.Item name="path" rules={[{ required: true, message: '请输入路径!' }]} label="方法/路径">
                        <Input addonBefore={this.methodSelector} style={{ width: '100%' }} placeholder="请输入路径，以相对路径/开头，并支持路径参数,例入{param0}、{param1}..." />
                    </Form.Item>
                    <Form.Item label="接口分类">
                        <Row gutter={8}>
                            <Col span={12}>
                                <Form.Item name="groupid" rules={[{ required: true, message: '请选择分类' }]}>
                                    <Select onChange={this.onGroupChanged} placeholder="请选择分类" style={{ width: '100%' }}>
                                        {
                                            groups.map(item => (
                                                <Select.Option key={item.id} value={item.id}>{item.name}</Select.Option>
                                            ))
                                        }
                                    </Select>
                                </Form.Item>
                            </Col>
                            <Col>
                                <Button onClick={() => this.showGroup(visible)}>管理分类</Button>
                            </Col>
                        </Row>
                    </Form.Item>

                    <Form.Item label="" hidden={!visible}>
                        <Form.Item>
                            <Input allowClear addonAfter={<a onClick={() => this.onAddGroup()}>新增</a>} onChange={this.onGroupChanged} placeholder="新分类名称" />
                        </Form.Item>
                        <List dataSource={groups} renderItem={item => (
                            item.id > 0 && <List.Item key={item.id} actions={[<Popconfirm title="确认删除?" onConfirm={() => this.onDeleteGroup(item)}><DeleteOutlined></DeleteOutlined></Popconfirm>]}>
                                {item.name}
                            </List.Item>
                        )}>
                        </List>
                    </Form.Item>

                </Form >
            </Modal >
        )
    }
}
export default MockEditForm