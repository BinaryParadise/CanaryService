import React from 'react'
import PropTypes from 'prop-types'
import { Button, Input, Popconfirm, Table, Popover, Tag } from 'antd'
import moment from 'moment'
import { nickname } from '../../common/config'
import { message } from 'antd/lib'
import axios from '../../component/axios'

const AdjustContent = (value, maxLength) => {
  maxLength = maxLength || 50
  if (value != undefined && value.length > maxLength) {
    return (
      <Popover placement="topLeft" content={value}>
        {value.length > maxLength ? value.substring(0, maxLength) + '...' : value}
      </Popover>)
  } else {
    return value
  }
}

const EditableCell = ({ editable, value, onChange, column }) => (
  <div>
    {editable ?
      <Input style={{ margin: '-5px 0' }} value={value} onChange={e => onChange(e.target.value)} />
      :
      AdjustContent(value, 50)}
  </div>
)

export default class EnvList extends React.Component {
  constructor(props) {
    super(props)

    this.columns = [
      {
        dataIndex: 'platform',
        title: '平台',
        width: '5%',
        render: (text, record) => this.renderType(record)
      },
      {
        dataIndex: 'name',
        title: '参数名称',
        width: '12%',
        render: (text, record) => {
          return this.renderColumns(text, record, 'name');
        }
      },
      {
        dataIndex: 'value',
        title: '参数值',
        width: '30%',
        render: (text, record) => this.renderColumns(text, record, 'value')
      },
      {
        dataIndex: 'comment',
        title: '描述',
        render: (text, record) => this.renderColumns(text, record, 'comment')
      },
      {
        dataIndex: 'updateTime',
        title: '操作时间',
        width: 155,
        render: (text, record) => moment(text).format('YYYY-MM-DD HH:mm:ss')
      },
      {
        dataIndex: 'author',
        title: '操作人',
        width: 98
      },
      {
        dataIndex: '',
        title: '操作',
        width: 180,
        render: (text, record) => {
          const { editable } = record
          return (
            <div className="editable-row-operations" style={{ padding: '0 0 0 8px' }}>
              {editable ? (
                <span className="m-action-group">
                  <a onClick={() => this.cancel(record.id)} style={{ marginRight: 5 }}>取消</a>
                  <a onClick={() => this.onSubmit(record.id)}>
                    保存
                  </a>
                </span>
              ) : (
                  <span className="m-action-group">
                    <a onClick={() => this.edit(record.id)} style={{ marginRight: 5 }}>
                      编辑
                  </a>
                    <Popconfirm title="确认删除?" onConfirm={() => this.props.onRemove(record.id)}>
                      <a>删除</a>
                    </Popconfirm>
                  </span>
                )}
            </div>
          )
        }
      }
    ]

    this.state = { data: [], listData: this.props.listData, modal: { visible: false } }
    this.cacheData = this.props.listData.map(item => ({ ...item }))
  }

  edit(key) {
    const newData = [...this.props.listData]
    const target = newData.filter(item => key === item.id)[0]
    if (target) {
      target.editable = true
      this.setState({ data: newData })
    }
  }

  handleAdd = e => {
    const { listData } = this.props
    const count = listData.length
    const newData = {
      id: count,
      editable: true,
      name: `ParameterName${count}`,
      value: '',
      comment: '这个参数是用来干嘛的?',
      updateTime: Date.now(),
      author: { nickname }
    }

    this.setState({ listData: [newData, ...listData] })
  }

  handleChange(value, key, column) {
    const newData = [...this.state.data]
    const target = newData.filter(item => key === item.id)[0]
    if (target) {
      target[column] = value
      this.setState({ data: newData })
    }
  }

  onSubmit = key => {
    const newData = [...this.props.listData]
    const target = newData.filter(item => key === item.id)[0]
    if (target) {
      axios.post('/envitem/update/' + target.id, Object.assign(target))
        .then(() => {
          this.onFinished(true, target)
        })
        .finally(() => this.onFinished(false))
    }
  }

  onFinished = (success, data) => {
    if (success) {
      message.success('更新成功!')
      this.props.onChange(data.envid)
    }
  }

  cancel(key) {
    const newData = [...this.props.listData]
    const target = newData.filter(item => key === item.id)[0]
    if (target) {
      Object.assign(target, this.cacheData.filter(item => key === item.id)[0])
      delete target.editable
      this.setState({ data: newData })
    }
  }

  renderColumns(text, record, column) {
    return (
      <EditableCell
        editable={record.editable}
        value={text}
        column={column}
        onChange={value => this.handleChange(value, record.id, column)}
      />
    )
  }

  //参数平台
  renderType(record) {
    var color = "#2db7f5"
    var typeStr = "全部"
    switch (record.platform) {
      case 1:
        color = "#FF99FF"
        typeStr = "iOS"
        break
      case 2:
        color = '#87d068'
        typeStr = "Android"
        break
    }
    return <Tag color={color}>{typeStr}</Tag>
  }

  render() {
    const { onShowModal, loading, pageSize, pageIndex, onRemove } = this.props
    const { listData } = this.props
    return (
      <div>
        <Button onClick={onShowModal} type="primary">
          添加
        </Button>

        <div style={{ margin: '8px 0' }} />

        <Table
          rowKey="id"
          loading={loading}
          columns={this.columns}
          dataSource={listData}
          size={'small'}
          pagination={{
            total: listData.length,
            pageSizeOptions: ['10', '20', '50'],
            showSizeChanger: listData.length > 10,
            size: 'middle',
            showQuickJumper: true,
            showTotal: total => `共 ${total} 条`
          }}
        />
      </div>
    )
  }
}

EnvList.propTypes = {
  listData: PropTypes.array.isRequired,
  onShowModal: PropTypes.func.isRequired,
  loading: PropTypes.bool.isRequired,
  onChange: PropTypes.func.isRequired,
  onRemove: PropTypes.func.isRequired
}
