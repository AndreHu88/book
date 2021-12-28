# Xcode脚本打包

## Python版

打包并上传IPA包到蒲公英，然后发送邮件通知相关人员

```
import os
import datetime
import subprocess
import requests
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.image import MIMEImage
from email.header import Header

# config the build settings
CONFIGURATION = 'Release'
SDK = "iphoneos"
WORKSPACE = "TargetName.xcworkspace"
TARGET = "TargetName"
SCHEME = "TargetName"
XCARCHIVE_NAME = TARGET + '.xcarchive'

PROJECT_PATH = '~/Desktop/code/TargetName'
EXPORT_DIRECTORY = '~/desktop/ipa/TargetName'
APP_PATH = os.getcwd() + '/build/' + CONFIGURATION + '-iphoneos'
APP_FILE_NAME = APP_PATH + TARGET + '.app'
KEYCHAIN_PATH = '~/Library/Keychains/login.keychain'
KEYCHAIN_PWD = 'password'

EXPORT_APP_STORE_PLIST = 'AppStoreOptions.plist'
EXPORT_ADHOC_PLIST = 'AdhocOptions.plist'
PGYER_UPLOAD_URL = "http://www.pgyer.com/apiv1/app/upload"
DOWNLOAD_BASE_URL = "http://www.pgyer.com"
PGYER_API_KEY = ''
PGYER_USER_KEY = ''
PGYER_APP_KEY = ''
PGYER_APP_ID = ''

# 邮件相关
SENDER_EMAIL = 'xx@xx.com'
RECEIVER_EMAIL = 'xx@xx.com'
SENDER_EMAIL_AUTH_CODE = 'authCode'
SMTP_SERVER = 'SMTP_SERVER'
EMAIL_USER_NAME = 'EMAIL_USER_NAME'
PGYER_DOWN_URL = "https://www.pgyer.com/1Zfu"
RECEIVER_EMAIL_MUTIPLE = ['receiverEmail1', 'receiverEmail2', 
'receiverEmail3', 
'mreceiverEmail4']


# clean项目
def clean_project():
    print('clean project')
    os.system('cd %s; xcodebuild clean' % PROJECT_PATH)
    show_notification('clean成功', '正在运行clean方法')
    return


# build编译
def build_project():

    archive_path = PROJECT_PATH + '/build/' + XCARCHIVE_NAME
    build_commond = 'cd %s; xcodebuild archive -workspace %s -scheme %s -sdk %s -configuration %s' \
                    ' -archivePath %s' \
                    % (PROJECT_PATH, WORKSPACE, SCHEME, SDK, CONFIGURATION, archive_path)
    print(build_commond)
    os.system('xcodebuild -list')
    os.system(build_commond)
    show_notification('正在编译中', '别着急，正在编译')
    print('the path of xcarchive is %s' % archive_path)
    archive_ipa(archive_path)


# 打包
def archive_ipa(archive_path):

    current_date = datetime.datetime.now().strftime("%Y-%m-%d-%H:%M:%S")
    ipa_path = '%s/%s-%s' % (EXPORT_DIRECTORY, SCHEME, current_date)
    print("\nexport ipa path is: " + ipa_path)
    # 如果不存在文件夹，则创建
    if not os.path.isdir(ipa_path):
        os.system('mkdir %s' % ipa_path)
    ipa_export_path = ipa_path + '/'
    # 设置打包类型
    export_option_plist = PROJECT_PATH + "/TargetName/AppDelegate" + EXPORT_ADHOC_PLIST
    print("adhoc export option plist is: " + export_option_plist)
    archive_commmand = 'xcodebuild -exportArchive  -archivePath %s -exportPath %s -exportOptionsPlist %s' \
                       % (archive_path, ipa_export_path, export_option_plist)
    print(archive_commmand)
    show_notification('正在打包中', '别着急，正在打包')
    os.system(archive_commmand)
    ipa_file_name = ipa_export_path + TARGET + '.ipa'
    print("ipa file name is " + ipa_file_name)


    # 删除archive文件
    archive_file_path = PROJECT_PATH + "/build"
    print("build archive file path is " + archive_file_path)
    if os.path.isdir(archive_file_path) :
        os.remove(archive_file_path)
    upload_pgyer(ipa_file_name)


# 解析上传蒲公英的结果
def parser_upload_result(json_result):
    result_code = json_result['code']
    if result_code == 0:
        download_url = DOWNLOAD_BASE_URL + "/" + json_result['data']['appShortcutUrl']
        print('upload success! url is %s' % download_url)
    else:
        print('upload failed! Reason is %s' % json_result['message'])


# 上传到蒲公英
def upload_pgyer(ipa_path):
    ipa_path = os.path.expanduser(ipa_path)
    files = {'file': open(ipa_path, 'rb')}
    headers = {'enctype': 'multipart/form-data'}
    paramater = {'uKey': PGYER_USER_KEY, '_api_key': PGYER_API_KEY}
    r = requests.post(PGYER_UPLOAD_URL, data=paramater, files=files, headers=headers)
    if r.status_code == 200:
        result = r.json()
        parser_upload_result(result)
        print("蒲公英上传成功了")
        show_notification("上传蒲公英","上传成功了")
        send_email()
    else:
        print('上传蒲公英出现了问题，errorcode = %s' % r.status_code)


def send_email() :
    # 设置smtplib所需的参数
    # 下面的发件人，收件人是用于邮件传输的。
    # receiver='XXX@126.com'
    # 收件人为多个收件人
    receiver = ['huyong229@163.com', '229376483@qq.com']
    subject = 'smartOffice 版本更新（此邮件为脚本自动发送）'
    # 通过Header对象编码的文本，包含utf-8编码信息和Base64编码信息。以下中文名测试ok
    # subject = '中文标题'
    # subject=Header(subject, 'utf-8').encode()

    # 构造邮件对象MIMEMultipart对象
    # 下面的主题，发件人，收件人，日期是显示在邮件页面上的。
    msg = MIMEMultipart('mixed')
    msg['Subject'] = subject
    msg['From'] = '%s <%s>' %(SENDER_EMAIL, SENDER_EMAIL)
    # msg['From'] = "系统"
    # msg['To'] = 'XXX@126.com'
    # 收件人为多个收件人,通过join将列表转换为以;为间隔的字符串
    msg['To'] = ";".join(RECEIVER_EMAIL_MUTIPLE)
    msg['Date']= datetime.datetime.now().strftime("%Y-%m-%d %H:%M")

    # 构造文字内容
    text = "Hi All\n\n  APP发布了新版本了! 下载地址是: %s\n " %(PGYER_DOWN_URL)
    text += "\n\n 请重新下载安装"
    text += '\n\n\n\n\n\n\n 如需关闭此邮件提醒，请联系Jack Hu'
    text_plain = MIMEText(text, 'plain', 'utf-8')
    msg.attach(text_plain)

    # 发送邮件
    smtp = smtplib.SMTP()
    smtp.connect('smtp.163.com')
    # 我们用set_debuglevel(1)就可以打印出和SMTP服务器交互的所有信息。
    smtp.set_debuglevel(1)
    smtp.login(EMAIL_USER_NAME, SENDER_EMAIL_AUTH_CODE)
    for email in RECEIVER_EMAIL_MUTIPLE:
        smtp.sendmail(SENDER_EMAIL, email, msg.as_string())
    smtp.quit()


# 获取权限
def allow_keychain():
    os.system("security unlock-keychain -p '%s' %s" % (KEYCHAIN_PWD, KEYCHAIN_PATH))
    return

# Mac弹出系统通知
def show_notification(title, subtitle):
    notification = "osascript -e 'display notification \"%s\" with title \"%s\"'" % (subtitle, title)
    print(notification)
    os.system(notification)


def main():
    print("hello")
    allow_keychain()
    clean_project()
    build_project()


if __name__ == '__main__':
    main()

```


## Shell版

```
#!/bin/sh
export LANG=en_US.UTF-8

# 1.设置配置标识,编译环境(根据需要自行填写 release ｜ debug )
configuration="debug"

# 工程名(根据项目自行填写)
APP_NAME="TargetName"

# TARGET名称（根据项目自行填写）
TARGET_NAME="TargetName"

# ipa前缀（根据项目自行填写）
IPA_NAME="xx"

# 工程根目录#工程源码目录(这里的${WORKSPACE}是jenkins的内置变量表示(jenkins job的路径):/Users/plz/.jenkins/workspace/TestDome/)
# ${WORKSPACE}/TestDome/ 中的TestDome根据你的项目自行修改
CODE_PATH="${WORKSPACE}/${TARGET_NAME}"
echo "-------------- CODE_PATH: ${CODE_PATH}"

# info.plist路径
project_infoplist_path= "${CODE_PATH}/${TARGET_NAME}/Info.plist"

# 取版本号
bundleShortVersion= $(/usr/libexec/PlistBuddy -c "print CFBundleShortVersionString" "${project_infoplist_path}")
# bundleVersion= $(/usr/libexec/PlistBuddy -c "print CFBundleVersion" "${project_infoplist_path}")

echo "------- info plist path : ${project_infoplist_path}"
echo "------- bundleShortVersion : ${bundleShortVersion}"

# 日期
DATE=$(date +%Y%m%d-%H-%M-%S)
# 工程文件路径
ARCHIVE_NAME="${APP_NAME}_${DATE}.xcarchive"
# 存放ipa的文件夹名称（根据自己的喜好自行修改）
IPANAME="${IPA_NAME}_IPA"

# 要上传的ipa文件路径 ${username} 需要换成自己的用户名
ROOT_PATH="/Users/${username}/Desktop/Jenkins"

ARCHIVE_PATH="${ROOT_PATH}/Archive/${ARCHIVE_NAME}"

IPA_PATH="${ROOT_PATH}/Export/${IPANAME}"

echo "-------------- ARCHIVE_PATH: ${ARCHIVE_PATH}"
echo "-------------- IPA_PATH: ${IPA_PATH}"


# 导包方式(这里需要根据需要手动配置:AdHoc/AppStore/Enterprise/Development)
EXPORT_METHOD="AdHoc"

# 导包方式配置文件路径(这里需要手动创建对应的XXXExportOptionsPlist.plist文件，并将文件复制到根目录下[我这里在源项目的根目录下又新建了ExportPlist文件夹专门放ExportPlist文件])
if test "$EXPORT_METHOD" = "AdHoc"; then
    EXPORT_METHOD_PLIST_PATH=${CODE_PATH}/ExportOptions.plist
elif test "$EXPORT_METHOD" = "AppStore"; then
    EXPORT_METHOD_PLIST_PATH=${CODE_PATH}/ExportOptions/AppStoreExportOptios.plist
elif test "$EXPORT_METHOD" = "Enterprise"; then
    EXPORT_METHOD_PLIST_PATH=${CODE_PATH}/ExportOptions/EnterpriseExportOptions.plist
else
    EXPORT_METHOD_PLIST_PATH=${CODE_PATH}/ExportOptions/DevelopmentExportOptions.plist
fi

echo "-------------- EXPORT_METHOD_PLIST_PATH: ${EXPORT_METHOD_PLIST_PATH}"

# 指ipa定输出文件夹,如果有删除后再创建，如果没有就直接创建
if test -d ${IPA_PATH}; then
    "-------------- 删除:IPA Path : ${IPA_PATH}"
    rm -rf ${IPA_PATH}
    mkdir ${IPA_PATH}
    "-------------- 创建:IPA Path : ${IPA_PATH}"
else
    mkdir -pv ${IPA_PATH}
    "-------------- 创建:IPA Path : ${IPA_PATH}"
fi

# 进入工程源码根目录
cd "${CODE_PATH}"

echo "-------------- 安装Pod Code Path: ${CODE_PATH}"
# 执行pod
pod install --verbose --no-repo-update

#mkdir -p build

# 清除工程
echo "-------------- Clean项目 执行Shell: xcodebuild clean -workspace ${APP_NAME}.xcworkspace -scheme ${APP_NAME} -configuration ${configuration}"
xcodebuild clean -workspace ${APP_NAME}.xcworkspace -scheme ${APP_NAME} -configuration ${configuration}

# 将app打包成xcarchive格式文件
echo "-------------- archive项目 执行Shell: xcodebuild archive -workspace ${APP_NAME}.xcworkspace -scheme ${APP_NAME} -configuration ${configuration} -archivePath ${ARCHIVE_PATH}"
xcodebuild archive -workspace ${APP_NAME}.xcworkspace -scheme ${APP_NAME} -configuration ${configuration} -archivePath ${ARCHIVE_PATH}

# 将xcarchive格式文件打包成ipa
echo "-------------- 导出ipa包 执行Shell: xcodebuild -exportArchive -archivePath ${ARCHIVE_PATH} -exportPath "${IPA_PATH}" -exportOptionsPlist ${EXPORT_METHOD_PLIST_PATH} -allowProvisioningUpdates"
xcodebuild -exportArchive -archivePath ${ARCHIVE_PATH} -exportPath "${IPA_PATH}" -exportOptionsPlist ${EXPORT_METHOD_PLIST_PATH} -allowProvisioningUpdates

# 删除工程文件
# echo "+++++++++删除工程文件+++++++++"
# rm -rf $ARCHIVE_PATH

```

### Fastlane工具


### Jenkins自动化工具