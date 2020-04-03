import React from 'react'
import styles from './logger.css';
import PropTypes from 'prop-types'
import { Affix, Icon, Breadcrumb, Menu, Badge, notification, Dropdown } from 'antd'
import WebSocket from '../../../component/websocket'
import router from 'umi/router';
import NetLog from '../component/netlog'

// 日志标记
const Error = (1 << 0)
const Warning = (1 << 1)
const Info = (1 << 2)
const Debug = (1 << 3)
const Verbose = (1 << 4)

// 日志等级
const LevelError = 1;
const LevelWarning = 3;
const LevelInfo = 7;
const LevelDebug = 15;
const LevelVerbose = 31;


const FlagInfo = {
    1: { flag: Error, name: "错误", style: styles.red },
    3: { flag: Warning, name: "警告", style: styles.yellow },
    7: { flag: Info, name: "信息", style: styles.white },
    15: { flag: Debug, name: "调试", style: styles.green },
    31: { flag: Verbose, name: "全部", style: styles.white }
}

export default class LoggerMonitor extends React.Component {
    state = {
        data: this.props.location.state,
        logs: [],
        autoscroll: true,
        avaiable: false,
        logLevel: LevelVerbose,
        visiable: false
    }
    wsInstance = WebSocket.create(this.state.data.deviceId)

    componentDidMount() {
        if (this.state.data == undefined) {
            router.push('/device')
            return
        }
        this.wsInstance.connect(this.onMessage)
        this.scrollToBottom()
    }

    componentWillUnmount() {
        this.wsInstance.close()
    }

    componentDidUpdate() {
        this.scrollToBottom()
    }

    formatDate = obj => {
        return new Date(obj.timestamp || new Date().getTime()).Format('HH:mm:ss.S')
    }

    formatFunc = obj => {
        if (obj.function === undefined) {
            return ""
        }
        return obj.function + '+' + obj.line + ' '
    }

    formatMessage = obj => {
        if (obj.type !== 1) {
            return '🌐' + obj.method + ' ' + obj.url
        }
        return obj.message;
    }

    scrollToBottom = () => {
        if (this.state.autoscroll) {
            this.messagesEnd.scrollIntoView(false);
        }
    }

    onMenuClick = (item) => {
        this.setState({ logLevel: parseInt(item.key) })
    }

    onLogClick = (item) => {
        if (item.type == 2) {
            this.setState({ curData: item })
        }
    }

    onLogClose = (item) => {
        this.setState({ curData: null })
    }

    logMenu = () => {
        const selectedKeys = []
        Object.keys(FlagInfo).map((key) => {
            if (FlagInfo[parseInt(key)].flag & this.state.logLevel) {
                selectedKeys.push(key)
            }
        })
        return (
            < Menu style={{ width: 80 }} theme="dark" selectedKeys={selectedKeys} multiple={true} onClick={this.onMenuClick} > {
                Object.keys(FlagInfo).map((skey) => {
                    return (<Menu.Item key={skey}>
                        <a className={FlagInfo[parseInt(skey)].style}>{FlagInfo[skey].name}</a>
                    </Menu.Item>)
                })}
            </Menu >
        )
    }

    logClass = obj => {
        if (obj.type == 2) {
            return styles.yellow;
        }
        switch (obj.flag) {
            case Verbose: return styles.verbose;
            case Debug: return styles.green;
            case Info: return styles.white;
            case Warning: return styles.yellow;
            case Error: return styles.red;
            default: return styles.white;
        }
    }

    transformIp = (data) => {
        const ipv4 = (data.ipAddrs || {}).ipv4
        let key = Object.keys(ipv4).filter(item => !ipv4[item].startsWith('169') && item.startsWith('en'))[0]
        return ipv4[key]
    }

    render() {
        const { autoscroll, data, avaiable, logLevel } = this.state
        const filterLogs = this.state.logs.filter(item => item.flag & logLevel)
        const levelInfo = FlagInfo[logLevel]
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
                        <Badge status={avaiable ? 'processing' : 'default'}></Badge> {data.name}（<span style={{color:'orange'}}>{this.transformIp(data)}</span>）
                    </Breadcrumb.Item>
                </Breadcrumb>
                <div className={styles.logbody}>
                    <pre className={styles.ansi} ref={(el) => { this.messagesEnd = el }}>
                        {
                            filterLogs.map((record) => <div onClick={() => this.onLogClick(record)} className={styles.log_line} key={record.key}><a href='#'></a>
                                <span id={record.key} className={this.logClass(record) + " " + styles.bold}>{this.formatDate(record) + ' '}{this.formatFunc(record)}{this.formatMessage(record)}</span>
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
                    <Dropdown overlay={this.logMenu()} placement="topRight">
                        <a>{levelInfo.name}<Icon type="down"></Icon></a>
                    </Dropdown>
                </Affix>
                <NetLog data={this.state.curData} onClose={this.onLogClose}></NetLog>
            </div >
        )
    }

    onMessage = (obj) => {
        if (obj.code != 0) {
            notification['error']({
                message: '错误',
                description:
                    obj.msg,
            });
            return
        }
        const { logs } = this.state
        switch (obj.type) {
            case 1: notification['success']({
                message: '信息',
                description:
                    obj.msg,
            });
                return true;
            case 11:
                this.setState({ avaiable: obj.data.avaiable })
                this.setState({ logs: [...logs, { flag: 8, message: obj.msg, key: 'key-' + logs.length, type: 1 }] })
                return true;
            case 30://本地日志
            case 31://网络日志
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
        height: '25px',
        marginRight: '6px'
    },
    paus: {
        color: 'gray',
        width: '25px',
        height: '25px',
        marginRight: '6px'
    }
}