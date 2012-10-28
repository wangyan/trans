## 一、简介

1. `Transmission`是一款在`Linux`系统上非常流行的`BT`客户端。
2. `Transmission`一键安装包使用`Linux Shell`语言编写，用于在`Linux`操作系统上一键安装`Transmission`。

## 二、下载地址

1. 方法一：通过Git下载（推荐）

    	git clone git://github.com/wangyan/trans.git
    	cd trans && ./install.sh

2. 方法二：直接下载已打包版本

    	wget http://wangyan.org/download/src/trans-latest.tar.gz
    	tar -zxf trans-*.tar.gz
    	cd trans && ./install.sh

## 三、安装步骤

1. 输入`Transmission`远程登录用户名。
2. 输入`Transmission`远程登录密码。
3. 输入`Transmission`下载目录，默认目录是`/root/Downloads`
4. 按任意键开始安装，可以按+c退出。

## 四、使用说明

1. 输入`/etc/init.d/transmission start`启动
2. 输入`/etc/init.d/transmission stop`停止
3. 输入`/etc/init.d/transmission restart`重启

## 五、扩展资源

> http://www.transmissionbt.com/resources/

例如：[transmisson-remote-gui 图形客户端](http://code.google.com/p/transmisson-remote-gui/)、  [Transdroid 手机android客户端](http://www.transdroid.org/about/)

## 六、注意事项

1. 修改配置文件需要重启
2. `Transmission`配置文件路径是`/usr/local/transmission/etc/settings.json.bak`    
    注意：请不要遗漏了`bak`，请不要直接修改`settings.json`文件。

## 七、联系方式

> 如果安装出错，请将安装目录下的 `log.txt` 文件提交给我处理。   
>   
> Email: [WangYan#188.com](WangYan#188.com) （推荐）  
> Gtalk: [myidwy#gmail.com](myidwy#gmail.com)  
> Q Q群：[138082163](http://qun.qq.com/#jointhegroup/gid/138082163)  
> Twitter：[@wang_yan](https://twitter.com/wang_yan)  
> Home Page: [WangYan Blog](http://wangyan.org/blog)  

