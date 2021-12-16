import styles from '../index.less'
import PropTypes from 'prop-types'
import ReactJson from 'react-json-view'
import { Drawer, Descriptions, Modal, Button, message } from 'antd'
import { routerURL } from '@/common/util'
import { Link } from 'react-router-dom'
import React from 'react'
import axios from '@/component/axios'
import CopyToClipboard from 'copy-to-clipboard'
import MockEditForm from '@/pages/mock/edit'
import URL from 'url'

export default class NetLogPage extends React.Component {
    static propTypes = {
        data: PropTypes.object,
        onClose: PropTypes.func.isRequired
    }

    state = {
        editItem: { visible: false }
    }

    generateUrl = () => {
        const { data } = this.props
        return axios.post('/snapshot/add', data).then(result => {
            if (result.code == 0) {
                CopyToClipboard(window.location.origin + '/log/snapshot/' + data.identify)
                message.success('复制成功')
            } else {
                message.error(result.msg)
            }
        })
    }

    generateMock = () => {
        const { data } = this.props
        this.setState({ editItem: { visible: true, key: Math.random(), path: URL.parse(data.url).pathname, data: data.responsebody } })
    }

    render() {
        const { data } = this.props
        if (data == undefined || data == null) {
            return <p></p>
        }

        localStorage.setItem("requestData", JSON.stringify(data))

        const { editItem } = this.state

        return (<Drawer
            width={800}
            height={600}
            title={<span><span style={{ color: 'red', marginRight: 6 }}>{data.statusCode}</span><span style={{ color: 'purple', marginRight: 6 }}>{data.method}</span><Link to={routerURL('/request', data)} target="_blank" style={{ color: 'orange' }}>{data.url}</Link><Button type="primary" onClick={() => this.generateUrl()} style={{ marginLeft: 8 }}>生成快照</Button><Button type="primary" style={{ marginLeft: 6 }} onClick={() => this.generateMock()}>生成Mock</Button></span>}
            placement="bottom"
            closable={true}
            onClose={this.props.onClose}
            visible={data != null}
            getContainer={false}
            style={{ position: 'absolute' }}
        >
            <Descriptions title="" column={2} size='small' layout="vertical" bordered column={{ xxl: 2, xl: 2, lg: 2, md: 1, sm: 1, xs: 1 }}>
                <Descriptions.Item label={<b>请求</b>} className={styles.logtop}><ReactJson src={data.requestfields} name={'Headers'} collapseStringsAfterLength={50}></ReactJson></Descriptions.Item>
                <Descriptions.Item label={<b>响应</b>} className={styles.logtop}><ReactJson src={data.responsefields} collapseStringsAfterLength={50} name={'Headers'}></ReactJson></Descriptions.Item>
                <Descriptions.Item label="Body" className={styles.logtop}><ReactJson src={data.requestbody || {}} name={false} collapseStringsAfterLength={50}></ReactJson></Descriptions.Item>
                <Descriptions.Item label="Body" className={styles.logtop}><ReactJson src={data.responsebody || {}} name={false} collapseStringsAfterLength={50}></ReactJson></Descriptions.Item>
            </Descriptions>
            {editItem.visible && <MockEditForm key={editItem.key} data={editItem}></MockEditForm>}
        </Drawer>)
    }
}