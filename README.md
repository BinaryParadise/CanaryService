# 金丝雀

提供前端开发的辅助功能，提升工作效率

主要功能：
- 远程配置
- 日志监控
- 网络日志抓取

## 如何使用

 > 管理员账号: admin 

 > 密码: admin

- [接口文档](SpringBoot)
- [iOS SDK](https://github.com/BinaryParadise/Canary)

## 开发环境搭建

Web和Java服务部署推荐使用nginx

```bash
#下载代码
git clone git@github.com:BinaryParadise/MCFrontendService.git
```

### 搭建Java API服务

```bash
cd MCFrontendService java
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

![image](https://user-images.githubusercontent.com/8289395/58154303-e4b39a80-7ca3-11e9-80ca-b8e0af1b0ec8.png)
