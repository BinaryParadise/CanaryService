import styles from './index.css';
import React from 'react'

import { Layout, Drawer, Icon } from 'antd';

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
          title="Basic Drawer"
          placement="left"
          closable={false}
          onClose={this.onClose}
          visible={this.state.visible}
          getContainer={false}
          style={{ position: 'absolute' }}
        >
          <p>Some contents...</p>
        </Drawer>
        <Header className={styles.header} title="水月洞天">
          <Icon type="unordered-list" className={styles.logo} onMouseOver={this.showDrawer} />
          <span className={styles.title}>水月洞天</span>
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
