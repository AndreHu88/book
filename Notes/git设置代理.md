# Git设置和取消代理


## 常见场景
我们在访问github或者提交代码到github时，经常会遇到"unable to access ': Failed to connect to github.com port 443: Operation timed out" 的错误

## 配置文件

在git的配置文件中添加代理， 配置文件路径： `~/.gitconfig`

查看Git配置 `git config --list`

编辑配置命令

- `sudo vim ~/.gitconfig` 

- `git config --global --edit`

## 使用钥匙串凭据
`git config --global credential.helper osxkeychain`

## 直接修改代理
直接修改用户主目录下的 `.gitconfig` 文件

执行`vim ~/.gitconfig` 

以下的1080是电脑的代理端口，请根据实际端口填写

##### socks5代理
```
[http]
        proxy = socks5://127.0.0.1:1080
[https]
        proxy = socks5://127.0.0.1:1080
```

##### 普通代理
```
[http]
    proxy = http://127.0.0.1:1080
[https]
    proxy = http://127.0.0.1:1080
```

## 命令设置

##### 设置全局代理
```
//http
git config --global https.proxy http://127.0.0.1:1080

//https
git config --global https.proxy https://127.0.0.1:1080
```

##### 设置Socks5代理
```
//使用socks5代理的 例如ss，ssr 1080是windows下ss的默认代理端口,mac下不同，或者有自定义的，根据自己的改
git config --global http.proxy socks5://127.0.0.1:1080

git config --global https.proxy socks5://127.0.0.1:1080
```

##### 只对github.com使用代理，其他仓库不走代理
```
git config --global http.https://github.com.proxy socks5://127.0.0.1:1080

git config --global https.https://github.com.proxy socks5://127.0.0.1:1080

git config --global http.https://github.com.proxy http://127.0.0.1:1080
```

也可以这么写

`[http "https://github.com"]
        proxy = http://127.0.0.1:1080`

#####  取消github代理
```
git config --global --unset http.https://github.com.proxy

git config --global --unset https.https://github.com.proxy
```

##### 取消全局代理
```
git config --global --unset http.proxy

git config --global --unset https.proxy
```





