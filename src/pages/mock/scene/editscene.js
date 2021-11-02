import React from 'react'
import { Form, Input, Modal, message } from 'antd'
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

class SceneEditForm extends React.Component {
    formRef = React.createRef()
    state = {
        data: this.props.data
    }

    componentDidMount() {
    }

    onSave = (values) => {
        this.submit(values, () => {
            this.formRef.current.resetFields()
            if (this.props.onClose) {
                this.props.onClose()
            }
        });
    }

    submit = (values, callback) => {
        return axios.post('/mock/scene/update', values).then(result => {
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
            title={data.id == undefined ? "新增" : "修改"}
            cancelText="取消"
            okText="保存"
            width={1500}
            onCancel={() => this.setState({ data: { visible: false } })}
            onOk={() => this.formRef.current.validateFields().then(this.onSave)}
            destroyOnClose={true}
        >
            <Form ref={this.formRef} {...formItemLayout} initialValues={data} layout="horizontal">
                {data.id > 0 &&
                    <Form.Item name="id" style={{ display: 'none' }}>
                        <Input type="hidden"></Input>
                    </Form.Item>
                }
                {data.mockid > 0 &&
                    <Form.Item name="mockid">
                        <Input type="hidden"></Input>
                    </Form.Item>
                }
                <Form.Item name="name" rules={[{ required: true, message: '请输入名称!' }]} label="场景名称">
                    <Input placeholder="请输入名称" maxLength={8} />
                </Form.Item>
                <Form.Item name="response" label="响应结果">
                    <Input.TextArea placeholder="请输入响应结果" autoSize={{ minRows: 6, maxRows: 50 }} />
                </Form.Item>
            </Form >
        </Modal>
        )
    }
}
export default SceneEditForm