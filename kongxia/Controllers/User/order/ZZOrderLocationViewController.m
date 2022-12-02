//
//  ZZOrderLocationViewController.m
//  zuwome
//
//  Created by wlsy on 16/1/29.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZOrderLocationViewController.h"
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>
#import <LCActionSheet.h>
#import <CoreLocation/CoreLocation.h>

@interface ZZOrderLocationViewController ()<MKMapViewDelegate>
{
    NSMutableArray *_navapps;
    NSString *_riginAddressString;//用户自身当前的地址
    CLLocationCoordinate2D _currentUserLocation;//用户自身当前的经纬度
    CLLocationCoordinate2D _pt;//目的地的经纬度

}

@property (nonatomic,strong)   UIView *mapViewNav;
//@property (strong, nonatomic) MAMapView *mapView;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UILabel *inviteSiteLab;//邀约地点
@end

@implementation ZZOrderLocationViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (MKMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
        _mapView.mapType = MKMapTypeStandard;
        _mapView.delegate = self;
    }
    
    return _mapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (isNullString(_naviTitle)) {
        self.navigationItem.title = @"邀约地点";
    }
    [self getNavAppsData];
    [self.view addSubview:self.mapView];
    [self locateMap];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(_location.coordinate.latitude, _location.coordinate.longitude);
    annotation.title = _name;
    if (isNullString(_naviTitle)) {
        self.inviteSiteLab.text = [NSString stringWithFormat:@"邀约地点:%@",_name];
    }
    else {
        self.inviteSiteLab.text = [NSString stringWithFormat:@"%@:%@",_naviTitle, _name];
    }

    //加在地图上
    [_mapView addAnnotation:annotation];
    
    CLLocationCoordinate2D center = _location.coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    [self.mapView setRegion:region animated:NO];
    [self setMapNavigation];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self.mapView removeFromSuperview];
    
    [self.view addSubview:mapView];
    [self.view bringSubviewToFront:self.mapViewNav];
}

/**
 判断定位功能是否打开
 */
- (void)locateMap {
    if ([LocationMangers shared].hasLocationService) {
//        [LocationMangers shared] getlo;
//        [[LocationManager shared] getLocationWithSuccess:^(CLLocation *location, CLPlacemark *placemark) {
//            [self configureLocation:location
//                          placeMark:placemark];
//        } failure:^(CLAuthorizationStatus status, NSString *error) {
//            [UIAlertView showWithTitle:@"允许\"定位\"提示" message:@"请在设置中打开定位" cancelButtonTitle:@"取消" otherButtonTitles:@[@"打开定位"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
//                if (buttonIndex ==1 ) {
//                    //打开定位设置
//                    NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                    [[UIApplication sharedApplication] openURL:settingUrl];
//                }
//                
//            }];
//        }];
    }
}

- (void)configureLocation:(CLLocation *)location placeMark:(CLPlacemark *)placemark {
    _currentUserLocation.latitude = location.coordinate.latitude;
    _currentUserLocation.longitude = location.coordinate.longitude;
    _riginAddressString = placemark.addressDictionary[@"Name"];
    if (!_riginAddressString) {
        NSLog(@"无法定位");
    }
}

#pragma mark -  导航UI
/**
 设置地图导航
 */
- (void)setMapNavigation {
    
    _mapViewNav = [[UIView alloc]init];
    [self.view bringSubviewToFront:_mapViewNav];
    _mapViewNav.backgroundColor = HEXCOLOR(0xf5f5f5);
    [self.view addSubview:_mapViewNav];
    [_mapViewNav addSubview: self.inviteSiteLab];
    UIButton *inviteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_mapViewNav addSubview:inviteButton];
    [inviteButton addTarget:self action:@selector(inviteClick:) forControlEvents:UIControlEventTouchUpInside];
    [inviteButton setImage:[UIImage imageNamed:@"icMap"] forState:UIControlStateNormal];
    
    [_mapViewNav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.bottom.offset(0);
        make.height.equalTo(@82);
    }];
    [self.inviteSiteLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_mapViewNav).offset(15);
        make.right.equalTo(inviteButton.mas_left).offset(-15);
        make.top.bottom.equalTo(_mapViewNav);
    }];
    
    [inviteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_mapViewNav.mas_centerY);
        make.width.equalTo(@45);
        make.height.equalTo(@45);
        make.right.offset(-15);
    }];
}

/**
 邀约地点显示lab
 */
- (UILabel *)inviteSiteLab {
    if (!_inviteSiteLab) {
        _inviteSiteLab = [[UILabel alloc]init];
        _inviteSiteLab.textAlignment = NSTextAlignmentLeft;
        _inviteSiteLab.textColor = HEXCOLOR(0x635858);
        _inviteSiteLab.font = [UIFont systemFontOfSize:17];
        _inviteSiteLab.numberOfLines = 2;
    }
    return _inviteSiteLab;
}
#pragma mark - 导航的点击和逻辑判断
//获取导航方式的数据
- (void)getNavAppsData {
    _pt = _location.coordinate;
    _navapps = [NSMutableArray new];
    [_navapps addObject:@"苹果地图"];

    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]])
    {
        [_navapps addObject:@"高德地图"];
    }
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]])
    {
        [_navapps addObject:@"百度地图"];
    }
}
- (void)inviteClick:(UIButton *)sender {
    [self openNativeNavi];
}
- (void)openNativeNavi
{
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:nil cancelButtonTitle:@"取消" clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        if (buttonIndex <= _navapps.count) {
            
            if (buttonIndex == 0) {
                NSLog(@"取消");
            }else {
                if ([_navapps[buttonIndex-1] isEqualToString:@"苹果地图"]) {
                    [self openApple];
                }
                else if ([_navapps[buttonIndex-1] isEqualToString:@"高德地图"]) {
                    [self openGaode];
                }
                else if ([_navapps[buttonIndex-1] isEqualToString:@"百度地图"]) {
                    [self openBaidu];
                }
             
            }
        }
        
    } otherButtonTitleArray:_navapps];
    
    [sheet show];
    
}
-(void)openApple
{
    if (!_riginAddressString&&!_currentUserLocation.latitude&&!_currentUserLocation.longitude) {
        return;
    }
    
    NSMutableDictionary *addressDict = @{}.mutableCopy;
    if (!isNullString(_riginAddressString)) {
        addressDict[(__bridge NSString *) kABPersonAddressStreetKey] = _riginAddressString;
    }

    MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:_currentUserLocation addressDictionary:addressDict.copy]];
    
    NSDictionary *toaddressDict = @{
                                    (__bridge NSString *) kABPersonAddressStreetKey : _name
                                    };
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:_pt addressDictionary:toaddressDict]];
    
    
    [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                   launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
}
-(void)openBaidu
{
    
    
    CLLocationCoordinate2D baidu = _pt;
    NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=name:%@|latlng:%f,%f&mode=driving&coord_type=gcj02",_name, baidu.latitude, baidu.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
baidumap://map/direction?origin={{我的位置}}&destination=%@&mode=driving&src=kongxia&coord_type=gcj02
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

- (void)openGaode
{
    CLLocationCoordinate2D gaode = _location.coordinate;

    NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&slat=%f&slon=%f&sname=我的位置&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=0&t=0",_currentUserLocation.latitude,_currentUserLocation.longitude,gaode.latitude, gaode.longitude,_name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}
- (void)dealloc
{
    [self.mapView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)setNaviTitle:(NSString *)naviTitle {
    _naviTitle = naviTitle;
    self.title = _naviTitle;
}

@end
