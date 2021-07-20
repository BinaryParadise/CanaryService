import React from 'react'
import PropTypes from 'prop-types'
import { Form, Input, Icon, Select, Popconfirm, message } from 'antd'
import { routerURL, AuthUser } from '../../../common/util'
import axios from '../../../component/axios'

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

class SceneEditForm extends React.Component {
    state = {
        visible: false
    }

    componentDidMount() {
    }

    render() {
        const { getFieldDecorator } = this.props.form
        const { data } = this.props

        return (<div>
            <Form {...formItemLayout} layout="horizontal">
                {data.id > 0 &&
                    <Form.Item style={{ display: 'none' }}>
                        {getFieldDecorator('id', {
                            initialValue: data.id
                        })(<Input type="hidden"></Input>)}
                    </Form.Item>
                }
                {data.mockid > 0 &&
                    <Form.Item>
                        {getFieldDecorator('mockid', {
                            initialValue: data.mockid
                        })(<Input type="hidden"></Input>)}
                    </Form.Item>
                }
                <Form.Item label="场景名称">
                    {getFieldDecorator('name', {
                        initialValue: data.name,
                        rules: [{ required: true, message: '请输入名称!' }],
                    })(<Input placeholder="请输入名称" maxLength={8} />)}
                </Form.Item>
                <Form.Item label="响应结果">
                    {getFieldDecorator('response', {
                        initialValue: data.response,
                        rules: [{ required: false }],
                    })(<Input.TextArea placeholder="请输入响应结果" autoSize={{ minRows: 6, maxRows: 50 }} />)}
                </Form.Item>
            </Form >
        </div>
        )
    }
}
export default Form.create()(SceneEditForm)