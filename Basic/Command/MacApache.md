# Mac Apache使用

Mac自带Apache，要使用Apache服务直接进行配置即可

## Apache操作

- 查看版本
```
httpd -v
apachectl -version
```

- 配置文件与网站根目录默认所在位置
```
/etc/apache2/httpd.conf //配置文件
/Library/WebServer/Documents //网站根目录
```

- 基本操作
```
sudo apachectl start // 开启Apache
sudo apachectl stop // 关闭Apache
sudo apachectl restart // 重启Apache
```

## 开启目录访问
修改`/etc/apache2/httpd.conf`,把`Options FollowSymLinks Multiviews`改成`Options Indexes FollowSymLinks Multiviews`

**修改根目录**
```
<Directory />
     AllowOverride none
     Require all granted
     Allow from all
</Directory>
DocumentRoot "/Library/WebServer/Documents"
<Directory "/Library/WebServer/Documents">
    Options Indexes FollowSymLinks Multiviews
    MultiviewsMatch Any
    AllowOverride All
    Require all granted
</Directory>
```

## Apache 403

apache出现403主要有两个原因:
- DocumentRoot目录或以下的文件没有权限，如：把文档目录设成/root/xxx,因为root目前默认没有X权限导致403，或者具体文件没有644 权限,  **目录权限修改说明： R=4 ，W=2 ，X=1 （R表示读，W表示写，X表示执行）rwx 相加就是 7**

- apache配置文件问题，需要修改http.conf文件。

```
#查看目录权限
ll /root
drwxrwx---.  11 root root 4096 Feb 24 02:18 root
#通过以下命令修改
chmod 641 /root 

#查看文件权限
-rw-r----- 
#通过以下命令修改
chmod 644 index.html
-rw-r--r--  
```

