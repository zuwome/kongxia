//
//  ZZUserChuzuViewController.m
//  zuwome
//
//  Created by angBiu on 16/6/7.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZUserChuzuViewController.h"
#import "ZZAgeEditTableViewController.h"
#import "ZZUserEditViewController.h"
#import "ZZUserSkillChooseViewController.h"
#import "ZZChuZuPrivateChatCell.h"

#import "ZZSelectView.h"
#import "ZZRentTopicAddCell.h"
#import "ZZRentRangeTableViewCell.h"
#import "ZZRentInfoCell.h"
#import "ZZRentTimeCell.h"
#import "ZZRentBaseTableViewCell.h"
#import "ZHPickView.h"
#import "ZZChuzuApplyShareView.h"
#import "ZZHeadImageView.h"
#import "ZZLevelImgView.h"
#import "ZZPrivateChatPayManager.h"
#import <CoreLocation/CoreLocation.h>


#import "ZZServiceChargeVC.h"
#import "ZZOpenSuccessVC.h"
#import "ZZNewRentSuccessViewController.h"//出租成功的流程
#define OpenString @"收到每条私信获得咨询收益，24小时内回复领取"//开启的文案
#define CloseString @"开启后收到私信可获得咨询收益"//关闭的文案

#define OpenYaoYueString @"可在附近、推荐及新鲜发现您，并向您发起邀约"//开启的文案
#define CloseYaoYueString @"无法在附近、推荐及新鲜发现您，且无法向你发起邀约"//关闭的文案
#define NoReviewYaoYueString @"系统正在审核，如有疑问请联系客服"//没有审核通过

@interface ZZUserChuzuViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    ZHPickView                      *_pickview;
    BOOL                            _haveCityName;
    UIImageView                     *_rightImgView;
    UIButton                        *_rightBtn;
}

@property (nonatomic, strong) NSMutableArray *topics;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UILabel *ageLabel;
@property (strong, nonatomic) UILabel *heightLabel;
@property (strong, nonatomic) NSMutableArray *skills;
@property (strong, nonatomic) IBOutlet UIButton *bottomBtn;//提交按钮
@property (nonatomic, strong) ZZChuzuApplyShareView *shareView;
@property (nonatomic,strong) ZZUser *oldUser;//旧的数据
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *submitInfoBottom;

@property (nonatomic, strong) ZZHeadImageView *headView;
@property (nonatomic, strong) ZZLevelImgView *levelImgView;

@property (nonatomic,assign) BOOL isOpenPrivChat;//默认为有资格的人,第一次没有开通私聊付费的情况下是打开的状态
@property (nonatomic,assign) BOOL isLastOpenPrivChat;//默认为有资格的人,第一次没有开通私聊付费的情况下是打开的状态

@property (nonatomic, assign) BOOL isFirstOpen;//是否第一次出租

@property (nonatomic,assign) BOOL isModify;//修改出租信息
@end

@implementation ZZUserChuzuViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [_pickview remove];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(0xf5f5f5);

    // Do any additional setup after loading the view.
    if (!self.user) {
        self.user = [ZZUserHelper shareInstance].loginer;
    }
    

    _isLastOpenPrivChat = self.user.open_charge;
    if (self.user.rent==0&&self.user.can_see_open_charge) {
        _isLastOpenPrivChat = YES;
    }
    if (_user.rent.status !=0) {
        self.isModify = YES;
        [self.bottomBtn setTitle:@"保存" forState:UIControlStateNormal];
    }else{
        if (_user.rent.time.count<1) {
            _user.rent.time = @[@"偶尔"];//默认第一次出租为选择为偶尔
        }
    }
    _oldUser = [self.user copy];
    [self.tableView registerClass:[ZZChuZuPrivateChatCell class] forCellReuseIdentifier:[ZZChuZuPrivateChatCell reuseIdentifier]];
    [self loadData];
    [self manageLocation];
    self.submitInfoBottom.constant = 20+SafeAreaBottomHeight;
    [self.bottomBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-20-SafeAreaBottomHeight);
    }];
    if (self.user.rent.status == 0&&self.user.can_see_open_charge&&!self.user.open_charge) {
        _isOpenPrivChat = YES;
    }

    [self updateLocalInfoForUI];

}

// 加载缓存中的信息（草稿）
- (void)updateLocalInfoForUI {
    
    ZZUser *cacheUser = [ZZUser yy_modelWithJSON:[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_RENTINFO_KEY]];// [[ZZUser alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_RENTINFO_KEY] error:nil];
    if (cacheUser) {
        if ([cacheUser.uid isEqualToString:[ZZUserHelper shareInstance].loginer.uid] && _user.rent.status == 0) {
            WEAK_SELF();
            [NSObject asyncWaitingWithTime:0.2 completeBlock:^{
                _ageLabel.text = [NSString stringWithFormat:@"%ld岁", (long)cacheUser.age];
                _user.height = cacheUser.height;
                _heightLabel.text = [NSString stringWithFormat:@"%dcm", cacheUser.height];
                _user.rent.time = cacheUser.rent.time;
                _topics = cacheUser.rent.topics;
                _user.rent.city = cacheUser.rent.city;
                _user.birthday = cacheUser.birthday;
                [weakSelf.tableView reloadData];
            }];
        }
    }
}

- (void)loadData
{
    if (!_user) {
        _user = [ZZUserHelper shareInstance].loginer;
    }
    
    if ([ZZUserHelper shareInstance].configModel.open_rent_need_pay_module) {   // 有开启收费功能
        if (!_user.rent_need_pay) {// 不需要付费
            if (_user.rent.paid_status != 0) {// 并且有会员信息
                // headerView 会员信息
                UIView *headerView = [self createHeaderView];
                self.tableView.tableHeaderView = headerView;
            }
        }
    }
    
    [self.tableView setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F5" andAlpha:1]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (!_user.rent.city) {
        _user.rent.city = [[ZZCity alloc] init];
        _user.rent.city.name = [ZZUserHelper shareInstance].cityName;
    }
    if (_user.rent.city.name) {
        _haveCityName = YES;
    }
    
    if (!_user.rent.topics) {
        _topics = [NSMutableArray array];
    } else {
        _topics = _user.rent.topics;
    }
}

- (ZZHeadImageView *)headView {
    if (!_headView) {
        _headView = [[ZZHeadImageView alloc] init];
    }
    return _headView;
}

- (ZZLevelImgView *)levelImgView {
    if (!_levelImgView) {
        _levelImgView = [[ZZLevelImgView alloc] init];
        [_levelImgView setLevel:_user.level];
    }
    return _levelImgView;
}

#pragma mark - NavigationBtn

- (UIView *)createHeaderView {
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    
    UIView *backgroundView = [UIView new];
    backgroundView.backgroundColor = [UIColor whiteColor];
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.textColor = kBlackColor;
    nameLabel.font = [UIFont systemFontOfSize:17];
    nameLabel.text = _user.nickname;
    
    UILabel *dueDate = [UILabel new];
    dueDate.textColor = kBlackColor;
    dueDate.font = [UIFont systemFontOfSize:13];
    dueDate.text = _user.rent.expired_at_text;
    dueDate.numberOfLines = 2;
    
    UIButton *renewal = [UIButton buttonWithType:UIButtonTypeCustom];
    [renewal setTitle:@"续费" forState:(UIControlStateNormal)];
    [renewal setTitleColor:kBlackColor forState:UIControlStateNormal];
    renewal.backgroundColor = RGBCOLOR(244, 203, 7);
    renewal.titleLabel.font = [UIFont systemFontOfSize:15];
    renewal.layer.masksToBounds = YES;
    renewal.layer.cornerRadius = 4.0f;
    [renewal addTarget:self action:@selector(gotoServiceChargeVC:) forControlEvents:UIControlEventTouchUpInside];
    
    [backgroundView addSubview:self.headView];
    [backgroundView addSubview:nameLabel];
    [backgroundView addSubview:self.levelImgView];
    [backgroundView addSubview:dueDate];
    [backgroundView addSubview:renewal];
    
    [view addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(@0);
        make.bottom.equalTo(@(-5));
    }];

    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@15);
        make.top.equalTo(@15);
        make.size.mas_equalTo(CGSizeMake(65, 65));
    }];
    _headView.touchHead = ^{
    };

    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headView.mas_top).offset(5);
        make.leading.equalTo(_headView.mas_trailing).offset(10);
        make.height.equalTo(@20);
    }];
    
    [_levelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(nameLabel.mas_trailing).offset(5);
        make.centerY.equalTo(nameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(28, 14));
    }];
    
    [dueDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headView.mas_centerY).offset(8);
        make.leading.equalTo(nameLabel.mas_leading);
        make.trailing.equalTo(renewal.mas_leading).offset(-3);
    }];
    
    [renewal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backgroundView.mas_centerY);
        make.trailing.equalTo(@(-10));
        make.width.equalTo(@53);
        make.height.equalTo(@32);
    }];
    
    [_headView setUser:_user width:65 vWidth:10];
    
    return view;
}

- (IBAction)gotoServiceChargeVC:(id)sender {
    ZZServiceChargeVC *vc = [ZZServiceChargeVC new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.user = _user;
    vc.isRenew = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)createRightButton
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 64, 44);
    [rightBtn addTarget:self action:@selector(navigationRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    _rightImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 64, 44)];
    _rightImgView.contentMode = UIViewContentModeCenter;
    _rightImgView.userInteractionEnabled = NO;
    [rightBtn addSubview:_rightImgView];
    
    [self managerStatusImage];
}

- (void)managerStatusImage
{
    if (_user.banStatus) {
        _rightBtn.userInteractionEnabled = NO;
        _rightImgView.image = [UIImage imageNamed:@"btn_rent_ban"];
    } else {
        if (_user.rent.status == 0) {
            _rightBtn.userInteractionEnabled = NO;
            _rightImgView.image = [UIImage imageNamed:@"btn_rent_unrent"];
        } else if (_user.rent.status == 1) {
            _rightBtn.userInteractionEnabled = NO;
            _rightImgView.image = [UIImage imageNamed:@"btn_rent_wating"];
        } else if (_user.rent.status == 2) {
            if (_user.rent.show) {
                _rightImgView.image = [UIImage imageNamed:@"btn_rent_up"];
            }  else {
                _rightImgView.image = [UIImage imageNamed:@"btn_rent_down"];
            }
        } else {
            _rightImgView.image = [UIImage imageNamed:@"btn_rent_down"];
        }
    }
}


#pragma mark - 定位

- (void)manageLocation
{
    //定位是否可用
    CLAuthorizationStatus status = [LocationMangers shared].authorizationStatus;
    if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
        [UIAlertView showWithTitle:@"定位服务未开启" message:@"请在手机设置中开启定位服务以看到附近用户" cancelButtonTitle:@"取消" otherButtonTitles:@[@"开启定位"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    } else {
        [self getLocation];
    }
}

- (void)getLocation
{
    __weak typeof(self)weakSelf = self;
    if ([ZZUserHelper shareInstance].cityName) {
        _user.rent.city.name = [ZZUserHelper shareInstance].cityName;
    } else {
        [ZZHUD showWithStatus:@"获取地址中..."];
        self.tableView.userInteractionEnabled = NO;
        //获取地理位置
        [[LocationMangers shared] requestPlacemark:^(CLPlacemark * placemark, NSError * error) {
            if (!error) {
                [ZZHUD showSuccessWithStatus:@"城市更新成功!"];

                NSString *cityName = @"";
                if (placemark.locality) {
                    cityName = placemark.locality;
                }
//                else if (placemark.province) {
//                    cityName = placemark.province;
//                }
                if (!isNullString(cityName)) {
                    ZZUserHelper *userHelper = [ZZUserHelper shareInstance];
                    userHelper.cityName = cityName;
                }
                    
                //如果已登录就上传
                if ([ZZUserHelper shareInstance].isLogin) {
                    if ([ZZUserHelper shareInstance].cityName) {
                        weakSelf.user.rent.city.name = [ZZUserHelper shareInstance].cityName;
                    }
                }
            } else {
                [ZZHUD showErrorWithStatus:@"地址获取失败..."];
            }
        }];
//        _locationManger = [[AMapLocationManager alloc] init];
//        _locationManger.desiredAccuracy = kCLLocationAccuracyHundredMeters;
//        [_locationManger requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
//            weakSelf.tableView.userInteractionEnabled = YES;
//            if (!error) {
//                [ZZHUD showSuccessWithStatus:@"城市更新成功!"];
//                [weakSelf.locationManger stopUpdatingLocation];
//
//                NSString *cityName = @"";
//                if (regeocode.city) {
//                    cityName = regeocode.city;
//                } else if (regeocode.province) {
//                    cityName = regeocode.province;
//                }
//                if (!isNullString(cityName)) {
//                    ZZUserHelper *userHelper = [ZZUserHelper shareInstance];
//                    userHelper.cityName = cityName;
//                }
//
//                //如果已登录就上传
//                if ([ZZUserHelper shareInstance].isLogin) {
//                    if ([ZZUserHelper shareInstance].cityName) {
//                        weakSelf.user.rent.city.name = [ZZUserHelper shareInstance].cityName;
//                    }
//                }
//            } else {
//                [ZZHUD showErrorWithStatus:@"地址获取失败..."];
//            }
//        }];
    }
}

#pragma mark - UITableViewMethod

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isModify) {
        return 2;
    }
    if (_user.open_charge ||!isNullString(_user.open_charge_channel)||_user.can_see_open_charge) {
        return 4;
    }else{
        return 3;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.isModify) {
        if (_user.open_charge ||!isNullString(_user.open_charge_channel)||_user.can_see_open_charge) {
            if (section == 3) {
                if (_topics.count < 3) {
                    return _topics.count + 1;
                }
                return _topics.count;
            }
        }else{
            if (section == 2) {
                if (_topics.count < 3) {
                    return _topics.count + 1;
                }
                return _topics.count;
            }
        }
    }else{
        if (section==0) {
            if ([ZZUserHelper shareInstance].configModel.hide_open_charge) {    //字段控制，ture则隐藏私信收益
                return 1;
            } else {
                return 2;
            }
        }else{
            if (_topics.count < 3) {
                return _topics.count + 1;
            }
            return _topics.count;
        }
    }
    return section == 0 ? 2:1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isModify) {
        switch (indexPath.section) {
            case 0:
            {
                ZZChuZuPrivateChatCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZChuZuPrivateChatCell reuseIdentifier]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

                if (indexPath.row ==0) {
                    if (_user.rent.status == 3) {
                        cell.contentLable.text = @"待审核";
                        cell.openSwitch.on = _user.rent.show;
                       cell.promptLable.text = NoReviewYaoYueString;
                    }else{
                    cell.contentLable.text = @"线下邀约";
                    cell.openSwitch.on = _user.rent.show;
                    if (cell.openSwitch.on) {
                        cell.promptLable.text = OpenYaoYueString;
                    }else{
                        cell.promptLable.text =CloseYaoYueString;
                    }
                    [cell.openSwitch addTarget:self action:@selector(isModifyYaoYue:) forControlEvents:UIControlEventTouchUpInside];
                    }

                }else{
                    cell.openSwitch.on = _user.open_charge;
                    _isOpenPrivChat = _user.open_charge;
                    if (cell.openSwitch.on) {
                        cell.promptLable.text = OpenString;
                    }else{
                        cell.promptLable.text = CloseString;
                    }
                    [cell.openSwitch addTarget:self action:@selector(isModifyPayChat:) forControlEvents:UIControlEventTouchUpInside];
                  
                }
                  return cell;
            }
                break;
            case 1:
            {
                if (indexPath.row == _topics.count && _topics.count < 3) {
                    ZZRentTopicAddCell *cell = [tableView dequeueReusableCellWithIdentifier:@"add" forIndexPath:indexPath];
                    cell.wrapperView.width = cell.width - 40;
                    return cell;
                }
                __weak typeof(self)weakSelf = self;
                ZZRentRangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"skill" forIndexPath:indexPath];
                ZZTopic *topic = _topics[indexPath.row];
                cell.nameLabel.text = [topic title];
                cell.priceLabel.text = [NSString stringWithFormat:@"%@ 元", topic.price];
                cell.tapDeleteNext = ^(UIButton *sender) {
                    [weakSelf.topics removeObject:topic];
                    [weakSelf.tableView reloadData];
                };
                return cell;
            }
                break;
            default:
                return [UITableViewCell new];
                break;
        }
        
        
    }else{
    switch (indexPath.section) {
        case 0:
        {
            ZZRentInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"name"];
            if (indexPath.row == 0) {
                cell.titleLabel.text = @"年龄";
                if (_user.birthday) {
                    cell.contentLabel.text = [@(_user.age) stringValue]?: @"";
                    if ([ZZUtils isIdentifierAuthority:_user]) {
                        cell.imgView.hidden = YES;
                    }
                }
                self.ageLabel = cell.contentLabel;
            } else {
                cell.titleLabel.text = @"身高";
                if (_user.height) {
                    cell.contentLabel.text = [NSString stringWithFormat:@"%dcm",_user.height];
                    cell.imgView.hidden = NO;
                }
                self.heightLabel = cell.contentLabel;
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 15, 1)];
                lineView.backgroundColor = kLineViewColor;
                [cell.contentView addSubview:lineView];
            }
            return cell;
        }
            break;
        case 1:
        {
            ZZRentTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"time"];
            cell.timeSelectView.options = @[@"全天", @"节假日", @"偶尔", @"白天", @"晚上"];
            cell.timeSelectView.allowsMultipleSelection = YES;
            __weak __typeof(self) self_ = self;
            cell.timeSelectView.didSeletedOptions = ^(NSMutableArray *opts) {
                self_.user.rent.time = opts;
            };
          
            if (_user.rent.time) {
                [_user.rent.time enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSInteger i = [cell.timeSelectView.options indexOfObject:name];
                    if (i != NSNotFound) {
                        [cell.timeSelectView selectItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
                    }
                }];
            }
            return cell;
        }
            break;
            
        case 2:
        {
            if (_user.open_charge ||!isNullString(_user.open_charge_channel)||_user.can_see_open_charge) {
                ZZChuZuPrivateChatCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZChuZuPrivateChatCell reuseIdentifier]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.openSwitch.on = _user.open_charge;
                if (_user.rent.status == 0&&_user.can_see_open_charge) {
                    cell.openSwitch.on = YES;
                    _isOpenPrivChat = YES;
                }else{
                    _isOpenPrivChat = _user.open_charge;
                }
                if (cell.openSwitch.on) {
                    cell.promptLable.text = OpenString;
                }else{
                    cell.promptLable.text = CloseString;
                }
                [cell.openSwitch addTarget:self action:@selector(openPayChat:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }else{
                if (indexPath.row == _topics.count && _topics.count < 3) {
                    ZZRentTopicAddCell *cell = [tableView dequeueReusableCellWithIdentifier:@"add" forIndexPath:indexPath];
                    cell.wrapperView.width = cell.width - 40;
                    return cell;
                }
                __weak typeof(self)weakSelf = self;
                ZZRentRangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"skill" forIndexPath:indexPath];
                ZZTopic *topic = _topics[indexPath.row];
                cell.nameLabel.text = [topic title];
                cell.priceLabel.text = [NSString stringWithFormat:@"%@ 元", topic.price];
                cell.tapDeleteNext = ^(UIButton *sender) {
                    [weakSelf.topics removeObject:topic];
                    [weakSelf.tableView reloadData];
                };
                return cell;
            }
        }
            break;
        default:
        {
            if (indexPath.row == _topics.count && _topics.count < 3) {
                ZZRentTopicAddCell *cell = [tableView dequeueReusableCellWithIdentifier:@"add" forIndexPath:indexPath];
                cell.wrapperView.width = cell.width - 40;
                return cell;
            }
            
            __weak typeof(self)weakSelf = self;
            ZZRentRangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"skill" forIndexPath:indexPath];
            ZZTopic *topic = _topics[indexPath.row];
            cell.nameLabel.text = [topic title];
            cell.priceLabel.text = [NSString stringWithFormat:@"%@ 元", topic.price];
            cell.tapDeleteNext = ^(UIButton *sender) {
                [weakSelf.topics removeObject:topic];
                [weakSelf.tableView reloadData];
            };
            return cell;
        }
            break;
    }
    
    return nil;
    }
     return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.isModify) {
        if (indexPath.section==0) {
            return 128;
        }else{
            return 80;
        }
    }
    //判断是不是第一次,如果是第一次开通判断服务器是否给她开通的渠道,如果没有就不显示私信收益的
    if (_user.open_charge ||!isNullString(_user.open_charge_channel)||_user.can_see_open_charge) {
        if (indexPath.section == 3) {
            return 80;
        } else if (indexPath.section == 2) {
            return 128;
        }else{
            return 50;
        }
    }else{
        
        if (indexPath.section == 2) {
            return 80;
        }else{
            return 50;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.isModify) {
        
        if (section==0) {
            return nil;
        }else{
            UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.textColor = kGrayTextColor;
            titleLabel.font = [UIFont systemFontOfSize:12];
            [headView addSubview:titleLabel];
            
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(headView.mas_centerY);
                make.left.mas_equalTo(headView.mas_left).offset(15);
            }];
            if (_user.open_charge ||!isNullString(_user.open_charge_channel)||_user.can_see_open_charge) {
                titleLabel.text = @"请选择想要分享的特长或技能";
            }
            return headView;
        }
    }else{
    
    if (section == 0||(section == 2&&(_user.open_charge ||!isNullString(_user.open_charge_channel)||_user.can_see_open_charge))) {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    } else {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = kGrayTextColor;
        titleLabel.font = [UIFont systemFontOfSize:12];
        [headView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(headView.mas_centerY);
            make.left.mas_equalTo(headView.mas_left).offset(15);
        }];
        
        switch (section) {
            case 1:
            {
                titleLabel.text = @"请选择可被邀约的时间";
            }
                break;
                case 2:
            {
                if (!(_user.open_charge ||!isNullString(_user.open_charge_channel)||_user.can_see_open_charge)) {
                    titleLabel.text = @"请选择想要分享的特长或技能";
                }
            }
                break;
            case 3:
            {
                if (_user.open_charge ||!isNullString(_user.open_charge_channel)||_user.can_see_open_charge) {
                    titleLabel.text = @"请选择想要分享的特长或技能";
                }
            }
                break;
            default:
                break;
        }
        return headView;
    }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section == 0||(section == 2&&(_user.open_charge ||!isNullString(_user.open_charge_channel)||_user.can_see_open_charge))) ? 0.1:35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.isModify) {
            return;
        }
        if (indexPath.row == 1) {
            NSMutableArray *data = [NSMutableArray array];
            for (int i = 140; i<= 200; i++) {
                [data addObject:[NSString stringWithFormat:@"%dcm", i]];
            }
            _pickview=[[ZHPickView alloc] initPickviewWithArray:data isHaveNavControler:NO];
            __weak __typeof(self) self_ = self;
            _pickview.selectDoneBlock = ^(NSArray *items) {
                self_.user.height = [[items firstObject] intValue];
                self_.heightLabel.text = [items firstObject];
            };
            [_pickview showInView:self.view];
            
            NSUInteger row = 0;
            if (_user.height) {
                row = _user.height - 140;
            } else if (_user.gender == 1) {
                row = 170 - 140;
            } else {
                row = 160 - 140;
            }
            
            [_pickview.pickerView selectRow:row inComponent:0 animated:YES];
            [_pickview pickerView:_pickview.pickerView didSelectRow:row inComponent:0];
        } else {
            if (_user.realname.status != 2 || !_user.birthday) {
                [self gotoAgeCtl];
            }
        }
    } else {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        WeakSelf;
        if ([cell isKindOfClass:[ZZRentRangeTableViewCell class]]) {
            ZZTopic *topic = _topics[indexPath.row];
            ZZUserSkillChooseViewController *controller = [[ZZUserSkillChooseViewController alloc] init];
            controller.topic = topic;
            controller.extSkills = self.extSkills;
            NSMutableArray *array = self.extPrices;
            [array removeObject:topic.price];
            controller.extPirces = array;
            controller.callBack = ^{
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:controller animated:YES];
        } else if ([cell isKindOfClass:[ZZRentTopicAddCell class]]) {
            if (_topics.count >= 3) {
                [ZZHUD showErrorWithStatus:@"最多不能超过3个技能"];
                return;
            }
            ZZUserSkillChooseViewController *controller = [[ZZUserSkillChooseViewController alloc] init];
            controller.extSkills = self.extSkills;
            controller.extPirces = self.extPrices;
            controller.isAdd = YES;
            controller.addCallBack = ^(ZZTopic *topic){
                [weakSelf.topics addObject:topic];
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}
/**
 私聊收费
 */
- (void)openPayChat:(UISwitch *)openSwitch {
    
    [self openPayChat:openSwitch isFistRent:YES];
}

- (void)openPayChat:(UISwitch *)openSwitch  isFistRent:(BOOL)isFistRent {
    if ( openSwitch.on) {
        [UIAlertController presentAlertControllerWithTitle:nil message:@"开启后收到私信可获得咨询收益，但可能会大幅度降低收到私信的数量" doneTitle:@"确认开启" cancelTitle:@"我再想想" showViewController:self completeBlock:^(BOOL isSureOpen) {
            if (!isSureOpen) {
                openSwitch.on = YES;
                [self isModifyOpenChatWithSwitch:openSwitch isFistRent:isFistRent];

            }else{
                _isOpenPrivChat =   NO;
                openSwitch.on = NO;
                [self updatePayChat:openSwitch];
            }
        }];
    }else {
        [self isModifyOpenChatWithSwitch:openSwitch isFistRent:isFistRent];
     
    }
}

- (void)isModifyOpenChatWithSwitch:(UISwitch *)openSwitch  isFistRent:(BOOL)isFistRent{
    _isOpenPrivChat =   openSwitch.on;
    if (isFistRent) {
        [self updatePayChat:openSwitch];
        
    }else{
        [MobClick event:Event_click_PayChat_Set_Switch];
        [ZZPrivateChatPayManager modifyPrivateChatPayState:_isOpenPrivChat callBack:^(NSInteger state) {
            if (state!=-1) {
                _user.open_charge =  [ZZUserHelper shareInstance].loginer.open_charge;
                openSwitch.on = _user.open_charge ;
                [self updatePayChat:openSwitch];
            }
        }];
    }
}
/**
 更改邀约

 @param openSwitch <#openSwitch description#>
 */
- (void)isModiupdateYaoYue:(UISwitch *)openSwitch {

    ZZChuZuPrivateChatCell *cell = (ZZChuZuPrivateChatCell *)[[openSwitch superview] superview];
    if (cell.openSwitch.on) {
        cell.promptLable.text = OpenYaoYueString;
    }else{
        cell.promptLable.text = CloseYaoYueString;
    }
}

/**
 更新私聊的cell的文案

 @param openSwitch 开关
 */
- (void)updatePayChat:(UISwitch *)openSwitch {
    
    ZZChuZuPrivateChatCell *cell = (ZZChuZuPrivateChatCell *)[[openSwitch superview] superview];
    if (cell.openSwitch.on) {
        cell.promptLable.text = OpenString;
    }else{
        cell.promptLable.text = CloseString;
    }
}
#pragma mark - UIButtonMethod

- (IBAction)doneBtnClick:(UIButton *)sender
{
    [self saveOpenRentInfo];
}

- (void)saveOpenRentInfo {
    if ([ZZUtils isBan]) {
        return;
    }
    if (!_user.birthday || _user.rent.time.count == 0 || !_user.rent.city || !_user.height) {
        [ZZHUD showErrorWithStatus:@"请填写所有资料"];
        return;
    }
    if (_topics.count == 0) {
        [ZZHUD showErrorWithStatus:@"请添加技能"];
        return;
    }
    if (_topics.count > 3) {
        [ZZHUD showErrorWithStatus:@"最多不能超过3个技能"];
        return;
    }
    
    _user.rent.topics = (NSMutableArray<ZZTopic>*)_topics;
    // 有开启收费功能，并且此用户需要去付费
    if ([ZZUserHelper shareInstance].configModel.open_rent_need_pay_module && _user.rent_need_pay) {
        
        ZZServiceChargeVC *vc = [ZZServiceChargeVC new];
        vc.hidesBottomBarWhenPushed = YES;
        vc.isBackRoot = YES;
        vc.user = _user;
        if (_user.rent.status == 0) {//如果是个未出租状态，则下个页面如果返回，则会保存信息
            vc.isSaveUser = YES;
        }
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        
        if ([ZZUserHelper shareInstance].configModel.open_rent_need_pay_module && _user.rent.paid_status == 1) {//过期用户去付费
            ZZServiceChargeVC *vc = [ZZServiceChargeVC new];
            vc.hidesBottomBarWhenPushed = YES;
            vc.user = _user;
            [self.navigationController pushViewController:vc animated:YES];
            
        } else {
            
            self.isFirstOpen = [ZZUserHelper shareInstance].loginer.rent.status == 0;
            [MobClick event:Event_chuzu_apply];
            [ZZHUD showWithStatus:@"正在提交..."];
            //第一次开启出租业务,同时拥有私聊资格的
            [MobClick event:Event_click_PayChat_Set_Switch];
            [ZZPrivateChatPayManager modifyPrivateChatPayState:_isOpenPrivChat callBack:^(NSInteger state) {
                if (state!=-1) {
                    _user.open_charge =  [ZZUserHelper shareInstance].loginer.open_charge;
                }
                [self openRent];
            }];
        }
    }

}

- (void)openRent {
    WS(weakSelf);
    [ZZUser rent:[_user toDictionary] next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else if (data) {
            [ZZHUD dismiss];
            ZZUser *user = [ZZUser yy_modelWithJSON:data];
            weakSelf.user.rent = user.rent;
            [self managerStatusImage];
            [[ZZUserHelper shareInstance] saveLoginer:weakSelf.user postNotif:NO];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UpdatedRentStatus object:nil];
            if (self.isModify) {
                [weakSelf gotoOpenSuccessVC];
            }else{
                [weakSelf newRentOpenSuccess];
            }
        }
    }];

}


/**
 新版本的开通成功的
 */
- (void)newRentOpenSuccess {
    
    ZZNewRentSuccessViewController  *newRentOpenVC = [[ZZNewRentSuccessViewController alloc]init];
  
    [self.navigationController pushViewController:newRentOpenVC animated:YES];
    

}


/**
 旧版本的开通成功
 */
- (void)gotoOpenSuccessVC {
    
    NSMutableArray<ZZViewController *> *vcs = [self.navigationController.viewControllers mutableCopy];
    [vcs removeObject:self];
    
    ZZOpenSuccessVC *vc = [ZZOpenSuccessVC new];
    vc.hidesBottomBarWhenPushed = YES;
    if (self.isFirstOpen) {
        vc.titleString = @"恭喜您开通成功";
    } else {
        vc.titleString = @"修改成功";
    }
    [vcs addObject:vc];
    [self.navigationController setViewControllers:vcs animated:YES];
}

- (void)createShareView
{
    if (_shareView) {
        _shareView.hidden = NO;
    } else {
        __weak typeof(self)weakSelf = self;
        _shareView = [[ZZChuzuApplyShareView alloc] initWithFrame:[UIScreen mainScreen].bounds controller:weakSelf];
        _shareView.shareCallBack = ^{
            [weakSelf gotoSelfEditTableView];
        };
        [self.view.window addSubview:_shareView];
    }
}

- (void)gotoSelfEditTableView
{
    ZZUserEditViewController *controller = [[ZZUserEditViewController alloc] init];
    controller.gotoRootCtl = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)gotoAgeCtl
{
    __weak typeof(self)weakSelf = self;
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ZZAgeEditTableViewController *age = [sb instantiateViewControllerWithIdentifier:@"agecontroller"];
    age.isChuzu = YES;
    if (_user.birthday) {
        age.defaultBirthday = _user.birthday;
    }
    age.user = _user;
    age.dateChangeBlock = ^(NSDate *birthday) {
        weakSelf.user.birthday = birthday;
        weakSelf.user.age = [ZZUser ageWithBirthday:birthday];
        weakSelf.ageLabel.text = [NSString stringWithFormat:@"%ld岁", weakSelf.user.age];
    };
    [self.navigationController pushViewController:age animated:YES];
}

- (NSMutableArray *)extSkills {
    NSMutableArray * a = [NSMutableArray array];
    [_topics enumerateObjectsUsingBlock:^(ZZTopic *topic, NSUInteger idx, BOOL * _Nonnull stop) {
        [topic.skills enumerateObjectsUsingBlock:^(ZZSkill *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [a addObject:obj.name];
        }];
    }];
    return a;
}

- (NSMutableArray *)extPrices {
    NSMutableArray *a = [NSMutableArray array];
    [_topics enumerateObjectsUsingBlock:^(ZZTopic *topic, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![topic.price isKindOfClass:[NSString class]]) {
            [a addObject:[(NSNumber *)topic.price stringValue]];
        } else {
            [a addObject:topic.price];
        }
    }];
    return a;
}
- (void)navigationLeftBtnClick {
    //TODO:返回的时候判断用户是否有修改
    BOOL isChange = NO;
    if ((_isOpenPrivChat !=_isLastOpenPrivChat &&!self.isModify)||self.user.age !=_oldUser.age) {
        isChange = YES;
    }
    if ([self judgeUserRentInfo]) {
        isChange = YES;
    } ;
    if (!isChange) {
        [super navigationLeftBtnClick];
    }else{
        
        if (_oldUser.rent.status ==0) {
            [UIAlertController presentAlertControllerWithTitle:@"温馨提示" message:@"未提交申请，确认放弃" doneTitle:@"继续申请" cancelTitle:@"放弃申请" showViewController:self completeBlock:^(BOOL isSure) {
                if (isSure) {
                    [super navigationLeftBtnClick];
                }
            }];
            return;
        }
        
        [UIAlertController presentAlertControllerWithTitle:@"温馨提示" message:@"更改的信息未保存，确定退出" doneTitle:@"保存" cancelTitle:@"退出" showViewController:self completeBlock:^(BOOL isSure) {
            if (isSure) {
                [super navigationLeftBtnClick];
            }else{
                [self saveOpenRentInfo];
            }
        }];
    }
}


/**
判断用户的出租信息是否发生改变
 */
- (BOOL)judgeUserRentInfo {
    __block BOOL isChange = YES;
    __block NSInteger count = 0;
    [_user.rent.time enumerateObjectsUsingBlock:^(NSString *newTime, NSUInteger newIdx, BOOL * _Nonnull newStop) {
        [_oldUser.rent.time enumerateObjectsUsingBlock:^(NSString *oldTime, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([newTime isEqualToString:oldTime]) {
                count+=1;
            }
        }];
    }];
    
      __block NSInteger topicsCount = 0;
    [_user.rent.topics enumerateObjectsUsingBlock:^(ZZTopic * newTopic, NSUInteger newIdx, BOOL * _Nonnull newStop) {
        [_oldUser.rent.topics enumerateObjectsUsingBlock:^(ZZTopic * oldOpic, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([oldOpic.price isEqualToString:newTopic.price]) {
                if (newTopic.skills.count == oldOpic.skills.count) {
                      __block NSInteger skillCount = 0;
                    [newTopic.skills enumerateObjectsUsingBlock:^(ZZSkill * newSkill, NSUInteger idx, BOOL * _Nonnull stop) {
                        [oldOpic.skills enumerateObjectsUsingBlock:^(ZZSkill * oldskill, NSUInteger idx, BOOL * _Nonnull stop) {
                            if ([newSkill.name isEqualToString:oldskill.name]) {
                                skillCount +=1;
                            }
                        }];
                    }];
                    if (skillCount ==newTopic.skills.count ) {
                         topicsCount +=1;
                    }
                }
            }
        }];
    }];
    if ((_user.rent.topics.count ==_oldUser.rent.topics.count&& topicsCount==_user.rent.topics.count)&&(_user.rent.time.count ==_oldUser.rent.time.count&& count==_user.rent.time.count)) {
        isChange =NO;
    }
    return isChange;
}
//TODO:修改出租的时候,更改线下邀约
- (void)isModifyYaoYue:(UISwitch *)openSwitch {
    
    if (_user.rent.status == 2) {
        if (_user.rent.show) {
            [UIAlertView showWithTitle:@"提示" message:@"确定隐身吗？隐身之后将无法在首页、附近看到您的信息。" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"确定"]) {
                    
                    [MobClick event:Event_chuzu_down];
                    [ZZHUD showWithStatus:@"正在保存"];
                    [_user.rent enable:NO next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                        NSLog(@"========%@", data);
                        [ZZHUD dismiss];
                        if (error) {
                              openSwitch.on = YES;
                            [ZZHUD showErrorWithStatus:error.message];
                        } else if (data) {
                            _user.rent.show = NO;
                            openSwitch.on = NO;
                            [[ZZUserHelper shareInstance] saveLoginer:_user postNotif:YES];
                            
                        }
                        [self isModiupdateYaoYue: openSwitch];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UpdatedRentStatus object:nil];
                    }];
                }
            }];
        }
        else{
            [MobClick event:Event_chuzu_up];
            [_user.rent enable:YES next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                [ZZHUD dismiss];
                if (error) {
                    [ZZHUD showErrorWithStatus:error.message];
                    openSwitch.on = _user.rent.show;
                } else if (data) {
                    _user.rent.show = YES;
                    openSwitch.on = YES;

                    [[ZZUserHelper shareInstance] saveLoginer:_user postNotif:NO];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UpdatedRentStatus object:nil];
            }];
        }
    }
}

//TODO:修改出租的时候,更改私信收益
- (void)isModifyPayChat:(UISwitch *)openSwitch  {
    
    [self openPayChat:openSwitch isFistRent:NO];
}
- (void)dealloc
{
    [_shareView removeFromSuperview];
    _shareView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [ZZHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
