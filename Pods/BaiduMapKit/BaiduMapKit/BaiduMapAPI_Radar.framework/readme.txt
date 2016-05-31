周边雷达：包含位置信息上传和检索周边相同应用的用户位置信息功能；




--------------------------------------------------------------------------------------

iOS 地图 SDK v3.0.0是适用于iOS系统移动设备的矢量地图开发包

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

 【 新版提示 】
 1.自v3.0.0起，iOS SDK全面支持ipv6网格
 
 【 新  增 】
   基础地图
 1、新增室内地图功能
 新增室内地图信息类：BMKBaseIndoorMapInfo
 BMKMapView新增接口:
 /// 设定地图是否显示室内图（包含室内图标注），默认不显示
 @property (nonatomic, assign) BOOL baseIndoorMapEnabled;
 /// 设定室内图标注是否显示，默认YES，仅当显示室内图（baseIndoorMapEnabled为YES）时生效
 @property (nonatomic, assign) BOOL showIndoorMapPoi;
 // 设置室内图楼层
 - (BMKSwitchIndoorFloorError)switchBaseIndoorMapFloor:(NSString*)strFloor withID:(NSString*)strID;
 // 获取当前聚焦的室内图信息
 - (BMKBaseIndoorMapInfo*)getFocusedBaseIndoorMapInfo;
 BMKMapViewDelegate新增接口：
 //地图进入/移出室内图会调用此接口
 - (void)mapview:(BMKMapView *)mapView baseIndoorMapWithIn:(BOOL)flag baseIndoorMapInfo:(BMKBaseIndoorMapInfo *)info;
 2、普通地图与个性化地图切换可以自由切换，BMKMapView新增接口:
 + (void)enableCustomMapStyle:(BOOL) enable;
 3、个性化地图配置json文件出错时，打印log提示
 4、设置mapPadding时可控制地图中心是否跟着移动，BMKMapView新增接口:
 @property (nonatomic) BOOL updateTargetScreenPtWhenMapPaddingChanged;
 5、BMKMapPoi中新增属性：
 ///点标注的uid，可能为空
 @property (nonatomic,strong) NSString* uid;
 
   检索功能
 1、新增室内POI检索
 新增室内POI检索参数信息类：BMKPoiIndoorSearchOption
 新增室内POI搜索结果类：BMKPoiIndoorResult
 新增室内POI信息类：BMKPoiIndoorInfo
 BMKPoiSearch新增接口：
 //poi室内检索
 - (BOOL)poiIndoorSearch:(BMKPoiIndoorSearchOption*)option;
 BMKPoiSearchDelegate新增接口：
 //返回POI室内搜索结果
- (void)onGetPoiIndoorResult:(BMKPoiSearch*)searcher result:(BMKPoiIndoorResult*)poiIndoorResult errorCode:(BMKSearchErrorCode)errorCode;
 2、驾车路线规划结果新增3个属性：打车费用信息、拥堵米数、红路灯个数，BMKDrivingRouteLine新增接口：
 ///路线红绿灯个数
 @property (nonatomic, assign) NSInteger lightNum;
 ///路线拥堵米数，发起请求时需设置参数 drivingRequestTrafficType = BMK_DRIVING_REQUEST_TRAFFICE_TYPE_PATH_AND_TRAFFICE 才有值
 @property (nonatomic, assign) NSInteger congestionMetres;
 ///路线预估打车费(元)，负数表示无打车费信息
 @property (nonatomic, assign) NSInteger taxiFares;
 3、busline检索新增参考票价和上下线行信息，BMKBusLineResult新增接口：
 ///公交线路方向
 @property (nonatomic, strong) NSString* busLineDirection;
 ///起步票价
 @property (nonatomic, assign) CGFloat basicPrice;
 ///全程票价
 @property (nonatomic, assign) CGFloat totalPrice;
 4、poi检索结果新增是否有全景信息，BMKPoiInfo新增接口：
 @property (nonatomic, assign) BOOL panoFlag;
 
   计算工具
 新增调起百度地图客户端全景功能
 新增调起百度地图全景类：BMKOpenPanorama
 新增调起百度地图全景参数类：BMKOpenPanoramaOption
 新增调起百度地图全景delegate：BMKOpenPanoramaDelegate
 
 【 修  复 】
 1、修复反复添加移除离线瓦片图时偶现的crash问题
 2、修复上传AppStore时提示访问私有api:-setOverlayGeometryDelegate:的问题
 3、修复地图网络解析时偶现的crash问题