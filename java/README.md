# Pepper服务端接口文档

- [获取配置列表](#获取配置列表)
- [获取调试日志](#获取调试日志)
- [获取网络日志](#获取网络日志)
- [WebSocket](#WebSocket)
  - [消息格式](#消息格式)
    - [连接控制](#连接控制)
    - [注册设备](#注册设备)
    - [发送调试日志](#发送调试日志)
    - [发送网络日志](#发送网络日志)
    - [客户端缓存](#客户端缓存)

## baseURL

测试环境：http://127.0.0.1:8082

## 获取配置列表

### URL

**{baseURL}/japi/env/config?appkey=[appkey]&os=[os]**

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

### 获取调试日志

【POST】: **{baseURL}/japi/log/list**

##### 参数列表

| 参数       | 类型   | 说明                                            | 默认值 |
| ---------- | ------ | ----------------------------------------------- | ------ |
| pageSize   | number | 每页数量                                        | -      |
| pageIndex  | number | 页码                                            | -      |
| uid        | string | 用户标识                                        | -      |
| appId      | number | 应用编号                                        | -      |
| deviceId   | string | 设备标识                                        | -      |
| message    | string | 关键字                                          | -      |
| type       | number | 类型：`0、全部 1、调试 2、信息 3、警告 4、错误` | -      |
| appVersion | string | 应用版本号                                      | -      |
| platform   | string | 平台号                                          | -      |
| beginDate  | string | 开始时间                                        | -      |
| endDate    | string | 结束时间                                        | -      |

```JSON
{
    "code": 0,
    "error": null,
    "data": {
        "totalCount": 1,
        "list": [
            {
                "appId": 4,
                "rid": 14375,
                "appKey": null,
                "appVersion": "1.0.0.0",
                "deviceId": "FA6CE78C175E4B4ABE492968828E610B",
                "uid": "100000000",
                "platform": "10000",
                "message": "-[ViewController viewWillAppear:]+41 http://baymax.hangzhoucaimi.com",
                "type": 2,
                "file": "ViewController.m",
                "fileName": "ViewController",
                "line": 41,
                "function": "-[ViewController viewWillAppear:]",
                "timestamp": 1556437730000
            }
        ]
    },
    "ext": null
}
```

### 获取网络日志

【POST】: **{baseURL}/japi/netlog/list**

| 参数       | 类型   | 说明          | 默认值 |
| ---------- | ------ | ------------- | ------ |
| pageSize   | number | 每页数量      | -      |
| pageIndex  | number | 页码          | -      |
| uid        | string | 用户标识      | -      |
| appId      | number | 应用编号      | -      |
| deviceId   | string | 设备标识      | -      |
| message    | string | url筛选关键字 | -      |
| appVersion | string | 应用版本号    | -      |
| platform   | string | 平台号        | -      |
| beginDate  | string | 开始时间      | -      |
| endDate    | string | 结束时间      | -      |

```JSON
{
	"code": 0,
	"error": null,
	"data": {
		"totalCount": 101,
		"list": [{
			"appId": 4,
			"rid": 629,
			"appVersion": null,
			"deviceId": "3C05598422F743DDAAD5572288A70889",
			"uid": "100000000",
			"platform": "10000",
			"url": "https://www.apple.com/v/home/ee/images/logos/dark-iphone_xr_logo_hero__f8r05iokxoi2_small_2x.png",
			"method": "GET",
			"mimeType": "image/png",
			"requestHeader": "{\"User-Agent\":\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 12_1 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) Mobile\\/16B91\",\"Accept\":\"image\\/png,image\\/svg+xml,image\\/*;q=0.8,video\\/*;q=0.8,*\\/*;q=0.5\",\"Accept-Language\":\"en-us\",\"Referer\":\"https:\\/\\/www.apple.com\\/\",\"Accept-Encoding\":\"gzip, deflate\"}",
			"requestBody": null,
			"responseHeader": "{\"x-content-type-options\":\"nosniff\",\"Content-Type\":\"image\\/png\",\"Server\":\"Apache\",\"Last-Modified\":\"Thu, 18 Apr 2019 04:48:17 GMT\",\"Accept-Ranges\":\"bytes\",\"Date\":\"Sat, 27 Apr 2019 06:29:10 GMT\",\"Content-Length\":\"4208\",\"Cache-Control\":\"max-age=2421\",\"Expires\":\"Sat, 27 Apr 2019 07:09:31 GMT\"}",
			"responseBody": "LJtYasnYOk9vRGmcZEOWPRYQSK\r\nmiZ+MvaaDkh1l5jxSiPyjgwPDx8zDplvHTqOvo0I0nZkzDx4At1mwufk38U6bAzz\r\npmjDokPg3NXxhxN3LovsRc5ddfB4pvlAshN/xpixoaTqUXuOX7LjwG97180b5CRn\r\nj9eUcPYnaEgxRjB2hU0cLN25HRCXePX37MKiQlEpKsy+eyVhYSAbHhoY/A8MqxYa\r\nnDtebgAAAABJRU5ErkJggg==",
			"timestamp": 1556348213000,
			"statusCode": 200
		}]
	},
	"ext": null
}
```

## WebSocket

测试环境：`ws://127.0.0.1:8082/fk/[platform]/[deviceid]`

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
	"type": 10,
	"data": {
		"name": "iPhone X",
		"databases": ["PepperExample.db"],
		"deviceId": "3C05598422F743DDAAD5572288A70889",
		"ipAddr": "192.168.18.64",
		"appKey": "com.hangzhoucaimi.baymax",
		"appVersion": "1.0.0",
		"osName": "iOS",
		"osVersion": "12.1",
		"modelName": "iPhone Simulator",
		"profile": [{
			"value": "",
			"key": "userid"
		}, {
			"value": "100000000",
			"key": "uid"
		}, {
			"value": "",
			"key": "pushid"
		}, {
			"value": "",
			"key": "token"
		}]
	}
}
```

#### 发送调试日志

```JSON
{
	"type": 30,
	"data": {
        "deviceId": "3C05598422F743DDAAD5572288A70889",//设备唯一标识
        "platform": "3",//平台号
        "appVersion": "5.3.0.6", //四位版本号
        "uuid": "",//用户唯一标识，可为空
        "fileName": "MCLogger",//文件名
        "message": "日志内容",//日志内容
        "file": "~\/Documents\/Github\/MCLogger\/MCLogger\/Classes\/MCLogger.m",//文件路径
        "timestamp": 1553570264074,//时间（毫秒）
        "function": "+[MCLogger startMonitor:]",//方法
        "line": 51,//代码行
        "threadID": "4195899",//线程Id
        "type": 4, //0.VERBOSE 1.DEBUG 2.INFO 3.WARN 4.ERROR 日志等级
        "tag": null,//标签
        "threadName": "",//线程名称
        "queueLabel": "com.apple.main-thread",//队列名称
	}
}
```

#### 发送网络日志

```JSON
{
	"type": 31,
	"data": {
	    "deviceId": "3C05598422F743DDAAD5572288A70889",//设备唯一标识
        "platform": "3",//平台号
        "appVersion": "5.3.0.6", //四位版本号
        "uuid": "",//用户唯一标识，可为空
		"method": "GET",
		"statusCode": 404,
		"url": "http:\/\/127.0.0.1:8081\/japi\/logs",
		"mimeType", "image/png",
		"requestHeader": "{\n  \"User-Agent\" : \"FoundationDemo\\\/1.0 (iPhone; iOS 12.1; Scale\\\/3.00)\",\n  \"Accept-Language\" : \"zh-Hans-US;q=1, en;q=0.9\"\n}",
		"requestBody": null, //Base64
		"responseHeader": "{\n  \"Access-Control-Allow-Headers\" : \"x-requested-with\",\n  \"X-Application-Context\" : \"application:8081\",\n  \"Content-Type\" : \"application\\\/json;charset=UTF-8\",\n  \"Transfer-Encoding\" : \"Identity\",\n  \"Date\" : \"Tue, 26 Mar 2019 03:31:02 GMT\"\n}",
		"responseBody": null //Base64
	}
}
```

### 客户端缓存

* 通过`客户端缓存类型注册`获得缓存的相关信息，因为从cache中获取可能只有部分信息，在客户端有些key可能还没触发写入
    * 客户端注册所有缓存的key及value的取值约束、描述
    * web端可通过取值描述进行编辑约束，展示每个key和value的描述
* 通过`客户端缓存读取`得到客户端完整的缓存信息
    * 将信息展示在web端
* 通过`客户端缓存写入`将修改后的缓存信息回写到客户端
  * web端提供编辑交互，回写前需要根据缓存值类型做校验，校验可以根据`客户端缓存类型注册`中的信息，或者根据`客户端缓存读取`的信息来判断(但无法知道未还未存到cache中的缓存)

#### 客户端缓存读取

```json
{
	"type": 40,
	"data": {
        "deviceId": "3C05598422F743DDAAD5572288A70889",//设备唯一标识
        "platform": "3",//平台号
        "appVersion": "5.3.0.6", //四位版本号
        "uuid": "",//用户唯一标识，可为空
        "cache": {
            "KeyHelloString": "World",
            "KeyHelloBool": true,
            "KeyHelloNumber": 1,
            "KeyHelloObj": {},
            "KeyHelloArray": [],
        }
    }
}
```



#### 客户端缓存写入

```json
{
	"type": 41,
	"data": {
        "KeyHelloString": "WorldChanged"
    }
}
```



#### 客户端缓存类型注册

> 可选。如果不上传web端会根据写入数据来做数据校验

```json
{
	"type": 42,
	"data": {
        "deviceId": "3C05598422F743DDAAD5572288A70889",//设备唯一标识
        "platform": "3",//平台号
        "appVersion": "5.3.0.6", //四位版本号
        "uuid": "",//用户唯一标识，可为空
        "cache": {
            "KeyHeight": {
				"keyDescription": "",//必填            
                "value"://必填            
                {	
                    //必填 [string|boolean|number|object|array]
	                "valueType": number,
                    //选填 约束值的闭包范围 [numberRange|numberEnum|stringEnum]
                    "numberRange":[
                        {"value":"1","description":"最小的身高值"},
                        {"value":"200","description":"最大的身高值"}
                    ]},
            }，
            "KeyLanguage": {
				"description": "",//必填            
                "value"://必填            
                {	
	                "valueType": number,
                    "numberEnum":[
                        {"value":"0","description":"中文"},
                        {"value":"1","description":"英文"}，
					    {"value":"2","description":"日文"}
                    ]},
				}
            }，
			"KeyStyle": {
				"description": "",//必填            
                "value"://必填            
                {	
	                "valueType": number,
                    "stringEnum":[
                        {"value":"white","description":"白色主题"},
                        {"value":"black","description":"黑色主题"}，
                    ]},
				}
            }，
        }
    }
}
```



## 打包&部署

maven
