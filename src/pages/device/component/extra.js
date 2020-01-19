import PropTypes from 'prop-types'
import { Drawer, Descriptions } from 'antd'
import React from 'react'

export default class ExtraPage extends React.Component {
    static propTypes = {
        device: PropTypes.object,
        visible: PropTypes.bool.isRequired,
        onClose: PropTypes.func.isRequired
    }
    render() {
        const { device } = this.props
        if (device == null) {
            return (<p></p>)
        }

        return (<Drawer
            width={618}
            title={device.name + '/' + device.ipAddr}
            placement="right"
            closable={false}
            onClose={this.props.onClose}
            visible={this.props.visible}
            getContainer={false}
            style={{ position: 'absolute' }}
        >
            <Descriptions column={1} size='small' layout="horizontal" bordered>
                {Object.keys(device.profile).map((key) => {
                    return <Descriptions.Item label={key}>{device.profile[key]}</Descriptions.Item>
                })}
            </Descriptions>
        </Drawer>)
    }
}