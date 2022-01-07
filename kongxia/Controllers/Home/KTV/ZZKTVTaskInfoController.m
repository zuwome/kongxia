//
//  ZZKTVTaskInfoController.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/30.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZKTVTaskInfoController.h"
#import "ZZChatViewController.h"
#import "ZZCreateSingingTaskController.h"

#import "ZZKTVSingingTaskSongsInfoCell.h"
#import "ZZKTVUserInfoCell.h"
#import "ZZKTVUserActionCell.h"
#import "ZZKTVlyricsCell.h"
#import "ZZKTVSingingTaskSingedUserHeaderView.h"
#import "ZZKTVRecordingView.h"
#import "ZZKTVRecordCompleteView.h"
#import "ZZEmptyCell.h"
#import "ZZKTVSingingTaskCompleteCell.h"
#import "ZZKTVlyricsCell.h"

#import "ZZKTVAudioPlayManager.h"
#import "ZZKTVConfig.h"
#import "faac.h"
#import "ESCFAACDecoder.h"
#import "ESCAACEncoder.h"
#import "AudioManager.h"
#import <RongIMLib/RongIMLib.h>
#import "ZZChatKTVModel.h"



@interface ZZKTVTaskInfoController () <UITableViewDelegate, UITableViewDataSource, ZZKTVSingingTaskSongsInfoCellDelegate, ZZKTVUserInfoCellDelegate, ZZKTVUserActionCellDelegate, ZZKTVRecordingViewDelegate,ZZKTVSingingTaskCompleteCellDelegate, ZZCreateSingingTaskControllerDelegate, ZZKTVAudioPlayManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSString *taskID;

@property (nonatomic, strong) ZZKTVRecordingView *recordingView;

@property (nonatomic, assign) NSInteger currentSelectSongIndex;

@property (nonatomic, strong) ZZKTVReceiveUserModel *currentPlayedSongModel;

@property (nonatomic, strong) ZZKTVAudioPlayManager *audioPlayManager;

@end

@implementation ZZKTVTaskInfoController

- (instancetype)initWithTaskModel:(ZZKTVModel *)model {
    self = [super init];
    if (self) {
        _taskID = model._id;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.greenColor;
    [self layoutNavigation];
    [self layout];
    [self fetchDetails];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor] cornerRadius:0]];
    self.navigationController.navigationBar.tintColor = kBlackTextColor;
    
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kYellowColor cornerRadius:0] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:kYellowColor cornerRadius:0]];
    self.navigationController.navigationBar.tintColor = kYellowColor;
    self.navigationController.navigationBar.translucent = NO;
    
    [self releaseAudioManager];
}


#pragma mark - private method
- (BOOL)canSing {
    // 头像可以报名逻辑: 有真实头像或者没有真实头像但是头像在人工审核中并且有旧的可用头像
    if (![UserHelper.loginer didHaveRealAvatar] && !([UserHelper.loginer isAvatarManualReviewing] && [UserHelper.loginer didHaveOldAvatar])) {
        [UIAlertController presentAlertControllerWithTitle:@"您未上传本人正脸五官清晰照，暂不可报名"
                                                   message:nil
                                                 doneTitle:@"去上传"
                                               cancelTitle:@"取消"
                                             completeBlock:^(BOOL isCancelled) {
                                                 if (!isCancelled) {
                                                     [self gotoUploadPicture];
                                                 }
                                             }];
        return NO;
    }
    
    // 性别必须符合
    if (_taskDetailsModel.task.gender != 3 && (_taskDetailsModel.task.gender != [ZZUserHelper shareInstance].loginer.gender)) {
        [ZZHUD showErrorWithStatus:@"您不符合他设置的性别要求，无法完成他的点唱任务哦"];
        return NO;
    }
    return YES;
}

- (void)startSingSong:(NSInteger)index {
    if ([self canSing]) {
        [[AudioManager audioManager] fetchRecordAuthentication:^(AVAudioSessionRecordPermission recordPermission) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (recordPermission == AVAudioSessionRecordPermissionDenied ) {
                    [UIAlertView showWithTitle:@"开启麦克风权限"
                                       message:@"在“设置-空虾”中开启麦克风就可以开始使用本功能哦~"
                             cancelButtonTitle:NSLocalizedString(@"取消", nil)
                             otherButtonTitles:@[NSLocalizedString(@"设置", nil)]
                                      tapBlock:
                     ^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                         if (buttonIndex) {
                             if (UIApplicationOpenSettingsURLString != NULL) {
                                 NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                 [[UIApplication sharedApplication] openURL:appSettings];
                             }
                         }
                     }];
                }
                else if (recordPermission == AVAudioSessionRecordPermissionGranted) {
                    [self showRecordingViewSongIndex:index];
                }
            });
        }];
        
    }
}

- (void)releaseAudioManager {
    [self stopPlaying];
    [self.audioPlayManager releasePlayer];
    _audioPlayManager = nil;
}

- (void)stopPlaying {
    [self.audioPlayManager stop];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_taskDetailsModel.receiveList enumerateObjectsUsingBlock:^(ZZKTVReceiveUserModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.isSongPlaying = NO;
        }];
        _taskDetailsModel.isPlaying = NO;
        _currentPlayedSongModel = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    });
}

- (void)startPlaying:(ZZKTVReceiveUserModel *)model {
    if (model == _currentPlayedSongModel) {
        if (self.audioPlayManager.isPlaying) {
            [self.audioPlayManager stop];
            model.isSongPlaying = NO;
            
        }
        _currentPlayedSongModel = nil;
        _taskDetailsModel.isPlaying = model.isSongPlaying;
        [_tableView reloadData];
        return;
    }
    
    _currentPlayedSongModel = model;
    [_taskDetailsModel.receiveList enumerateObjectsUsingBlock:^(ZZKTVReceiveUserModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj == model) {
            obj.isSongPlaying = YES;
        }
        else {
            obj.isSongPlaying = NO;
        }
    }];
    [self.audioPlayManager playAudio:model.content];
    _taskDetailsModel.isPlaying = model.isSongPlaying;
    [_tableView reloadData];
}

- (void)convertPCMToAAc:(NSString *)pcmPath completion:(void(^)(NSData *aacFileData))completion {
    ESCAACEncoder *aacEncoder = [[ESCAACEncoder alloc] init];
    [aacEncoder setupEncoderWithSampleRate:8000 channels:1 sampleBit:16];
    NSData *pcmData = [NSData dataWithContentsOfFile:pcmPath];
    NSData *aacData = [aacEncoder encodePCMDataWithPCMData:pcmData];
    [aacEncoder closeEncoder];
    
    if (completion) {
        completion(aacData ? aacData : nil);
    }
}

// 为pcm文件写入wav头
- (NSData*)writeWavHead:(NSData *)audioData {
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [NSNumber numberWithFloat: 8000],AVSampleRateKey, //采样率
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,//通道的数目
                                   [NSNumber numberWithInt:AVAudioQualityHigh], AVEncoderAudioQualityKey,
                                   nil];

    long sampleRate = [recordSetting[AVSampleRateKey] longValue];
    long numOfChannelsKey = [recordSetting[AVNumberOfChannelsKey] longValue];
    Byte waveHead[44];
    waveHead[0] = 'R';
    waveHead[1] = 'I';
    waveHead[2] = 'F';
    waveHead[3] = 'F';
    
    long totalDatalength = [audioData length] + 44;
    waveHead[4] = (Byte)(totalDatalength & 0xff);
    waveHead[5] = (Byte)((totalDatalength >> 8) & 0xff);
    waveHead[6] = (Byte)((totalDatalength >> 16) & 0xff);
    waveHead[7] = (Byte)((totalDatalength >> 24) & 0xff);
    
    waveHead[8] = 'W';
    waveHead[9] = 'A';
    waveHead[10] = 'V';
    waveHead[11] = 'E';
    
    waveHead[12] = 'f';
    waveHead[13] = 'm';
    waveHead[14] = 't';
    waveHead[15] = ' ';
    
    waveHead[16] = 16;  //size of 'fmt '
    waveHead[17] = 0;
    waveHead[18] = 0;
    waveHead[19] = 0;
    
    waveHead[20] = 1;   //format
    waveHead[21] = 0;
    
    waveHead[22] = numOfChannelsKey;   //chanel
    waveHead[23] = 0;
    
    waveHead[24] = (Byte)(sampleRate & 0xff);
    waveHead[25] = (Byte)((sampleRate >> 8) & 0xff);
    waveHead[26] = (Byte)((sampleRate >> 16) & 0xff);
    waveHead[27] = (Byte)((sampleRate >> 24) & 0xff);
    
    long byteRate = sampleRate * 2 * (16 >> 3);;
    waveHead[28] = (Byte)(byteRate & 0xff);
    waveHead[29] = (Byte)((byteRate >> 8) & 0xff);
    waveHead[30] = (Byte)((byteRate >> 16) & 0xff);
    waveHead[31] = (Byte)((byteRate >> 24) & 0xff);
    
    waveHead[32] = 2*(16 >> 3);
    waveHead[33] = 0;
    
    waveHead[34] = 16;
    waveHead[35] = 0;
    
    waveHead[36] = 'd';
    waveHead[37] = 'a';
    waveHead[38] = 't';
    waveHead[39] = 'a';
    
    long totalAudiolength = [audioData length];
    
    waveHead[40] = (Byte)(totalAudiolength & 0xff);
    waveHead[41] = (Byte)((totalAudiolength >> 8) & 0xff);
    waveHead[42] = (Byte)((totalAudiolength >> 16) & 0xff);
    waveHead[43] = (Byte)((totalAudiolength >> 24) & 0xff);
    
    NSMutableData *pcmData = [[NSMutableData alloc]initWithBytes:&waveHead length:sizeof(waveHead)];
    [pcmData appendData:audioData];
    
    
    return pcmData;
    //    [pcmData writeToFile:kVoiceWav atomically:true];
    
}

- (void)changeTaskStateWithType:(KTVTaskGiftReceiveStatus)receiveStatus {
    if (receiveStatus == ReceiveStatusMine) {
        _taskDetailsModel.receiveStatus = 1;
        if (_taskDetailsModel.task.gift_last_count == 1) {
            _taskDetailsModel.task.gift_last_count = 0;
        }
    }
    else if (receiveStatus == ReceiveStatusEmpty) {
        _taskDetailsModel.task.gift_last_count = 0;
    }
    [_tableView reloadData];
}


#pragma mark - response method
- (void)navigationLeftBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - ZZKTVAudioPlayManagerDelegate
- (void)managerDidFinish:(ZZKTVAudioPlayManager *)manager {
    [self stopPlaying];
}


#pragma mark - ZZKTVRecordingViewDelegate
- (void)view:(ZZKTVRecordingView *)view recogniteComplete:(NSString *)pcmFile fileDuration:(NSTimeInterval)duration {
    WeakSelf
    [self uploadTask:pcmFile duration:duration completeHandler:^(BOOL isSuccess, NSString *songUrl, NSInteger errorCode) {
        [weakSelf.recordingView removeFromSuperview];
        weakSelf.recordingView = nil;

        [weakSelf fetchDetails];
        
        if (isSuccess || (!isSuccess && errorCode == 304)) {
            BOOL isSingSuccess = YES;
            if (!isSuccess && errorCode == 304) {
                isSingSuccess = NO;
            }
            [self showCompleteViewIsSuccess:isSingSuccess];
            
            [weakSelf sendMessage:weakSelf.taskDetailsModel songUrl:songUrl completeStatus:isSingSuccess];
        }
    }];
}


#pragma mark - ZZKTVUserActionCellDelegate
- (void)cell:(ZZKTVUserActionCell *)cell chat:(id)model {
    if ([model isKindOfClass:[ZZKTVReceiveUserModel class]]) {
        [self gotoChat:((ZZKTVReceiveUserModel *)model).to shouldShowGift:NO];
    }
}

- (void)cell:(ZZKTVUserActionCell *)cell sendGift:(id)model {
    if ([model isKindOfClass:[ZZKTVReceiveUserModel class]]) {
        [self gotoChat:((ZZKTVReceiveUserModel *)model).to shouldShowGift:YES];
    }
}


#pragma mark - ZZKTVUserInfoCellDelegate
- (void)cell:(ZZKTVUserInfoCell *)cell showUserInfo:(id)model {
    if ([model isKindOfClass:[ZZKTVReceiveUserModel class]]) {
        [self showUserInfo:((ZZKTVReceiveUserModel *)model).to];
    }
}

- (void)cell:(ZZKTVUserInfoCell *)cell startPlay:(id)model {
    if ([model isKindOfClass:[ZZKTVReceiveUserModel class]]) {
        [self startPlaying:(ZZKTVReceiveUserModel *)model];
    }
}


#pragma mark - ZZKTVSingingTaskSongsInfoCellDelegate
- (void)cell:(ZZKTVSingingTaskSongsInfoCell *)cell startSingSelectedSong:(NSInteger)index {
    [self startSingSong:index];
    NSLog(@"page index is %ld select song is %@", index, _taskDetailsModel.task.song_list[index].name);
}

- (void)cell:(ZZKTVSingingTaskSongsInfoCell *)cell showTaskOwner:(ZZKTVDetailsModel *)taskModel {
    [self showUserInfo:taskModel.task.from];
}


#pragma mark - ZZKTVSingingTaskCompleteCellDelegate
- (void)comepleteCellStartToPlay:(ZZKTVSingingTaskCompleteCell *)cell {
    __block ZZKTVReceiveUserModel *model = nil;
    [_taskDetailsModel.receiveList enumerateObjectsUsingBlock:^(ZZKTVReceiveUserModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.to.uid isEqualToString:[ZZUserHelper shareInstance].loginer.uid]) {
            *stop = YES;
            model = obj;
        }
    }];
    
    if (!model) {
        return;
    }
    
    [self startPlaying:model];
}

- (void)comepleteCellGoPostTask:(ZZKTVSingingTaskCompleteCell *)cell {
    [self goCreateTask];
}

- (void)completeCell:(ZZKTVSingingTaskCompleteCell *)cell showTaskOwner:(ZZKTVDetailsModel *)taskModel {
    [self showUserInfo:taskModel.task.from];
}


#pragma mark - ZZCreateSingingTaskController
- (void)controllerCreateSuccess:(ZZCreateSingingTaskController *)controller {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (_taskDetailsModel.receiveList.count == 0 ? 1 : _taskDetailsModel.receiveList.count) + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else {
        if (_taskDetailsModel.receiveList.count == 0) {
            return 1;
        }
        else {
            if ([_taskDetailsModel.receiveList[section - 1].to.uid isEqualToString:[ZZUserHelper shareInstance].loginer.uid]) {
                if (_taskDetailsModel.receiveList[section - 1].isSongPlaying) {
                    return 2;
                }
                else {
                    return 1;
                }
            }
            else {
                if (_taskDetailsModel.receiveList[section - 1].isSongPlaying) {
                    return 3;
                }
                else {
                    return 2;
                }
            }
            
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (_taskDetailsModel.receiveStatus == 1 || _taskDetailsModel.areGiftsAllCollected) {
            ZZKTVSingingTaskCompleteCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZKTVSingingTaskCompleteCell cellIdentifier] forIndexPath:indexPath];
            cell.delegate = self;
            cell.taskDetailModel = _taskDetailsModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else {
            ZZKTVSingingTaskSongsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZKTVSingingTaskSongsInfoCell cellIdentifier] forIndexPath:indexPath];
            cell.delegate = self;
            cell.taskDetailModel = _taskDetailsModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else {
        if (_taskDetailsModel.receiveList.count == 0) {
            ZZEmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZEmptyCell cellIdentifier] forIndexPath:indexPath];
            [cell configureData:5];
            return cell;
        }
        else {
            if (indexPath.row == 0) {
                ZZKTVUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZKTVUserInfoCell cellIdentifier] forIndexPath:indexPath];
                cell.delegate = self;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.receiverModel = _taskDetailsModel.receiveList[indexPath.section - 1];
                [cell didReceivedGift:!(isNullString(_taskDetailsModel.receiveList[indexPath.section - 1].gift_recording))
                            giftModel:_taskDetailsModel.task.gift];
                return cell;
            }
            else if (indexPath.row == 1) {
                if (_taskDetailsModel.receiveList[indexPath.section - 1].isSongPlaying) {
                    ZZKTVlyricsCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZKTVlyricsCell cellIdentifier] forIndexPath:indexPath];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.songModel = _taskDetailsModel.receiveList[indexPath.section - 1].song;
                    return cell;
                }
                else {
                    ZZKTVUserActionCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZKTVUserActionCell cellIdentifier] forIndexPath:indexPath];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.delegate = self;
                    cell.receiverModel = _taskDetailsModel.receiveList[indexPath.section - 1];
                    return cell;
                }
            }
            else {
                ZZKTVUserActionCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZKTVUserActionCell cellIdentifier] forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
                cell.receiverModel = _taskDetailsModel.receiveList[indexPath.section - 1];
                return cell;
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 44.0;
    }
    else {
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        ZZKTVSingingTaskSingedUserHeaderView *header = [[ZZKTVSingingTaskSingedUserHeaderView alloc] init];
        header.taskModel = _taskDetailsModel.task;
        return header;
    }
    else {
        return [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 0.01)];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0 || section == _taskDetailsModel.receiveList.count) {
        return 0.01;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0 || section == _taskDetailsModel.receiveList.count) {
        return [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 0.01)];
    }
    else {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 10)];
        footerView.backgroundColor = RGBCOLOR(245, 245, 245);
        return footerView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
//        if (_taskDetailsModel.receiveStatus == 1) {
//            return 255.0;
//        }
//        else if (_taskDetailsModel.areGiftsAllCollected) {
//            return 200.0;
//        }
//        else {
            return UITableViewAutomaticDimension;
//        }
    }
    else {
        if (_taskDetailsModel.receiveList.count == 0) {
            return 300.0;
        }
        else {
            if (indexPath.row == 0) {
                return 101.0;
            }
            else if (indexPath.row == 1) {
                if (_taskDetailsModel.receiveList[indexPath.section - 1].isSongPlaying) {
                    return UITableViewAutomaticDimension;
                }
                else {
                    return 61.0;
                }
            }
            else {
                return 61.0;
            }
        }
    }
}


#pragma mark - Navigator
/**
 聊天
 */
- (void)gotoChat:(ZZUser *)user shouldShowGift:(BOOL)showGift {
    ZZChatViewController *chatController = [[ZZChatViewController alloc] init];
    chatController.nickName = user.nickname;
    chatController.uid = user.uid;
    chatController.portraitUrl = user.avatar;
    chatController.shouldShowGift = showGift;
    chatController.giftEntry = GiftEntryKTV;
    [self.navigationController pushViewController:chatController animated:YES];
}

/**
 用户信息
 */
- (void)showUserInfo:(ZZUser *)user {
    ZZRentViewController *controller = [[ZZRentViewController alloc] init];
    controller.uid = user.uid;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)goCreateTask {
    ZZCreateSingingTaskController *controller = [[ZZCreateSingingTaskController alloc] init];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 没有头像，则上传真实头像
 */
- (void)gotoUploadPicture {
    ZZPerfectPictureViewController *vc = [ZZPerfectPictureViewController new];
    vc.isFaceVC = NO;
    vc.faces = [ZZUserHelper shareInstance].loginer.faces;
    vc.user = [ZZUserHelper shareInstance].loginer;
    //    vc.from = _user;//不需要用到
    vc.type = NavigationTypePublishTask;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Request
- (void)fetchDetails {
    [ZZHUD show];
    [ZZKTVServer fetchTaskDetailsWithTaskID:_taskID completeHandler:^(BOOL isSuccess, ZZKTVDetailsModel *taskDetailsModel) {
        [ZZHUD dismiss];
        if (isSuccess) {
            _taskDetailsModel = taskDetailsModel;
        }
        [_tableView reloadData];
    }];
}

- (void)uploadToQN:(NSData *)accData duration:(NSTimeInterval)duration complete:(void(^)(BOOL isComplete, NSString *filePath))completeHandler {
    NSString *fileName = [NSString stringWithFormat:@"song/%@_%@_%ld.aac",[ZZUserHelper shareInstance].loginer.ZWMId, [[ZZDateHelper shareInstance] fetchTimeForKTV], (NSInteger)duration];
    [ZZUploader uploadAacData:accData fileName:fileName success:^(NSString *url) {
        if (completeHandler) {
            completeHandler(YES, url);
        }
    } failure:^{
        if (completeHandler) {
            completeHandler(NO, nil);
        }
    }];
    
}

- (void)uploadTask:(NSString *)filePath
          duration:(NSTimeInterval)duration
          completeHandler:(void(^)(BOOL isSuccess, NSString *songUrl, NSInteger errorCode))completeHandler {
    WeakSelf
    
    [ZZHUD show];
    // 先转换格式成WAV
    NSData *pcmData = [NSData dataWithContentsOfFile:filePath];
    NSData *wavData = [self writeWavHead:pcmData];
    if (!wavData) {
        [ZZHUD dismiss];
        [ZZHUD showErrorWithStatus:@"转码失败,请重试"];
        if (completeHandler) {
            completeHandler(NO, nil, 999);
        }
        return;
    }
    [AudioManager deleteAudio:filePath];
    [weakSelf uploadToQN:wavData duration:duration complete:^(BOOL isComplete, NSString *filePath) {
        if (!isComplete) {
            
            [ZZHUD showErrorWithStatus:@"转码失败,请重试"];
            if (completeHandler) {
                completeHandler(NO, nil, 990);
            }
            return;
        }
        
        [ZZKTVServer uploadTaskID:_taskDetailsModel.task._id
                              sid:_taskDetailsModel.task.song_list[_currentSelectSongIndex]._id
                          songURL:filePath
                  completeHandler:^(BOOL isSuccess, NSInteger errorCode, NSString *errorMsg) {
            [ZZHUD dismiss];
            if (!isSuccess) {
                [ZZHUD showErrorWithStatus:errorMsg];
            }
            if (completeHandler) {
                completeHandler(isSuccess, filePath, errorCode);
            }
        }];
    }];
//    NSData *wavData [ZZKTVTaskInfoController :pcmData];
//    [self convertPCMToAAc:filePath completion:^(NSData *aacFileData) {
//        if (!aacFileData) {
//            [ZZHUD dismiss];
//            [ZZHUD showErrorWithStatus:@"转码失败,请重试"];
//            if (completeHandler) {
//                completeHandler(NO, nil, 999);
//            }
//            return;
//        }
//        [AudioManager deleteAudio:filePath];
//        [weakSelf uploadToQN:aacFileData duration:duration complete:^(BOOL isComplete, NSString *filePath) {
//            if (!isComplete) {
//
//                [ZZHUD showErrorWithStatus:@"转码失败,请重试"];
//                if (completeHandler) {
//                    completeHandler(NO, nil, 990);
//                }
//                return;
//            }
//
//            [ZZKTVServer uploadTaskID:_taskDetailsModel.task._id
//                                  sid:_taskDetailsModel.task.song_list[_currentSelectSongIndex]._id
//                              songURL:filePath
//                      completeHandler:^(BOOL isSuccess, NSInteger errorCode, NSString *errorMsg) {
//                [ZZHUD dismiss];
//                if (!isSuccess) {
//                    [ZZHUD showErrorWithStatus:errorMsg];
//                }
//                if (completeHandler) {
//                    completeHandler(isSuccess, filePath, errorCode);
//                }
//            }];
//        }];
//
//    }];
}

- (void)sendMessage:(ZZKTVDetailsModel *)taskModel songUrl:(NSString *)songUrl completeStatus:(BOOL)completeStatus {
    
    if (isNullString(taskModel.task.from.uid)) {
        return;
    }
    
    if ([taskModel.task.from.uid isEqualToString: [ZZUserHelper shareInstance].loginer.uid]) {
        return;
    }
    
    ZZChatKTVModel *ktvModel = [[ZZChatKTVModel alloc] init];
    ktvModel.songUrl = songUrl;
    ktvModel.songStatus = completeStatus ? @"嗨！谢谢你的礼物，这是我的唱趴任务！" : @"虽然来晚一步，没有礼物！还是给你听听我的唱趴任务！";

    NSString *pushParam = [ZZUtils dictionaryToJson:@{
        @"rc": @{
                @"fId": [ZZUserHelper shareInstance].loginer.uid,
                @"tId": taskModel.task.from.uid,
                @"cType": @"PR"
             }
    }];
    
    [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE targetId:taskModel.task.from.uid content:ktvModel pushContent:@"[唱趴任务]" pushData:pushParam success:^(long messageId) {
    } error:^(RCErrorCode nErrorCode, long messageId) {
    }];
}

#pragma mark - Layout
- (void)layoutNavigation {
    UIButton *navigationLeftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 44,44)];
     navigationLeftBtn.contentEdgeInsets =UIEdgeInsetsMake(0, -20,0, 0);
     navigationLeftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15,0, 0);
     
     [navigationLeftBtn setImage:[UIImage imageNamed:@"icBack_white"] forState:UIControlStateNormal];
    
     [navigationLeftBtn setImage:[UIImage imageNamed:@"icBack_white"] forState:UIControlStateHighlighted];
     
     [navigationLeftBtn addTarget:self action:@selector(navigationLeftBtnClick) forControlEvents:UIControlEventTouchUpInside];
     
     UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:navigationLeftBtn];
     
     self.navigationItem.leftBarButtonItems =@[leftItem];
}

- (void)layout {
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)showRecordingViewSongIndex:(NSInteger)index {
    _currentSelectSongIndex = index;
    _recordingView = [[ZZKTVRecordingView alloc] initWithTaskModel:_taskDetailsModel.task selectedSong:index];
    _recordingView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:_recordingView];
    [_recordingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo([UIApplication sharedApplication].keyWindow);
    }];
    
    // 开始唱歌
    [_recordingView singingAction];
}

- (void)showCompleteViewIsSuccess:(BOOL)isSuccess {
    ZZKTVRecordCompleteView *view = [[ZZKTVRecordCompleteView alloc] initWithFrame:self.view.bounds task:_taskDetailsModel.task isRecivedComplete:isSuccess gift_rate:_taskDetailsModel.gift_rate];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
}


#pragma mark - getters and setters
- (ZZKTVAudioPlayManager *)audioPlayManager {
    if (!_audioPlayManager) {
        _audioPlayManager = [[ZZKTVAudioPlayManager alloc] init];
        _audioPlayManager.delegate = self;
    }
    return _audioPlayManager;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColor.clearColor;//RGBCOLOR(54, 54, 54);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 200;
        
        [_tableView registerClass:[ZZKTVUserInfoCell class]
           forCellReuseIdentifier:[ZZKTVUserInfoCell cellIdentifier]];
        
        [_tableView registerClass:[ZZKTVUserActionCell class]
           forCellReuseIdentifier:[ZZKTVUserActionCell cellIdentifier]];
        
        [_tableView registerClass:[ZZKTVlyricsCell class]
           forCellReuseIdentifier:[ZZKTVlyricsCell cellIdentifier]];
        
        [_tableView registerClass:[ZZKTVSingingTaskSongsInfoCell class]
           forCellReuseIdentifier:[ZZKTVSingingTaskSongsInfoCell cellIdentifier]];
        
        [_tableView registerClass:[ZZKTVSingingTaskCompleteCell class]
           forCellReuseIdentifier:[ZZKTVSingingTaskCompleteCell cellIdentifier]];
        
        [_tableView registerClass:[ZZKTVlyricsCell class]
        forCellReuseIdentifier:[ZZKTVlyricsCell cellIdentifier]];
        
        [_tableView registerClass:[ZZEmptyCell class]
           forCellReuseIdentifier:[ZZEmptyCell cellIdentifier]];
    }
    return _tableView;
}


@end

