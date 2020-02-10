import React from 'react'
import PropTypes from 'prop-types'
import axios from '../../../component/axios'
import { Badge, Input, Popconfirm, Switch, Table, Tag, Tooltip, Dropdown, Menu, Button, Icon } from 'antd'
import moment from 'moment'
import { routerURL } from '../../../common/util'
import { message } from 'antd/lib/index'
import { Link } from 'react-router-dom'

export class EnvList extends React.Component {
  static propTypes = {
    listData: PropTypes.array.isRequired,
    onEdit: PropTypes.func.isRequired,
    loading: PropTypes.bool,
    onChange: PropTypes.func.isRequired,
    cacheData: PropTypes.array,
    onRowClick: PropTypes.func.isRequired,
    pageSize: PropTypes.number.isRequired
  }

  constructor(props) {
    super(props)

    this.columns = [
      { dataIndex: 'appName', title: '项目', width: 168 },
      {
        dataIndex: 'name', title: '环境名称',
        render: (text, record) => this.renderColumns(text, record, 'name')
      },
      {
        dataIndex: 'type', title: '类型', width: 86, className: 'column-center',
        render: (text, record) => this.renderColumns(text, record, 'type')
      },
      {
        dataIndex: 'comment', title: '描述',
        render: (text, record) => this.renderColumns(text, record, 'comment')
      },
      { dataIndex: 'author', title: '操作人', width: 100 },
      {
        dataIndex: 'updateTime', title: '操作时间', width: 150, key: 'updateTime',
        sortOrder: true,
        render: date => moment(date).format('YYYY-MM-DD HH:mm:ss')
      },
      {
        dataIndex: '',
        title: '操作',
        width: 180,
        render: (text, record) => {
          const { editable } = record
          return (
            <div className="editable-row-operations">
              {
                this.renderActions(record)
              }
            </div>
          )
        }
      }
    ]

    this.state = { data: [] }
    this.cacheData = this.props.listData.map((item => ({ ...item })))
  }

  delete(key) {
    const newData = [...this.props.listData]
    const target = newData.filter(item => key === item.id)[0]
    if (target) {
      axios.post(`/conf/delete/${key}`, target).then(result => {
        message.success('删除成功！')
        this.props.onChange()
      })
    }
  }

  handleChange(value, key, column) {
    const newData = [...this.state.data]
    const target = newData.filter(item => key === item.id)[0]
    if (target) {
      target[column] = value;
      this.setState({ data: newData });
    }
  }

  renderColumns(value, record, name) {
    const { editable } = record
    switch (name) {
      case 'name':
        return (
          <span><Tooltip placement='topLeft' title={'已配置 ' + record.subItemsCount + ' 个参数'}>{value}</Tooltip> {record.default &&
            <Tag color='purple' style={{ margin: '0 5px', minWidth: '27' }}>默认</Tag>}</span>
        )
      case 'type':
        return this.renderType(record)
      default:
        return value
    }
  }

  renderActions(record) {
    const { onEdit } = this.props

    return (
      <span className="m-action-group">
        <Link to={routerURL('/envitem', record)}>查看</Link>
        <a style={{ margin: "0px 5px" }} onClick={() => this.props.onEdit(record)}>编辑</a>
        <Popconfirm placement="topRight"
          title="确定要删除该项？" onConfirm={() => this.delete(record.id)}
        >{(record.isDefault ? false : true) && <a>删除</a>}
        </Popconfirm>
      </span>
    )
  }

  //环境类型
  renderType(record) {
    var color = "#2db7f5"
    var typeStr = "测试"
    switch (record.type) {
      case 1:
        color = "#FF99FF"
        typeStr = "开发"
        break
      case 2:
        color = '#87d068'
        typeStr = "生产"
        break
    }
    return <Tag color={color}>{typeStr}</Tag>
  }

  render() {
    const { loading, listData, onChange, pageSize } = this.props
    var total = listData.length
    return (
      <Table className="env-records"
        rowKey="id"
        loading={loading}
        columns={this.columns}
        dataSource={listData}
        size='small'
        // onRow={record => {
        //   return {
        //     onClick:() => {this.props.onRowClick(record)}
        //   }
        // }}
        pagination={{
          total: total,
          showSizeChanger: total > pageSize,
          pageSizeOptions: ['15', '30', '50'],
          size: 'midlle',
          showQuickJumper: true,
          showTotal: total => `共 ${total} 条`
        }}
      />
    )
  }
}

export default EnvList
