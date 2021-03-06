import React from 'react'
import PropTypes from 'prop-types'
import { Popconfirm, Input, Button, Breadcrumb, message, Table, Modal, Icon, Tag, Divider } from 'antd'
import { routerURL } from '../../../common/util'
import axios from '../../../component/axios'
import Layout from 'antd/lib/layout/layout'
import ReactJson from 'react-json-view'
import moment from 'moment'
import { Link } from 'react-router-dom'
import SceneEditForm from './editscene'
import ParamEditForm from '../param/edit'

class MockScenePage extends React.Component {
    state = {
        loading: false,
        mock: this.props.location.state,
        listData: [],
        editItem: {},
        editParam: {},
        showParam: false
    }

    mock = () => {
        return this.props.location.state
    }

    columns = [
        {
            title: '场景名称',
            dataIndex: 'name',
            width: 180
        },
        {
            title: '响应结果',
            width: 666,
            dataIndex: 'response',
            ellipsis: true
        },
        {
            title: '状态',
            width: 80,
            render: (text, record) => {
                if (record.activeid == null) {
                    return <Tag color="orange">自动</Tag>
                } else if (record.activeid == record.id) {
                    return <Tag color="#87d068">激活</Tag>
                } else {
                    return <Tag color="gray">闲置</Tag>
                }
            }
        },
        {
            dataIndex: 'updatetime',
            title: '更新时间',
            width: 200,
            render: (text, record) => {
                return moment(text).format("YYYY-MM-DD HH:mm:ss")
            }
        },
        {
            title: '操作',
            dataIndex: 'id',
            render: (text, record) => {
                return (<span>
                    < Popconfirm title="确认删除?" onConfirm={() => this.onDeleteScene(record)
                    }>
                        <a style={{ marginLeft: 8, color: "red" }}>删除</a>
                    </Popconfirm >
                    <a style={{ marginLeft: 8 }} onClick={() => this.onEdit(record)}>编辑</a>
                    <Divider type="vertical"></Divider>
                    {this.renderSceneAction(record)}
                    <a style={{ marginLeft: 8, color: "#0b8235" }} href={"/api/mock/app/scene/" + record.id} target="_blank">查看</a>
                </span>
                )
            }
        }
    ];

    renderSceneAction = (record) => {
        var sceneid = record.activeid
        var p = { title: '确认激活?', color: '#35B0D8', btn: '激活', active: true }
        if (sceneid == null) {

        } else {
            if (sceneid == record.id) {
                p.title = "确认切换为自动模式？"
                p.btn = "关闭"
                p.active = false
            }
        }
        return <Popconfirm title={p.title} onConfirm={() => this.onActive(record, p.active)}>
            <a style={{ color: p.color }}>{p.btn}</a>
        </Popconfirm>
    }

    componentDidMount() {
        this.queryAll()
    }

    queryMock() {
        return axios.get('/mock')
    }

    queryAll() {
        return axios.get('/mock/scene/list/' + this.state.mock.id, {}).then(result => {
            if (result.code != 0) {
                return
            }
            this.setState({ listData: result.data, editItem: {}, editParam: {} })
        })
    }

    onEdit = (record) => {
        this.setState({ editItem: { visible: true, data: record } })
    }

    onActive = (record, active) => {
        var newR = { sceneid: record.id, enabled: active, id: record.mockid }
        return axios.post('/mock/scene/active', newR).then(result => {
            if (result.code != 0) {
                message.error(result.error)
                return
            }
            this.props.location.state = newR
            this.queryAll()
        })
    }

    onSave = () => {
        const { form } = this.formRef.props;
        form.validateFields((err, values) => {
            if (err) {
                return;
            }

            this.submit(values, () => {
                form.resetFields()
                this.queryAll()
            });
        });
    }

    onParam = (record) => {
        this.setState({ editParam: { visiable: true, data: record } })
    }

    onParamSave = () => {
        const { form } = this.formParam.props;
        form.validateFields((err, values) => {
            if (err) {
                return;
            }

            return axios.post('/mock/param/update', values).then(result => {
                if (result.code == 0) {
                    message.success("保存成功")
                    form.resetFields()
                    this.queryAll()
                } else {
                    message.error(result.error)
                }
            });
        });
    }

    onDeleteParam = (record) => {
        return axios.post('/mock/param/delete/' + record.id).then(result => {
            if (result.code == 0) {
                this.props.location.state = { ...this.mock(), sceneid: null }
                this.queryAll()
            } else {
                message.error(result.error)
            }
        });
    }

    onCancel = () => {
        this.setState({ editItem: { visible: false, data: {} } })
    }

    submit = (values, callback) => {
        return axios.post('/mock/scene/update', values).then(result => {
            if (result.code == 0) {
                message.success("保存成功")
                callback()
            } else {
                message.error(result.error)
            }
        });
    }

    onDeleteScene(item) {
        return axios.post('/mock/scene/delete/' + item.id).then(result => {
            if (result.code != 0) {
                message.error(result.error)
                return
            }
            this.queryAll()
        })
    }

    expandTable = (item) => {
        var excolumns = [
            {
                title: '参数名称',
                dataIndex: 'name',
                width: 160
            },
            {
                title: '参数值',
                dataIndex: 'value',
                width: 168
            },
            {
                title: '参数说明',
                width: 210,
                dataIndex: 'comment',
                ellipsis: true
            },
            {
                dataIndex: 'updatetime',
                title: '更新时间',
                width: 200,
                render: (text, record) => {
                    return text == null ? "-" : moment(text).format("YYYY-MM-DD HH:mm:ss")
                }
            },
            {
                title: '操作',
                dataIndex: 'id',
                render: (text, record) => {
                    return <span>
                        <Icon type="plus-circle" style={{ color: 'green' }} onClick={() => this.onParam(record)} />
                        {
                            text != null &&
                            <Popconfirm title="确认删除?" onConfirm={() => this.onDeleteParam(record)}>
                                <Icon style={{ marginLeft: 8, color: 'red' }} type="minus-circle" />
                            </Popconfirm>
                        }
                    </span>
                }
            }
        ]

        return (<Table size="small" dataSource={item.params || [{ sceneid: item.id }]} columns={excolumns} rowKey="id"></Table>)
    }

    render() {
        const { loading, listData, mock, editItem, editParam } = this.state
        return (
            <Layout>
                <Breadcrumb style={{ marginBottom: 12 }}>
                    <Breadcrumb.Item>
                        <a href="/">首页</a>
                    </Breadcrumb.Item>
                    <Breadcrumb.Item><a href="/mock/data">Mock数据</a></Breadcrumb.Item>
                    <Breadcrumb.Item>场景配置</Breadcrumb.Item>
                </Breadcrumb>

                <div style={{ verticalAlign: 'middle' }}>
                    <span style={{ fontWeight: 'bold', fontSize: 18, color: 'orange' }}>{mock.name} {mock.path}</span>
                    <Button type="primary" style={{ width: 100, marginBottom: 12, float: "right" }} onClick={() => this.onEdit({ mockid: mock.id })}>+添加场景</Button>


                    <Table rowKey="id" loading={loading} dataSource={listData} columns={this.columns} rowKey="id" expandedRowRender={(e) => this.expandTable(e)}></Table>

                    <span style={{ fontWeight: 'bold', marginTop: 8, marginBottom: 8 }}>模板数据</span>

                    <Input.TextArea placeholder="请在设备中上传模板数据" autoSize={{ minRows: 6, maxRows: 100 }} value={mock.template} />
                    <Button type="primary" style={{ width: 100, marginTop: 8, marginBottom: 12 }} onClick={() => this.onEdit({})}>保存模板</Button>
                </div>
                <Modal
                    visible={editItem.visible}
                    title={editItem.data == null ? "新增" : "修改"}
                    cancelText="取消"
                    okText="保存"
                    width={1500}
                    onCancel={this.onCancel}
                    onOk={this.onSave}
                    destroyOnClose={true}
                >
                    <SceneEditForm wrappedComponentRef={(ref) => this.formRef = ref} data={editItem.data || {}}></SceneEditForm>
                </Modal>
                <Modal
                    visible={editParam.visiable}
                    title={"参数配置"}
                    cancelText="取消"
                    okText="保存"
                    width={666}
                    onCancel={() => this.setState({ editParam: { visiable: false, data: {} } })}
                    onOk={this.onParamSave}
                    destroyOnClose={true}
                >
                    <ParamEditForm wrappedComponentRef={(ref) => this.formParam = ref} data={editParam.data || {}}></ParamEditForm>
                </Modal>

            </Layout>
        )
    }
}

export default MockScenePage