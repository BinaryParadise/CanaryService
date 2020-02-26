import React from 'react'
import propTypes from 'prop-types'
import { Form, Input, Checkbox } from 'antd'
import { AuthUser } from '../../common/util'

const formItemLayout = {
    labelCol: {
        xs: { span: 24 },
        sm: { span: 6 },
    },
    wrapperCol: {
        xs: { span: 24 },
        sm: { span: 16 },
    },
};

class ProjectEditForm extends React.Component {
    render() {
        const { getFieldDecorator } = this.props.form
        const { data } = this.props
        return (
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
                    })(<Input />)}
                </Form.Item>
                <Form.Item label="唯一标识">
                    {getFieldDecorator('identify', {
                        initialValue: data.identify,
                        rules: [{ required: true, message: '请输入唯一标识!' }]
                    })(<Input />)}
                </Form.Item>
                <Form.Item label="共享">
                    {getFieldDecorator('shared', {
                        valuePropName: 'checked',
                        initialValue: data.share || true
                    })(<Checkbox />)}
                </Form.Item>
            </Form>
        )
    }
}
export default Form.create()(ProjectEditForm)