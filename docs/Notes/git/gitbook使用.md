# gitbook使用

## 初始化
在使用 `gitbook init` 之后本地会生成两个文件 `README.md` 和 `SUMMARY.md` ，这两个文件都是必须的，一个为介绍，一个为目录结构。

## 插件
`book.json` 文件是Gitbook的配置文件

我们更新了`book.json`文件后需要执行 `gitbook install`安装插件

## 本地预览
当内容书写完毕后，可以在终端中输入如下命令，实现实时预览
```
gitbook serve
gitbook serve ./ {book_name}
```
`gitbook serve` 命令实际会先调用 `gitbook build` 编译书籍，完成后打开 web 服务器，默认监听本地 4000 端口，在浏览器打开 http://localhost:4000 即可浏览电子书。

## 发布到Github Pages

修改书籍发布需要先构建，然后上传到github
```
gitbook build ./ docs   

git add --all

git commit -m "some update"

git push -u origin master
```
