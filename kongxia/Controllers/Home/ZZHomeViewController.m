//
//  ZZHomeViewController.m
//  zuwome
//
//  Created by angBiu on 16/7/15.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZHomeViewController.h"
#import "ZZHomeTypeViewController.h"
#import "ZZHomeRefreshViewController.h"
#import "ZZHomeNearbyViewController.h"
#import "ZZFilterViewController.h"
#import "ZZCityViewController.h"
#import "LiveCheck01ViewController.h"
#import "ZZSignUpS3ViewController.h"
#import "ZZRentViewController.h"
#import "ZZTabBarViewController.h"
#import "ZZLiveStreamViewController.h"
#import "LiveCheck01ViewController.h"
#import "ZZPerfectPictureViewController.h"
#import "ZZFastChatVC.h"
#import "ZZRealNameListViewController.h"
#import "ZZRentalAgreementVC.h"
#import "ZZUserChuzuViewController.h"
#import "ZZChooseSkillViewController.h"
#import "ZZSkillThemeManageViewController.h"
#import "ZZRegisterRentViewController.h"

#import "ZZHomeTitleLabel.h"
#import "ZZHomeNavigationView.h"
#import "ZZLineView.h"
#import "ZZHomeRefreshView.h"
#import "ZZSecurityButton.h"
#import "ZZSelfIntroduceVC.h"
#import "ZZSendVideoManager.h"
#import "ZZVideoUploadStatusView.h"

#import <UIViewController+NJKFullScreenSupport.h>
#import "UINavigationController+WXSTransition.h"
#import <AMapLocationKit/AMapLocationKit.h>

#import "ZZHomeModel.h"
#import "ZZAFNHelper.h"
#import "ZZActivityUrlNetManager.h"


@interface ZZHomeViewController () <UIScrollViewDelegate,CLLocationManagerDelegate, WBSendVideoManagerObserver>
{
    NSMutableArray                  *_ctlArray;//存放的所有controller
    ZZHomeNavigationView            *_topView;//导航栏view
    
    UIScrollView                    *_bigScrollView;//显示下面的view
    ZZLineView                      *_lineView;//黑色线
    CGFloat                         _lastOffsetX;//偏移量
    CGFloat                         _titleWidth;//每个title的宽
    UIViewController                *_lastViewController;//上次显示的controller
    NSString                        *_cityName;
    NSDictionary                    *_filterDict;//筛选条件
    BOOL                            _isCity;//是否城市过去判断更新
    BOOL                            _firstLoad;
    BOOL                            _fistNoLogin;//刚进APP没有登陆
    BOOL                            _haveGetLocation;//是否已获取定位信息
    
    ZZHomeTitleLabel                *_lastLabel;//上次显示的label
}

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL getLocatio;//防止多次定位
@property (nonatomic, strong) AMapLocationManager *aMapManager;
@property (nonatomic, assign) BOOL haveGetPushGuthority;//是否已经允许推送
@property (nonatomic, strong) ZZHomeRefreshView *refreshView;
@property (nonatomic, assign) BOOL viewDidApper;
@property (nonatomic, strong) ZZSecurityButton *securityBtn;

@property (nonatomic, strong) ZZVideoUploadStatusView *model;
@property (nonatomic, strong) ZZSKModel *sk;//录制的达人视频，临时保存，更新成功后=nil
@property (nonatomic, assign) BOOL isUploading;//是否正在上传达人视频

@property (nonatomic,   weak) ZZHomeNearbyViewController *nearbyViewController;

@end

@implementation ZZHomeViewController

// 单例
+ (id)sharedInstance {
    __strong static id sharedObject = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}

- (void)enterForeground {
    NSLog(@"PY_后台进入前台");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [ZZUtils managerUnread];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_lastViewController == _livestreamCtl) {
        _showLiveStream = YES;
    }
    else {
        _showLiveStream = NO;
    }
    _viewDidApper = YES;
    
    [self getSecurityStatus];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _showLiveStream = NO;
    _viewDidApper = NO;
    [[ZZTabBarViewController sharedInstance] hideBubbleView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    _firstLoad = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [GetSendVideoManager() addObserver:self];

    [self createNavigationViews];
    [self createScrollView];
    [self getLstaFilterValue];
    [self getLocation];
    [self addNotifications];
    
    if ([ZZUserHelper shareInstance].isLogin && [ZZUserHelper shareInstance].firstInstallAPP) {
        [ZZUtils isAllowLocation];
    } else {
        _fistNoLogin = YES;
    }
    
    
    [self loadH5_activeData];
    
}


/**
 加载h5的活动页
 */
- (void)loadH5_activeData {
    
    [ZZActivityUrlNetManager loadH5ActiveWithViewController:self isHaveReceived:NO callBack:^{
        
    }];
    
}

#pragma mark - 通知
- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidLogin)
                                                 name:kMsg_UserLogin
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidLogout)
                                                 name:kMsg_UserDidLogout
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getLocation)
                                                 name:kMsg_UserDidLogout
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNewPublishOrder)
                                                 name:kMsg_NewPublishOrder
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTaskRedPoint)
                                                 name:kMsg_UpdateTaskSnatchCount
                                               object:nil];
}

- (void)userDidLogin {
    if (_fistNoLogin && [ZZUserHelper shareInstance].firstInstallAPP) {
        [ZZUtils isAllowLocation];
    }
    [ZZUserHelper shareInstance].firstInstallAPP = @"firstInstallAPP";
    
    _fistNoLogin = NO;
    [self getLocation];
    [self uploadUserNotificionStatus];
}

- (void)userDidLogout {
    [self labelClick:1];
}

//收到新的派单
- (void)receiveNewPublishOrder {
    dispatch_async(dispatch_get_main_queue(), ^{
        [ZZTabBarViewController sharedInstance].selectedIndex = 0;
        [self labelClick:2];
        [_livestreamCtl receiveNewPublishOrder];
    });
}

- (void)updateTaskRedPoint {
    if (!_viewDidApper || _lastViewController != _livestreamCtl) {
        if ([ZZUserHelper shareInstance].unreadModel.pd_receive != 0) {
            _topView.showRedPoint = YES;
        }
    }
}

#pragma mark - GetLocation
- (void)getLocation {
    if ([ZZUserHelper shareInstance].isLogin && [CLLocationManager locationServicesEnabled]) {
        __block BOOL haveCity = NO;
        if ([ZZUserHelper shareInstance].cityName) {
            haveCity = YES;
            _cityName = [ZZUserHelper shareInstance].cityName;
            [_topView setCityName:_cityName];
        }
        [self getHomeData];
        _haveGetLocation = NO;
        _getLocatio = NO;
        if (!_locationManager) {
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.delegate = self;
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest; //控制定位精度,越高耗电量越大。
            _locationManager.distanceFilter = 100; //控制定位服务移动后更新频率。单位是“米”
        }
        [_locationManager startUpdatingLocation];
    } else {
        _haveGetLocation = NO;
        _cityName = nil;
        [_topView setCityName:@"全国"];
        [self getHomeData];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (_getLocatio) {
        return;
    }
    _getLocatio = YES;
    [[ZZUserHelper shareInstance] updateUserLocationWithLocation:locations[0]];
    [ZZUserHelper shareInstance].location = locations[0];
    [_locationManager stopUpdatingLocation];
    [self reverseGeocodeLocation];
}

//先用系统自带的逆地址解析
- (void)reverseGeocodeLocation {
    __block BOOL haveCity = NO;
    if ([ZZUserHelper shareInstance].cityName) {
        haveCity = YES;
    }
    [ZZUserHelper shareInstance].isAbroad = NO;
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:25.0421840000 longitude:121.5248710000];
    location = [ZZUserHelper shareInstance].location;
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            NSLog(@"locationerror = %@",error);
            [self gaodeReverseGeocodeLocation];
        } else {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSString *cityName = @"";
            if (placemark.locality) {
                cityName = placemark.locality;
            } else if (placemark.administrativeArea) {
                cityName = placemark.administrativeArea;
            }
            if ([self isSpecailProvince:cityName]) {
                cityName = placemark.subLocality;
            }
            if (![placemark.ISOcountryCode isEqualToString:@"CN"]) {
                [ZZUserHelper shareInstance].isAbroad = YES;
                cityName = placemark.country;
            }
            
            if (!isNullString(cityName)) {
                _haveGetLocation = YES;
                if (haveCity && ![cityName isEqualToString:[ZZUserHelper shareInstance].cityName]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIAlertView showWithTitle:nil message:[NSString stringWithFormat:@"定位到当前城市「%@」,是否切换",cityName] cancelButtonTitle:@"取消" otherButtonTitles:@[@"切换"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                              NSLog(@"PY_点击切换城市");
                            _cityName = cityName;
                            _firstLoad = NO;
                            [_topView setCityName:_cityName];
                            haveCity = NO;
                            [[ZZTabBarViewController sharedInstance] showBubbleView:2];
                            [ZZUserHelper shareInstance].cityName = _cityName;
                            [self getHomeData];
                            [_nearbyViewController refresh];

                        }];
                    });
                    
                }
                if (!haveCity) {
                    _cityName = cityName;
                    [_topView setCityName:_cityName];
                    haveCity = NO;
                    [ZZUserHelper shareInstance].cityName = cityName;
                }
            }
        }
        if (!haveCity) {
            [self getHomeData];
        }
    }];
}

//系统的没解析出来用高德的解析
- (void)gaodeReverseGeocodeLocation {
    __block BOOL haveCity = NO;
    if ([ZZUserHelper shareInstance].cityName) {
        haveCity = YES;
    }
    _aMapManager = [[AMapLocationManager alloc] init];
    _aMapManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    [_aMapManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error) {
            NSLog(@"locationerror = %@",error);
        } else {
            NSLog(@"regeocode = %@",regeocode);
            [_aMapManager stopUpdatingLocation];
            
            NSString *cityName = @"";
            if (regeocode.city) {
                cityName = regeocode.city;
            } else if (regeocode.province) {
                cityName = regeocode.province;
            }
            if ([self isSpecailProvince:cityName]) {
                cityName = regeocode.district;
            }
            if (!isNullString(cityName)) {
                _haveGetLocation = YES;
                if (!haveCity || ![cityName isEqualToString:[ZZUserHelper shareInstance].cityName]) {
                    _cityName = cityName;
                    _topView.leftTitleLabel.text = cityName;
                    haveCity = NO;
                }
                
                ZZUserHelper *userHelper = [ZZUserHelper shareInstance];
                userHelper.cityName = cityName;
                userHelper.location = location;
            }
        }
        if (!haveCity) {
            [self getHomeData];
        }
    }];
}

- (BOOL)isSpecailProvince:(NSString *)province {
    NSArray *array = @[@"新疆维吾尔自治区",@"海南省",@"湖北省",@"河南省"];
    if ([array containsObject:province]) {
        return YES;
    }
    return NO;
}

#pragma mark - Data

- (void)getHomeData
{
    if (!_firstLoad) {
        [self updateCityAndFilter];
    } else {
        _firstLoad = NO;
        [self initViews];
    }
}

- (void)getLstaFilterValue
{
    if ([ZZUserHelper shareInstance].lastFilterSexValue) {
        _filterDict = @{@"gender":[ZZUserHelper shareInstance].lastFilterSexValue};
    }
}
//保存最后一次筛选性别
- (void)updateLastFilterValue
{
    NSString *value = [_filterDict objectForKey:@"gender"];
    [ZZUserHelper shareInstance].lastFilterSexValue = value;
}
//是否显示紧急求助
- (void)getSecurityStatus
{
    if ([ZZUserHelper shareInstance].isLogin) {
        [ZZRequest method:@"GET" path:@"/api/user/emergency_help/status" params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (data) {
                if ([[data objectForKey:@"emergency_help_status"] integerValue] == 1) {
                    self.securityBtn.hidden = NO;
                    self.securityBtn.orderId = [data objectForKey:@"order_id"];
                } else {
                    self.securityBtn.hidden = YES;
                }
            }
        }];
    } else {
        self.securityBtn.hidden = YES;
    }
}

#pragma mark - CreateViews

- (void)initViews
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _bigScrollView.scrollsToTop = NO;
    _bigScrollView.delegate = self;
    
    CGFloat contentX = 4 * SCREEN_WIDTH;
    _bigScrollView.contentSize = CGSizeMake(contentX, 0);
    _bigScrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    _bigScrollView.pagingEnabled = YES;
    
    [self initControllers];
    
    // 添加默认控制器
    _lastViewController.view.frame = _bigScrollView.bounds;
    [_bigScrollView addSubview:_lastViewController.view];
    ZZHomeTitleLabel *lable = [_topView.bgView viewWithTag:301];
    lable.textColor = kBlackTextColor;
    [lable setViewScale:1.0];
    _lastLabel = lable;
    _bigScrollView.showsHorizontalScrollIndicator = NO;
}

- (void)createNavigationViews
{   
    __weak typeof(self)weakSelf = self;
    _topView = [[ZZHomeNavigationView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT)];
    _topView.backgroundColor = kYellowColor;
    [_topView setCityName:@"全国"];
    _topView.touchLeft = ^{
        [weakSelf leftBtnClick];
    };
    _topView.touchRight = ^{
        [weakSelf rightBtnClick];
    };
    _topView.selctedIndex = ^(NSInteger index){
        [weakSelf labelClick:index];
    };
    [self.view addSubview:_topView];
    
    if ([ZZUserHelper shareInstance].unreadModel.pd_receive > 0) {
        _topView.showRedPoint = YES;
    } else {
        _topView.showRedPoint = NO;
    }
}

- (void)createScrollView
{
    _bigScrollView = [[UIScrollView alloc] init];
    _bigScrollView.showsVerticalScrollIndicator = NO;
    _bigScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_bigScrollView];
    
    [_bigScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topView.mas_bottom);
        make.left.right.offset(0);
        make.bottom.mas_equalTo(self.view).with.offset(0);

    }];
    
    [self checkPushStatus];
}

#pragma mark - 推送授权状态

//检查推送是否开启
- (void)checkPushStatus
{
    if (![ZZUserHelper shareInstance].firstHomeGuide) {
        return;
    }
    self.haveGetPushGuthority = YES;
    if (_infoView) {
        [self.infoView removeFromSuperview];
    }
    if ([[[UIDevice currentDevice] systemVersion] integerValue] < 8) {
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(type == UIRemoteNotificationTypeNone) {
            [self showNotificationInfoView];
        }
    } else {
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (setting.types == UIUserNotificationTypeNone) {
            [self showNotificationInfoView];
        }
    }
    [self uploadUserNotificionStatus];
}

- (void)showNotificationInfoView
{
    [self.view addSubview:self.infoView];
    self.haveGetPushGuthority = NO;
    [_bigScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topView.mas_bottom).offset(self.infoView.height);
    }];
}

- (void)hideNotificationInfoView
{
    WEAK_SELF();
    [weakSelf.infoView removeFromSuperview];
    weakSelf.haveGetPushGuthority = YES;
    [_bigScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topView.mas_bottom);
    }];
}
//上传用户是否开启了通知
- (void)uploadUserNotificionStatus
{
    if ([ZZUserHelper shareInstance].isLogin) {
        BOOL open = YES;
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (setting.types == UIUserNotificationTypeNone) {
            open = NO;
        }
        NSDictionary *param = @{@"push_config":@{@"open_system_push":[NSNumber numberWithBool:open]}};
        ZZUser *user = [[ZZUser alloc] init];
        [user updateWithParam:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                
            }
        }];
    }
}

#pragma mark - 标签创建和动作管理

- (void)initControllers
{
    WEAK_SELF();
    _ctlArray = [NSMutableArray array];
    
    ZZHomeNearbyViewController *nearCtl = [[ZZHomeNearbyViewController alloc] init];
    nearCtl.type = @"near";
    nearCtl.cityName = _cityName;
    nearCtl.filterDict = _filterDict;
    
    nearCtl.didScroll = ^(CGFloat offset) {
        [weakSelf moveBar:offset];
    };
    nearCtl.didScrollStatus = ^(BOOL isShow) {
        [weakSelf showOrHideBar:isShow];
    };
    nearCtl.callBack = ^{
        [weakSelf manageNextController];
    };
    nearCtl.tapCell = ^(ZZHomeNearbyModel *model,UIImageView *imgView) {
        [weakSelf gotoUserPageWithModel:model.user imgView:imgView];
    };
    [self addChildViewController:nearCtl];
    [_ctlArray addObject:nearCtl];
    _nearbyViewController = nearCtl;
    
    ZZHomeTypeViewController *typeCtl = [[ZZHomeTypeViewController alloc] init];
    typeCtl.type = @"recommend";
    typeCtl.cityName = _cityName;
    typeCtl.filterDict = _filterDict;
    typeCtl.didScroll = ^(CGFloat offset) {
        [weakSelf moveBar:offset];
    };
    typeCtl.didScrollStatus = ^(BOOL isShow) {
        [weakSelf showOrHideBar:isShow];
    };
    typeCtl.callBack = ^{
        [weakSelf manageNextController];
    };
    typeCtl.tapCell = ^(ZZUser *user,UIImageView *imgView) {
        [weakSelf gotoUserPageWithModel:user imgView:imgView];
    };
    typeCtl.gotoRefreshTab = ^{
        [weakSelf labelClick:3];
    };
    typeCtl.showRefreshInfoView = ^{
        [weakSelf.refreshView viewShow];
    };
    typeCtl.touchLivestream = ^{
        [weakSelf labelClick:2];
        [weakSelf.livestreamCtl defaultSelectVideo];
    };
    [typeCtl setTouchRecordVideo:^{
        [weakSelf gotoSelfIntroduceVC];
    }];
    [typeCtl setFastChatBlock:^{
        [weakSelf gotoFastChatVC];
    }];
    [self addChildViewController:typeCtl];
    [_ctlArray addObject:typeCtl];
    
    _livestreamCtl = [[ZZLiveStreamViewController alloc] init];
    [_livestreamCtl setNoFaceBlock:^{
        [weakSelf faceRecognition];
    }];
    [_livestreamCtl setNoRealPictureBlock:^{
        [weakSelf uploadRealPicture];
    }];
    [_livestreamCtl setGenderAbnormalBlock:^{
        // 性别异常，需要验证
        [weakSelf genderAbnormalUpdateClick];
    }];
    [_livestreamCtl setRentStatusNone:^{
        // 没有上架出租信息
        [weakSelf rentStatusNoneClick];
    }];
    [_livestreamCtl setRentStatusInvisible:^{
        // 有上架出租信息，但是出于隐身状态
        [weakSelf rentStatusInvisibleClick];
    }];
    [self addChildViewController:_livestreamCtl];
    [_ctlArray addObject:_livestreamCtl];
    
    [_livestreamCtl receiveNewPublishOrder];
    
    ZZHomeRefreshViewController *rcCtl = [[ZZHomeRefreshViewController alloc] init];
    rcCtl.type = @"new";
    rcCtl.cityName = _cityName;
    rcCtl.filterDict = _filterDict;
    rcCtl.didScroll = ^(CGFloat offset) {
        [weakSelf moveBar:offset];
    };
    rcCtl.didScrollStatus = ^(BOOL isShow) {
        [weakSelf showOrHideBar:isShow];
    };
    rcCtl.callBack = ^{
        [weakSelf manageNextController];
    };
    rcCtl.tapCell = ^(ZZHomeNearbyModel *model,UIImageView *imgView) {
        [weakSelf gotoUserPageWithModel:model.user imgView:imgView];
    };
    rcCtl.touchCancel = ^(NSString *uid) {
        [typeCtl refreshCancel:uid];
        [_refreshView viewHide];
    };
    typeCtl.touchCancel = ^(NSString *uid) {
        [rcCtl refreshCancel:uid];
    };
    [self addChildViewController:rcCtl];
    [_ctlArray addObject:rcCtl];
    
    _lastViewController = _ctlArray[1];
}

/** 标题栏label的点击事件 */
- (void)labelClick:(NSInteger)index
{
    if (index == 2) {
        //点击导航栏闪租
        [MobClick event:Event_click_Nav_shanzu];
    }
    ZZHomeTitleLabel *titlelable = (ZZHomeTitleLabel *)[_topView.bgView viewWithTag:300+index];
    CGFloat offsetX = (titlelable.tag - 300) * _bigScrollView.frame.size.width;
    
    CGFloat offsetY = _bigScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    
    [_bigScrollView setContentOffset:offset animated:YES];
    
    [self managerBar];
    if ([_ctlArray indexOfObject:_lastViewController] == (titlelable.tag - 300)) {
        if ([_lastViewController isKindOfClass:[ZZHomeTypeViewController class]]) {
            ZZHomeTypeViewController *controller = (ZZHomeTypeViewController *)_lastViewController;
            [controller refresh];
//            [self managerBar];
            return;
        }
        if ([_lastViewController isKindOfClass:[ZZHomeNearbyViewController class]]) {
            ZZHomeNearbyViewController *controller = (ZZHomeNearbyViewController *)_lastViewController;
            [controller refresh];
//            [self managerBar];
            return;
        }
        if ([_lastViewController isKindOfClass:[ZZHomeRefreshViewController class]]) {
            ZZHomeRefreshViewController *controller = (ZZHomeRefreshViewController *)_lastViewController;
            [controller refresh];
//            [self managerBar];
            return;
        }
    }
}

- (void)managerBar
{
    [self moveBar:MAXFLOAT];
    [self showOrHideBar:YES];
}

#pragma mark - UIScrollViewDelegate

/** 滚动结束后调用（代码导致） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSUInteger index = scrollView.contentOffset.x / _bigScrollView.frame.size.width;
    if (index == 0 || index == 2) {
        _topView.leftBgView.hidden = YES;
    } else {
        _topView.leftBgView.hidden = NO;
    }
    // 添加控制器
    UIViewController *newController = self.childViewControllers[index];
    if (newController != _lastViewController) {
        _lastViewController = newController;
        if ([self pageToUpdataData]) {
            [self updateControllerData];
        }
    }
    
    _lastLabel.textColor = HEXCOLOR(0x3F3A3A);
    [_topView.bgView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *view = _topView.bgView.subviews[idx];
        if (view.tag == index + 300) {
            ZZHomeTitleLabel *temlabel = [_topView.bgView viewWithTag:(300 + index)];
            temlabel.textColor = kBlackTextColor;
            _lastLabel = temlabel;
        }
    }];
    
    NSString *string = [ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].homeRefreshView];
    _showLiveStream = NO;
    if (index == 2) {
        if ([ZZUserHelper shareInstance].isLogin) {
            [self managerBar];
            _showLiveStream = YES;
            [ZZKeyValueStore saveValue:@"firstHomeTaskHotGuide" key:[ZZStoreKey sharedInstance].firstHomeTaskHotGuide];
            _topView.showRedPoint = NO;
        } else {
            [self gotoLoginView];
            [self labelClick:1];
            return;
        }
    } else if (index == 3 && !string) {
        [self.refreshView viewShow];
    } else {
        self.refreshView.hidden = YES;
    }
    if (newController.view.superview) return;
    
    newController.view.frame = CGRectMake(index*SCREEN_WIDTH, 0, SCREEN_WIDTH, _bigScrollView.frame.size.height);
    [_bigScrollView addSubview:newController.view];
}

/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 取出绝对值 避免最左边往右拉时形变超过1
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
    NSUInteger leftIndex = (int)value;
    NSUInteger rightIndex = leftIndex + 1;
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft = 1 - scaleRight;
    ZZHomeTitleLabel *labelLeft = [_topView.bgView viewWithTag:(300 + leftIndex)];
    [labelLeft setViewScale:scaleLeft];
    ZZHomeTitleLabel *labelRight = [_topView.bgView viewWithTag:(300 + rightIndex)];
    [labelRight setViewScale:scaleRight];
    
    if (scrollView.contentOffset.x > 0 && scrollView.contentOffset.x < scrollView.contentSize.width - SCREEN_WIDTH) {
        CGFloat lineOffsetX = 0;
        if (_lastOffsetX > scrollView.contentOffset.x) {
            lineOffsetX =  10 + (leftIndex + 1)*_titleWidth - scaleLeft*_titleWidth;
        } else {
            lineOffsetX = 10 + leftIndex*_titleWidth + scaleRight*_titleWidth;
        }
        _lineView.frame = CGRectMake(lineOffsetX, _lineView.frame.origin.y, _lineView.frame.size.width, _lineView.frame.size.height);
    }
    if (scrollView.contentOffset.x <= 0) {
        _lineView.frame = CGRectMake(10, _lineView.frame.origin.y, _lineView.frame.size.width, _lineView.frame.size.height);
    }
    _lastOffsetX = scrollView.contentOffset.x;
}

#pragma mark - NavigationBarAndTabbarAnimation

- (void)moveBar:(CGFloat)offset {
    [[ZZTabBarViewController sharedInstance] hideBubbleView];
    //-24和20分别是 _topView 最高点和最低点的y值
    CGFloat y = fmin(fmax(_topView.frame.origin.y + offset, - NAVIGATIONBAR_HEIGHT), 0);
    if (self.haveGetPushGuthority) {
        if (offset>0) {
            _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT);
        } else {
            _topView.frame = CGRectMake(0, y, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT);
        }
    }
    [self moveTabBar:-offset animated:YES];
}

//隐藏或者显示tabbar
- (void)showOrHideBar:(BOOL)isShow {
    if (isShow) {
        [self showTabBar:YES];
    } else {
        [self hideTabBar:YES];
    }
}

#pragma mark - 城市和筛选数据更新

//更新城市获取筛选
- (void)updateCityAndFilter {
    for (UIViewController *ctl in _ctlArray) {
        if ([ctl isKindOfClass:[ZZHomeRefreshViewController class]]) {
            ZZHomeRefreshViewController *controller = (ZZHomeRefreshViewController *)ctl;
            controller.cityName = _cityName;
            controller.filterDict = _filterDict;
            controller.update = YES;
            controller.haveGetLocation = _haveGetLocation;
            continue;
        }
        if ([ctl isKindOfClass:[ZZHomeNearbyViewController class]]) {
            ZZHomeNearbyViewController *controller = (ZZHomeNearbyViewController *)ctl;
            controller.cityName = _cityName;
            controller.filterDict = _filterDict;
            controller.haveGetLocation = _haveGetLocation;
            if (!_isCity) {
                controller.update = YES;
            }
            _isCity = NO;
            continue;
        }
        if ([ctl isKindOfClass:[ZZHomeTypeViewController class]]) {
            ZZHomeTypeViewController *controller = (ZZHomeTypeViewController *)ctl;
            controller.cityName = _cityName;
            controller.filterDict = _filterDict;
            controller.update = YES;
            controller.haveGetLocation = _haveGetLocation;
            continue;
        }
    }
    [self updateControllerData];
}

//更新城市或者筛选数据翻页后更新数据
- (void)updateControllerData
{
    if ([_lastViewController isKindOfClass:[ZZHomeRefreshViewController class]]) {
        ZZHomeRefreshViewController *controller = (ZZHomeRefreshViewController *)_lastViewController;
        [controller updateData];
        return;
    }
    if ([_lastViewController isKindOfClass:[ZZHomeNearbyViewController class]]) {
        ZZHomeNearbyViewController *controller = (ZZHomeNearbyViewController *)_lastViewController;
        [controller updateData];
        return;
    }
    if ([_lastViewController isKindOfClass:[ZZHomeTypeViewController class]]) {
        ZZHomeTypeViewController *controller = (ZZHomeTypeViewController *)_lastViewController;
        [controller updateData];
        return;
    }
}

//滚动过去的页面是否需要刷新
- (BOOL)pageToUpdataData
{
    _topView.leftBtn.userInteractionEnabled = YES;
    if ([_lastViewController isKindOfClass:[ZZHomeRefreshViewController class]]) {
        ZZHomeRefreshViewController *controller = (ZZHomeRefreshViewController *)_lastViewController;
        [self addEventClick:controller.type];
        return controller.update;
    }
    if ([_lastViewController isKindOfClass:[ZZHomeNearbyViewController class]]) {
        _topView.leftBtn.userInteractionEnabled = NO;
        ZZHomeNearbyViewController *controller = (ZZHomeNearbyViewController *)_lastViewController;
        [self addEventClick:controller.type];
        return controller.update;
    }
    if ([_lastViewController isKindOfClass:[ZZHomeTypeViewController class]]) {
        ZZHomeTypeViewController *controller = (ZZHomeTypeViewController *)_lastViewController;
        [self addEventClick:controller.type];
        return controller.update;
    }
    
    return NO;
}

#pragma mark - Navigation

- (void)manageNextController
{
    NSRange range = [[ZZUserHelper shareInstance].loginer.avatar rangeOfString:@"person-flat.png"];
    if ([ZZUserHelper shareInstance].isLogin) {
        if ([ZZUserHelper shareInstance].loginer.faces.count == 0)
        {
            [self gotoLiveCheck];
        } else if (![ZZUserHelper shareInstance].loginer.avatar || range.location != NSNotFound)
        {
            [self gotoUploadPhoto];
        }
    } else {
        [self gotoLoginView];
    }
}

- (void)gotoLiveCheck
{
    NSRange range = [[ZZUserHelper shareInstance].loginer.avatar rangeOfString:@"person-flat.png"];
    
    LiveCheck01ViewController *vc = [[LiveCheck01ViewController alloc] init];
    if (![ZZUserHelper shareInstance].loginer.avatar || range.location != NSNotFound) {
        vc.type = NavigationTypeNoPhotos;
    } else {
        vc.type = NavigationTypeHavePhotos;
    }
    vc.user = [ZZUserHelper shareInstance].loginer;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoUploadPhoto
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    ZZSignUpS3ViewController *vc = [sb instantiateViewControllerWithIdentifier:@"CompleteUserInfo"];
    vc.faces = [NSMutableArray arrayWithArray:[ZZUserHelper shareInstance].loginer.faces];
    vc.user = [ZZUserHelper shareInstance].loginer;
    vc.isPush = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoUserPageWithModel:(ZZUser *)user imgView:(UIImageView *)imgView
{
    ZZRentViewController *controller = [[ZZRentViewController alloc] init];
    controller.isFromHome = YES;
    controller.user = user;
    controller.uid = user.uid;
    [self.navigationController wxs_pushViewController:controller makeTransition:^(WXSTransitionProperty *transition) {
        transition.animationType = WXSTransitionAnimationTypeCustomZoom;
        transition.animationTime = 0.4;
        transition.startView  = imgView;
    }];
}

- (void)gotoSelfIntroduceVC {
    ZZUser *user = [ZZUserHelper shareInstance].loginer;
    
    ZZSelfIntroduceVC *vc = [ZZSelfIntroduceVC new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.isShowTopUploadStatus = YES;
    vc.isUploadAfterCompleted = YES;
    vc.loginer = user;
    if (user.base_video.status == 0) {
        vc.reviewStatus = ZZVideoReviewStatusNoRecord;
    } else if (user.base_video.status == 1) {
        vc.reviewStatus = ZZVideoReviewStatusSuccess;
    } else {
        vc.reviewStatus = ZZVideoReviewStatusFail;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoFastChatVC {
    //TODO:更改闪聊列表
    ZZFastChatVC *vc = [ZZFastChatVC new];
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 自定义事件统计

- (void)addEventClick:(NSString *)event
{
    [MobClick event:[NSString stringWithFormat:@"click_%@_cate",event]];
}

#pragma mark - UIButtonMethod

- (void)leftBtnClick
{
    [MobClick event:Event_click_home_choose_city];
    ZZCityViewController *controller = [[ZZCityViewController alloc] init];
    controller.selectCity = ^(NSString *cityName) {
        if (![_topView.leftTitleLabel.text isEqualToString:cityName]) {
            _cityName = cityName;
            [_topView setCityName:_cityName];
            _isCity = YES;
            [self updateCityAndFilter];
        }
    };
    ZZNavigationController *navCtl = [[ZZNavigationController alloc] initWithRootViewController:controller];
    [self.navigationController presentViewController:navCtl animated:YES completion:nil];
}

- (void)rightBtnClick
{
    ZZFilterViewController *controller = [[ZZFilterViewController alloc] init];
    controller.filter = _filterDict;
    controller.filterDone = ^(NSDictionary *params) {
        _filterDict = params;
        [self updateCityAndFilter];
        [self updateLastFilterValue];
    };
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - WBSendVideoManagerObserver

- (void)videoStartSendingVideoUploadStatus:(ZZVideoUploadStatusView *)model {
    _isUploading = YES;
    _model = model;
}

// 视频发送进度
- (void)videoSendProgress:(NSString *)progress {
    _isUploading = YES;
}

// 视频发送完成
- (void)videoSendSuccessWithVideoId:(ZZSKModel *)sk {
    
    _sk = sk;
    _isUploading = NO;
    
    // 闪租页面的录制达人视频 需要直接更新到User-服务器
    if (_model.isUploadAfterCompleted) {
        
        ZZUser *user = [ZZUserHelper shareInstance].loginer;
        if (_sk) {// 如果达人视频上传成功的话，则保存的时候需要将 sk 整个Model一起上传
            user.base_video.sk = sk;
            user.base_video.status = 1;
        }
        [ZZHUD showWithStatus:@"更新信息"];
        [user updateWithParam:[user toDictionary] next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else {
                [ZZHUD showSuccessWithStatus:@"更新成功"];
                NSError *err;
                ZZUser *user = [[ZZUser alloc] initWithDictionary:data error:&err];
                [[ZZUserHelper shareInstance] saveLoginer:[user toDictionary] postNotif:NO];
                [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UploadCompleted object:nil];
            }
        }];
    }
    _model = nil;
}

// 视频发送失败
- (void)videoSendFailWithError:(NSDictionary *)error {
    _isUploading = NO;
}

#pragma mark - lazyload

- (ZZHomeNotificationInfoView *)infoView
{
    WeakSelf;
    if (!_infoView) {
        _infoView = [[ZZHomeNotificationInfoView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, 40)];
        _infoView.callBack = ^{
            [weakSelf hideNotificationInfoView];
        };
    }
    return _infoView;
}

- (ZZHomeRefreshView *)refreshView
{
    if (!_refreshView) {
        _refreshView = [[ZZHomeRefreshView alloc] init];
        _refreshView.hidden = YES;
        [self.view addSubview:_refreshView];
        
        [_refreshView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(-TABBAR_HEIGHT-10);
            make.height.mas_equalTo(@36);
        }];
    }
    return _refreshView;
}

- (ZZSecurityButton *)securityBtn
{
    if (!_securityBtn) {
        _securityBtn = [[ZZSecurityButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 57 - 15, SCREEN_HEIGHT - TABBAR_HEIGHT - 65 - 15, 57, 65.5)];
        [self.view addSubview:_securityBtn];
    }
    return _securityBtn;
}


// 去人脸识别
- (void)faceRecognition {
    WEAK_SELF();
    [UIAlertController presentAlertControllerWithTitle:@"目前账户安全级别较低，将进行身份识别，否则无法抢单" message:nil doneTitle:@"前往" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
        if (!isCancelled) {
            // 去验证人脸
            [weakSelf gotoVerifyFace:NavigationTypeSnatchOrder];
        }
    }];
}

// 去上传真实头像
- (void)uploadRealPicture {
    WEAK_SELF();
    [UIAlertController presentAlertControllerWithTitle:@"您未上传本人正脸五官清晰照，无法抢单，请前往上传真实头像" message:nil doneTitle:@"前往" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
        if (!isCancelled) {
            // 去上传真实头像
            [weakSelf gotoUploadPicture:NavigationTypeApplyTalent];
        }
    }];
}

// 性别异常更新
- (void)genderAbnormalUpdateClick {
    WEAK_SELF();
    [UIAlertController presentAlertControllerWithTitle:@"身份信息异常，请进行身份验证" message:nil doneTitle:@"前往" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
        if (!isCancelled) {
            ZZRealNameListViewController *controller = [[ZZRealNameListViewController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.user = [ZZUserHelper shareInstance].loginer;
            controller.isRentPerfectInfo = YES;
            [weakSelf.navigationController pushViewController:controller animated:YES];
        }
    }];
}

// 没有出租信息，则去上架
- (void)rentStatusNoneClick {
    [UIAlertController presentAlertControllerWithTitle:@"申请成为达人后将开启抢任务功能，前往发布出租信息。" message:nil doneTitle:@"前往" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
        if (!isCancelled) {
            if (![ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].firstProtocol]) { // 需要先去同意协议
                [self gotoRentalAgreementVC];
            } else {
                [self gotoUserChuZuVC];
            }
        }
    }];
}

// 出租协议
- (void)gotoRentalAgreementVC {
    ZZRentalAgreementVC *vc = [ZZRentalAgreementVC new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

// 出租信息页
- (void)gotoUserChuZuVC {
    [MobClick event:Event_click_me_rent];
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    ZZUserChuzuViewController *controller = [sb instantiateViewControllerWithIdentifier:@"rentStart"];
//    controller.user = [ZZUserHelper shareInstance].loginer;
//    controller.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:controller animated:YES];
    //未出租状态前往申请达人，其余状态进入主题管理
    if ([ZZUserHelper shareInstance].loginer.rent.status == 0) {
        WeakSelf
        ZZRegisterRentViewController *registerRent = [[ZZRegisterRentViewController alloc] init];
        registerRent.type = RentTypeRegister;
        [registerRent setRegisterRentCallback:^(NSDictionary *iDict) {
            ZZChooseSkillViewController *controller = [[ZZChooseSkillViewController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:controller animated:YES];
        }];
        [self.navigationController presentViewController:registerRent animated:YES completion:nil];
    } else {
        ZZSkillThemeManageViewController *controller = [[ZZSkillThemeManageViewController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

// 有出租信息，但是隐身了，则去开启
- (void)rentStatusInvisibleClick {
    WEAK_SELF();
    [UIAlertController presentAlertControllerWithTitle:@"您当前为隐身状态，请前往修改邀约状态" message:nil doneTitle:@"前往" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
        if (!isCancelled) {
            [weakSelf gotoUserChuZuVC];
        }
    }];
}

// 没有人脸，则验证人脸
- (void)gotoVerifyFace:(NavigationType)type {
    LiveCheck01ViewController *vc = [[LiveCheck01ViewController alloc] init];
    vc.user = [ZZUserHelper shareInstance].loginer;
    vc.type = type;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

// 没有头像，则上传真实头像
- (void)gotoUploadPicture:(NavigationType)type {
    ZZPerfectPictureViewController *vc = [ZZPerfectPictureViewController new];
    vc.isFaceVC = NO;
    vc.faces = [ZZUserHelper shareInstance].loginer.faces;
    vc.user = [ZZUserHelper shareInstance].loginer;
    vc.type = type;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
