//
//  ZZSettingNotificationViewController.m
//  zuwome
//
//  Created by angBiu on 16/9/12.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZSettingNotificationViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "ZZSettingSwitchCell.h"
#import "ZZDisturbTimeCell.h"
#import "ZZDisturbTimePickerView.h"
#import "ZZSystemToolsManager.h"
#import "ZZUserDefaultsHelper.h"
#import "ZZSettingTitleSwitchCell.h"
#import "ZZSettingSubtitleSwitchCell.h"

#define NO_LONGER_REMIND    (@"NO_LONGER_REMIND")

@interface ZZSettingNotificationViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView                     *_tableView;
    NSMutableDictionary             *_param;
}

@property (nonatomic, strong) ZZDisturbTimePickerView *pickerView;
@property (nonatomic, strong) NSString *timeString;
@property (nonatomic,assign) BOOL lastOpenNotification;//用于记录上次的开启通知的状态
@end

@implementation ZZSettingNotificationViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_pickerView) {
        [_pickerView removeFromSuperview];
        _pickerView = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (!self.user) {
        self.user = [ZZUserHelper shareInstance].loginer;
    }
    self.navigationItem.title = @"新消息提醒";
    self.automaticallyAdjustsScrollViewInsets = NO;
    // app从后台进入前台都会调用这个方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    [self createViews];
    _lastOpenNotification = [GetSystemToolsManager() isOpenSystemNotification];
    if (![ZZUserDefaultsHelper objectForDestKey:NO_LONGER_REMIND]) {
        
        if (![GetSystemToolsManager() isOpenSystemNotification]) {
            [UIAlertController presentAlertControllerWithTitle:nil message:@"你现在无法收到新消息通知。请到系统“设置”-“通知”-“空虾”中开启。" doneTitle: @"前往开启" cancelTitle:@"不再提醒" completeBlock:^(BOOL isCancelled) {
                if (isCancelled) {
                    [ZZUserDefaultsHelper setObject:@"1" forDestKey:NO_LONGER_REMIND];
                } else {
                    if (UIApplicationOpenSettingsURLString != NULL) {
                        NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        [[UIApplication sharedApplication] openURL:appSettings options:@{} completionHandler:NULL];
                    }
                }
            }];
        }
    }
}

/**
 当用户更改了通知状态  及时刷新界面
 */
- (void)applicationBecomeActive {
    BOOL isOpenNotification =  [GetSystemToolsManager() isOpenSystemNotification];
    if (isOpenNotification !=_lastOpenNotification) {
         UIView *headerView = [self tableViewHeaderView];
        _tableView.tableHeaderView = headerView;
        _lastOpenNotification = isOpenNotification;
        [_tableView  reloadData];
    }
}

- (void)createViews {
    UIView *headerView = [self tableViewHeaderView];
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = headerView;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 20.0;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[ZZSettingTitleSwitchCell class]
       forCellReuseIdentifier:[ZZSettingTitleSwitchCell cellIdentifier]];
    
    [_tableView registerClass:[ZZSettingSubtitleSwitchCell class]
       forCellReuseIdentifier:[ZZSettingSubtitleSwitchCell cellIdentifier]];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.height.mas_equalTo(self.view.height -NAVIGATIONBAR_HEIGHT-SafeAreaBottomHeight);
    }];
    
    _param = [@{
                @"chat": [NSNumber numberWithBool:_user.push_config.chat],
                @"following": [NSNumber numberWithBool:_user.push_config.following],
                @"reply": [NSNumber numberWithBool:_user.push_config.reply],
                @"like": [NSNumber numberWithBool:_user.push_config.like],
                @"tip": [NSNumber numberWithBool:_user.push_config.tip],
                @"mmd_following": [NSNumber numberWithBool:_user.push_config.mmd_following],
                @"red_packet_msg": [NSNumber numberWithBool:_user.push_config.red_packet_msg],
                @"system_msg": [NSNumber numberWithBool:_user.push_config.system_msg],
                @"red_packet_following": [NSNumber numberWithBool:_user.push_config.red_packet_following],
                @"sk_following": [NSNumber numberWithBool:_user.push_config.sk_following],
                @"need_sound": [NSNumber numberWithBool:_user.push_config.need_sound],
                @"need_shake": [NSNumber numberWithBool:_user.push_config.need_shake],
                @"no_push": [NSNumber numberWithBool:_user.push_config.no_push],
                @"push_hide_name": [NSNumber numberWithBool:_user.push_config.push_hide_name]
    } mutableCopy];
    
    if (!isNullString(_user.push_config.no_push_begin_at)) {
        [_param setObject:_user.push_config.no_push_begin_at forKey:@"no_push_begin_at"];
        [_param setObject:_user.push_config.no_push_end_at forKey:@"no_push_end_at"];
    }
    
    if (!isNullString(_user.push_config.no_push_begin_at)) {
        _timeString = [NSString stringWithFormat:@"%@至%@",_user.push_config.no_push_begin_at,_user.push_config.no_push_end_at];
    }
    else {
        _timeString = [NSString stringWithFormat:@"23:00至06:00"];
    }
}

- (UIView *)tableViewHeaderView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 94.5)];
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor whiteColor];
    
    UILabel *receiveLabel = [UILabel new];
    receiveLabel.text = @"接收推送通知";
    receiveLabel.textColor = [UIColor blackColor];
    receiveLabel.font = [UIFont systemFontOfSize:15];
    
    UILabel *stateLbale = [UILabel new];
    stateLbale.text = [GetSystemToolsManager() isOpenSystemNotification] ? @"已开启" : @"未开启";
    stateLbale.textAlignment = NSTextAlignmentRight;
    stateLbale.textColor = [UIColor grayColor];
    stateLbale.font = [UIFont systemFontOfSize:15];
   
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kLineViewColor;
    
    [bgView addSubview:receiveLabel];
    [bgView addSubview:stateLbale];
    [bgView addSubview:lineView];
    [view addSubview:bgView];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpOpenNotification)];
    [bgView addGestureRecognizer:gesture];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(@0);
        make.height.equalTo(@50);
    }];
    [receiveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.leading.equalTo(@15);
        make.width.equalTo(@120);
    }];

    if (!GetSystemToolsManager().isOpenSystemNotification) {
        UIImageView *arrowImage =  [[UIImageView alloc]init];
        arrowImage.image = [UIImage imageNamed:@"icStoryMore"];
        [bgView addSubview:arrowImage];
        [arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(@(-15));
            make.centerY.equalTo(receiveLabel.mas_centerY);
        }];
        [stateLbale mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(@0);
            make.right.equalTo(arrowImage.mas_left).offset(-8);
            make.width.equalTo(@80);
        }];
     
    }
    else {
        [stateLbale mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(@0);
            make.trailing.equalTo(@(-15));
            make.width.equalTo(@80);
        }];
    }
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@15);
        make.trailing.equalTo(@(-15));
        make.bottom.equalTo(bgView.mas_bottom);
        make.height.equalTo(@0.5);
    }];
    
    UILabel *tips = [UILabel new];
    tips.text = @"要开启或关闭空虾的推送通知，请在iPhone的“设置”-“通知”中找到“空虾”进行设置";
    tips.textColor = RGBCOLOR(161, 161, 161);

    tips.font = [UIFont systemFontOfSize:12];
    tips.numberOfLines = 0;
    
    [view addSubview:tips];
    [tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@15);
        make.trailing.equalTo(@(-15));
        make.top.equalTo(bgView.mas_bottom).offset(4.5);
        make.bottom.equalTo(view).offset(-7.5);
    }];
    return view;
}

#pragma mark - UITableViewMethod
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: {
            return _user.push_config.no_push ? 9 : 8;
            break;
        }
        case 1: {
            return 1;
            break;
        }
        default: {
            return 2;
            break;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isOpen = [GetSystemToolsManager() isOpenSystemNotification];
    if (indexPath.row == 9) {
        ZZDisturbTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timecell"];
        
        if (!cell) {
            cell = [[ZZDisturbTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"timecell"];
        }
        
        if (!isNullString(_user.push_config.no_push_begin_at)) {
            _timeString = [NSString stringWithFormat:@"%@至%@",_user.push_config.no_push_begin_at,_user.push_config.no_push_end_at];
        }
        cell.contentLabel.text = _timeString;
        
        return cell;
    }
    
    NSString *title = nil, *subTitle = nil;
    BOOL enable = NO, lineHidden = NO;
    
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    // 私信
                    title = @"私信";
                    enable = isOpen ? _user.push_config.chat : NO;
                    break;
                }
                case 1: {
                    // 关注
                    title = @"关注";
                    enable = isOpen ?  _user.push_config.following : NO;
                    break;
                }
                case 2: {
                    title = @"评论";
                    enable =  isOpen ? _user.push_config.reply : NO;
                    break;
                }
                case 3: {
                    title = @"点赞";
                    enable = isOpen ?  _user.push_config.like : NO;
                    break;
                }
                case 4: {
                    title = @"打赏";
                    enable =  isOpen ? _user.push_config.tip : NO;
                    break;
                }
                case 5: {
                    title = @"系统通知";
                    enable =  isOpen ? _user.push_config.system_msg : NO;
                    break;
                }
//                case 6: {
//                    title = @"招呼推送";
//                    subTitle = @"打开时，收到新的招呼时将推送给你";
//                    enable =  isOpen ? _user.push_config.say_hi : NO;
//                    break;
//                }
                case 6:  {
                    title = @"么么答推送";
                    subTitle = @"打开时，你关注的人发布么么答时将推送给你";
                    enable =  isOpen ? _user.push_config.mmd_following : NO;
                    break;
                }
                case 7: {
                    title = @"瞬间推送";
                    subTitle = @"打开时，你关注的人发布瞬间时将推送给你";
                    enable =  isOpen ? _user.push_config.sk_following : NO;
                    break;
                }
//                case 9: {
//                    title = @"接收短信";
//                    subTitle = @"打开时，你将会收到短信提醒";
//                    enable =  isOpen ? _user.push_config.sms_push : NO;
//                    break;
//                }
                    
//                case 8: {
//                    title = @"免打扰时段";
//                    enable =  isOpen ? _user.push_config.no_push : NO;
//                    break;
//                }
                default:
                    break;
            }
            break;
        }
        case 1: {
            lineHidden = YES;
            title = @"通知显示消息详情";
            subTitle = @"关闭时，你收到的消息将隐藏发信人和内容";
            enable =  isOpen ? _user.push_config.push_hide_name : NO;
            break;
        }
        default: {
            switch (indexPath.row) {
                case 0: {
                    lineHidden = YES;
                    title = @"新通知声音";
                    enable =  isOpen ? _user.push_config.need_sound : NO;
                    break;
                }
                case 1: {
                    title = @"振动";
                    enable =  isOpen ? _user.push_config.need_shake : NO;
                    break;
                }
                default:
                    break;
            }
            break;
        }
    }
    
    NSLog(@"switch is %@", enable ? @"YES" : @"NO");
    if (isNullString(subTitle)) {
        ZZSettingTitleSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZSettingTitleSwitchCell cellIdentifier] forIndexPath:indexPath];
        cell.titleLabel.text   = title;
        cell.settingSwitch.on  = enable;
        cell.lineView.hidden   = lineHidden;
        cell.settingSwitch.tag = indexPath.row + 100*indexPath.section + 100;
        [cell.settingSwitch addTarget:self action:@selector(switchDidChange:) forControlEvents:UIControlEventValueChanged];
        return cell;
    }
    else {
        ZZSettingSubtitleSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZSettingSubtitleSwitchCell cellIdentifier] forIndexPath:indexPath];
        cell.titleLabel.text    = title;
        cell.subTitleLabel.text = subTitle;
        cell.settingSwitch.on   = enable;
        cell.lineView.hidden    = lineHidden;
        cell.settingSwitch.tag  = indexPath.row + 100 * indexPath.section + 100;
        [cell.settingSwitch addTarget:self action:@selector(switchDidChange:) forControlEvents:UIControlEventValueChanged];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2 || section == 1) {
        return 0.1;
    }
    else {
        return 20;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2 || section == 1) {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    }
    else {
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        return footView;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 9) {
        [self.pickerView show:_timeString];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - UISwitchMethod

- (void)switchDidChange:(UISwitch *)sender {
    BOOL isOn = sender.on;
    NSMutableDictionary *aDict = [NSMutableDictionary dictionaryWithDictionary:_param];
    switch (sender.tag - 100) {
        case 0: {
            [aDict setObject:[NSNumber numberWithBool:!_user.push_config.chat] forKey:@"chat"];
            break;
        }
        case 1: {
            [aDict setObject:[NSNumber numberWithBool:!_user.push_config.following] forKey:@"following"];
            break;
        }
        case 2: {
            [aDict setObject:[NSNumber numberWithBool:!_user.push_config.reply] forKey:@"reply"];
            break;
        }
        case 3: {
            [aDict setObject:[NSNumber numberWithBool:!_user.push_config.like] forKey:@"like"];
            break;
        }
        case 4: {
            [aDict setObject:[NSNumber numberWithBool:!_user.push_config.tip] forKey:@"tip"];
            break;
        }
        case 5: {
            [aDict setObject:[NSNumber numberWithBool:!_user.push_config.system_msg] forKey:@"system_msg"];
             break;
        }
//        case 6: {
//            [aDict setObject:[NSNumber numberWithBool:!_user.push_config.say_hi] forKey:@"say_hi"];
//            break;
//        }
        case 6: {
            [aDict setObject:[NSNumber numberWithBool:!_user.push_config.mmd_following] forKey:@"mmd_following"];
            break;
        }
        case 7: {
            [aDict setObject:[NSNumber numberWithBool:!_user.push_config.sk_following] forKey:@"sk_following"];
            break;
        }
//        case 9: {
//            [aDict setObject:[NSNumber numberWithBool:!_user.push_config.sms_push] forKey:@"sms_push"];
//            break;
//        }
        case 8: {
            [aDict setObject:[NSNumber numberWithBool:!_user.push_config.no_push] forKey:@"no_push"];
            break;
        }
        case 100: {
            [aDict setObject:[NSNumber numberWithBool:!_user.push_config.push_hide_name] forKey:@"push_hide_name"];
            break;
        }
        case 200: {
            [aDict setObject:[NSNumber numberWithBool:!_user.push_config.need_sound] forKey:@"need_sound"];
            break;
        }
        case 201: {
            [aDict setObject:[NSNumber numberWithBool:!_user.push_config.need_shake] forKey:@"need_shake"];
            break;
        }
        default:
            break;
    }
    
    ZZUser *model = [[ZZUser alloc] init];
    [model updateWithParam:@{@"push_config":aDict} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
            sender.on = !isOn;
        }
        else {
            _param = [NSMutableDictionary dictionaryWithDictionary:aDict];
            
            switch (sender.tag - 100) {
                case 0: {
                    _user.push_config.chat = isOn;
                    if (isOn) {
                        [MobClick event:Event_click_notification_private_on];
                        if (_user.push_config.no_push) {
                            [self disableIMWithString:_timeString];
                        } else {
                            [self enableRCIM];
                        }
                    }
                    else {
                        [MobClick event:Event_click_notification_private_off];
                        [self disableRCIMWithStarTime:@"00:00:00" mins:1439];
                    }
                    
                    [[ZZUserHelper shareInstance] saveLoginer:_user postNotif:NO];
                    break;
                }
                case 1: {
                    _user.push_config.following = isOn;
                    if (isOn) {
                        [MobClick event:Event_click_notification_attent_on];
                    }
                    else {
                        [MobClick event:Event_click_notification_attent_off];
                    }
                    break;
                }
                case 2: {
                    _user.push_config.reply = isOn;
                    if (isOn) {
                        [MobClick event:Event_click_notification_comment_on];
                    }
                    else {
                        [MobClick event:Event_click_notification_comment_off];
                    }
                    break;
                }
                case 3: {
                    _user.push_config.like = isOn;
                    if (isOn) {
                        [MobClick event:Event_click_notification_zan_on];
                    }
                    else {
                        [MobClick event:Event_click_notification_zan_off];
                    }
                    break;
                }
                case 4: {
                    _user.push_config.tip = isOn;
                    if (isOn) {
                        [MobClick event:Event_click_notification_tip_on];
                    }
                    else {
                        [MobClick event:Event_click_notification_tip_off];
                    }
                    break;
                }
                case 5: {
                    _user.push_config.system_msg = isOn;
                    if (isOn) {
                        [MobClick event:Event_click_notification_sysmsg_on];
                    }
                    else {
                        [MobClick event:Event_click_notification_sysmsg_off];
                    }
                    break;
                }
//                case 6: {
//                    _user.push_config.say_hi = isOn;
//                    if (isOn) {
//                        [MobClick event:Event_click_notification_sayhi_on];
//                    }
//                    else {
//                        [MobClick event:Event_click_notification_sayhi_off];
//                    }
//                    break;
//                }
                case 6: {
                    _user.push_config.mmd_following = isOn;
                    if (isOn) {
                        [MobClick event:Event_click_notification_mmd_following_on];
                    }
                    else {
                        [MobClick event:Event_click_notification_mmd_following_off];
                    }
                    break;
                }
                case 7: {
                    _user.push_config.sk_following = isOn;
                    if (isOn) {
                        [MobClick event:Event_click_notification_sk_on];
                    }
                    else {
                        [MobClick event:Event_click_notification_sk_off];
                    }
                    break;
                }
//                case 9: {
//                    _user.push_config.sms_push = isOn;
//                    if (isOn) {
//                        [MobClick event:Event_click_notification_smspush_on];
//                    }
//                    else {
//                        [MobClick event:Event_click_notification_smspush_off];
//                    }
//                    break;
//                }
                case 8: {
                    _user.push_config.no_push = isOn;
                    if (isOn) {
                        [MobClick event:Event_click_notification_nopush_on];
                        if (_user.push_config.chat) {
                            [self disableIMWithString:_timeString];
                        }
                    }
                    else {
                        [MobClick event:Event_click_notification_nopush_off];
                        if (_user.push_config.chat) {
                            [self enableRCIM];
                        }
                    }
                    [_tableView reloadData];
                    break;
                }
                case 100: {
                    _user.push_config.push_hide_name = isOn;
                    if (isOn) {
                        [MobClick event:Event_click_notification_pushhidename_on];
                    }
                    else {
                        [MobClick event:Event_click_notification_pushhidename_off];
                    }
                    break;
                }
                case 200: {
                    _user.push_config.need_sound = isOn;
                    if (isOn) {
                        [MobClick event:Event_click_notification_sound_on];
                    }
                    else {
                        [MobClick event:Event_click_notification_sound_off];
                    }
                    break;
                }
                case 201: {
                    _user.push_config.need_shake = isOn;
                    if (isOn) {
                        [MobClick event:Event_click_notification_shake_on];
                    }
                    else {
                        [MobClick event:Event_click_notification_shake_off];
                    }
                    break;
                }
                default:
                    break;
            }
            [[ZZUserHelper shareInstance] saveLoginer:_user postNotif:NO];
        }
    }];
}

- (void)updateNopushTime:(NSString *)string {
    NSArray *array = [string componentsSeparatedByString:@"至"];
    NSMutableDictionary *aDict = [NSMutableDictionary dictionaryWithDictionary:_param];
    if (array.count == 2) {
        [aDict setObject:array[0] forKey:@"no_push_begin_at"];
        [aDict setObject:array[1] forKey:@"no_push_end_at"];
        ZZUser *model = [[ZZUser alloc] init];
        [model updateWithParam:@{@"push_config":aDict} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
                [_tableView reloadData];
            }
            else {
                if (array.count == 2) {
                    _user.push_config.no_push_begin_at = array[0];
                    _user.push_config.no_push_end_at = array[1];
                    [_param setObject:array[0] forKey:@"no_push_begin_at"];
                    [_param setObject:array[1] forKey:@"no_push_end_at"];
                    _timeString = [NSString stringWithFormat:@"%@至%@",_user.push_config.no_push_begin_at,_user.push_config.no_push_end_at];
                    [self disableIMWithString:_timeString];
                }
                [_tableView reloadData];
                [[ZZUserHelper shareInstance] saveLoginer:_user postNotif:NO];
            }
        }];
    }
}

- (void)disableIMWithString:(NSString *)string {
    NSArray *array = [string componentsSeparatedByString:@"至"];
    if (array.count == 2) {
        int left = [[array[0] stringByReplacingOccurrencesOfString:@":00" withString:@""] intValue];
        int right = [[array[1] stringByReplacingOccurrencesOfString:@":00" withString:@""] intValue];
        NSString *startTime = [NSString stringWithFormat:@"%@:00",array[0]];
        int minutes;
        if (left < right) {
            minutes = (right - left)*60;
        } else {
            minutes = (right + 24 - left)*60;
        }
        [self disableRCIMWithStarTime:startTime mins:minutes];
    }
}

- (void)enableRCIM {
    [[RCIMClient sharedRCIMClient] removeNotificationQuietHours:^{
        NSLog(@"success~~~~~~~~~~");
    } error:^(RCErrorCode status) {
        NSLog(@"failure~~~~~~~~~~");
    }];
}

- (void)disableRCIMWithStarTime:(NSString *)startTime mins:(int)mins {
    [[RCIMClient sharedRCIMClient] setNotificationQuietHours:startTime spanMins:mins success:^{
        NSLog(@"success~~~~~~~~~~");
    } error:^(RCErrorCode status) {
        NSLog(@"failure~~~~~~~~~~");
    }];
}

#pragma mark -
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

- (void)jumpOpenNotification {
    BOOL isOpen = [GetSystemToolsManager() isOpenSystemNotification];
    if (!isOpen) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]])
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:NULL];
        }else{
            NSLog(@"can not open");
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
