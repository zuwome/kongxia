//
//  ZZSettingPrivacyViewController.m
//  zuwome
//
//  Created by angBiu on 16/9/12.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZSettingPrivacyViewController.h"
#import "ZZBlackManagerViewController.h"
#import "ZZContactViewController.h"
#import "ZZUserEditViewController.h"

#import "ZZSettingSwitchCell.h"
#import "ZZSettingTitleCell.h"

@interface ZZSettingPrivacyViewController () <UITableViewDelegate,UITableViewDataSource> {
    UITableView                         *_tableView;
}

@end

@implementation ZZSettingPrivacyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"隐私";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)createViews {
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark - UITableViewMethod
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2 || indexPath.row == 3) {
        static NSString *identifier = @"switchcell";
        ZZSettingSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ZZSettingSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.settingSwitch.tag = indexPath.row + 100 * indexPath.section + 100;
        if (indexPath.row == 2) {
            cell.hidden = YES;
            [cell.settingSwitch addTarget:self action:@selector(switchDidChange:) forControlEvents:UIControlEventValueChanged];
            cell.lineView.hidden = NO;
            cell.contentLabel.hidden = NO;
            cell.titleLabel.text = @"允许直接私信";
            cell.contentLabel.text = @"开启后，所有人可以直接与你进行私信";
            cell.settingSwitch.on = _user.privacy_config.open_chat;
        } else {
            cell.hidden = YES;
            
            if (_user.rent.status == 2) {
                // 已上架
                cell.hidden = NO;
            }
            [cell.settingSwitch addTarget:self action:@selector(visibleFunctionDidChanged:) forControlEvents:UIControlEventValueChanged];
            cell.lineView.hidden = NO;
            cell.contentLabel.hidden = NO;
            cell.titleLabel.text = @"隐身";
            cell.contentLabel.text = @"开启后，其他人将无法在首页看到你的信息";
            cell.settingSwitch.on = !_user.rent.show;
        }
        return cell;
    } else {
        ZZSettingTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titlecell"];
        if (!cell) {
            cell = [[ZZSettingTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titlecell"];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"屏蔽手机联系人";
        } else {
            cell.titleLabel.text = @"黑名单管理";
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2)
        return 0;
    else if (indexPath.row == 3) {
        //未出租不显示隐身功能
        if (_user.rent.status == 2) {
            // 已上架
            return 50;
        }
        return 0.0;
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            [MobClick event:Event_click_shield_phone_contact];
            ZZContactViewController *controller = [[ZZContactViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        } break;
        case 1: {
            [MobClick event:Event_click_privacy_black];
            ZZBlackManagerViewController *controller = [[ZZBlackManagerViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        } break;
        default: break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)canHideOrShow {
    if (_user.rent.status != 2) {
        return NO;
    }
    
    if (!_user.rent.show) {
        // 隐身中
        if (![_user didHaveRealAvatar] ) {
            // 没有真实头像
            if ([_user isAvatarManualReviewing]) {
                // 头像在人工审核中
                if (![_user didHaveOldAvatar]) {
                    // 没有旧的可用头像
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"隐身需要上传本人正脸五官清晰照您的头像正在人工审核中，请等待审核结果" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
                    [alertController addAction:doneAction];
                    
                    UIViewController *rootVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
                    if ([rootVC presentedViewController] != nil) {
                        rootVC = [UIAlertController findAppreciatedRootVC];
                    }
                    [rootVC presentViewController:alertController animated:YES completion:nil];
                    return NO;
                }
                else {
                    // 有旧的可用头像
                    return YES;
                }
            }
            else {
                // 头像不在人工审核中
                [UIAlertController presentAlertControllerWithTitle:@"温馨提示"
                                                           message:@"您未上传本人正脸五官清晰照，暂不可出租"
                                                         doneTitle:@"去上传"
                                                       cancelTitle:@"取消"
                                                     completeBlock:^(BOOL isCancelled) {
                                                         if (!isCancelled) {
                                                             ZZUserEditViewController *controller = [[ZZUserEditViewController alloc] init];
                                                             [self.navigationController pushViewController:controller animated:YES];
                                                         }
                                                     }];
                return NO;
            }
        }
        else {
            // 有真实头像
            return YES;
        }
    }
    return YES;
}

#pragma mark - UISwitchMethod
//允许直接私信
- (void)switchDidChange:(UISwitch *)sender {
    BOOL isOn = sender.on;
    sender.userInteractionEnabled = NO;
    NSDictionary *aDict = @{@"open_chat":[NSNumber numberWithBool:isOn]};
    ZZUser *model = [[ZZUser alloc] init];
    [model updateWithParam:@{@"privacy_config":aDict} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        sender.userInteractionEnabled = YES;
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
            sender.on = !isOn;
        } else {
            [ZZHUD dismiss];
            _user.privacy_config.open_chat = isOn;
            [[ZZUserHelper shareInstance] saveLoginer:_user postNotif:NO];
        }
    }];
}
//出租 -- 隐身功能
- (void)visibleFunctionDidChanged:(UISwitch *)sender {
    if (![self canHideOrShow]) {
        return;
    }
    
    BOOL isOn = !sender.on;
    if (!isOn) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定下架么？" message:@"下架之后其他人将无法在首页看到你的信息，是否下架？" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            sender.on = isOn;
        }];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [self changeVisibleStatus:isOn sender:sender];
        }];
        [alert addAction:cancelAction];
        [alert addAction:sureAction];
        [self.navigationController presentViewController:alert animated:YES completion:nil];
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault removeObjectForKey:@"LastShowNotHideViewDay"];
        [userDefault synchronize];
    }
    else {
        [self changeVisibleStatus:isOn sender:sender];
    }
}

- (void)changeVisibleStatus:(BOOL)isOn sender:(UISwitch *)sender {
    sender.userInteractionEnabled = NO;
    [_user.rent enable:isOn next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        sender.userInteractionEnabled = YES;
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
            sender.on = isOn;
        } else {
            [ZZHUD dismiss];
            _user.rent.show = isOn;
            [[ZZUserHelper shareInstance] saveLoginer:_user postNotif:NO];
            
            if (isOn) {
                [[ZZSayHiHelper sharedInstance] showSayHiWithType:SayHiTypeRecallLogin canAlwaysShow:YES];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
