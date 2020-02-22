import React from 'react'
import { Table, Popconfirm, Layout, Button, message, Modal, Badge } from "antd";
import axios from '../../component/axios'
import ProjectEditForm from './edit'

export default class ProjectPage extends React.Component {
    columns = [
        {
            title: '名称',
            dataIndex: 'name',
            width: '30%',
            editable: true,
        },
        {
            title: '唯一标识',
            dataIndex: 'identify',
        },
        {
            title: '共享',
            dataIndex: 'shared',
            render: (text) => {
                return <Badge status={text ? 'success' : 'default'} text={text ? '共享' : '私有'} />;
            }
        },
        {
            title: '操作',
            dataIndex: 'orderno',
            render: (text, record) => {
                return (<span>
                    < Popconfirm title="确认删除?" onConfirm={() => this.handleDelete(record)
                    }>
                        <a>删除</a>
                    </Popconfirm >
                    <a style={{ marginLeft: 5 }} onClick={() => this.onEdit(record)}>编辑</a></span>
                )
            }
        }
    ];

    state = {
        loading: false,
        listData: [],
        editItem: {
            visible: false,
            data: {}
        }
    }

    onEdit = (record) => {
        this.setState({ editItem: { visible: true, data: record } })
    }

    componentDidMount() {
        this.getAppList();
    }

    // 获取项目列表
    getAppList = () => {
        return axios.get('/project/list', {}).then(result => {
            this.setState({ listData: result.data, loading: false, editItem: { visible: false, data: {} } })
        })
    }

    handleDelete = (record) => {
        return axios.post("/project/delete/" + record.id).then(result => {
            if (result.code == 0) {
                const dataSource = [...this.state.listData];
                this.setState({ listData: dataSource.filter(item => item.id !== record.id) });
                message.success("刪除成功");
            } else {
                message.error(result.error);
            }
        })
    }

    onCancel = () => {
        const { editItem } = this.state
        this.setState({ editItem: { ...editItem, visible: false } })
    }

    onSave = () => {
        const { form } = this.formRef.props;
        form.validateFields((err, values) => {
            if (err) {
                return;
            }

            this.submit(values, () => {
                form.resetFields()
                this.getAppList()
            });
        });
    }

    saveFormRef = (formRef) => {
        this.formRef = formRef
    }

    submit = (values, callback) => {
        return axios.post('/project/update', values).then(result => {
            if (result.code == 0) {
                message.success("保存成功")
                callback()
            } else {
                message.error(result.error)
            }
        });
    }

    render() {
        const { loading, listData, editItem } = this.state
        return (
            <Layout>
                <Button type="primary" style={{ width: 80, marginBottom: 12 }} onClick={() => this.onEdit({})}>添加</Button>
                <Modal
                    visible={editItem.visible}
                    title={editItem.data == null ? "新增" : "修改"}
                    cancelText="取消"
                    okText="保存"
                    onCancel={this.onCancel}
                    onOk={this.onSave}
                >
                    <ProjectEditForm wrappedComponentRef={this.saveFormRef} data={editItem.data || {}}></ProjectEditForm>
                </Modal>
                <Table rowKey="id" loading={loading} dataSource={listData} columns={this.columns}></Table>
            </Layout>
        )
    }

}