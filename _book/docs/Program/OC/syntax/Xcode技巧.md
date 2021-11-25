# Xcode技巧

## 快捷键总结

- 在目录结构中定位文件 `command + shfit + J`   

- 选中自动对齐 `control + i`

- 快速打开文件方法  `command + shift + o`

- 多行光标（使用鼠标）`shift + control + click / ⇧ + ⌃ + click`

- 多行光标（使用键盘）`shift + control + up or down /⇧ + ⌃ + ↑ or ↓`

- 多行光标快速初始化
![](https://cdn-images-1.medium.com/max/2000/1*8G_uBAI7tyIhejpOBqlMLw.gif)

- 返回光标之前所在的位置  `option + command + L / ⌥ + ⌘ + L`

- 跳到某一行 `command + L / ⌘ + L`

- 快速打开偏好设置 `command + , / ⌘ + ,`

- 移动快捷键
    ```
    上移： command + option + [   
    
    下移： command + option + ]
        
    左移： command + [
        
    右移： command + ]
    ```

- 快速重命名变量 `Cmd + Ctrl + E`  

    ![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/4d6da94548d74e51a2b9b6c4a1e96f4d~tplv-k3u1fbpfcp-watermark.awebp)

- 按住`Alt` 选中不同行，可以同时编辑多行
    ![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/704aac5be0e04da491becb32fff0140c~tplv-k3u1fbpfcp-watermark.awebp)

## Xcode配置常用变量

使用`$(xxx)` 这种方式来使用如: `$(SRCROOT)`
| 名称 | 说明 |
| ---- | ---- |
| ~ | 当前帐户的HOME目录 | 
| BUILD_PATH | 基础构建目录 |
| BUILD_DIR | 构建目录 |
| BUILD_ROOT | 构建根目录 |
| PROJECT | 项目名称 |
| PROJECT_NAME | 项目显示名称 |
| PROJECT_DIR | 项目绝对目录 |
| PROJECT_FILE_PATH | 项目文件目录`${PROJECT_DIR}/*.xcodeproj` |
| SOURCE_ROOT | `${PROJECT_DIR}`源码根目录 |
| SRCROOT | `.xcodeproj`所在目录 |
| TARGET_NAME | 目标工程名称 |
| USER | 登陆系统的用户名 |
| CONFIGURATION | 配置类型,”Debug” 或 “Release” |
| CONFIGURATION_BUILD_DIR | 配置构建目录 |

##  系统常用宏说明
| 宏名称 | 说明 |
| ---- | ---- |
| `__FILE__` | 当前文件所在目录 | 
| `__FUNCTION__` | 当前函数名称 |
| `__LINE__` | 当前语句在源文件中的行数 |
| `__TIME__` | 编译时间的字符串，格式为“hh:mm:ss” |
| `__STDC__` | 整数常量1，表示此编译器遵循ISOC标准 |
| `__DATE__` | 编译日期的字符串,格式为“mm dd yyyy” |

## XCode中类模板预定义宏变量
| 宏变量 | 说明 |
| ---- | ---- |
| `___FILENAME___ ` | 文件名,包括扩展名 如 abc.h | 
|` ___FILEBASENAMEASIDENTIFIER___` | 文件名, 不包括扩展名, 如 abc |
|` ___PROJECTNAME___` | 项目名称 |
|` ___USERNAME___` | 用户名称 |
|` ___FULLUSERNAME___` | 用户名全称 |
|` ___ORGANIZATIONNAME___` | 公司名称 |
|` ___DATE___` | 基础构建目录 |
|` ___FILEBASENAMEASIDENTIFIER___` | 日期, 如 21/11/25 |
|` ___TIME___` | 时间, 如 下午2:30 |
|` ___YEAR___` | 四位数的年限 如 2015 |