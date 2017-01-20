//
//  ZGYDragMapVC.m
//  MeiTuanMapDemo
//
//  Created by 张桂源 on 16/9/23.
//  Copyright © 2016年 800best. All rights reserved.
//

#import "ZGYDragMapVC.h"


#import "ZGYAlertView.h"
/**
 引入百度地图所需头文件
 */
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

@interface ZGYDragMapVC ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate>{
    BMKGeoCodeSearch* _geocodesearch;
    UIImageView *_poiView;
    BMKLocationService* _locService;//定位
    
}

@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic,strong)PoiResultListViewController *poiResultVC;
@property (nonatomic,strong)PoiModel *model;
@property (nonatomic,strong)NSMutableDictionary *dataDic;
@property (nonatomic, strong) NSArray *poiResultArray;
@end

@implementation ZGYDragMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavItem];
    self.view.backgroundColor = [UIColor whiteColor];
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    
    //初始化mapView
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 300)];
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    _mapView.zoomLevel = 19.5;
    
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];
    displayParam.isRotateAngleValid = false;//跟随态旋转角度是否生效
    displayParam.isAccuracyCircleShow = false;//精度圈是否显示
    [_mapView updateLocationViewWithParam:displayParam];
    
    
    UIImageView *poiView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"poi"]];
    poiView.frame = CGRectMake(0, 0, 40, 40);
    poiView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 150 - 20);
    [self.mapView addSubview:poiView];
    _poiView = poiView;
    
    UIButton *getLocationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getLocationBtn.frame = CGRectMake(5, _mapView.frame.size.height - 55, 40, 40);
    [getLocationBtn setBackgroundImage:[UIImage imageNamed:@"dingwei"] forState:UIControlStateNormal];
    [getLocationBtn addTarget:self action:@selector(currentAddressMsg:) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:getLocationBtn];
    
    
    PoiResultListViewController *poiResultVC = [[PoiResultListViewController alloc]init];
    [self addChildViewController:poiResultVC];
    __weak ZGYDragMapVC *weakSelf = self;
    [poiResultVC setPoiListBlock:^(PoiModel *model) {
        weakSelf.model = model;
        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){model.lat,model.lon};
        [weakSelf.mapView setCenterCoordinate:pt animated:YES];
    }];

    
    [self initLocation];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    
}
- (void)setNavItem{
    self.title = @"地址定位";
    UIButton* leftBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 32, 30);
    UIBarButtonItem* leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    [leftBtn addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:leftBtnItem];
    
    
    UIButton* rightBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 32, 30);
    UIBarButtonItem* rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    [rightBtn addTarget:self action:@selector(rightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:rightBtnItem];
    
    
}
#pragma mark 设置定位参数
- (void)setLocation
{
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //设置定位精度
    _locService.desiredAccuracy = kCLLocationAccuracyBest;
    CLLocationDistance distance = 10.0;
    _locService.distanceFilter = distance;
    
}
- (void)startLocation{
    
    [_locService startUserLocationService];
}

- (void)leftBtn:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightBtn:(UIButton *)sender{
    if (self.poiResultArray.count == 0) {
        self.zgyDrapMapBlock(self.model);
    }else{
        self.zgyDrapMapBlock(self.poiResultArray[0]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)currentAddressMsg:(UIButton *)sender{
    [self initLocation];
}

- (UIView *)contentView
{
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.frame = CGRectMake(0, 364, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 364);
        [self.view addSubview:_contentView];
    }
    return _contentView;
}


- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    
    static NSString *pinID = @"pinID";
    // 从缓存池取出大头针数据视图
    BMKAnnotationView *customView = [mapView dequeueReusableAnnotationViewWithIdentifier:pinID];
    // 如果取出的为nil , 那么就手动创建大头针视图
    if (customView == nil) {
        customView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinID];
    }
    // 1. 设置大头针图片
    customView.image = [UIImage imageNamed:@"point"];
    // 2. 设置弹框
    customView.canShowCallout = YES;
    
    return customView;
}
/**
 *地图区域改变完成后会调用此接口
 *@param mapview 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"%lf -------  %lf",mapView.centerCoordinate.latitude,mapView.centerCoordinate.longitude);
    [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        _poiView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 150 - 35);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            _poiView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 150 - 20);
        } completion:nil];
        
    }];
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
    pt = (CLLocationCoordinate2D){mapView.centerCoordinate.latitude, mapView.centerCoordinate.longitude};
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送成功");
    }
}

/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < result.poiList.count; i++) {
            BMKPoiInfo* poi = [result.poiList objectAtIndex:i];
            self.model = [[PoiModel alloc]init];
            self.model.name = poi.name;
            self.model.city = poi.city;
            self.model.address = poi.address;
            self.model.lat = poi.pt.latitude;
            self.model.lon = poi.pt.longitude;
            [array addObject:self.model];
        }
        self.poiResultArray = [NSArray arrayWithArray:array];
        self.poiResultVC.resultListArray = [NSArray arrayWithArray:array];
        
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
    } else {
        // 各种情况的判断。。。
    }
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [self.view addSubview:self.mapView];
    PoiResultListViewController *poiResultVC = (PoiResultListViewController *)self.childViewControllers[0];
    self.poiResultVC = poiResultVC;
    [self.contentView addSubview:poiResultVC.view];
    
    
    [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        _poiView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 150 - 35);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            _poiView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 150 - 20);
        } completion:nil];
        
    }];
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
    pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送成功");
    }
    [_mapView updateLocationData:userLocation];
    [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    [_locService stopUserLocationService];
}

/**
 定位失败

 @param error 定位失败后的错误信息   根据错误信息判断失败的原因
 */
- (void)didFailToLocateUserWithError:(NSError *)error{
    //无法获取位置信息
    [[ZGYAlertView alloc]showAlertViewMessage:[NSString stringWithFormat:@"错误代码:%ld",[error code]] Title:@"无法获取位置信息" cancleItem:@"取消" andOtherItem:nil viewController:self onBlock:^(AlertViewBtnIndex index) {
        
    }];
    [_locService stopUserLocationService];
    
}

/**
 判断定位是否可用并且初始化定位信息
 */
- (void)initLocation{
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized
         || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
            //定位功能可用，开始定位
            [self setLocation];
            [self startLocation];
            
        }else if (([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) || ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusRestricted)){
            [[ZGYAlertView alloc]showAlertViewMessage:nil Title:@"请确认打开了定位服务,且允许商户管理系统获取位置" cancleItem:@"去设置" andOtherItem:nil viewController:self onBlock:^(AlertViewBtnIndex index) {
                if (0 == index) {
                    if (![CLLocationManager locationServicesEnabled]) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
                    }else{
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    }
                }
            }];
            
        }
}
/**
 管理百度地图的生命周期
 */
- (void)viewWillAppear:(BOOL)animated{
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _geocodesearch.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _geocodesearch.delegate = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
