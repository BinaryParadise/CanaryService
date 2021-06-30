import styles from '../index.less'
import PropTypes from 'prop-types'
import { Drawer, Descriptions } from 'antd'
import React from 'react'
import ReactJson from 'react-json-view'

export default class ExtraPage extends React.Component {
    static propTypes = {
        device: PropTypes.object,
        visible: PropTypes.bool.isRequired,
        onClose: PropTypes.func.isRequired,
        isProfile: PropTypes.bool
    }
    render() {
        const { device, isProfile } = this.props
        if (device == null) {
            return (<p></p>)
        }

        const title = isProfile ? "额外信息" : "IP详细信息"
        const data = isProfile ? device.profile : device.ipAddrs

        return (<Drawer
            width={isProfile ? 800 : 600}
            height={600}
            title={device.name + ' / ' + title}
            placement="bottom"
            closable={false}
            onClose={this.props.onClose}
            visible={this.props.visible}
            getContainer={false}
            style={{ position: 'absolute' }}
        >
            <Descriptions column={1} size='middle' layout="horizontal" bordered>
                {Object.keys(data).map((key) => {
                    return <Descriptions.Item label={key}>
                        <ReactJson name={false} src={data[key]} collapseStringsAfterLength={50}></ReactJson>
                    </Descriptions.Item>
                })}
            </Descriptions>
        </Drawer >)
    }
}