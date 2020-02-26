import React from 'react';
import ReactDOM from 'react-dom';
import router from 'umi/router';
import { Form, Icon, Input, Button, message } from 'antd';
import axios from '../../component/axios'
import { MD5 } from '../../common/util'

class NormalLoginForm extends React.Component {
    state = {
        loading: false
    }

    handleSubmit = e => {
        this.setState({ loading: true })
        e.preventDefault();
        this.props.form.validateFields((err, values) => {
            if (!err) {
                message.loading("登录中...", 2.5)
                    .then(() => this.doLogin(values))
            }
        });
    };

    doLogin = (values) => {
        let password = MD5(values.password)
        let params = { ...values, password }
        return axios.post('/user/login', params).then(result => {
            if (result.code == 0) {
                localStorage.setItem("user", JSON.stringify(result.data))
                message.success("登录成功,即将跳转", 2.5)
                    .then(() => router.push('/'))
            } else {
                message.error(result.error);
                this.setState({ loading: false })
            }
        })
    }

    render() {
        const { getFieldDecorator } = this.props.form;
        return (
            <Form onSubmit={this.handleSubmit} className="login-form">
                <Form.Item>
                    {getFieldDecorator('username', {
                        rules: [{ required: true, message: '请输入用户名或邮箱!' }],
                    })(
                        <Input
                            prefix={<Icon type="user" style={{ color: 'rgba(0,0,0,.25)' }} />}
                            placeholder="用户名或邮箱"
                        />,
                    )}
                </Form.Item>
                <Form.Item>
                    {getFieldDecorator('password', {
                        rules: [{ required: true, message: '请输入密码!' }],
                    })(
                        <Input
                            prefix={<Icon type="lock" style={{ color: 'rgba(0,0,0,.25)' }} />}
                            type="password"
                            placeholder="密码"
                        />,
                    )}
                </Form.Item>
                <Form.Item>
                    <Button type="primary" loading={this.state.loading} htmlType="submit" className="login-form-button">
                        登录
                    </Button>
                </Form.Item>
            </Form>
        );
    }
}

const WrappedNormalLoginForm = Form.create({ name: 'normal_login' })(NormalLoginForm);

export default WrappedNormalLoginForm;