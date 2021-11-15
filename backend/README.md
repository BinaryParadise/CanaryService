# CanaryBackend

推荐使用`Centos 8`

# CentOS 8

```bash
wget https://swift.org/builds/swift-5.5-release/centos8/swift-5.5-RELEASE/swift-5.5-RELEASE-centos8.tar.gz
tar xzf swift-5.5-RELEASE-centos8.tar.gz
mv swift-5.5-RELEASE-centos8 /opt/swift
```

```bash
# ~/.bash_profile
export PATH=/opt/swift/usr/bin:$PATH
```

## 编译

```bash
swift build --skip-update
```

## [CentOS 8安装Docker](https://www.cnblogs.com/ding2016/p/11592999.html)

```bash
dnf install docker -y
```

```
docker pull swift

docker run -itd --privileged --interactive --tty \
-p 10010:9001 --name swiftfun swift:5.3.3-centos8 /sbin/init

docker start swiftfun
docker exec -it swift /bin/bash
```


## 依赖

`Centos 8 - Swift 5.3.3`

```bash
# dnf install swift-lang
dnf install epel-release -y \
libuuid-devel -y \
openssl-devel -y \
libcurl-devel -y \
libsqlite3x-devel -y
```

## [swift docker](https://swift.org/download/#docker)

## Further Information
For more information on the Perfect project, please visit [perfect.org](http://perfect.org).
