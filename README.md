# LDAccount

##### 欢迎Star,或者Fork, 联系我: 302934443, [简书](http://www.jianshu.com/u/2846c3d3a974)

### 说明
自己设计, 编写的一个小APP, 用于保护日常使用的各种账号, 密码等信息, 所有的信息加密后, 保存到本地数据库, 并可同步到iCloud, 可在设备间进行共享.
APP功能简单, 界面元素较少, 逻辑简单, 可作为入门级的APP来练习.
这是一个单机的APP, 使用网络的地方, 仅仅是同步数据到iCloud, 在设备间进行共享, 其他不会再使用网络, 可在断网状态下正常使用.

>PS: 此项目已成功上线, 但由于个人开发者账号到期, 已被商店下架, 没有再续费, 大家可以在模拟器,或者真机运行此项目, 查看具体效果.


### 功能
APP的整体功能仅是保存个人的一些信息, 然后辅助各种安全验证, 在本地保存的内容为经过安全加密的密文, 对于账户密码这种敏感信息, 可使用保存提示性的内容来代替密码本身, 或者部分密码内容.
- 保存账户信息
- 安全验证

信息保存, D主要使用了数据库SQLite, 这里你可以学习数据库操作相关的一些方法; 重点和难点是安全验证这部分内容, 此工程提供了手势密码, 数字密码以及TouchID来进行解锁等操作. 这里你可以学习TouchID的使用, 以及自定义数字密码界面, 手势界面, 以及结果验证逻辑. 
除了以上必需的功能, 此项目还使用了iCloud数据同步备份, 及3DTouch快速新增保存新

### 这里你可以学习到以下知识点

- 数据库的增删改查, 以及定制需求封装
- 自定义UITabBarController
- 自定义解锁界面
- 3DTouch的简单应用, 以及跳转到指定页面
- TouchID指纹解锁
- iCloud实现数据共享及备份
- 字符串排序以及对NSObject对象(模型)排序实现逻辑
... 

### 工具类
- [LZTabBarController](https://github.com/LQQZYY/LZTabBarController) : 自定义tabBarController;
- [LZSqliteTool](https://github.com/LQQZYY/LZSqliteTool) : 数据库相关操作的封装工具;
- [LZSortTool](https://github.com/LQQZYY/LZSortTool) : 对字符串或者模型进行排序的工具类; 
- [LZiCloud](https://github.com/LQQZYY/LZiCloudDemo) : iCloud云同步/存储的操作工具类, 里面的 LZiCloudDocument 是操作iCloud的另一种方式, 此方法有个问题, 在设备间同步的时候, 数据的存取会有问题, 所以没有采用;
- LZStringEncode : 针对本项目需求定制的编解码工具类;
- [LZPasswordViewController](https://github.com/LQQZYY/LZPasswordViewController): 模仿系统数字密码界面, 在设置模块下的"设置数字密码"(LZClass)分组内 ;
- LZGestureSecurity : 手势密码绘制类, 在设置模块下的"设置手势密码"分组内 ;

此项目的整体代码量不是很大, 其他的细节可以直接阅读项目代码.

### 一些截图
安全验证界面
<br>
![安全验证界面](http://upload-images.jianshu.io/upload_images/1928848-62ada81ae8ae8b4a.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

分组界面
<br>
![分组界面](http://upload-images.jianshu.io/upload_images/1928848-67466d3ecefa2ad3.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

搜索界面
<br>
![搜索界面](http://upload-images.jianshu.io/upload_images/1928848-904ed99d900e56af.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

设置界面
<br>
![设置界面](http://upload-images.jianshu.io/upload_images/1928848-9b1425bfa3abc531.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

详情界面
<br>
![详情界面](http://upload-images.jianshu.io/upload_images/1928848-73a53b956d392e63.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

手势设置页
<br>
![手势设置页](http://upload-images.jianshu.io/upload_images/1928848-5aba7191de899756.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

数字密码设置页
<br>
![数字密码设置页](http://upload-images.jianshu.io/upload_images/1928848-79b058ba9a3a8f03.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


# 欢迎Star,或者Fork, 联系我: 302934443, [简书](http://www.jianshu.com/u/2846c3d3a974)
# (完)
