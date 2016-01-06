# MobileProject

一个通用的IOS项目基础，整理的一些项目常用的内容；

![image](https://github.com/wujunyang/MobileProject/blob/master/MobileProject/%E9%A1%B9%E7%9B%AE%E7%9B%AE%E5%BD%95.png)

主项目中的分层主要包含四个模块，Main(主要)、Expand(扩展)、Resource(资源)、Vender(第三方)，还有本项目是有多个Tag,用于区分不同的版本，比如本地环境测试版、产品版，主要是通过Tag来区分，不同的标识对应不同的连接地址；当然也可以设置其它不同的内容；

2.1 Main(主要)模块的内容

此模块主要目的是为了存放项目的页面内容，比如MVC的内容，Base(基类)用于存放一些公共的内容，其它功能模块的提取，方便继承调用；在本实例中已经在BaseController整理的一个公用的ViewController

2.2 Expand(扩展)模块的内容

此模块主要包含Const、Macros、Tool、NetWork、Category、DataBase六个子模块；

2.2.1 Macros(宏)主要存放宏定义的地方，这边有两个宏文件，Macros.h主要是项目的一些主要宏，比如字体、版本、色值等，而ThirdMacros.h主要用于存放一些第三放SDK的key值；

2.2.2 Tool(工具类)主要存放一些常用的类，此处Logger用于存放日志的封装帮助类，Reachability用于存放判断网络状态的帮助类；

2.2.3 Network(网络)这边主要用到YTKNetwork 是猿题库 iOS 研发团队基于 AFNetworking 封装的 iOS 网络库，这边是对它进行一些修改，为了满足不同Tag及不同的功能模块可能访问不同URL的要求；

2.2.4 Category(分类)主要用到Git上面iOS-Categories分类的内容，多创建一个Other用于存放平时要扩展的分类；

2.3 Resource(资源)模块的内容

资源模块主要包含三方面，Global(全局)、Image(图片)、Plist(配置文件)；

2.3.1 Global用于存放项目一些全局的内容，包含启动项的内容LaunchScreen.storyboard、头部引用PrefixHeader.pch、语言包File.strings

2.3.2 Image用于存放图片资源，可以根据功能模块进行再分不同的xcassets文件；

2.3.3 Plist用于存放plist文件，主要是本项目中会创建多个的Tag,而每个Tag都会有自个的plist文件进行管理，所以统一存放方便管理；

2.4 Vender(第三方)模块的内容

虽然项目中已经用Pod来管理第三方插件，但对于一些可能要进行修改的第三方可以存放在这边，本实例中引用的几个比较常用的第三方插件，简单介绍其中的几个，GVUserDefaults是对UserDefaults的封装，简单就可以用于存取操作；JDStatusBarNotification是在状态栏提示效果的插件；ActionSheetPicker底部弹出如时间选择、选项的插件；QBImagePickerController是照片选择插件，支持多选并可以设置最多选择张数；


