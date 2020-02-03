import React from 'react'
import PropTypes from 'prop-types'
import { Form, Input, Modal, message, Switch, Icon, Radio } from 'antd'
import axios from '../../component/axios'
import EnvItemDetailForm from './itemform'

export default class EnvItemAdd extends React.Component {
    static propTypes = {
        modal: PropTypes.object.isRequired,
        data: PropTypes.object.isRequired,
        onChange: PropTypes.func.isRequired,
        onCancel: PropTypes.func.isRequired
    }

    onSubmit = e => {
        const { modal } = this.props

        this.refs.form.validateFields((errors, values) => {
            if (!errors) {
                this.saveAdd(values)
            }
        })
    }

    onFinished = (success, props) => {
        const { modal } = this.props
        this.setState({ modal: Object.assign(modal, props) })
        if (success) {
            message.success('添加成功!')
            this.props.onChange(modal.envid)
        }
    }

    saveAdd(data) {
        const { modal } = this.props
        data = { ...data, envid: modal.envid }
        this.setState({ modal: Object.assign(modal, { loading: true }) })

        return axios
            .post('/envitem/update/' + data.id, Object.assign(data))
            .then(() => this.onFinished(true, { visible: false }))
            .finally(() => this.onFinished(false, { loading: false }))
    }

    render() {
        const { modal, onCancel } = this.props

        return (
            <Modal
                title={'新增'}
                visible={modal.visible}
                confirmLoading={modal.loading}
                onOk={this.onSubmit}
                onCancel={onCancel}
                key={modal.key}
                maskClosable={false}
            >
                <EnvItemDetailForm ref="form" data={this.props.data} />
            </Modal>
        )
    }
}
