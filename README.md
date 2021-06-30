# 金丝雀

研发工具平台，旨在提示开发测试效率。

> [反馈和建议](https://github.com/BinaryParadise/CanaryService/issues)

主要功能：
- 远程配置
- 日志监控
- 设备信息
- Mock数据

## Web

> umijs、nodejs

```bash

管理员账号: admin（默认）
密码: admin（默认）
```

## API

> [Perfect（Swift）](backend/)

## iOS SDK

> 金丝雀只需要登录一次，登录信息存储在keychain中

```bash
pod 'Canary', :configurations => ['Debug']
```

[接入指南](iOS/README.md)

## 功能点预览

### 远程配置

![image](https://user-images.githubusercontent.com/8289395/83214277-c4f86180-a196-11ea-8656-39c83808387b.png)
![image](https://user-images.githubusercontent.com/8289395/83214335-eeb18880-a196-11ea-9ea8-9aa82bb35a01.png)
![image](https://user-images.githubusercontent.com/8289395/83214360-fec96800-a196-11ea-8ff8-fbb4ee62787d.png)


![image](https://user-images.githubusercontent.com/8289395/58154303-e4b39a80-7ca3-11e9-80ca-b8e0af1b0ec8.png)

### 设备信息查看

![image](https://user-images.githubusercontent.com/8289395/110730418-60a51b00-825b-11eb-85ea-a3892120bdd6.png)


### 日志监控（含接口调用）

- 点击接口请求的日志可以查看接口**全部数据**
- 支持生成分享链接，例如：http://127.0.0.1:8081/log/snapshot/42c5b9b93a98477ebd7c67c8fd6b7d25

![image](https://user-images.githubusercontent.com/8289395/83214834-2240e280-a198-11ea-94fc-0f0762224dff.png)

![image](https://user-images.githubusercontent.com/8289395/110731294-02793780-825d-11eb-8d7e-0830680816ca.png)

### Mock数据

![image](https://user-images.githubusercontent.com/8289395/110731405-39e7e400-825d-11eb-8c86-3edef36f1ce6.png)

![image](https://user-images.githubusercontent.com/8289395/110731469-5421c200-825d-11eb-8a61-4ea715946d80.png)


### 应用管理

![image](https://user-images.githubusercontent.com/8289395/110728599-55042500-8258-11eb-86b1-dc128cf7b5c1.png)

### 用户管理

![image](https://user-images.githubusercontent.com/8289395/110728414-00f94080-8258-11eb-9cbe-b98b618228d9.png)
