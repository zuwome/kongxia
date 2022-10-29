//
//  ZZSnatchTaskSettingViewController.m
//  zuwome
//
//  Created by MaoMinghui on 2018/9/11.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZSnatchTaskSettingViewController.h"
#import "ZZSnatchOrderNotificationCell.h"
#import "ZZDisturbTimeCell.h"
#import "ZZSystemToolsManager.h"
#import "ZZCloseNotificationAlertView.h"
#import "ZZDisturbTimePickerView.h"

@interface ZZSnatchTaskSettingViewController () <UITableViewDelegate, UITableViewDataSource, ZZSnatchOrderNotificationCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZZDisturbTimePickerView *pickerView;

@property (nonatomic, strong) ZZUser *user;

@property (nonatomic, strong) NSString *timeString;
@property (nonatomic, strong) NSMutableDictionary *param;

@end

@implementation ZZSnatchTaskSettingViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _settingType = settingSnatch;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"通知设置";
    self.user = [ZZUserHelper shareInstance].loginer;
    
    if (_settingType == settingSnatch) {
        if (!isNullString(_user.push_config.pd_push_begin_at)) {
            [self.param setObject:_user.push_config.pd_push_begin_at forKey:@"pd_push_begin_at"];
            [self.param setObject:_user.push_config.pd_push_end_at forKey:@"pd_push_end_at"];
        }
        if (!isNullString(_user.push_config.pd_push_begin_at)) {
            _timeString = [NSString stringWithFormat:@"%@至%@",_user.push_config.pd_push_begin_at,_user.push_config.pd_push_end_at];
        } else {
            _timeString = [NSString stringWithFormat:@"23:00至06:00"];
        }
    }
    else {
        
    }
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark - ZZSnatchOrderNotificationCellDelegate
- (void)cell:(ZZSnatchOrderNotificationCell *)cell type:(NotificationType)type on:(BOOL)isOne {
    if (![[ZZUserHelper shareInstance] isLogin]) {
        return;
    }
    
    if (type == NotificationTypeSnatchPush) {
        [self switchSnatch:isOne];
    }
    else if (type == NotificationTypeSnatchSms) {
        [self switchSnatchSms:isOne];
    }
    else if (type == NotificationTypeTaskFreeSms) {
        [self switchTaskFreeSms:isOne];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_settingType == settingSnatch) {
        return 2;
    }
    else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_settingType == settingSnatch) {
        static NSString *notiFicationID = @"notification";
        ZZSnatchOrderNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:notiFicationID forIndexPath:indexPath];
        cell.delegate = self;
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"开启新发布通告通知";
            cell.contentLabel.text = @"随时报名新发布通告 轻松赚钱";
            cell.aSwitch.on = _user.push_config.pd_push;
            cell.type = NotificationTypeSnatchPush;
            
            if (![GetSystemToolsManager() isOpenSystemNotification]) {
                cell.aSwitch.on = NO;
            }
        }
        else {
            cell.titleLabel.text = @"有新的通告短信通知我";
            cell.contentLabel.text = @"开启通知随时报名新发布通告 轻松赚钱";
            cell.aSwitch.on = _user.open_pd_sms;
            cell.type = NotificationTypeSnatchSms;
        }
        return cell;
    }
    else {
        static NSString *notiFicationID = @"notification";
        ZZSnatchOrderNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:notiFicationID forIndexPath:indexPath];
        cell.delegate = self;
        cell.titleLabel.text = @"有新的免费活动推送通知我";
        cell.contentLabel.text = @"";
        cell.aSwitch.on = _user.open_pdg_sms;
        cell.type = NotificationTypeTaskFreeSms;
        return cell;
    }
//    if (indexPath.row == 0) {
//        static NSString *notiFicationID = @"notification";
//        ZZSnatchOrderNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:notiFicationID];
//        cell.aSwitch.on = _user.push_config.pd_push;
//        if (![GetSystemToolsManager() isOpenSystemNotification]) {
//            cell.aSwitch.on = NO;
//        }
//        [cell.aSwitch addTarget:self action:@selector(switchDidChange:) forControlEvents:UIControlEventValueChanged];
//        return cell;
//    } else {
//        ZZDisturbTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timecell"];
//        cell.titleLabel.text = @"设置通知时间段";
//        if (!isNullString(_user.push_config.pd_push_begin_at)) {
//            _timeString = [NSString stringWithFormat:@"%@至%@",_user.push_config.pd_push_begin_at,_user.push_config.pd_push_end_at];
//        }
//        cell.contentLabel.text = _timeString;
//        return cell;
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.row == 1) {
//        [self.pickerView show:_timeString];
//    }
//}

/**
*  活动短信通知
*/
- (void)switchTaskFreeSms:(BOOL)isOn {
    NSDictionary *param = @{
        @"uid": [ZZUserHelper shareInstance].loginer.uid,
        @"open_pdg_sms" : @(isOn),
    };
    
    [ZZRequest method:@"POST" path:@"/api/openPdgSmsSwitch" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            _user.open_pdg_sms = isOn;
            [[ZZUserHelper shareInstance] saveLoginer:_user postNotif:NO];
            
        }
        [self.tableView reloadData];
    }];
}

/**
 *  通告短信通知
 */
- (void)switchSnatchSms:(BOOL)isOn {
    NSDictionary *param = @{
        @"uid": [ZZUserHelper shareInstance].loginer.uid,
        @"open_pd_sms" : @(isOn),
    };
    
    [ZZRequest method:@"POST" path:@"/api/openPdSmsSwitch" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            _user.open_pd_sms = isOn;
            [[ZZUserHelper shareInstance] saveLoginer:_user postNotif:NO];
            
        }
        [self.tableView reloadData];
    }];
}

- (void)switchSnatch:(BOOL)isOn {
    WEAK_SELF();
    if ([GetSystemToolsManager() isOpenSystemNotification]) {
        if (!isOn) {
            ZZCloseNotificationAlertView *alert = [[ZZCloseNotificationAlertView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            [alert setDoneBlock:^{
                [weakSelf.param setObject:[NSNumber numberWithBool:isOn] forKey:@"pd_push"];
                ZZUser *model = [[ZZUser alloc] init];
                [model updateWithParam:@{@"push_config":weakSelf.param} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                    if (error) {
                        [ZZHUD showErrorWithStatus:error.message];
                    } else {
                        _user = [ZZUser yy_modelWithJSON:data];
                        _user.push_config.pd_push = isOn;
                        [[ZZUserHelper shareInstance] saveLoginer:_user postNotif:NO];
                    }
                    [weakSelf.tableView reloadData];
                }];
            }];
            [alert setCancelBlock:^{
                [_tableView reloadData];
            }];
            [[UIApplication sharedApplication].keyWindow addSubview:alert];
            
            return ;
        }
    }

    if (isOn && ![GetSystemToolsManager() isOpenSystemNotification]) {
        [UIAlertController presentAlertControllerWithTitle:nil message:@"你现在无法收到抢任务通知。请到系统“设置”-“通知”-“空虾”中开启。" doneTitle:@"前往" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
            if (!isCancelled) {
                if (UIApplicationOpenSettingsURLString != NULL) {
                    NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    [[UIApplication sharedApplication] openURL:appSettings];
                }
            }
        }];
        [_tableView reloadData];
        return;
    }
    [self.param setObject:[NSNumber numberWithBool:isOn] forKey:@"pd_push"];
    ZZUser *model = [[ZZUser alloc] init];
    [model updateWithParam:@{@"push_config":self.param} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            _user = [ZZUser yy_modelWithJSON:data];
            _user.push_config.pd_push = isOn;
            [[ZZUserHelper shareInstance] saveLoginer:_user postNotif:NO];
            
        }
        [self.tableView reloadData];
    }];
}

- (void)updateNopushTime:(NSString *)string {
    NSArray *array = [string componentsSeparatedByString:@"至"];
    if (array.count == 2) {
        _param = [NSMutableDictionary dictionaryWithDictionary:[[ZZUserHelper shareInstance].loginer.push_config toDictionary]];
        [self.param setObject:array[0] forKey:@"pd_push_begin_at"];
        [self.param setObject:array[1] forKey:@"pd_push_end_at"];
        ZZUser *model = [[ZZUser alloc] init];
        [model updateWithParam:@{@"push_config":self.param} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
                [_tableView reloadData];
            } else {
                if (array.count == 2) {
                    _user = [ZZUserHelper shareInstance].loginer;
                    _user.push_config.pd_push_begin_at = array[0];
                    _user.push_config.pd_push_end_at = array[1];
                    [_param setObject:array[0] forKey:@"pd_push_begin_at"];
                    [_param setObject:array[1] forKey:@"pd_push_end_at"];
                    _timeString = [NSString stringWithFormat:@"%@至%@",_user.push_config.pd_push_begin_at,_user.push_config.pd_push_end_at];
                }
                [_tableView reloadData];
                [[ZZUserHelper shareInstance] saveLoginer:_user postNotif:NO];
            }
        }];
    }
}

- (UITableView *)tableView {
    if (nil == _tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[ZZSnatchOrderNotificationCell class] forCellReuseIdentifier:@"notification"];
        [_tableView registerClass:[ZZDisturbTimeCell class] forCellReuseIdentifier:@"timecell"];
    }
    return _tableView;
}

- (NSMutableDictionary *)param {
    if (!_param) {
        _param = [NSMutableDictionary dictionaryWithDictionary:[[ZZUserHelper shareInstance].loginer.push_config toDictionary]];
    }
    return _param;
}

- (ZZDisturbTimePickerView *)pickerView {
    WeakSelf;
    if (!_pickerView) {
        _pickerView = [[ZZDisturbTimePickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view.window addSubview:_pickerView];
        
        _pickerView.chooseTime = ^(NSString *showString) {
            [weakSelf updateNopushTime:showString];
        };
    }
    return _pickerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
