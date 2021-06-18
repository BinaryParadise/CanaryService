import styles from './index.css';
import React from 'react'

import { Layout, Drawer, Icon, Menu, Avatar, Row, Col, Button, Modal, Select, message, Dropdown, ConfigProvider, Empty } from 'antd';
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
      message.error('请选择应用');
      return;
    }

    const projectInfo = this.state.appData.filter(item => item.id == this.state.selectedItem)[0];
    return axios.post('/user/change/app', projectInfo).then(result => {
      localStorage.setItem("user", JSON.stringify(result.data))
      window.__config__.user = result.data
      this.setState({ project: false })
      message.success("应用切换成功!")
      window.location.href = window.location.href
    })
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
    if (localStorage.getItem("user") == null) {
      router.push('/login')
    }
  }

  render() {
    const { user } = window.__config__
    const { appData } = this.state
    const { pathname } = this.props.location
    if (pathname === "/login") {
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
    if (pathname === "/request" || pathname.startsWith("/log/snapshot/")) {
      return this.props.children
    }
    return (
      <ConfigProvider locale={zhCN}>
        <Layout className={styles.normal}>
          <Modal visible={this.state.project} title="请选择应用" onOk={this.confirmSwitchProject} onCancel={() => this.setState({ project: false })}>
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
              openKeys={["mockgroup"]}
              inlineCollapsed={this.state.collapsed}
              onSelect={this.onMenuSelect}
            >
              <Menu.Item key="/env">
                <Icon type="setting" />
                <span>环境配置</span>
              </Menu.Item>
              <Menu.Item key="/device">
                <Icon type="hdd" />
                <span>设备列表</span>
              </Menu.Item>
              <Menu.Item key="/source" hidden={true}>
                <Icon type="link" />
                <span>路由配置</span>
              </Menu.Item>
              <Menu.Item key="/mock/data">
                <Icon type="container" />
                <span>Mock数据</span>
              </Menu.Item>
              <Menu.Item key="/tool">
                <Icon type="tool"></Icon>
                <span>工具箱</span>
              </Menu.Item>
              <Menu.Item key="/project" hidden={!Auth('project')}>
                <Icon type="project" />
                <span>应用管理</span>
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
              {(user || {}).app == undefined ? "未选择应用" : user.app.name}
            </Button>
            <span style={{ float: "right" }}>
              <a style={{ marginRight: 8, color: "orange" }} href="https://github.com/BinaryParadise/CanaryService" target="_blank">帮助</a>

              <Dropdown overlay={(
                <Menu onClick={this.logout}>
                  <Menu.Item key="1">
                    退出
              </Menu.Item>
                </Menu>)}>
                <a className="ant-dropdown-link" onClick={e => e.preventDefault()}>
                  {AuthUser().name}
                  <Avatar style={{ marginRight: 16, marginLeft: 8 }} src={default_handsome}></Avatar>
                </a>
              </Dropdown>
            </span>
          </Header>
          <Content ref={this.saveContainer} style={{ padding: '12px 24px', marginTop: 50, overflow: 'auto' }}>
            {
              user && user.app ? this.props.children :
                <Empty style={{ marginTop: 60 }}>
                  <Button type="primary" onClick={this.switchProject}>选择应用</Button>
                </Empty>
            }
          </Content>
        </Layout >
      </ConfigProvider>
    );
  }
}

export default BasicLayout;
