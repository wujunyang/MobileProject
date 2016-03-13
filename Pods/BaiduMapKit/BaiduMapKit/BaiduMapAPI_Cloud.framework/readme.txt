LBS云检索：包括LBS云检索（周边、区域、城市内、详情）；




--------------------------------------------------------------------------------------

iOS 地图 SDK v2.10.0是适用于iOS系统移动设备的矢量地图开发包

--------------------------------------------------------------------------------------

地图SDK功能介绍（全功能开发包）：

地图：提供地图展示和地图操作功能；

POI检索：支持周边检索、区域检索和城市内兴趣点检索；

地理编码：提供经纬度和地址信息相互转化的功能接口；

线路规划：支持公交、驾车、步行三种方式的线路规划；

覆盖物图层：支持在地图上添加覆盖物（标注、几何图形、热力图、地形图图层等），展示更丰富的LBS信息；

定位：获取当前位置信息，并在地图上展示（支持普通、跟随、罗盘三种模式）；

离线地图：使用离线地图可节省用户流量，提供更好的地图展示效果；

调启百度地图：利用SDK接口，直接在本地打开百度地图客户端或WebApp，实现地图功能；

周边雷达：利用周边雷达功能，开发者可在App内低成本、快速实现查找周边使用相同App的用户位置的功能；

LBS云检索：支持查询存储在LBS云内的自有数据；

特色功能：提供短串分享、Place详情检索、热力图等特色功能，帮助开发者搭建功能更加强大的应用；


--------------------------------------------------------------------------------------

注意：百度地图iOS SDK向广大开发者提供了配置更简单的 .framework形式的开发包，请开发者选择此种类型的开发包使用。

自v2.9.0起，百度地图iOS SDK将不再提供 .a形式的开发包。
   
自v2.9.0起，采用分包的形式提供 .framework包，请广大开发者使用时确保各分包的版本保持一致。

其中BaiduMapAPI_Base.framework为基础包，使用SDK任何功能都需导入，其他分包可按需导入。


---------------------------------------------------------------------------------------

【新版提示】
1.自V2.9.0起，将启用新的地图资源服务，旧地图离线包在新版上不可使用；同时官方不再支持地图离线包下载，所以V2.9.0起，去掉“手动离线导入接口”，SDK离线下载接口维持不变。

2.自V2.9.0起，iOS SDK采用分包形式，旧包无法与新包同时混用，请将之前所有旧包(包含bundle资源)并全部替换为新包。
3.自V2.9.0起，iOS SDK使用新的矢量地图样式，地图显示更加清新，和百度地图客户端保持一致。

较之v2.9.1，升级功能：
【 新  增  / 废  弃 】
   基础地图 1、新增3D-Touch的回调 BMKMapView 新增属性: /// 设定地图是否回调force touch事件，默认为NO，仅适用于支持3D Touch的情况，开启后会回调 - mapview:onForceTouch:force:maximumPossibleForce: @property(nonatomic) BOOL forceTouchEnabled; BMKMapViewDelegate 新增: - (void)mapview:(BMKMapView *)mapView onForceTouch:(CLLocationCoordinate2D)coordinate force:(CGFloat)force maximumPossibleForce:(CGFloat)maximumPossibleForce; 2、新增个性化地图模板，支持黑夜模式、清新蓝等风格地图 BMKMapView 新增方法: + (void)customMapStyle:(NSString*) customMapStyleJsonFilePath; 3、新增设置地图边界区域的方法: BMKMapView 新增属性: ///地图预留边界，默认：UIEdgeInsetsZero。设置后，会根据mapPadding调整logo、比例尺、指南针的位置，以及targetScreenPt(BMKMapStatus.targetScreenPt) @property (nonatomic) UIEdgeInsets mapPadding; 4、开放显示21级地图，但不支持卫星图、热力图、交通路况图层的21级地图。 5、BMKMapType新增BMKMapTypeNone类型：不加载百度地图瓦片，显示为空白地图。和瓦片图功能配合使用，减少加载数据 6、新增限制地图的显示范围的方法 BMKMapView 新增属性: @property (nonatomic) BMKCoordinateRegion limitMapRegion; 7、支持自定义百度logo位置，共支持6个位置，使用枚举类型控制显示的位置 BMKMapView 新增属性: @property (nonatomic) BMKLogoPosition logoPosition; 8、新增禁用所有手势功能 BMKMapView 新增属性: @property(nonatomic) BOOL gesturesEnabled; 9、新增获取指南针大小的方法，并支持更换指南针图片 BMKMapView 新增属性、方法: @property (nonatomic, readonly) CGSize compassSize; - (void)setCompassImage:(UIImage *)image; 10、新增获取比例尺大小的方法 BMKMapView 新增属性: /// 比例尺的宽高 @property (nonatomic, readonly) CGSize mapScaleBarSize; 11、增加自定义定位精度圈的填充颜色和边框 BMKLocationViewDisplayParam 新增属性： ///精度圈 填充颜色 @property (nonatomic, strong) UIColor *accuracyCircleFillColor; ///精度圈 边框颜色 @property (nonatomic, strong) UIColor *accuracyCircleStrokeColor; 12、新增获取矩形范围内所有marker点的方法 BMKMapView 新增方法: - (NSArray *)annotationsInCoordinateBounds:(BMKCoordinateBounds) bounds; 13、BMKMapView废弃接口: +(void)willBackGround;//逻辑由地图SDK控制 +(void)didForeGround;//逻辑由地图SDK控制    检索功能 1、新增骑行规划检索 BMKRouteSearch 新增骑行路线检索方法: - (BOOL)ridingSearch:(BMKRidingRoutePlanOption*) ridingRoutePlanOption; BMKRouteSearchDelegate 新增返回骑行检索结果回调: - (void)onGetRidingRouteResult:(BMKRouteSearch*)searcher result:(BMKRidingRouteResult*)result errorCode:(BMKSearchErrorCode)error; 新增类: BMKRidingRoutePlanOption 骑行查询基础信息类 BMKRidingRouteResult 骑行路线结果类 2、新增行政区边界数据检索 新增类: BMKDistrictSearch 行政区域搜索服务类 BMKDistrictSearchDelegate 行政区域搜索结果Delegate BMKDistrictSearchOption 行政区域检索信息类 BMKDistrictResult 行政区域检索结果类 3、新增驾车、公交、骑行、步行路径规划短串分享检索 BMKShareURLSearch 新增获取路线规划短串分享方法: - (BOOL)requestRoutePlanShareURL:(BMKRoutePlanShareURLOption *)routePlanShareUrlSearchOption; BMKShareURLSearchDelegate 新增返回路线规划分享url结果回调: - (void)onGetRoutePlanShareURLResult:(BMKShareURLSearch *)searcher result:(BMKShareURLResult *)result errorCode:(BMKSearchErrorCode)error;    计算工具 支持调起百度地图客户端骑行、步行导航功能（百度地图App 8.8 以上版本支持） BMKNavigation 新增方法: //调起百度地图客户端骑行导航页面 + (BMKOpenErrorCode)openBaiduMapRideNavigation:(BMKNaviPara*)para; //调起百度地图客户端步行导航页面 + (BMKOpenErrorCode)openBaiduMapWalkNavigation:(BMKNaviPara*)para;  【 修  复 】 1、修复只使用检索时，首次鉴权失败（网络问题），再次发起鉴权无效的问题 2、修复使用地图前使用离线地图，首次安装应用地图白屏的问题 3、修复拖拽地图时，点击到标注，会触发didSelectAnnotationView:的回调，不回调regionDidChangeAnimated的问题
 4、修复BMKTransitStep 里的stepType中地铁和公交未做区分的问题