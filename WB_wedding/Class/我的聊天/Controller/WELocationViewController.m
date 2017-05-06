//
//  WELocationViewController.m
//  WB_wedding
//
//  Created by 谢威 on 17/2/14.
//  Copyright © 2017年 龙山科技. All rights reserved.
//

#import "WELocationViewController.h"
#import "WEMyChatTool.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <MapKit/MapKit.h>
#import "WELocationCell.h"
@interface WELocationViewController ()
<BMKMapViewDelegate,
BMKGeoCodeSearchDelegate,

BMKPoiSearchDelegate,
BMKLocationServiceDelegate,
UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic,strong)BMKMapView          *mapView;
@property (nonatomic,strong)BMKGeoCodeSearch    *geocodesearch;
@property (nonatomic,strong)BMKLocationService  *locService;

@property (nonatomic,strong)UITableView         *tableView;
@property (nonatomic,copy)NSString *lng;
@property (nonatomic,copy)NSString *lat;
@property (nonatomic,strong)NSMutableArray      *dataSource;

@end

@implementation WELocationViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _geocodesearch.delegate = self;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _geocodesearch.delegate = nil;
    
}

- (void)dealloc {
    if (_mapView) {
        if (_mapView.superview) {
            [_mapView removeFromSuperview];
        }
        _mapView = nil;
    }

    if (_geocodesearch) {
        _geocodesearch = nil;
    }

    
}


- (void)viewDidLoad {
    [super viewDidLoad];
//     [self configDataSource];
    [self configBMK];
    [self configNavigationBar];
    [self configTableview];
   

}
- (void)configNewData{
    self.dataSource = [NSMutableArray array];
    [WEMyChatTool getHisHerLocationWithID:[KUserDefaults objectForKey:KHisHerID] page:@"1" size:@"100" success:^(NSArray *model) {
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:model];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
    } failed:^(NSString *error) {
        [self showMessage:error toView:self.view];
        [self.tableView.mj_header endRefreshing];
    }];

    NSDictionary *dic = @{
                          @"hisOrherId":[XWUserModel getUserInfoFromlocal].loverId
                          };
    
    [HQBaseNetManager GET:BASEURL(@"/location/getjingwei") parameters:dic completionHandler:^(id responseObj, NSError *error) {
        
        
        _geocodesearch = [[BMKGeoCodeSearch alloc]init];
            double lat = [responseObj[@"data"][@"latitude"] doubleValue];
            double lng = [responseObj[@"data"][@"longitude"] doubleValue];
//        double lat = [@"30"   doubleValue];
//        double lng = [@"111"  doubleValue];
        
        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){lat,lng};
        
        BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeocodeSearchOption.reverseGeoPoint = pt;
        BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
        if(flag)
        {
            NSLog(@"反geo检索发送成功");
        }
        else
        {
            NSLog(@"反geo检索发送失败");
        }

        
        
        
    }];
    
}

// 配置百度地图相关
- (void)configBMK{

    
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0,KScreenWidth,300)];
    self.mapView.delegate = self;
    self.mapView.userTrackingMode = BMKUserTrackingModeNone;//定位跟随模式
    self.mapView.showMapScaleBar = YES;// 比例尺
    self.mapView.rotateEnabled = NO;// 不支持旋转
    self.mapView.mapScaleBarPosition = CGPointMake(10, 0);//比例尺的位置
    [self.mapView setMapType:BMKMapTypeStandard];//地图的样式(标准地图)
    [self.mapView setZoomEnabled:YES];
    [self.mapView setZoomLevel:16.f];//缩放级别，3-25
    self.mapView.showsUserLocation = YES;
    self.mapView.isSelectedAnnotationViewFront = YES;
    [self.view addSubview:self.mapView];


    
    
    
}

- (void)configTableview{
    // table
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 50;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"WELocationCell" bundle:nil] forCellReuseIdentifier:WELocationCellID];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.mapView.mas_bottom).offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];

    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(configNewData)];
    
    
    
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    
    [self.tableView.mj_header beginRefreshing];
    

    
    
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WELocationCell *cell = [tableView dequeueReusableCellWithIdentifier:WELocationCellID];
    NSDictionary *dic = self.dataSource[indexPath.row];
    cell.adress.text = dic[@"location"];
    

    
    NSString*str= [NSString stringWithFormat:@"%@",dic[@"time"]];//时间戳
    
    NSTimeInterval time=[str doubleValue]/1000;
    
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    cell.time.text = currentDateStr;
    
    
    
    return cell;
    
}

//根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"annotationViewID";
    //根据指定标识查找一个可被复用的标注View，一般在delegate中使用，用此函数来代替新申请一个View
    BMKAnnotationView *annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    annotationView.canShowCallout = YES;

    return annotationView;
}


#pragma mark -- 反地理编码
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
  
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.location;
        NSString* titleStr;
        NSString* showmeg;
        titleStr = @"反向地理编码";
        showmeg = [NSString stringWithFormat:@"%@",item.title];
        
      
    }
    
    
}
- (void)configNavigationBar{
    
    self.baseNavigationBar.backgroundColor = [[UIColor colorWithRed:251.0/255 green:114.0/255.0 blue:114/255.0 alpha:1.0]colorWithAlphaComponent:0];
    self.statusView.backgroundColor = [[UIColor colorWithRed:251.0/255 green:114.0/255.0 blue:114/255.0 alpha:1.0]colorWithAlphaComponent:0];
   [self.baseNavigationBar.backBtn setImage:[UIImage imageNamed:@"return48"] forState:UIControlStateNormal];
    [self.view bringSubviewToFront:self.baseNavigationBar];
    [self.view bringSubviewToFront:self.statusView];
    
    UIButton *colseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [colseBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [colseBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [colseBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.baseNavigationBar addSubview:colseBtn];
    [colseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.baseNavigationBar);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(self.baseNavigationBar.mas_right).offset(-20);
    }];
    
    
}

#pragma mark -- 关闭定位
- (void)close{
    
}


@end
