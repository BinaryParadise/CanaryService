import React from 'react'
import propTypes from 'prop-types'
import { Form, Input, Checkbox, Select } from 'antd'
import { AuthUser } from '../../common/util'

const formItemLayout = {
    labelCol: {
        xs: { span: 24 },
        sm: { span: 6 },
    },
    wrapperCol: {
        xs: { span: 32 },
        sm: { span: 16 },
    },
};

class MockEditForm extends React.Component {
    render() {
        const { getFieldDecorator } = this.props.form
        const { data } = this.props
        const methodSelecor = getFieldDecorator('method', {
            initialValue: data.method,
            rules: [{ required: true, message: '选择方法' }],
        })(<Select initialValue={data.method ?? "GET"} placeholder="请选择方法" style={{ width: 115 }}>
            <Select.Option key="GET">GET</Select.Option>
            <Select.Option key="POST">POST</Select.Option>
        </Select>)

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
                <Form.Item label="方法/路径">
                    {getFieldDecorator('path', {
                        initialValue: data.path,
                        rules: [{ required: true, message: '请输入路径!' }],
                    })(<Input addonBefore={methodSelecor} />)}
                </Form.Item>
                <Form.Item label="公开">
                    {getFieldDecorator('shared', {
                        valuePropName: 'checked',
                        initialValue: data.share || true
                    })(<Checkbox />)}
                </Form.Item>
            </Form>
        )
    }
}
export default Form.create()(MockEditForm)