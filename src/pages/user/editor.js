import React from 'react'
import PropTypes from 'prop-types'
import { Form, Input, Select } from 'antd'
import axios from '../../component/axios'

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
    static propTypes = {
        resetPwd: PropTypes.bool.isRequired
    }
    state = {
        confirmDirty: false,
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

    handleConfirmBlur = e => {
        const { value } = e.target;
        this.setState({ confirmDirty: this.state.confirmDirty || !!value });
    };

    compareToFirstPassword = (rule, value, callback) => {
        const { form } = this.props;
        if (value && value !== form.getFieldValue('password')) {
            callback('两次输入的密码不一致!');
        } else {
            callback();
        }
    };

    validateToNextPassword = (rule, value, callback) => {
        const { form } = this.props;
        if (value && this.state.confirmDirty) {
            form.validateFields(['confirm'], { force: true });
        }
        callback();
    };

    render() {
        const { getFieldDecorator } = this.props.form
        let { data, resetPwd } = this.props
        const { roleList } = this.state
        data = data || {}
        return (
            <Form {...formItemLayout} layout="horizontal">
                {data.id &&
                    <Form.Item style={{ display: 'none' }}>
                        {getFieldDecorator('id', {
                            initialValue: data.id
                        })(<Input type="hidden"></Input>)}
                    </Form.Item>
                }
                {!resetPwd &&
                    < div >
                        <Form.Item label="用户名">
                            {getFieldDecorator('username', {
                                initialValue: data.username,
                                rules: [{ required: true, message: '请输入用户名!' }],
                            })(<Input />)}
                        </Form.Item>
                        <Form.Item label="昵称">
                            {getFieldDecorator('name', {
                                initialValue: data.name,
                                rules: [{ required: true, message: '请输入名称!' }],
                            })(<Input />)}
                        </Form.Item>
                    </div>
                }
                {
                    (resetPwd || !data.id) &&
                    <Form.Item label="密码" hasFeedback>
                        {getFieldDecorator('password', {
                            initialValue: data.identify,
                            rules: [{ required: true, message: '请输入密码!' }]
                        })(<Input.Password />)}
                    </Form.Item>
                }
                {
                    (resetPwd || !data.id) &&
                    <Form.Item label="确认密码" hasFeedback>
                        {getFieldDecorator('confirm', {
                            rules: [
                                {
                                    required: true,
                                    message: '请确认你的密码!',
                                },
                                {
                                    validator: this.compareToFirstPassword,
                                },
                            ],
                        })(<Input.Password onBlur={this.handleConfirmBlur} />)}
                    </Form.Item>
                }
                {!resetPwd &&
                    <Form.Item label="角色">
                        {getFieldDecorator('roleid', {
                            initialValue: data.roleid,
                            rules: [
                                { required: true, message: '请选择角色' },
                            ],
                        })(<Select>
                            {
                                roleList.map(role => <Option key={role.id} value={role.id}>{role.name}</Option>)
                            }
                        </Select>)}
                    </Form.Item>
                }
            </Form >
        )
    }
}
export default Form.create()(UserEditorForm)