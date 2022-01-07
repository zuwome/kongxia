//
//  ZZSecurityOperationViewController.m
//  zuwome
//
//  Created by angBiu on 2017/8/18.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZSecurityOperationViewController.h"
#import "ZZEmergencyContactViewController.h"

#import "ZZSecurityOperationView.h"
#import "ZZSecurityOperationCoverView.h"
#import "ZZSecurityFloatView.h"

#import "ZZDateHelper.h"

#import <AgoraRtcKit/AgoraRtcEngineKit.h>
#import "ZZVideoPreProcessing.h"

@interface ZZSecurityOperationViewController () <AgoraRtcEngineDelegate>

@property (nonatomic, strong) ZZSecurityOperationView *operationView;
@property (nonatomic, strong) ZZSecurityOperationCoverView *coverView;
@property (nonatomic, strong) ZZSecurityFloatView *floatView;
@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) AgoraRtcEngineKit *agoraKit;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger timeCount;

@end

@implementation ZZSecurityOperationViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_coverView) {
        [_coverView removeFromSuperview];
    }
    if (_floatView) {
        [_floatView removeFromSuperview];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_test) {
        [self createViews];
    } else {
        [self loadData];
    }
}

- (void)loadData
{
    [ZZHUD showWithStatus:@"求救中..."];
    NSMutableDictionary *param = [@{@"oid":_orderId} mutableCopy];
    if ([ZZUserHelper shareInstance].location) {
        CLLocation *location = [ZZUserHelper shareInstance].location;
        [param setObject:[NSNumber numberWithFloat:location.coordinate.latitude] forKey:@"lat"];
        [param setObject:[NSNumber numberWithFloat:location.coordinate.longitude] forKey:@"lng"];
    }
    
    [ZZRequest method:@"GET"
                 path:@"/api/emergencycontact/pili_publish_url"
               params:param
                 next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [ZZHUD dismiss];
            [self startStreamWithUrl:data];
        }
    }];
}

- (void)startStreamWithUrl:(id)data
{
    _url = [data objectForKey:@"pili_publish_url"];
    [self.agoraKit joinChannelByToken:[data objectForKey:@"channel_key"] channelId:[data objectForKey:@"room_name"] info:nil uid:0 joinSuccess:nil];
}

- (void)createViews
{
    self.operationView.hidden = NO;
    if (_test) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CGRect rect = [self.operationView convertRect:self.operationView.recordBgView.frame toView:self.view.window];
            self.coverView.clearRect = rect;
            _count = 1;
            self.floatView.isUp = YES;
            self.floatView.infoString = @"求助开始 录音会自动上传作为帮助您的证据";
            [self.floatView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.view.window.mas_top).offset(rect.origin.y + rect.size.height + 15);
            }];
        });
    } else {
        if ([ZZUserHelper shareInstance].loginer.emergency_contacts.count) {
            [self notifyContacts];
        }
    }
    [self.timer fire];
}
//短信通知
- (void)notifyContacts
{
    if (!_test) {
        [ZZRequest method:@"POST" path:@"/api/user/notify/emergency_contacts" params:@{@"oid":_orderId} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else {
                self.operationView.notified = YES;
            }
        }];
    }
}

#pragma mark - AgoraRtcEngineDelegate

- (void)rtcEngineMediaEngineDidStartCall:(AgoraRtcEngineKit *)engine
{
    NSLog(@"");
}

- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didOccurError:(AgoraErrorCode)errorCode
{
    NSLog(@"%ld",errorCode);
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinChannel:(NSString*)channel withUid:(NSUInteger)uid elapsed:(NSInteger) elapsed
{
    if (!_operationView) {
        [self createViews];
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine reportAudioVolumeIndicationOfSpeakers:(NSArray*)speakers totalVolume:(NSInteger)totalVolume
{
    _operationView.audioLevel = totalVolume/255.0;
}

#pragma mark - UIButtonMethod

- (void)floatCloseBtnClick
{
    switch (_count) {
        case 1:
        {
            CGRect rect = [self.operationView convertRect:self.operationView.locationBgView.frame toView:self.view.window];
            self.coverView.clearRect = rect;
            
            _count = 2;
            [self.floatView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.view.window.mas_top).offset(rect.origin.y + rect.size.height + 15);
            }];
            _floatView.infoString = @"您的位置会上传给我们，便于更好的实施求助";
        }
            break;
        case 2:
        {
            CGRect rect = [self.operationView convertRect:self.operationView.contactBgView.frame toView:self.view.window];
            self.coverView.clearRect = rect;
            
            _count = 3;
            [self.floatView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.view.window.mas_top).offset(rect.origin.y + rect.size.height + 15);
            }];
            _floatView.infoString = @"您设置的紧急联系人将会收到您的位置信息短信";
        }
            break;
        case 3:
        {
            [self.floatView removeFromSuperview];
            [self.coverView removeFromSuperview];
        }
        default:
            break;
    }
}

- (void)navigationLeftBtnClick
{
    [UIAlertView showWithTitle:@"提示" message:@"您确定要退出紧急求助功能吗？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            WeakSelf;
            [_agoraKit leaveChannel:^(AgoraChannelStats * _Nonnull stat) {
                weakSelf.agoraKit = nil;
            }];
            [super navigationLeftBtnClick];
        }
    }];
}

#pragma mark - timer

- (void)timerEvent
{
    _timeCount++;
    _operationView.recordLabel.text = [NSString stringWithFormat:@"正在录音 %@",[ZZDateHelper getCountdownTimeString:_timeCount]];
}

#pragma mark - navigation

- (void)gotoContactSettingView
{
    ZZEmergencyContactViewController *controller = [[ZZEmergencyContactViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    controller.updateCallBack = ^{
        [self.operationView managerContactStatus];
        [self notifyContacts];
    };
}

#pragma mark - lazyload

- (ZZSecurityOperationView *)operationView
{
    WeakSelf;
    if (!_operationView) {
        _operationView = [[ZZSecurityOperationView alloc] init];
        [self.view addSubview:_operationView];
        
        [_operationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
        
        _operationView.audioLevel = 0.4;
        _operationView.touchContactSetting = ^{
            [weakSelf gotoContactSettingView];
        };
        _operationView.touchCancel = ^{
            [weakSelf navigationLeftBtnClick];
        };
    }
    return _operationView;
}

- (ZZSecurityOperationCoverView *)coverView
{
    if (!_coverView) {
        _coverView = [[ZZSecurityOperationCoverView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view.window addSubview:_coverView];
    }
    return _coverView;
}

- (ZZSecurityFloatView *)floatView
{
    WeakSelf;
    if (!_floatView) {
        _floatView = [[ZZSecurityFloatView alloc] init];
        [self.view.window addSubview:_floatView];
        
        [_floatView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.window.mas_top);
            make.centerX.mas_equalTo(self.view.window.mas_centerX);
        }];
        
        _floatView.showClose = YES;
        _floatView.touchClose = ^{
            [weakSelf floatCloseBtnClick];
        };
    }
    return _floatView;
}

- (AgoraRtcEngineKit *)agoraKit
{
    if (!_agoraKit) {
        _agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:AgoraAppId delegate:self];
        [_agoraKit enableAudio];
        //设置成直播模式才可推流
        [_agoraKit setChannelProfile:AgoraChannelProfileLiveBroadcasting];
        //双发都设置成主播
        [_agoraKit setClientRole:AgoraClientRoleBroadcaster];
//        [_agoraKit enableAudioVolumeIndication:200 smooth:3];
        [_agoraKit setParameters:(@"{\"che.video.enableRemoteViewMirror\":true}")];

        [_agoraKit addPublishStreamUrl:_url transcodingEnabled:YES];
//        AgoraPublisherConfiguration *configuration = [[AgoraPublisherConfiguration alloc] init];
//        configuration.owner = YES;
//        configuration.rawStreamUrl = _url;
//        [_agoraKit configPublisher:configuration];
    }
    return _agoraKit;
}

- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [ZZWeakTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
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

@end
