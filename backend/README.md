# CanaryBackend

`CentOS 8.4`

## [安装Swift环境](https://www.yundongfang.com/Yun42406.html)

```bash
# 下载Swift最新软件包
wget https://swift.org/builds/swift-5.4.1-release/centos8/swift-5.4.1-RELEASE/swift-5.4.1-RELEASE-centos8.tar.gz
tar xzf swift-5.4.1-RELEASE-centos8.tar.gz
mv swift-5.4.1-RELEASE-centos8 /opt/swift
```

```bash
# 安装依赖
dnf install epel-release
dnf install swift-lang
dnf install libuuid-devel
dnf install openssl-devel
```

## Further Information
For more information on the Perfect project, please visit [perfect.org](http://perfect.org).
