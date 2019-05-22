import './index.less';
import { Layout, Menu } from 'antd';

const { Header, Content, Footer } = Layout;
function BasicLayout(props) {
  return (
    <Layout className="layout">
    <Header>
      <div className="logo" />
      <Menu
        theme="dark"
        mode="horizontal"
        defaultSelectedKeys={['1']}
        style={{ lineHeight: '64px' }}
      >
        <Menu.Item key="1">日志监控</Menu.Item>
      </Menu>
    </Header>
    <Content>
      {props.children}
    </Content>
    <Footer style={{ textAlign: 'center' }}>
      Ant Design ©2019 Created by Ant UED
    </Footer>
  </Layout>
  );
}

export default BasicLayout;
