import styles from './index.css';
import React from 'react'

import { Layout, Drawer, Icon, Menu, Avatar, Row, Col, Button, Modal, Select, message, Dropdown, ConfigProvider } from 'antd';
import router from 'umi/router';
import axios from '../component/axios'
import { AuthUser, Auth } from '../common/util'
import default_handsome from '../assets/default_handsome.jpg'
import zhCN from 'antd/es/locale/zh_CN';

const { Header, Content, Footer } = Layout;

class BasicLayout extends React.Component {
  state = {
    visible: false,
    project: false,
    selectedItem: null,
    appData: []
  };

  showDrawer = () => {
    this.setState({
      visible: true,
    });
  };

  onClose = () => {
    this.setState({
      visible: false,
    });
  };

  refresh = () => {
    this.forceUpdate();
  }


  onMenuSelect = (item) => {
    this.setState({ visible: false })
    router.push(item.key);
  }

  confirmSwitchProject = () => {
    if (this.state.selectedItem == null) {
      message.error('请先选择一个项目');
      return;
    }

    const projectInfo = this.state.appData.filter(item => item.id == this.state.selectedItem)[0];
    localStorage.setItem("projectInfo", JSON.stringify(projectInfo))
    window.__config__.projectInfo = projectInfo
    this.setState({ project: false })
    message.success("项目切换成功!")
    router.push("/")
  }

  onChange = (value) => {
    this.setState({ selectedItem: value })
  }

  // 获取项目列表
  getAppList = () => {
    return axios.get('/project/list', {}).then(result => {
      this.setState({ appData: result.data, project: true })
    })
  }

  switchProject = () => {
    this.getAppList()
  }

  logout = () => {
    localStorage.removeItem("user")
    router.push('/login')
  }

  componentDidMount() {
    if (AuthUser().id && window.__config__.projectInfo == undefined) {
      router.push('/project')
    }
  }

  render() {
    const { projectInfo } = window.__config__
    const { appData } = this.state
    const { pathname } = this.props.location
    if (pathname === "/login" && localStorage.getItem("user") == null) {
      return (
        <Layout style={{ padding: "180px", height: '100vh' }}>
          <Row>
            <Col span={9} />
            <Col span={6} >
              {this.props.children}
            </Col>
            <Col span={9} />
          </Row>
        </Layout>
      )
    }
    return (
      <ConfigProvider locale={zhCN}>
        <Layout className={styles.normal}>
          <Modal visible={this.state.project} title="请选择项目" onOk={this.confirmSwitchProject} onCancel={() => this.setState({ project: false })}>
            <Select placeholder="请选择" style={{ width: 180 }} onChange={this.onChange}>
              {
                appData.map(item => {
                  return <Select.Option key={item.id} value={item.id}>{item.name}</Select.Option>;
                })
              }
            </Select> <a style={{ marginLeft: 6 }} hidden={!Auth('user')} onClick={() => {
              this.setState({ project: false })
              router.push('/project')
            }}>管理</a>
          </Modal>
          <Drawer
            title="基础服务"
            placement="left"
            closable={false}
            onClose={this.onClose}
            visible={this.state.visible}
            getContainer={false}
            style={{ position: 'absolute' }}
          >
            <Menu
              defaultSelectedKeys={pathname == "/" ? "/env" : "/" + pathname.split('/')[1]}
              style={{ width: 256, margin: -24 }}
              mode="inline"
              theme="light"
              inlineCollapsed={this.state.collapsed}
              onSelect={this.onMenuSelect}
            >
              <Menu.Item key="/env">
                <Icon type="setting" />
                <span>环境切换</span>
              </Menu.Item>
              <Menu.Item key="/device">
                <Icon type="hdd" />
                <span>设备列表</span>
              </Menu.Item>
              <Menu.Item key="/source" hidden={true}>
                <Icon type="link" />
                <span>路由配置</span>
              </Menu.Item>
              <Menu.Item key="/package" hidden={false}>
                <Icon type="appstore" />
                <span>测试包管理</span>
              </Menu.Item>
              <Menu.Item key="/project" hidden={!Auth('project')}>
                <Icon type="project" />
                <span>项目管理</span>
              </Menu.Item>
              <Menu.Item key="/user" hidden={!Auth('user')}>
                <Icon type="user" />
                <span>用户管理</span>
              </Menu.Item>
            </Menu>
          </Drawer>
          <Header className={styles.header}>
            <Icon type="unordered-list" className={styles.logo} onMouseOver={this.showDrawer} />
            <Button className={styles.title} onClick={this.switchProject}>
              {projectInfo == undefined ? "未选择项目" : projectInfo.name}
            </Button>
            <span style={{ float: "right" }}>
              <Dropdown overlay={(
                <Menu onClick={this.logout}>
                  <Menu.Item key="1">
                    退出
              </Menu.Item>
                </Menu>
              )}>
                <a className="ant-dropdown-link" onClick={e => e.preventDefault()}>
                  {AuthUser().name}
                  <Avatar style={{ marginRight: 16, marginLeft: 8 }} src={default_handsome}></Avatar>
                </a>
              </Dropdown>
            </span>
          </Header>
          <Content ref={this.saveContainer} style={{ padding: '12px 24px', marginTop: 50, overflow: 'auto' }}>
            {this.props.children}
          </Content>
        </Layout >
      </ConfigProvider>
    );
  }
}

export default BasicLayout;
