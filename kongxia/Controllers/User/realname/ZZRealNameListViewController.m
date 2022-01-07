//
//  ZZRealNameListViewController.m
//  zuwome
//
//  Created by angBiu on 16/7/7.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRealNameListViewController.h"
#import "ZZRealNameListCell.h"
#import "ZZRealNameDoneViewController.h"
#import "ZZRealNameZMViewController.h"
#import "ZZRealNameTableViewController.h"
#import "ZZRealNameZMDoneViewController.h"
#import "ZZRealNameNotMainlandViewController.h"
#import "ZZRealNameAuthenticationFailedCell.h"//实名认证失败的cell
#import "ZZRealNameAuthenticationFailedVC.h"//实名认证失败的viewController

#import "ZZUser.h"
#import "ZZUserHelper.h"
#import "ZZMyWalletViewController.h"//新版的我的钱包
@interface ZZRealNameListViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ZZRealNameListViewController

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = kBGColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
        [_tableView registerClass:[ZZRealNameAuthenticationFailedCell class] forCellReuseIdentifier:@"ZZRealNameAuthenticationFailedID"];
    }
    
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.user) {
        self.user = [ZZUserHelper shareInstance].loginer;
    }
    
    self.navigationItem.title = @"实名认证";
    [self createLeftButton];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (void)createLeftButton
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 44,44)];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -15,0, 0);
    btn.contentEdgeInsets =UIEdgeInsetsMake(0, -20,0, 0);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(navigationLeftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems =@[leftItem];
}

- (void)navigationLeftBtnClick
{
    BOOL haveCtl = NO;
    if (self.blackBlock) {
        self.blackBlock();
    }
    for (UIViewController *ctl in self.navigationController.viewControllers) {
        //新版的我的钱包
          if ([ctl isKindOfClass:[ZZMyWalletViewController class]]) {
            [self.navigationController popToViewController:ctl animated:YES];
            haveCtl = YES;
            break;
        }
    }
    if (!haveCtl) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITableViewMethod

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ZZUtils isIdentifierAuthority:_user] ? 2 : 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        ZZRealNameAuthenticationFailedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZZRealNameAuthenticationFailedID"];
        return cell;
    }
    static NSString *identifier = @"realname";
    ZZRealNameListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ZZRealNameListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setUer:_user IndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 0;
    }
    if (indexPath.row == 3) {
        //认证失败
        return 62;
    }
    return 112;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(_user.faces.count == 0) {
        [self gotoVerifyFace:NavigationTypeRealNameIndentify indexPath:indexPath];
        return;
    }
    
    if ([self isAuthCheckPassLimitePerDayWithIndexPath:indexPath]) {
        return;
    }
    
    if (indexPath.row == 3) {
        [self authenMunually];
    }
    else {
        BOOL isRealName = NO;
        if (indexPath.row == 0) {
            if (!_user.zmxy.openid) {
                [self authenZM];
            }
            else {
                ZZRealNameZMDoneViewController *controller = [[ZZRealNameZMDoneViewController alloc] init];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }
            return;
        }
        else if (indexPath.row == 1) {
            if (_user.realname.status == 2 || _user.realname_abroad.status != 2) {
                isRealName = YES;
            }
        }
        
        if (isRealName) {
            if (_user.realname.status == 2) {
                [self showRealNameDoneView:@"实名认证"];
            }
            else if (_user.realname_abroad.status != 2) {
                [self authenInChina];
            }
        }
        else {
            //海外实名认证
            if (_user.realname_abroad.status == 2) {
                [self showRealNameDoneView:@"港澳台及海外用户认证"];
            }
            else if (_user.realname.status != 2) {
                [self authenAbroad];
            }
        }
    }
}

- (void)authenZM {
    ZZRealNameZMViewController *controller = [[ZZRealNameZMViewController alloc] init];
    controller.user = _user;
    controller.successCallBack = ^{
        _user = [ZZUserHelper shareInstance].loginer;
        [_tableView reloadData];
    };
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)authenMunually {
    NSLog(@"PY_ 大陆认证人脸对比失败后进入失败认证环节");
    ZZRealNameAuthenticationFailedVC *vc = [[ZZRealNameAuthenticationFailedVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)authenAbroad {
    ZZRealNameNotMainlandViewController *controller = [[ZZRealNameNotMainlandViewController alloc] init];
    controller.isTiXian = self.isTiXian;

    controller.successCallBack = ^{
        _user = [ZZUserHelper shareInstance].loginer;
        [_tableView reloadData];
    };
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)authenInChina {
    //目前只有这个大陆  实名认证
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ZZRealNameTableViewController *vc = [sb instantiateViewControllerWithIdentifier:@"RealName"];
    if (self.isRentPerfectInfo) {
        vc.isRentPerfectInfo = self.isRentPerfectInfo;
    }
    if (self.isOpenFastChat) {
        vc.isOpenFastChat = self.isOpenFastChat;
    }
    vc.isTiXian = self.isTiXian;
    vc.logAuthBlock = ^{
        [self logAuthen];
    };
    
    vc.successCallBack = ^{
        _user = [ZZUserHelper shareInstance].loginer;
        [_tableView reloadData];
        
        if (_isTiXian) {
            if (self.successCallBack) {
                self.successCallBack();
            }
        }
    };
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showRealNameDoneView:(NSString *)title {
    ZZRealNameDoneViewController *controller = [[ZZRealNameDoneViewController alloc] init];
    controller.user = _user;
    controller.isTiXian =  self.isTiXian;
    controller.navigationItem.title = title;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

// 没有人脸，则验证人脸
- (void)gotoVerifyFace:(NavigationType)type indexPath:(NSIndexPath *)indexPath {
    ZZLivenessHelper *helper = [[ZZLivenessHelper alloc] initWithType:type inController:self];
    helper.user = [ZZUserHelper shareInstance].loginer;
    [helper start];
    
    helper.checkSuccess = ^{
        if (indexPath.row == 0) {
            [self authenZM];
        }
        else if (indexPath.row == 1) {
            [self authenInChina];
        }
        else if (indexPath.row == 2) {
            [self authenAbroad];
        }
    };
}

- (void)logAuthen {
    NSDictionary *authInfo =[[NSUserDefaults standardUserDefaults] objectForKey:@"authInfo"];
    if (authInfo == NULL) {
        authInfo = [[NSMutableDictionary alloc] init];
    }
    
    NSMutableDictionary *authInfoM = [authInfo mutableCopy];
    
    NSString *timeStampStr = authInfo[@"time"];
    if (timeStampStr == NULL) {
        timeStampStr = [self getCurrentTimeStamp];
        
        authInfoM[@"time"] = timeStampStr;
        authInfoM[@"repeat"] = @1;
    }
    else {
        BOOL isSameDay = [self isTheSameDay:timeStampStr];
        int repeat = 0;
        NSNumber *repeatPerDay = authInfoM[@"repeat"];
        if (isSameDay) {
            repeat = [repeatPerDay intValue];
            repeat += 1;
        }
        else {
            repeat = 0;
            authInfoM[@"time"] = [self getCurrentTimeStamp];
        }
        authInfoM[@"repeat"] = [NSNumber numberWithInt:repeat];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[authInfoM copy] forKey:@"authInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isTheSameDay:(NSString *)timeStamp {
    
    //传入时间毫秒数
    NSDate *pDate1 = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]];
    NSDate *pDate2 = [NSDate dateWithTimeIntervalSince1970:[[self getCurrentTimeStamp] doubleValue]];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:pDate1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:pDate2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

- (NSString *)getCurrentTimeStamp {
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970];// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

- (BOOL)isAuthCheckPassLimitePerDayWithIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != 1) {
        return NO;
    }
    
    NSDictionary *authInfo =[[NSUserDefaults standardUserDefaults] objectForKey:@"authInfo"];
    if (authInfo == NULL) {
        return NO;
    }
    
    
    NSString *date = authInfo[@"time"];
    NSNumber *repeatNum = authInfo[@"repeat"];
    
    if (date == NULL || repeatNum == NULL) {
        return NO;
    }
    
    if (![self isTheSameDay:date]) {
        return NO;
    }
    
    if ([repeatNum intValue] >= 5 ) {
        [ZZHUD showInfoWithStatus:@"认证遇到问题了？请您尝试页面下方身份信息人工审核"];
        return YES;
    }
    
    return NO;
}

@end
