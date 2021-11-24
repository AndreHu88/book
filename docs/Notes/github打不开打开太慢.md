# github打不开打开太慢

### 为什么访问速度会很慢

GitHub的CDN域名遭到DNS污染， 最主要的原因是GitHub的分发加速网络的域名遭到DNS污染。

由于GitHub的加速分发CDN域名assets-cdn.github.com遭到DNS污染，导致无法连接使用GitHub的加速分发服务器，才使得访问速度很慢。


### 如何解决DNS污染
一般的DNS问题都可以通过修改Hosts文件来解决，GitHub的CDN域名被污染问题也不例外，同样可以通过修改Hosts文件解决。

将域名解析直接指向IP地址来绕过DNS的解析，以此解决污染问题。

### 查找github的IP地址

1. 先使用工具查询GitHub的DNS的IP  [点击查询IP地址](http://tool.chinaz.com/dns?type=1&host=github.com&ip=)
2. 获取TTL值最小的IP地址

### 修改Hosts文件

修改hosts， 增加github相关的IP映射

hosts文件路径: `/private/etc/hosts`

编辑命令 `sudo vim /private/etc/hosts`

在文件的尾部添加对应的映射

```
140.82.113.3 github.com
192.30.253.118 gist.github.com
185.199.109.153 assets-cdn.github.com
199.232.68.133 raw.githubusercontent.com
199.232.68.133  gist.githubusercontent.com
199.232.68.133 cloud.githubusercontent.com
199.232.68.133 camo.githubusercontent.com
199.232.28.133 avatars0.githubusercontent.com
199.232.28.133 avatars1.githubusercontent.com
199.232.28.133 avatars2.githubusercontent.com
199.232.28.133 avatars3.githubusercontent.com
199.232.28.133 avatars4.githubusercontent.com
199.232.28.133 avatars5.githubusercontent.com
199.232.28.133 avatars6.githubusercontent.com
199.232.28.133 avatars7.githubusercontent.com
199.232.28.133 avatars8.githubusercontent.com
```

### 刷新DNS
域名更换了一个新的 IP 地址，但是使用电脑访问的话并不会立即生效，这个时候只需要强制的刷新一下本地的 DNS 缓存，就可以拿到我们最新设置的 域名-IP 映射关系，进行域名的访问

`sudo killall -HUP mDNSResponder`




