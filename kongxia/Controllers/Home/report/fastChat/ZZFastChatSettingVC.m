
//
//  ZZFastChatSettingVC.m
//  zuwome
//注*  这边的闪聊设置有时间就重构了吧  写的耦合太高了 接手别人的头大
//  Created by YuTianLong on 2017/12/29.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZFastChatSettingVC.h"
#import "ZZFastChatOpenCell.h"
#import "ZZFastChatTextCell.h"
#import "ZZCallRecordsVC.h"
#import "ZZDisturbTimePickerView.h"
#import "ZZFastSuccessAlert.h"
#import "ZZOpenNotificationGuide.h"
#import "ZZPrivateChatPayManager.h"
#import "ZZFastChatAgreementVC.h"

@interface ZZFastChatSettingVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZZDisturbTimePickerView *pickerView;
@property (nonatomic, copy) NSString *timeString;

@property (nonatomic, strong) ZZUser *user;
@property (nonatomic, strong) NSMutableDictionary *param;

@property (nonatomic, strong) ZZFastSuccessAlert *fastSuccessAlert;

@end

@implementation ZZFastChatSettingVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (!_user) {
        _user = [ZZUserHelper shareInstance].loginer;
    }
    
    self.navigationItem.title = @"闪聊设置";
    self.view.backgroundColor = kBGColor;
    [self setupUI];
    
    NSMutableArray *vcs = self.navigationController.viewControllers.mutableCopy;
    if ([vcs[vcs.count - 2] isKindOfClass: [ZZFastChatAgreementVC class]]) {
        [vcs removeObjectAtIndex:vcs.count - 2];
    }
    [self.navigationController setViewControllers:vcs.copy];
    NSLog(@"******viewController: %@", self.navigationController.viewControllers.mutableCopy);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = AdaptedHeight(87);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[ZZFastChatOpenCell class] forCellReuseIdentifier:[ZZFastChatOpenCell reuseIdentifier]];
        [_tableView registerClass:[ZZFastChatTextCell class] forCellReuseIdentifier:[ZZFastChatTextCell reuseIdentifier]];
    }
    return _tableView;
}

- (ZZDisturbTimePickerView *)pickerView
{
    WeakSelf;
    if (!_pickerView) {
        _pickerView = [[ZZDisturbTimePickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view.window addSubview:_pickerView];
        
        _pickerView.chooseTime = ^(NSString *showString) {
            [weakSelf updateFastChatTime:showString];
        };
    }
    return _pickerView;
}

- (NSMutableDictionary *)param {
    if (!_param) {
        _param = [NSMutableDictionary dictionaryWithDictionary:[[ZZUserHelper shareInstance].loginer.push_config toDictionary]];
    }
    return _param;
}

#pragma mark - Private methods

- (void)setupUI {
    
    _timeString = [NSString stringWithFormat:@"%@至%@", _user.push_config.qchat_push_begin_at , _user.push_config.qchat_push_end_at];
    if ([_timeString isEqualToString:@"00:00至00:00"]) {
        _timeString = [NSString stringWithFormat:@"(全天)  %@",_timeString];
    }
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(@0);
    }];
    
    if (self.isShow) {//弹窗
        //自定义弹窗
        [NSObject asyncWaitingWithTime:0.5f completeBlock:^{
            [ZZFastSuccessAlert showWithType: [UserHelper isAvatarManualReviewing] ? ToastReviewing : ToastSuccess action:^{
                
            }];
        }];
    }
}

- (void)switchDidChange:(UISwitch *)openSwitch {
    
    [MobClick event:Event_click_FastChat_Set_Switch];
    WEAK_SELF();
    if (!openSwitch.on) {//关闭时给弹窗提示
        
        [UIAlertController presentAlertControllerWithTitle:@"关闭后你将不出现在闪聊列表推荐中\n无法获得更多收益机会" message:nil doneTitle:@"确认关闭" cancelTitle:@"我再想想" completeBlock:^(BOOL isCancelled) {
            if (!isCancelled) {
                [weakSelf updateSwitchStatusWithSwitch:openSwitch];
            } else {
                openSwitch.on = YES;
            }
        }];
        return;
    }else{
        [ ZZOpenNotificationGuide showShanChatPromptWhenUserOpenSanChatSwitch:self heightProportion:0.4 showMessageTitle:@"及时响应闪聊视频电话，获得更多收益" showImageName:@"open_Notification_bgPopupReport"];
    }
    [weakSelf updateSwitchStatusWithSwitch:openSwitch];
}

- (void)updateSwitchStatusWithSwitch:(UISwitch *)openSwitch {
    
    BOOL isOn = openSwitch.on;
    [self.param setObject:[NSNumber numberWithBool:isOn] forKey:@"qchat_push"];
    ZZUser *model = [[ZZUser alloc] init];
    [model updateWithParam:@{@"push_config" : self.param} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if(error) {
            [ZZHUD showErrorWithStatus:error.message];
            openSwitch.on = !isOn;
        } else {
            _user = [[ZZUser alloc] initWithDictionary:data error:nil];
            _user.push_config.qchat_push = isOn;

            
            
            [[ZZUserHelper shareInstance] saveLoginer:[_user toDictionary] postNotif:NO];
            [self.tableView reloadData];
        }
    }];
}

- (void)updateFastChatTime:(NSString *)string {
    
    NSArray *array = [string componentsSeparatedByString:@"至"];
    if (array.count == 2) {
        _param = [NSMutableDictionary dictionaryWithDictionary:[[ZZUserHelper shareInstance].loginer.push_config toDictionary]];
        [self.param setObject:array[0] forKey:@"qchat_push_begin_at"];
        [self.param setObject:array[1] forKey:@"qchat_push_end_at"];
        ZZUser *model = [[ZZUser alloc] init];
        [model updateWithParam:@{@"push_config" : self.param} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
                [_tableView reloadData];
            } else {
                if (array.count == 2) {
                    _user = [ZZUserHelper shareInstance].loginer;
                    _user.push_config.qchat_push_begin_at = array[0];
                    _user.push_config.qchat_push_end_at = array[1];
                    [_param setObject:array[0] forKey:@"qchat_push_begin_at"];
                    [_param setObject:array[1] forKey:@"qchat_push_end_at"];
                    _timeString = [NSString stringWithFormat:@"%@至%@",_user.push_config.qchat_push_begin_at,_user.push_config.qchat_push_end_at];
                    if ([_timeString isEqualToString:@"00:00至00:00"]) {
                        _timeString = [NSString stringWithFormat:@"(全天)  %@",_timeString];
                    }
                }
                [_tableView reloadData];
                [[ZZUserHelper shareInstance] saveLoginer:[_user toDictionary] postNotif:NO];
            }
        }];
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        // 是否有开启闪聊
        return  _user.push_config.qchat_push ?2:1;

    } else if (section == 1) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0 ) {
            ZZFastChatOpenCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[ZZFastChatOpenCell reuseIdentifier] forIndexPath:indexPath];
            cell.leftLabel.text = @"开启闪聊推荐";
            
            cell.openSwitch.on = _user.push_config.qchat_push;
            if (cell.openSwitch.on) {
                cell.promptLable.text = @"保持在线可获得更多1V1视频推荐机会,忙碌时请关闭";
            }else{
                cell.promptLable.text = @"开启后可获得更多私信和视频通话邀请";

            }
            [cell.openSwitch addTarget:self action:@selector(switchDidChange:) forControlEvents:UIControlEventValueChanged];
            return cell;
        } else  {
            
            ZZFastChatTextCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[ZZFastChatTextCell reuseIdentifier] forIndexPath:indexPath];
            [cell setupWithModel:nil indexPath:indexPath];
            cell.rightLabel.text = _timeString;
            return cell;
        }
        
        
    } else if (indexPath.section == 1) {

        ZZFastChatTextCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[ZZFastChatTextCell reuseIdentifier] forIndexPath:indexPath];
        [cell setupWithModel:nil indexPath:indexPath];
        cell.rightLabel.text = @"";
        return cell;
    }
  
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            [self.pickerView show:_timeString];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {    //通话记录
            [MobClick event:Event_click_FastChat_CallRecords];
            ZZCallRecordsVC *vc = [ZZCallRecordsVC new];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}





@end
