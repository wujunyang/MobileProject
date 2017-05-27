platform :ios, '7.0'

# There are no targets called "MobileProjectDefault" in any Xcode projects
abstract_target 'MobileProjectDefault' do
    pod 'AFNetworking', '~>3.0'
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
    pod 'IQKeyboardManager', '~> 3.3.7'  #兼容IOS7
    pod 'LBXScan','~> 1.1.1'
    pod 'MBProgressHUD', '~> 0.9'
    pod 'MWPhotoBrowser'
    pod 'M13ProgressSuite', '~> 1.2.7'
    pod 'WebViewJavascriptBridge', '~> 5.0'
    pod 'YYText'
    pod 'LazyScroll'
    pod 'ZFPlayer'
    pod 'TZImagePickerController'  #照片选择浏览器
    pod 'UITableView+FDTemplateLayoutCell'
    
    target 'MobileProject_Local' do
        pod 'MLeaksFinder'  #可以把它放在MobileProject_Local的target中 这样就不会影响到产品环境
    end
    
    target 'MobileProject' do
        target 'MobileProjectTests' do
            inherit! :search_paths
            pod 'Kiwi', '~> 2.3.1'
        end
    end
end
