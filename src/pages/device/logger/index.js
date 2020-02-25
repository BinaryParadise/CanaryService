import React from 'react'
import styles from './logger.css';
import PropTypes from 'prop-types'
import { Popover, Affix, Icon, Breadcrumb, message, Badge, notification } from 'antd'
import WebSocket from '../../../component/websocket'
import router from 'umi/router';

export default class LoggerMonitor extends React.Component {
    state = {
        data: this.props.location.state,
        logs: [],
        autoscroll: true,
        avaiable: false
    }

    componentWillMount() {
        if (this.state.data == undefined) {
            router.push('/device')
            return
        }
    }

    componentDidMount() {
        WebSocket.create(this.state.data.deviceId).connect(this.onMessage)
        this.scrollToBottom()
    }

    componentDidUpdate() {
        this.scrollToBottom()
    }

    logClass = obj => {
        switch (obj.type) {
            case 0: return styles.verbose;
            case 1: return styles.green;
            case 2: return styles.white;
            case 3: return styles.yellow;
            case 4: return styles.red;
            case 5: return styles.magenta;
            default: return styles.white;
        }
    }

    formatDate = obj => {
        return new Date(obj.timestamp).Format('HH:mm:ss.S')
    }

    formatFunc = obj => {
        // return "";//自带函数名称和代码行
        if (obj.function === undefined) {
            return ""
        }
        return obj.function + '+' + obj.line + ' '
    }

    formatMessage = obj => {
        if (obj.type === undefined) {
            if (obj.mimeType.indexOf('image/') === 0) {
                return (<span>{'🌐' + obj.statusCode + ' '}<Popover placement='topLeft' style={{ backgroundColor: 'transparent' }} content={<img src={'data:' + obj.mimeType + ';base64,' + obj.responseBody} alt='' />}>
                    {obj.url}
                </Popover></span>
                )
            }
            return '🌐' + obj.statusCode + ' ' + obj.url
        }
        return obj.message;
    }

    scrollToBottom = () => {
        if (this.state.autoscroll) {
            this.messagesEnd.scrollIntoView(false);
        }
    }

    render() {
        const { autoscroll, logs, data, avaiable } = this.state
        return (
            <div>
                <Breadcrumb style={{ marginBottom: 12 }}>
                    <Breadcrumb.Item>
                        <a href="/">首页</a>
                    </Breadcrumb.Item>
                    <Breadcrumb.Item>
                        <a href="/device">设备列表</a>
                    </Breadcrumb.Item>
                    <Breadcrumb.Item>
                        <Badge status={avaiable ? 'success' : 'default'}></Badge> {data.name}（{(data.ipAddrs || {}).ipv4.en0}）
                    </Breadcrumb.Item>
                </Breadcrumb>
                <div className={styles.logbody}>
                    <pre className={styles.ansi} ref={(el) => { this.messagesEnd = el }}>
                        {
                            logs.map((record) => <div className={styles.log_line} key={record.key}><a href='#'></a>
                                <span id={record.key} className={this.logClass(record)}>{this.formatDate(record) + ' '}{this.formatFunc(record)}{this.formatMessage(record)}</span>
                            </div>)
                        }
                    </pre>
                </div>

                <Affix style={{ position: 'absolute', height: 40, width: '100vw', paddingLeft: 20, paddingTop: 12, left: 0, bottom: 0, background: '#222' }}>
                    <Icon type="delete" style={iconStyle.clear} onClick={() => {
                        this.setState({ logs: [] })
                    }} />
                    <Icon type={autoscroll ? "sync" : "pause-circle"} spin={autoscroll} style={autoscroll ? iconStyle.sync : iconStyle.paus} onClick={() => {
                        this.setState({
                            autoscroll: !this.state.autoscroll,
                        });
                    }} />
                </Affix>
            </div >
        )
    }

    onMessage = (obj) => {
        this.setState({ avaiable: obj.code == 0 })
        if (obj.code != 0) {
            notification['error']({
                message: '错误',
                description:
                    obj.msg,
            });
            return
        }
        switch (obj.type) {
            case 30://本地日志
            case 31://网络日志
                const { logs } = this.state
                obj.data.key = 'key-' + logs.length
                this.setState({ logs: [...logs, obj.data] })
                return true;
            default:
                return false;
        }
    }
}

const iconStyle = {
    clear: {
        color: 'white',
        marginRight: '6px'
    },
    sync: {
        color: '#B1FD79',
        width: '25px',
        height: '25px'
    },
    paus: {
        color: 'gray',
        width: '25px',
        height: '25px'
    }
}