
import styles from './logger.css';
import React from 'react'
import PropTypes from 'prop-types'
import { Popover, Affix, Icon } from 'antd'
import WebSocket from '../../component/websocket'
import imgURL from '../../assets/yay.jpg'
import router from 'umi/router';

export default class LogMonitor extends React.Component {
  state = {
    data: this.props.location.state,
    logs: [],
    autoscroll: true
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
      case 0: return 'verbose';
      case 1: return 'green';
      case 2: return 'white';
      case 3: return 'yellow';
      case 4: return 'red';
      case 5: return 'magenta bold';
      default: return 'white';
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
          <img src={imgURL} style={{ width: '20px', height: '14px', marginRight: '3px' }} alt='' />
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
    const { autoscroll, logs } = this.state
    return (
      <div>
        <div className="log-body">
          <pre className="ansi" ref={(el) => { this.messagesEnd = el }}>
            {
              logs.map((record) => <div className="log-line" key={record.key}><a href='#'></a>
                <span id={record.key} className={this.logClass(record)}>{this.formatDate(record) + ' '}{this.formatFunc(record)}{this.formatMessage(record)}</span>
              </div>)
            }
          </pre>
        </div>

        <Affix style={{ width: '50px', position: 'absolute', left: 10, bottom: 15 }}>
          <Icon type="delete" style={iconStyle.clear} onClick={() => {
            this.setState({ logs: [] })
          }} />
          <Icon type={autoscroll ? "sync" : "pause-circle"} spin={autoscroll} style={autoscroll ? iconStyle.sync : iconStyle.paus} onClick={() => {
            this.setState({
              autoscroll: !this.state.autoscroll,
            });
          }} />
        </Affix>
      </div>
    )
  }

  onMessage = (obj) => {
    switch (obj.type) {
      case 1: //开启监听
        WebSocket.sendMessage({ type: 1, data: { logger: true } })
        return false;
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