## MobileProject介绍![Platform info](http://img.shields.io/cocoapods/p/YTKNetwork.svg?style=flat)

MobileProject项目是一个以MVC模式搭建的开源功能集合，基于Objective-C上面进行编写，意在解决新项目对于常见功能模块的重复开发，MobileProject对于项目的搭建也进行很明确的划分，各个模块职责也比较明确，MobileProject也引入的一些常用第三方插件、宏定义、工具帮助类等；整个项目也是在不断更新跟维护中，功能点也会不断更新；代码支持iOS7以后版本；


## MobileProject模块简介

主项目中的分层主要包含四个模块，Main(主要)、Expand(扩展)、Resource(资源)、Vender(第三方)，还有本项目是有多个Tag,用于区分不同的版本，比如本地环境测试版、产品版，主要是通过Tag来区分，不同的标识对应不同的连接地址；当然也可以设置其它不同的内容；

#### Main(主要)模块的内容

此模块主要目的是为了存放项目的页面内容，比如MVC的内容，Base(基类)用于存放一些公共的内容，其它功能模块的提取，方便继承调用；在本实例中已经在BaseController整理的一个公用的ViewController


####  Expand(扩展)模块的内容

此模块主要包含Const、Macros、Tool、NetWork、Category、DataBase六个子模块；

Macros(宏)主要存放宏定义的地方，这边有两个宏文件，Macros.h主要是项目的一些主要宏，比如字体、版本、色值等，而ThirdMacros.h主要用于存放一些第三放SDK的key值；

Tool(工具类)主要存放一些常用的类，此处Logger用于存放日志的封装帮助类，Reachability用于存放判断网络状态的帮助类；

Network(网络)这边主要用到YTKNetwork 是猿题库 iOS 研发团队基于 AFNetworking 封装的 iOS 网络库，这边是对它进行一些修改，为了满足不同Tag及不同的功能模块可能访问不同URL的要求；

Category(分类)主要用到Git上面iOS-Categories分类的内容，多创建一个Other用于存放平时要扩展的分类；

####  Resource(资源)模块的内容

资源模块主要包含三方面，Global(全局)、Image(图片)、Plist(配置文件)；

Global用于存放项目一些全局的内容，包含启动项的内容LaunchScreen.storyboard、头部引用PrefixHeader.pch、语言包File.strings

Image用于存放图片资源，可以根据功能模块进行再分不同的xcassets文件；

Plist用于存放plist文件，主要是本项目中会创建多个的Tag,而每个Tag都会有自个的plist文件进行管理，所以统一存放方便管理；


####  部分代码介绍

1：定义宏进行区分不同的环境，可以根据要求再增加不同环境

```obj-c
#if PRODUCT  
//产品环境

#else   
//测试环境

#endif
```

2：对应不同的环境API前缀

```obj-c
        //测试环境
        self.develpoerDictionary=@{ACCOUNT_SERVERCENTER_Key:@"http://private-eda65-mock.com/",PICTURE_SERVERCENTER_key:@"图片前缀",BUSINESSLOGIC_SERVERCENTER_key:@"业务逻辑前缀",UPDATEVERSION_SERVERCENTER_key:@"版本升级前缀"};
        //产品环境
        self.productDictionary=@{ACCOUNT_SERVERCENTER_Key:@"http://private-eda66-mock.com/",PICTURE_SERVERCENTER_key:@"图片前缀",BUSINESSLOGIC_SERVERCENTER_key:@"业务逻辑前缀",UPDATEVERSION_SERVERCENTER_key:@"版本升级前缀"};
```

3：网络请求

```obj-c
@interface LogInApi()
{
    NSString *_username;
    NSString *_password;
}
@end

@implementation LogInApi

- (id)initWithUsername:(NSString *)username password:(NSString *)password {
    self = [super init];
    if (self) {
        _username = username;
        _password = password;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"user/login";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

-(SERVERCENTER_TYPE)centerType
{
    return ACCOUNT_SERVERCENTER;
}

- (id)requestArgument {
    return @{
             @"user_name": _username,
             @"user_password": _password
             };
}

@end
```
`可以指定不同的方式，以及请求对应的前缀类型如ACCOUNT_SERVERCENTER`


4: 目前Pod管理的第三方插件

```obj-c
platform :ios, '7.0'
pod 'AFNetworking', '~>2.6.0'
pod 'ReactiveCocoa', '~> 2.5'
pod 'SDWebImage', '~> 3.7.5'
pod 'JSONModel', '~> 1.0.1'
pod 'Masonry','~>0.6.1'
pod 'FMDB/common' , '~>2.5'
pod 'FMDB/SQLCipher', '~>2.5'
pod 'CocoaLumberjack', '~> 2.0.0-rc'
pod 'BaiduMapKit' #百度地图SDK
pod 'UMengAnalytics-NO-IDFA'#友盟统计无IDFA版SDK
pod 'GTSDK'  #个推SDK
pod 'UMengSocial', '~> 4.3'  #友盟社会化分享及第三方登录
pod 'FLEX', '~> 2.0', :configurations => ['Debug']
pod 'ActionSheetPicker-3.0'
pod 'JSPatch'
pod 'XAspect'
pod 'CYLTabBarController'
pod 'LKDBHelper'
pod 'RegexKitLite', '4.0'
pod 'IQKeyboardManager'
pod 'LBXScan','~> 1.1.1'
pod 'MBProgressHUD', '~> 0.9'
pod 'MWPhotoBrowser'
pod 'M13ProgressSuite', '~> 1.2.7'
pod 'WebViewJavascriptBridge', '~> 5.0'
```


#### Vender(第三方)模块的内容

虽然项目中已经用Pod来管理第三方插件，但对于一些可能要进行修改的第三方可以存放在这边，本实例中引用的几个比较常用的第三方插件，简单介绍其中的几个，GVUserDefaults是对UserDefaults的封装，简单就可以用于存取操作；JDStatusBarNotification是在状态栏提示效果的插件；ActionSheetPicker底部弹出如时间选择、选项的插件；QBImagePickerController是照片选择插件，支持多选并可以设置最多选择张数；

## 功能模块的集成

1 集成百度地图(3.0.0版)，目前有百度定位功能（ThirdMacros.h修改相应的key值）

2 集成友盟统计（ThirdMacros.h修改相应的key值）

3 集成CocoaLumberjack日志记录

4 引入第三方inputAccessoryView 解决为一些无输入源的控件添加输入响应。比如按钮、cell、view等

5 集成个推消息推送功能（ThirdMacros.h修改相应的key值），证书也要用你们自个的消息证书；

6 集成友盟分享SDK，并在登录页实现的（QQ,微信，新浪）三种的第三方登录功能（ThirdMacros.h修改相应的key值）

7 集成友盟第三方分享（QQ空间分享,微信朋友圈,新浪微博分享,QQ微博分享,微信好友）

8 增加关于CocoaLumberjack日志记录的展示及查看页面

9 增加百度地图显示页面功能实例，实现在地图上显示几个坐标点，并自定义坐标点的图标跟弹出提示窗内容，实现当前定位并画出行车路线图；

10 增加FLEX，在本地测试版本开启，FLEX是Flipboard官方发布的一组专门用于iOS开发的应用内调试工具，能在模拟器和物理设备上良好运作，而开发者也无需将其连接到LLDB/Xcode或其他远程调试服务器，即可直接查看或修改正在运行的App的每一处状态。

11 增加FCUIID帮助类，用于获取设备标识

12 增加热更新JSPatch插件，并增加相应的帮助类及测试功能（JSPatchViewController）

13 集成启动广告功能模块，如果不要功能可以在AppDelegate里面进行注掉

14 集成CYLTabBarController插件，为项目增加底部4个TabBar菜单

15 引入LKDBHelper并增加创建数据库帮助类，实现实体直接映射到数据库表

16 集成第一次启动的引导页功能模块

17 集成LBXScan插件，实现二维码相关功能模块，包含扫二维码显示结果、从相册读取图片中的二维码结果

18 封装MBProgressHUD扩展类，定义一些常见的提示效果，详见MBProgressHUD+MP类

19 开发关于图片上传，包含选择照片、拍照、浏览大图、获得图片GPS、图片名称、图片拍照时间、上传时对图片进行转正调整、压缩图片、图片展现效果

20 开发关于图片上传带进度效果，并把照片先存入沙盒中，上传成功删除，引入M13ProgressSuite插件显示进度扇形效果，部分用到ReactiveCocoa知识；

21 编写一个以iphone5为效果图的字体适配屏幕，兼容iphone6+效果，如果你的效果图不是iphone5,可以修改相应的宏定义，现在是以iphone5为标准

22 编写一个UITableViewCell倒计时功能,实例因为没有服务端接口，所以时间都以本地时间为准，正式项目时间都要从服务端获取；

23 引入WebViewJavascriptBridge进行H5交互，并对官网实例进行注解

24 增加省市区三级联动的帮助类，可以设置绑定默认值，也可以查看当前的弹出窗状态，并实现其小实例

## 效果图

<img src="https://github.com/wujunyang/MobileProject/blob/master/ObjcUML/1.png" width=250px height=350px></img>
<img src="https://github.com/wujunyang/MobileProject/blob/master/ObjcUML/2.png" width=250px height=350px></img>
<img src="https://github.com/wujunyang/MobileProject/blob/master/ObjcUML/3.png" width=250px height=350px></img>
<img src="https://github.com/wujunyang/MobileProject/blob/master/ObjcUML/4.png" width=250px height=350px></img>
<img src="https://github.com/wujunyang/MobileProject/blob/master/ObjcUML/5.png" width=250px height=350px></img>
<img src="https://github.com/wujunyang/MobileProject/blob/master/ObjcUML/6.png" width=250px height=350px></img>
<img src="https://github.com/wujunyang/MobileProject/blob/master/ObjcUML/7.png" width=250px height=350px></img>
<img src="https://github.com/wujunyang/MobileProject/blob/master/ObjcUML/8.png" width=250px height=350px></img>
<img src="https://github.com/wujunyang/MobileProject/blob/master/ObjcUML/9.png" width=250px height=350px></img>
<img src="https://github.com/wujunyang/MobileProject/blob/master/ObjcUML/10.png" width=250px height=350px></img>
<img src="https://github.com/wujunyang/MobileProject/blob/master/ObjcUML/11.png" width=250px height=350px></img>
<img src="https://github.com/wujunyang/MobileProject/blob/master/ObjcUML/12.png" width=250px height=350px></img>
<img src="https://github.com/wujunyang/MobileProject/blob/master/ObjcUML/13.png" width=250px height=350px></img>
<img src="https://github.com/wujunyang/MobileProject/blob/master/ObjcUML/14.png" width=250px height=350px></img>
<img src="https://github.com/wujunyang/MobileProject/blob/master/ObjcUML/15.png" width=250px height=350px></img>
<img src="https://github.com/wujunyang/MobileProject/blob/master/ObjcUML/16.png" width=250px height=350px></img>


## 联系方式

如果你在使用过程中有什么不明白或者问题可以wujunyang@126.com联系，当然如果你有时间也可以一起维护

##许可

MobileProject 使用 MIT 许可证，详情可见 [LICENSE](LICENSE) 文件。





