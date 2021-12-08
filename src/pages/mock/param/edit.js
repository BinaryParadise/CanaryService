import React from 'react'
import PropTypes from 'prop-types'
import { Form, Input, Modal, Select, Popconfirm, message } from 'antd'
import { routerURL, AuthUser } from '@/common/util'
import axios from '@/component/axios'

const formItemLayout = {
    wrapperCol: {
        xs: { span: 18 },
        sm: { span: 24 },
    },
};

let id = 0;

class ParamEditForm extends React.Component {
    formRef = React.createRef()
    state = {
        data: this.props.data
    }

    componentDidMount() {
    }

    submit = (values, callback) => {
        return axios.post('/mock/param/update', values).then(result => {
            if (result.code == 0) {
                message.success("保存成功")
                callback()
            } else {
                message.error(result.msg)
            }
        });
    }

    onParamSave = (values) => {
        this.submit(values, () => {
            this.formRef.current.resetFields()
            if (this.props.onClose) {
                this.props.onClose()
            }
        })
    }

    render() {
        const { data } = this.props
        return (<Modal
            visible={data.visible}
            title={"参数配置"}
            cancelText="取消"
            okText="保存"
            width={666}
            onCancel={() => this.setState({ data: { visible: false } })}
            onOk={() => this.formRef.current.validateFields().then(this.onParamSave)}
            destroyOnClose={true}
        >
            <Form ref={this.formRef} {...formItemLayout} initialValues={data} layout="inline">
                <Form.Item name="sceneid" rules={[{ required: true }]}>
                    <Input type="hidden" />
                </Form.Item>
                <Form.Item label="" name="name" rules={[{ required: true, message: '请输入名称!' }]}>
                    <Input placeholder="请输入参数名称" maxLength={80} />
                </Form.Item>
                <Form.Item name="value" rules={[{ required: true, message: '请输入名称!' }]}>
                    <Input placeholder="请输入参数值" maxLength={80} />
                </Form.Item>
                <Form.Item name="comment">
                    <Input placeholder="请输入说明" maxLength={80} />
                </Form.Item>
            </Form >
        </Modal>
        )
    }
}
export default ParamEditForm