# git相关总结

## git命令


#### 基本操作
```
# 初始化本地git仓库（创建新仓库）
git init                                                  

# 配置用户名
git config --global user.name "xxx"    

# 配置邮件                   
git config --global user.email "xxx@xxx.com"  
                                               
# 查看当前版本状态（是否修改）
git status 

# 增加当前子目录下所有更改过的文件至index
git add .

# 提交
git commit -m 'xx' 

# 将当前分支push到远程master分支
git push origin master

# 获取远程分支master并merge到当前分支
git pull origin master 
```

#### 分支操作
```
# 显示本地分支
git branch

# 显示所有分支
git branch -a
```



