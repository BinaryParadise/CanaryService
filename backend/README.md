# CanaryBackend

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

docker run --privileged --interactive --tty \
-p 8443:8443 --name swiftfun swift:5.5.0-centos8 /bin/bash
```

## [Ubuntu 18.04安装Docker](https://segmentfault.com/a/1190000022374119)

## [swift docker](https://swift.org/download/#docker)

## Further Information
For more information on the Perfect project, please visit [perfect.org](http://perfect.org).
