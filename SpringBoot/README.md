# 金丝雀服务端接口文档

- [获取配置列表](#获取配置列表)
- [WebSocket消息](#WebSocket)
    - [连接控制](#连接控制)
    - [注册设备](#注册设备)
    - [发送调试日志](#发送调试日志)
    - [发送网络日志](#发送网络日志)

## baseURL

测试环境：http://127.0.0.1:8082

## 获取配置列表

### URL

**{baseURL}/conf/full?appkey=[appkey]&os=[os]**

### 请求类型

**GET**

### 请求参数

| 参数   | 类型   | 说明               | 默认值 |
| ------ | ------ | ------------------ | ------ |
| appkey | string | 表示应用，固定不变 | -      |
| os     | string | 平台：iOS、Android | -      |

```yaml
# identify
```

**返回结果** `JSON示例`

```json
{
	"code": 0,
	"error": null,
	"data": [{
		"type": 0,
		"name": "测试",
		"items": [{
			"name": "Test-1",
			"type": 0,
			"comment": "一套测试环境（含短链）",
			"subItems": [{
				"name": "Base",
				"value": "http://www.apple.com",
				"comment": "主域名"
			}],
			"default": true
		}]
	}],
	"ext": {
		"comment": "分组"
	}
}
```

### 返回字段说明

##### 环境配置分组

| 参数  | 类型   | 说明                                       | 默认值 |
| ----- | ------ | ------------------------------------------ | ------ |
| 参数  | 类型   | 说明                                       | 默认值 |
| name  | string | 分组名称                                   | -      |
| type  | number | 类型：0、测试 1、开发 2、生产              | 0      |
| items | array  | 环境列表 <a href="#envconfig">查看详情</a> | -      |

##### <span id="envconfig">环境配置</span>

| 参数     | 类型    | 说明                          | 默认值 |
| -------- | ------- | ----------------------------- | ------ |
| name     | string  | 名称                          | -      |
| comment  | string  | 描述                          | -      |
| type     | number  | 类型：0、测试 1、开发 2、生产 | 0      |
| default  | boolean | 是否默认环境                  | false  |
| subItems | array   | [配置子项](#envitem)          | -      |

##### <span id="envitem">配置子项</span>

| 参数    | 类型   | 说明   | 默认值 |
| ------- | ------ | ------ | ------ |
| name    | string | 名称   | -      |
| value   | string | 参数值 | -      |
| comment | string | 描述   | -      |

## WebSocket

测试环境：`ws://127.0.0.1:8082/channel/[platform]/[deviceid]`

`platform`：iOS、Android、Web

### 消息格式

| 参数 | 类型   | 说明                                                         | 默认值 |
| ---- | ------ | ------------------------------------------------------------ | ------ |
| code | int    | 错误代码：0成功，非0失败                                     |        |
| data | object | 数据内容                                                     |        |
| type | int    | 消息类型<br/>[1: 连接控制](#连接控制)<br/>[10: 注册设备](#注册设备)<br/>[20: 数据库查询请求](#数据库查询请求)<br/>[21: 数据查询结果](#数据查询结果)<br/>[30: 发送调试日志](#发送调试日志)<br/>[31: 发送网络日志](#发送网络日志)<br/>[40: 客户端缓存读取](#客户端缓存读取)<br/>[41: 客户端缓存写入](#客户端缓存写入)<br />[42: 客户端缓存类型注册](#客户端缓存类型注册) |        |
| msg  | string | 错误信息                                                     |        |

示例
```JSON
{
	"code": 0,
	"data": {},
	"contextJID": 0,
	"type": 10
}
```

#### 连接控制

```JSON
{
	"code": 0,
	"data": {
    "logger": false,//开启、关闭日志监控
  },
	"type": 1
}
```

#### 注册设备

```JSON
{
    "appKey": "com.binaryparadise.neverland",
    "code": 0,
    "data": [
        {
            "appVersion": "1.0.39",
            "deviceId": "000000-000000-000000-000000-000000",
            "ipAddrs": {
                "ipv4": {
                    "en0": "192.168.50.64",
                    "lo0": "127.0.0.1",
                    "utun2": "10.8.0.188"
                },
                "ipv6": {
                    "en0": "fe80::6a:908:e502:fa7f",
                    "lo0": "fe80::1",
                    "utun1": "fe80::5cc5:ea23:40d5:64ff",
                    "utun0": "fe80::ca78:119a:2289:aef"
                }
            },
            "modelName": "iPhone",
            "name": "iPhone 11",
            "osName": "iOS",
            "osVersion": "13.3",
            "profile": {
                "desc": "未配置"
            },
            "simulator": true
        }
    ],
    "type": 11
}
```

#### 发送调试日志

```JSON
{
	"type": 30,
	"data": {
        "deviceId": "3C05598422F743DDAAD5572288A70889",//设备唯一标识
        "appVersion": "5.3.0.6", //四位版本号
        "fileName": "MCLogger",//文件名
        "message": "日志内容",//日志内容
        "file": "~\/Documents\/Github\/MCLogger\/MCLogger\/Classes\/MCLogger.m",//文件路径
        "timestamp": 1553570264074,//时间（毫秒）
        "function": "+[MCLogger startMonitor:]",//方法
        "line": 51,//代码行
        "threadID": "4195899",//线程Id
        "type": 4, //16、全部 8、调试 4、信息 2、警告 1、错误 日志等级
        "tag": null,//标签
        "threadName": "",//线程名称
        "queueLabel": "com.apple.main-thread",//队列名称
	}
}
```

#### 发送网络日志

```JSON
{
    "code": 0,
    "data": {
        "requestbody": {},
        "flag": 4,
        "method": "GET",
        "responsefields": {},
        "responsebody": {},
        "type": 31
    }
}
```

## 打包&部署

maven
