import styles from './index.css';
import React from 'react'

import { Layout, Drawer, Icon, Menu, Avatar } from 'antd';
const { SubMenu } = Menu;
const { Header, Content, Footer } = Layout;

class BasicLayout extends React.Component {
  state = { visible: false };

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

  getContainer = () => {
    console.warn(this.container)
    return this.container;
  }

  saveContainer = container => {
    this.container = container;
  }

  render() {
    return (
      <Layout className={styles.normal}>
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
            defaultSelectedKeys={['1']}
            defaultOpenKeys={['sub1']}
            style={{ width: 256, margin: -24 }}
            mode="inline"
            theme="light"
            inlineCollapsed={this.state.collapsed}
          >
            <Menu.Item key="1">
              <Icon type="hdd" />
              <span>设备列表</span>
            </Menu.Item>
            <Menu.Item key="2">
              <Icon type="setting" />
              <span>环境切换</span>
            </Menu.Item>
            <Menu.Item key="3">
              <Icon type="link" />
              <span>路由配置</span>
            </Menu.Item>
            <Menu.Item key="4">
              <Icon type="appstore" />
              <span>测试包管理</span>
            </Menu.Item>
          </Menu>
        </Drawer>
        <Header className={styles.header} title="水月洞天">
          <Icon type="unordered-list" className={styles.logo} onMouseOver={this.showDrawer} />
          <span className={styles.title}>水月洞天</span>
          <Avatar style={{ float: "right", marginRight: 16, marginTop: 9 }} src="https://oss.aliyuncs.com/aliyun_id_photo_bucket/default_handsome.jpg"></Avatar>
        </Header>
        <Content ref={this.saveContainer} style={{ padding: '12px 24px' }}>
          {this.props.children}
        </Content>
        <Footer style={{ textAlign: 'center' }}>Ant Design ©2020 Created by Ant UED</Footer>
      </Layout>
    );
  }
}

export default BasicLayout;
