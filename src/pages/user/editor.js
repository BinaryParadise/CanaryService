import React from 'react'
import PropTypes from 'prop-types'
import { Form, Input, Select, Modal, message } from 'antd'
import axios from '@/component/axios'
import { MD5 } from '@/common/util'

const { Option } = Select;

const formItemLayout = {
    labelCol: {
        xs: { span: 24 },
        sm: { span: 5 },
    },
    wrapperCol: {
        xs: { span: 24 },
        sm: { span: 16 },
    },
};

class UserEditorForm extends React.Component {
    formRef = React.createRef()
    static propTypes = {
        resetPwd: PropTypes.bool.isRequired
    }
    state = {
        data: this.props.data,
        roleList: []
    }

    componentDidMount() {
        this.getRoleList()
    }

    getRoleList = () => {
        axios.get("/user/role/list", {}).then(result => {
            this.setState({ roleList: result.data })
        });
    }

    onCancel = () => {
        this.setState({ data: { visible: false } })
    }

    onSave = () => {
        this.formRef.current.validateFields().then(values => {
            this.setState({ confirmLoading: true })
            this.submit(values, () => {
                this.formRef.current.resetFields()
                if (this.props.onClose) {
                    this.props.onClose()
                }
            });
        })
    }

    submit = (values, callback) => {
        const { resetPwd } = this.props
        let newValues = { ...values }
        if (newValues.id == undefined) {
            newValues.id = 0
        }
        if (newValues.password) {
            newValues.password = MD5(newValues.password)
            newValues.confirm = newValues.password
        }
        return axios.post(resetPwd ? '/user/resetpwd' : '/user/update', newValues).then(result => {
            if (result.code == 0) {
                message.success("保存成功")
                callback()
            } else {
                message.error(result.msg)
                this.setState({ confirmLoading: false })
            }
        });
    }

    render() {
        const { resetPwd } = this.props
        const { roleList, data } = this.state
        return (
            <Modal
                title={resetPwd ? "重置密码" : ((data || {}).id ? '编辑用户' : '添加用户')}
                visible={data.visible}
                onOk={this.onSave}
                closable={true}
                onCancel={this.onCancel}
                destroyOnClose={true}
            >
                <Form ref={this.formRef} initialValues={{ ...data, id: data.id || 0, password: '' }} {...formItemLayout} layout="horizontal">
                    <Form.Item name="id" style={{ display: 'none' }}>
                        <Input type="hidden"></Input>
                    </Form.Item>
                    {!resetPwd &&
                        < div >
                            <Form.Item name="username" rules={[{ required: true, message: '请输入用户名!' }]} label="用户名">
                                <Input />
                            </Form.Item>
                            <Form.Item name="name" rules={[{ required: true, message: '请输入名称!' }]} label="昵称">
                                <Input />
                            </Form.Item>
                        </div>
                    }
                    {
                        (resetPwd || !data.id) &&
                        <Form.Item name="password" label="密码" rules={[{ required: true, message: '请输入密码!' }]} hasFeedback>
                            <Input.Password />
                        </Form.Item>
                    }
                    {
                        (resetPwd || !data.id) &&
                        <Form.Item
                            name="confirm"
                            label="确认密码"
                            dependencies={['password']}
                            hasFeedback
                            rules={[
                                {
                                    required: true,
                                    message: '请输入确认密码!',
                                },
                                ({ getFieldValue }) => ({
                                    validator(_, value) {
                                        if (!value || getFieldValue('password') === value) {
                                            return Promise.resolve();
                                        }

                                        return Promise.reject(new Error('两次输入的密码不一致!'));
                                    },
                                }),
                            ]}
                        >
                            <Input.Password />
                        </Form.Item>
                    }
                    {
                        !resetPwd &&
                        <Form.Item name="roleid" rules={[
                            { required: true, message: '请选择角色' },
                        ]} label="角色">
                            <Select>
                                {
                                    roleList.map(role => <Option key={role.id} value={role.id}>{role.name}</Option>)
                                }
                            </Select>
                        </Form.Item>
                    }
                </Form >
            </Modal>
        )
    }
}
export default UserEditorForm