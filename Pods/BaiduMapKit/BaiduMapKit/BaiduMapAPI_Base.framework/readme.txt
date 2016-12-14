



--------------------------------------------------------------------------------------

iOS 地图 SDK v3.1.0是适用于iOS系统移动设备的矢量地图开发包

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
 
 【 新  增 】
   基础地图
 1、开放高清4K地图显示（无需设置）
 2、瓦片图新增异步加载方法：
    新增异步加载类：BMKAsyncTileLayer
 3、新增地图渲染完成回调方法：
    - (void)mapViewDidFinishRendering:(BMKMapView *)mapView;
 4、新增定位显示类型：BMKUserTrackingModeHeading（在普通定位模式的基础上显示方向）
 
   检索功能
 1、新增室内路径规划
    BMKRouteSearch新增发起室内路径规划接口：
    - (BOOL)indoorRoutePlanSearch:(BMKIndoorRoutePlanOption*) indoorRoutePlanOption;
    BMKRouteSearchDelegate新增室内路径规划结果回调：
    - (void)onGetIndoorRouteResult:(BMKRouteSearch*)searcher result:(BMKIndoorRouteResult*)result errorCode:(BMKSearchErrorCode)error;
    新增室内路径规划检索参数类：BMKIndoorRoutePlanOption
    新增室内路径规划检索结果类：BMKIndoorRouteResult
 2、增加新的公共交通线路规划（支持同城和跨城）
    BMKRouteSearch增加新的公共交通线路规划接口：
    - (BOOL)massTransitSearch:(BMKMassTransitRoutePlanOption*)routePlanOption;
    BMKRouteSearchDelegate增加新的公共交通线路规划结果回调：
    - (void)onGetMassTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKMassTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error;
    增加新的公共交通线路规划检索参数类：BMKMassTransitRoutePlanOption
    增加新的公共交通线路规划检索结果类：BMKMassTransitRouteResult
 
   LBS云检索
1、新增云RGC检索功能
    BMKCloudSearch新增发起云RGC检索接口：
    - (BOOL)cloudReverseGeoCodeSearch:(BMKCloudReverseGeoCodeSearchInfo*)searchInfo;
    BMKCloudSearchDelegate新增云RGC检索结果回调：
    - (void)onGetCloudReverseGeoCodeResult:(BMKCloudReverseGeoCodeResult*)cloudRGCResult searchType:(BMKCloudSearchType) type errorCode:(NSInteger) errorCode;
    新增云RGC检索参数类：BMKCloudReverseGeoCodeSearchInfo
    新增云RGC检索结果类：BMKCloudReverseGeoCodeResult
 
 【 优  化 】
 1、优化Marker加载性能：添加Marker和加载大量Marker时，性能大幅提高。
 2、优化地图内存
 
 【 修  复 】
 1、长按地图某区域，OnLongClick会被不停调用的问题
 2、绘制弧线，特殊case提示画弧失败的问题
 3、一次点击事件，点击地图空白处回调和点击覆盖物回调都会调用的问题