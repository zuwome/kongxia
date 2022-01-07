//
//  ZZSettingViewController.m
//  zuwome
//
//  Created by angBiu on 16/9/5.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZSettingViewController.h"
#import "ZZSettingSecurityViewController.h"
#import "ZZSettingNotificationViewController.h"
#import "ZZSettingPrivacyViewController.h"
#import "ZZSettingCurrencyViewController.h"
#import "ZZProtocolViewController.h"
#import "ZZAboutViewController.h"
#import "ZZTravelSecurityViewController.h"
#import "ZZHelpCenterVC.h"
#import "ZZSettingTitleCell.h"
#import "ZZSettingSwitchCell.h"
#import "ZZSettingMemoryCell.h"
#import "ZZCustomServiceWechatCell.h"
#import "MiPushSDK.h"
#import <RongIMKit/RongIMKit.h>
#import "ZZFileHelper.h"
#import "ZZPayHelper.h"//内购
@interface ZZSettingViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat folderSize;
@property (nonatomic, copy) NSString *customerServiceWechat;
@end

@implementation ZZSettingViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"设置";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _folderSize = 0;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _folderSize = [self calculateFolderSize];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
    [self fetchCustomerService];
}

- (void)fetchCustomerService {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/user/kefu"] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (data) {
            _customerServiceWechat = data;
        }
        [self createViews];
    }];
}

- (void)showPrivacyProtocol {
    ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc] init];
    controller.urlString = H5Url.privacyProtocol;
    controller.navigationItem.title = @"空虾隐私权政策";
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)createViews
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = kBGColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-50-SafeAreaBottomHeight);
    }];
    
    UIButton *logoutBtn = [[UIButton alloc] init];
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
    logoutBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    logoutBtn.backgroundColor = kYellowColor;
    [logoutBtn addTarget:self action:@selector(logoutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutBtn];
    
    [logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(_tableView.mas_bottom);
        make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(-SafeAreaBottomHeight);
    }];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    if (isIPhoneX) {
        CGSize titleSize = logoutBtn.titleLabel.frame.size;
        logoutBtn.titleEdgeInsets = UIEdgeInsetsMake(logoutBtn.height - titleSize.height, (logoutBtn.width - titleSize.width)/2, 0, (logoutBtn.width - titleSize.width)/2);
    }
    [self fillIphoneX:logoutBtn];
}
/**
 iphonex适配填充颜色
 */
- (void)fillIphoneX:(UIButton *)sender {
    UIView *fillView = [[UIView alloc]init];
    fillView.backgroundColor = kYellowColor;
    [self.view addSubview:fillView];
    [fillView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.equalTo(sender.mas_bottom);
    }];
}

#pragma mark - UITableViewMethod

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 2;
        }
            break;
        case 1:
        {
            return 3;
        }
            break;
        case 2:
        {
            return 4;
        }
            break;
        default:
        {
            return 1;
        }
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        static NSString *identifier = @"memorycell";
        
        ZZSettingMemoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[ZZSettingMemoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.contentLabel.text = [NSString stringWithFormat:@"%.1fMB",_folderSize];
        
        return cell;
    } else {
        if (indexPath.section == 2 && indexPath.row == 0) {
            ZZCustomServiceWechatCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZCustomServiceWechatCell cellIdentifier]];
            if (!cell) {
                cell = [[ZZCustomServiceWechatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[ZZCustomServiceWechatCell cellIdentifier]];
                cell.subTitleLable.text = self.customerServiceWechat;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            return cell;
        }
        static NSString *identifier = @"titlecell";
        
        ZZSettingTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[ZZSettingTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [cell setIndexPath:indexPath];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return 40;
    }
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        footerLabel.textAlignment = NSTextAlignmentCenter;
        footerLabel.textColor = kGoldenRod;//HEXCOLOR(0x214AB8);
        footerLabel.font = ADaptedFontMediumSize(13.0);
        footerLabel.text = @"《空虾隐私权政策》";
        footerLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPrivacyProtocol)];
        [footerLabel addGestureRecognizer:tap];
        return footerLabel;
    } else {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    [MobClick event:Event_click_setting_sucure];
                    ZZSettingSecurityViewController *controller = [[ZZSettingSecurityViewController alloc] init];
                    controller.user = _user;
                    [self.navigationController pushViewController:controller animated:YES];
                }
                    break;
                case 1:
                {
                    [MobClick event:Event_click_setting_security];
                    ZZTravelSecurityViewController *controller = [[ZZTravelSecurityViewController alloc] init];
                    [self.navigationController pushViewController:controller animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    [MobClick event:Event_click_setting_notification];
                    ZZSettingNotificationViewController *controller = [[ZZSettingNotificationViewController alloc] init];
                    controller.user = _user;
                    [self.navigationController pushViewController:controller animated:YES];
                }
                    break;
                case 1:
                {
                    [MobClick event:Event_click_setting_privacy];
                    ZZSettingPrivacyViewController *controller = [[ZZSettingPrivacyViewController alloc] init];
                    controller.user = _user;
                    [self.navigationController pushViewController:controller animated:YES];
                }
                    break;
                case 2:
                {
                    [MobClick event:Event_click_setting_currency];
                    ZZSettingCurrencyViewController *controller = [[ZZSettingCurrencyViewController alloc] init];
                    controller.user = _user;
                    [self.navigationController pushViewController:controller animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 1:
                {
                    [MobClick event:Event_click_about];
                    ZZAboutViewController *controller = [[ZZAboutViewController alloc] init];
                    [self.navigationController pushViewController:controller animated:YES];
                }
                    break;
                case 2:
                {
                    [MobClick event:Event_click_setting_protocol];
                    //免责声明
                    ZZProtocolViewController *controller = [[ZZProtocolViewController alloc] init];
                    controller.isMianZe = YES;
                    [self.navigationController pushViewController:controller animated:YES];
                }
                    break;
                case 3:
                {
                    [MobClick event:Event_click_setting_comment];
                    //应用评分
//                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1081895050"]];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 3:
        {
            [MobClick event:Event_click_setting_clear];
            tableView.userInteractionEnabled =  NO;
            [UIAlertView showWithTitle:@"提示" message:@"是否清除缓存？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                tableView.userInteractionEnabled =  YES;
                if (buttonIndex == 1) {
                    [self clearCache];

                }
            }];
        }
            break;
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIButtonMethod

//清除缓存
- (void)clearCache
{
    [ZZKeyValueStore clearTable:kTableName_VideoSave];
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
    for (NSString *p in files)
    {
        NSError *error;
        NSString *path = [cachPath stringByAppendingPathComponent:p];
        if ([path rangeOfString:question_savepath].location == NSNotFound) {
            if ([[NSFileManager defaultManager] fileExistsAtPath:path])
            {
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }
    }
    
    _folderSize = [self calculateFolderSize];
    [_tableView reloadData];
}

- (float)calculateFolderSize
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *folderPath = [paths objectAtIndex:0];
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:folderPath]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil)
    {
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    
    if (folderSize == 0)
    {
        return 0;
    }
    
    return folderSize/(1024.0*1024.0);
}

//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath
{
    if ([filePath rangeOfString:question_savepath].location == NSNotFound) {
        NSFileManager* manager = [NSFileManager defaultManager];
        
        if ([manager fileExistsAtPath:filePath])
        {
            return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        }
    }
    return 0;
}

- (void)logoutBtnClick:(UIButton *)sender
{
    if ([ZZUtils isConnecting]) {
        return;
    }

    [NSObject asyncWaitingWithTime:2 completeBlock:^{
        sender.enabled = YES;
    }];
    sender.enabled = NO;
    //退出
    [MobClick event:Event_click_logout];
    [UIAlertView showWithTitle:@"提示" message:@"确定退出登录吗？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
        if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"确定"]) {
            //停止内购的检测
            [[ZZPayHelper shared] stopManager];
            [MiPushSDK unsetAlias:[ZZUserHelper shareInstance].loginer.uid];
            
            [[RCIM sharedRCIM] logout];
            [ZZUserHelper shareInstance].firstCloseTopView = NO;
            [[[ZZUser alloc] init] logout:nil];
            [[ZZUserHelper shareInstance] clearLoginer];
            [self.navigationController popViewControllerAnimated:YES];
            ZZUserhelperOnce = 0;
            _sharedObject = nil;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UserDidLogout object:self];
            });
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
