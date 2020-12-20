import React from 'react'
import PropTypes from 'prop-types'
import { Popconfirm, Input, Button, Breadcrumb, message, Table, Modal } from 'antd'
import { routerURL } from '../../../common/util'
import axios from '../../../component/axios'
import Layout from 'antd/lib/layout/layout'
import ReactJson from 'react-json-view'
import moment from 'moment'
import { Link } from 'react-router-dom'
import SceneEditForm from './editscene'

class MockScenePage extends React.Component {
    state = {
        visiable: false,
        appid: (window.__config__.projectInfo || {}).id,
        loading: false,
        mock: this.props.location.state,
        listData: [],
        editItem: {}
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
            dataIndex: 'updatetime',
            title: '更新时间',
            width: 200,
            render: (text, record) => {
                return moment(text).format("YYYY-MM-DD HH:mm:ss")
            }
        },
        {
            title: '操作',
            dataIndex: 'orderno',
            render: (text, record) => {
                return (<span>
                    <a style={{ marginLeft: 8 }} onClick={() => this.onEdit(record)}>编辑</a>
                    <a style={{ marginLeft: 8 }} onClick={() => this.onEdit(record)}>复制</a>
                    <a style={{ marginLeft: 8, color: "#0b8235" }} href={"/api/mock/app/scene/" + record.id} target="_blank">查看</a>
                    < Popconfirm title="确认删除?" onConfirm={() => this.onDeleteScene(record)
                    }>
                        <a style={{ marginLeft: 8, color: "red" }}>删除</a>
                    </Popconfirm >
                </span>
                )
            }
        }
    ];

    componentDidMount() {
        this.queryAll()
    }

    queryAll() {
        return axios.get('/mock/scene/list', { params: { mockid: this.state.mock.id } }).then(result => {
            if (result.code != 0) {
                return
            }
            this.setState({ listData: result.data, visiable: false, editItem: {} })
        })
    }

    onEdit = (record) => {
        this.setState({ editItem: { visible: true, data: record } })
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
        return axios.post('/mock/scene/delete', item).then(result => {
            if (result.code != 0) {
                message.error(result.error)
                return
            }
            this.queryAll()
        })
    }

    render() {
        const { loading, listData, mock, editItem } = this.state
        return (
            <Layout>
                <Breadcrumb style={{ marginBottom: 12 }}>
                    <Breadcrumb.Item>
                        <a href="/">首页</a>
                    </Breadcrumb.Item>
                    <Breadcrumb.Item><a href="/mock">Mock数据</a></Breadcrumb.Item>
                    <Breadcrumb.Item>编辑场景</Breadcrumb.Item>
                </Breadcrumb>
                <Button type="primary" style={{ width: 100, marginBottom: 12 }} onClick={() => this.onEdit({ mockid: mock.id })}>+添加场景</Button>

                <Table rowKey="id" loading={loading} dataSource={listData} columns={this.columns}></Table>

                <span style={{ fontWeight: 'bold', marginTop: 8, marginBottom: 8 }}>模板数据</span>

                <Input.TextArea placeholder="请在设备中上传模板数据" autoSize={{ minRows: 6, maxRows: 100 }} value={mock.template} />
                <Button type="primary" style={{ width: 100, marginTop: 8, marginBottom: 12 }} onClick={() => this.onEdit({})}>保存模板</Button>

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

            </Layout>
        )
    }
}
export default MockScenePage