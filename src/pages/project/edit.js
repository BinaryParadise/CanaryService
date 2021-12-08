import React from 'react'
import propTypes from 'prop-types'
import { Form, Input, Checkbox, Modal, message } from 'antd'
import axios from '@/component/axios'

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
    formRef = React.createRef()

    state = {
        data: this.props.data
    }

    onCancel = () => {
        this.setState({ data: { ...this.state.data, visible: false } })
    }

    onSave = () => {
        this.formRef.current.validateFields().then(values => {
            this.submit(values, () => {
                this.formRef.current.resetFields()
                if (this.props.onClose) {
                    this.props.onClose()
                }
            });
        })
    }

    submit = (values, callback) => {
        if (values.id == undefined) {
            values.id = 0
            values.identify = "unknown"
        }
        return axios.post('/project/update', values).then(result => {
            if (result.code == 0) {
                message.success("保存成功")
                callback()
            } else {
                message.error(result.msg)
            }
        });
    }

    render() {
        const { data } = this.state
        return (<Modal
            visible={data.visible}
            title={data.id ? "新增" : "修改"}
            cancelText="取消"
            okText="保存"
            onCancel={this.onCancel}
            onOk={this.onSave}
            destroyOnClose
        >
            <Form ref={this.formRef} initialValues={{ ...data, id: data.id || 0, shared: data.shared || true }} {...formItemLayout} layout="horizontal">
                <Form.Item name="id" style={{ display: 'none' }}>
                    <Input type="hidden"></Input>
                </Form.Item>
                <Form.Item name="name" rules={[{ required: true, message: '请输入名称!' }]} label="名称">
                    <Input />
                </Form.Item>
                <Form.Item name="shared" label="公开" valuePropName="checked">
                    <Checkbox checked />
                </Form.Item>
            </Form>
        </Modal>
        )
    }
}
export default ProjectEditForm