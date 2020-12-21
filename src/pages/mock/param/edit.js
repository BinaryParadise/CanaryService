import React from 'react'
import PropTypes from 'prop-types'
import { Form, Input, Icon, Select, Popconfirm, message } from 'antd'
import { routerURL, AuthUser } from '@/common/util'
import axios from '@/component/axios'

const formItemLayout = {
    labelCol: {
        xs: { span: 3 },
        sm: { span: 3 },
    },
    wrapperCol: {
        xs: { span: 21 },
        sm: { span: 21 },
    },
};

let id = 0;

class ParamEditForm extends React.Component {
    componentDidMount() {
    }

    render() {
        const { getFieldDecorator } = this.props.form
        const { data } = this.props
        return (<div>
            <Form {...formItemLayout} layout="inline">
                <div>
                    <Form.Item>
                        {getFieldDecorator('sceneid', {
                            initialValue: data.sceneid,
                            rules: [{ required: true }],
                        })(<Input type="hidden" />)}
                    </Form.Item>
                    <Form.Item label="">
                        {getFieldDecorator('name', {
                            rules: [{ required: true, message: '请输入名称!' }],
                        })(<Input placeholder="请输入参数名称" maxLength={80} />)}
                    </Form.Item>
                    <Form.Item>
                        {getFieldDecorator('value', {
                            rules: [{ required: true, message: '请输入名称!' }],
                        })(<Input placeholder="请输入参数值" maxLength={80} />)}
                    </Form.Item>
                    <Form.Item>
                        {getFieldDecorator('comment', {
                            rules: [{ required: false, message: '请输入名称!' }],
                        })(<Input placeholder="请输入说明" maxLength={80} />)}
                    </Form.Item>
                </div>
            </Form >
        </div>
        )
    }
}
export default Form.create()(ParamEditForm)