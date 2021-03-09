# 金丝雀

提供前端开发的辅助功能，提升工作效率

主要功能：
- 远程配置
- 日志监控
- 设备信息
- 日志监控
- Mock数据

## 如何使用

 > 管理员账号: admin 

 > 密码: admin

- [接口文档](SpringBoot)

## iOS SDK

> 金丝雀只需要登录一次，登录信息存储在keychain中

```bash
pod 'Canary', :configurations => ['Debug']
```

## 开发环境搭建

Web和Java服务部署推荐使用nginx

### 搭建Java API服务

```bash
cd SpringBoot java
idea .
#点击启动调试即可
```

### nginx

```bash
//配置api代理，可自行修改
location /api {
	proxy_pass http://127.0.0.1:9001/v2;
}
```



### 搭建Web服务

前端页面基于[antd](http://ant-design.gitee.io/)和[umijs](umijs.org/zh/guide/getting-started.html)开发

1、安装依赖

```bash
npm install
```

2、启动服务

```bash
npm start
```

3、打开网页http://127.0.0.1:8081

```bash
#登录后根据提示创建项目，并切换，就可以添加环境配置和监控日志了等等
```



## [预览](http://127.0.0.1:8000)

### 远程配置

![image](https://user-images.githubusercontent.com/8289395/83214277-c4f86180-a196-11ea-8656-39c83808387b.png)
![image](https://user-images.githubusercontent.com/8289395/83214335-eeb18880-a196-11ea-9ea8-9aa82bb35a01.png)
![image](https://user-images.githubusercontent.com/8289395/83214360-fec96800-a196-11ea-8ff8-fbb4ee62787d.png)


![image](https://user-images.githubusercontent.com/8289395/58154303-e4b39a80-7ca3-11e9-80ca-b8e0af1b0ec8.png)

### 日志监控（可监控网络接口调用）&设备信息查看

![image](https://user-images.githubusercontent.com/8289395/83214577-82835480-a197-11ea-8571-9735df093f28.png)
![image](https://user-images.githubusercontent.com/8289395/83214834-2240e280-a198-11ea-94fc-0f0762224dff.png)


### 项目管理

![image](https://user-images.githubusercontent.com/8289395/83214440-2ae4e900-a197-11ea-9385-38eee08af08b.png)

### 用户管理

![image](https://user-images.githubusercontent.com/8289395/83214395-143e9200-a197-11ea-8554-dd841ee05dc8.png)