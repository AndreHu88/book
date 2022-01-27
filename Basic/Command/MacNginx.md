# Mac Nginx使用

-  安装Nginx
```
brew install nginx
```

- 查看nginx的配置信息

```
brew info nginx
```

-  查看nginx安装目录

```
open /usr/local/etc/nginx/
```

- 启动nginx服务
```
brew services start nginx 
```

- 重启
```
brew services restart nginx
```

- nginx停止
```
ps -ef|grep nginx

kill -QUIT  (从容的停止，即不会立刻停止)
Kill -TERM  （立刻停止）
Kill -INT  （和上面一样，也是立刻停止）
```