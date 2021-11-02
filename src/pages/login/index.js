import React from 'react';
import { history } from 'umi';
import { Form, Input, Button, message } from 'antd'
import { UserOutlined, LockOutlined } from '@ant-design/icons';
import axios from '../../component/axios'
import { MD5 } from '../../common/util'

class NormalLoginForm extends React.Component {
    state = {
        loading: false
    }

    handleSubmit = (values) => {
        this.setState({ loading: true })
        this.doLogin(values)
    };

    doLogin = (values) => {
        let password = MD5(values.password)
        let params = { ...values, password }
        return axios.post('/user/login', params).then(result => {
            if (result.code == 0) {
                localStorage.setItem("user", JSON.stringify(result.data))
                message.success("登录成功,即将跳转", 0.5)
                    .then(() => window.location.href = "/")
            } else {
                message.error(result.error);
                this.setState({ loading: false })
            }
        })
    }

    componentDidMount() {
        if (localStorage.getItem("user") != null) {
            history.push('/')
            return
        }
    }

    render() {
        return (
            <Form className="login-form" onFinish={this.handleSubmit}>
                <Form.Item><h1><span style={{ color: '#2c5cce', fontSize: 36 }}>欢迎使用金丝雀</span></h1></Form.Item>
                <Form.Item name="username" rules={[{ required: true, message: '请输入用户名或邮箱!' }]}>
                    <Input
                        prefix={<UserOutlined />}
                        placeholder="用户名或邮箱" />
                </Form.Item>
                <Form.Item name="password" rules={[{ required: true, message: '请输入密码!' }]}>
                    <Input
                        prefix={<LockOutlined />}
                        type="password"
                        placeholder="密码" />
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

export default NormalLoginForm;