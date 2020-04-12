import styles from '../index.less'
import PropTypes from 'prop-types'
import ReactJson from 'react-json-view'
import { Drawer, Descriptions, Tabs } from 'antd'
import React from 'react'

export default class NetLogPage extends React.Component {
    static propTypes = {
        data: PropTypes.object,
        onClose: PropTypes.func.isRequired
    }
    render() {
        const { data } = this.props
        if (data == undefined || data == null) {
            return <p></p>
        }

        return (<Drawer
            width={800}
            height={600}
            title={<span><span style={{ color: 'red', marginRight: 6 }}>{data.statusCode}</span><span style={{ color: 'purple', marginRight: 6 }}>{data.method}</span><span style={{ color: 'orange' }}>{data.url}</span></span>}
            placement="bottom"
            closable={true}
            onClose={this.props.onClose}
            visible={data != null}
            getContainer={false}
            style={{ position: 'absolute' }}
        >
            <Descriptions title="" column={2} size='small' layout="vertical" bordered>
                <Descriptions.Item label={<b>请求</b>} className={styles.logtop}><ReactJson src={data.requestfields} name={'Headers'}></ReactJson></Descriptions.Item>
                <Descriptions.Item label={<b>响应</b>} className={styles.logtop}><ReactJson src={data.responsefields} name={'Headers'}></ReactJson></Descriptions.Item>
                <Descriptions.Item label="Body" className={styles.logtop}><ReactJson src={data.requestbody || {}} name={false}></ReactJson></Descriptions.Item>
                <Descriptions.Item label="Body" className={styles.logtop}><ReactJson src={data.responsebody || {}} name={false}></ReactJson></Descriptions.Item>
            </Descriptions>
        </Drawer>)
    }
}