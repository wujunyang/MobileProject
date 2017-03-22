//
//  BaiDuMapViewController.m
//  MobileProject
//
//  Created by wujunyang on 16/1/28.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "BaiDuMapViewController.h"

@interface BaiDuMapViewController ()
@property (nonatomic,strong) BMKMapView             * myMapView;
@property (nonatomic,strong) BMKLocationService     * locationService;
@property (nonatomic,strong) BMKRouteSearch         * routesearch;
@property (nonatomic) CLLocationCoordinate2D curCoordinate;
@end

@implementation BaiDuMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=@"百度地图";
    
    //百度地图初始化默认数据
    NSMutableArray *coordinates=[[NSMutableArray alloc]init];
    
    BaiDuCoordinateModel *first=[[BaiDuCoordinateModel alloc]init];
    first.coordinate_comments=@"我是第一个坐标";
    first.coordinate_title=@"第一站";
    first.coordinate_objID=1;
    first.coordinate_latitude=24.496589;
    first.coordinate_longitude=118.188555;
    [coordinates addObject:first];
    
    BaiDuCoordinateModel *second=[[BaiDuCoordinateModel alloc]init];
    second.coordinate_comments=@"我是第二个坐标";
    second.coordinate_title=@"第二站";
    second.coordinate_objID=1;
    second.coordinate_latitude=24.49672;
    second.coordinate_longitude=118.182051;
    [coordinates addObject:second];
    self.coordinates=coordinates;
    
    
    //百度地图初始化
    self.myMapView=[[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    [self.view addSubview:self.myMapView];
    
    self.myMapView.delegate = self;
    //百度定位
    self.locationService.delegate=self;
    self.myMapView.showsUserLocation=YES;
    self.locationService = [[BMKLocationService alloc]init];
    self.routesearch = [[BMKRouteSearch alloc]init];
    
    //增加坐标标注
    [self addPointAnnotation];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.myMapView viewWillAppear];
    self.myMapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.locationService.delegate=self;  //定位
    self.routesearch.delegate=self;  //查找线路的
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.myMapView viewWillDisappear];
    self.myMapView.delegate = nil; // 不用时，置nil
    self.locationService.delegate=nil;
    self.routesearch.delegate=nil;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    if (self.myMapView) {
        self.myMapView = nil;
    }
    if (self.locationService) {
        self.locationService=nil;
    }
    if (self.routesearch) {
        self.routesearch=nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - BMKMapViewDelegate

- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    //NSLog(@"BMKMapView控件初始化完成");
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    //NSLog(@"map view: click blank");
}

- (void)mapview:(BMKMapView *)mapView onDoubleClick:(CLLocationCoordinate2D)coordinate {
    //NSLog(@"map view: double click");
}

#pragma mark BMKGeoCodeSearchDelegate, BMKRouteSearchDelegate

/**
 *  定位用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //当前点位置在虚拟器long会为负数 导致无法导航 真机不会
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.pt=userLocation.location.coordinate;
    
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.pt=self.curCoordinate;
    
    BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    drivingRouteSearchOption.from = start;
    drivingRouteSearchOption.to = end;
    
    //_routesearch记得实例化
    BOOL flag = [_routesearch drivingSearch:drivingRouteSearchOption];
    if(flag)
    {
        [self.locationService stopUserLocationService];
        //NSLog(@"car检索发送成功");
    }
    else
    {
        //NSLog(@"car检索发送失败");
    }
    //当前位置
    //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
}


//进行画线 进行起点 终点 经点处理 用于获起驾车线路
- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:self.myMapView.annotations];
    [self.myMapView removeAnnotations:array];
    array = [NSArray arrayWithArray:self.myMapView.overlays];
    [self.myMapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSUInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                BaiDuRouteAnnotation* item = [[BaiDuRouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                //item.title = @"起点";
                item.type = 0;
                [self.myMapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                BaiDuRouteAnnotation* item = [[BaiDuRouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                //item.title = @"终点";
                item.type = 1;
                [self.myMapView addAnnotation:item]; // 添加起点标注
            }
            planPointCounts += transitStep.pointsCount;
        }
        
        //防止原先的坐标点消失 重新再加载
        [self addPointAnnotation];
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [self.myMapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
    }
}

//百度地图 画线的样式修改
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

#pragma mark 自定义代码

//添加标注 BaiDuRouteAnnotation被重新定义 增加一个type=100
- (void)addPointAnnotation
{
    for (int i=0; i<self.coordinates.count; i++) {
        BaiDuCoordinateModel *model=self.coordinates[i];
        BaiDuRouteAnnotation* pointAnnotation = [[BaiDuRouteAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = model.coordinate_latitude;
        coor.longitude = model.coordinate_longitude;
        pointAnnotation.coordinate = coor;
        
        //通过title来起到传值的作用(与地图再交互)
        pointAnnotation.title=[NSString stringWithFormat:@"%d",i];
        //*自定义的类型 用于区分起点终点跟平常点
        pointAnnotation.type=100;
        
        [self.myMapView addAnnotation:pointAnnotation];
        //显示弹出窗
        [self.myMapView selectAnnotation:pointAnnotation animated:YES];
        
        //第一个设置为地图的中心
        if (i==0) {
            BMKCoordinateRegion region; ////表示范围的结构体
            region.center.latitude  = model.coordinate_latitude;// 中心中
            region.center.longitude = model.coordinate_longitude;
            region.span.latitudeDelta = 0.2;//经度范围（设置为0.1表示显示范围为0.2的纬度范围）
            region.span.longitudeDelta = 0.2;//纬度范围
            
            [self.myMapView setRegion:region];
        }
    }
}


//处理自定义弹出视图
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKAnnotationView *newAnnotationView=nil;
        BaiDuRouteAnnotation *newannotation=(BaiDuRouteAnnotation*)annotation;
        
        switch (newannotation.type) {
            case 0:
            {
                newAnnotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
                if (newAnnotationView == nil) {
                    newAnnotationView = [[BMKAnnotationView alloc]initWithAnnotation:newannotation reuseIdentifier:@"start_node"];
                    newAnnotationView.image =[UIImage imageNamed:@"test_BaiDu_StartPoint"];
                    newAnnotationView.centerOffset = CGPointMake(0, -(newAnnotationView.frame.size.height * 0.5));
                    newAnnotationView.canShowCallout = TRUE;
                }
                newAnnotationView.annotation = newannotation;
            }
                break;
            case 1:
            {
                newAnnotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
                if (newAnnotationView == nil) {
                    newAnnotationView = [[BMKAnnotationView alloc]initWithAnnotation:newannotation reuseIdentifier:@"end_node"];
                    newAnnotationView.image = [UIImage imageNamed:@"test_BaiDu_endPoint"];
                    newAnnotationView.centerOffset = CGPointMake(0, -(newAnnotationView.frame.size.height * 0.5));
                    newAnnotationView.canShowCallout = TRUE;
                }
                newAnnotationView.annotation = newannotation;
            }
                break;
            default:
            {
                //普通点 自定义视图
                newAnnotationView= [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myrenameMark"];
                
                newAnnotationView.image = [UIImage imageNamed:@"test_BaiDu_green"];   //把大头针换成别的图片
                
                int selectIndex=[((BMKPointAnnotation *)annotation).title intValue];
                //获得值
                BaiDuCoordinateModel *model=[self.coordinates objectAtIndex:[((BMKPointAnnotation *)annotation).title intValue]];
                
                
                UIView *popView=[[UIView alloc]initWithFrame:CGRectMake(0, 3, 150, 40)];
                popView.backgroundColor=[UIColor grayColor];  //可以查看视图的范围
                
                
                //自定义显示的内容
                UILabel *driverName = [[UILabel alloc]initWithFrame:CGRectMake(5, 3, 100, 15)];
                driverName.backgroundColor=[UIColor clearColor];
                driverName.text=model.coordinate_title;
                driverName.font = [UIFont systemFontOfSize:12];
                driverName.textColor = [UIColor blackColor];
                driverName.textAlignment = NSTextAlignmentLeft;
                [popView addSubview:driverName];
                
                UILabel *carName = [[UILabel alloc]initWithFrame:CGRectMake(5, 18, 100, 15)];
                carName.backgroundColor=[UIColor clearColor];
                carName.text=model.coordinate_comments;
                carName.font = [UIFont systemFontOfSize:11];
                carName.textColor = [UIColor blackColor];
                carName.textAlignment = NSTextAlignmentLeft;
                [popView addSubview:carName];
                
                UIButton *BtnLocation=[UIButton buttonWithType:UIButtonTypeCustom];
                BtnLocation.frame=CGRectMake(85, 10, 60, 20);
                BtnLocation.tag=selectIndex; //点击事件可以通过这个进行获取当前的坐标点
                [BtnLocation setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                [BtnLocation setTitle:@"到这里" forState:UIControlStateNormal];
                [BtnLocation addTarget:self action:@selector(BtnLocationAction:) forControlEvents:UIControlEventTouchUpInside];
                BtnLocation.userInteractionEnabled=YES;
                [popView addSubview:BtnLocation];
                
                BMKActionPaopaoView *pView = [[BMKActionPaopaoView alloc]initWithCustomView:popView];
                pView.frame = CGRectMake(0, 0, 150, 40);
                ((BMKPinAnnotationView*)newAnnotationView).paopaoView = nil;
                ((BMKPinAnnotationView*)newAnnotationView).paopaoView = pView;
                newAnnotationView.tag=selectIndex+10;
            }
                break;
        }
        
        
        return newAnnotationView;
    }
    return nil;
}

//到这里进行响应
-(void)BtnLocationAction:(UIButton *)sender
{
    //获得当前终点坐标值 开启定位
    [_locationService startUserLocationService];
    self.myMapView.showsUserLocation = NO;//先关闭显示的定位图层
    self.myMapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    self.myMapView.showsUserLocation = YES;//显示定位图层
    
    //获得终点的位置
    BaiDuCoordinateModel *model=[self.coordinates objectAtIndex:sender.tag];
    self.curCoordinate=CLLocationCoordinate2DMake(model.coordinate_latitude,model.coordinate_longitude);
}
@end
