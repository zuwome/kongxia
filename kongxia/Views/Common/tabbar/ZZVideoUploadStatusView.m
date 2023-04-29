//
//  ZZVideoUploadStatusView.m
//  zuwome
//
//  Created by angBiu on 2017/3/29.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZVideoUploadStatusView.h"
#import "ZZVideoUploadFailureView.h"
#import "ZZTabBarViewController.h"

#import "ZZMemedaModel.h"
#import "ZZPacketAlertView.h"

#import "ZZUploader.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "ZZSendVideoManager.h"
#import "ZZSKModel.h"

@interface ZZVideoUploadStatusView ()

@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIWindow *frontWindow;

@end

@implementation ZZVideoUploadStatusView

+ (id)sharedInstance
{
    __strong static id sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.frame = CGRectMake(0, -20, SCREEN_WIDTH, 20);
        
        self.backgroundColor = HEXCOLOR(0x18181d);
        
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.font = [UIFont systemFontOfSize:12];
        _statusLabel.textColor = [UIColor whiteColor];
        [self addSubview:_statusLabel];
        
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.offset(0);
            make.right.offset(0);
        }];
       
    }
    
    return self;
}

- (void)showBeginStatusView {
    _statusLabel.text = isIPhoneX ?@"发布0%":@"视频发布中...0%";
    [self uploadVideo];
    //如果是录制达人视频，则不显示 状态栏的发送进度
    if (self.isIntroduceVideo && !self.isShowTopUploadStatus) {
        return;
    }
    if (self.isFastChat) {//如果是录制开通闪聊视频，也不需要在状态栏显示进度
        return;
    }
    [self showView];
}

- (void)showSuccessStatusView
{
    _statusLabel.text = isIPhoneX ? @"发布成功":@"视频发布成功";
    [self showView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeViews];
    });
}

- (void)showView {
   
    ZZVideoUploadFailureView *statusView = [ZZVideoUploadFailureView sharedInstance];
    if (statusView.viewShow) {
        [statusView hideView];
    }
    _viewShow = YES;
    [self.frontWindow addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        if (isIPhoneX) {
            _statusLabel.layer.cornerRadius =self.height/2;
            _statusLabel.clipsToBounds = YES;
            _statusLabel.font = [UIFont systemFontOfSize:11];
            self.frame = CGRectMake(15, 35 ,80, self.height);
            self.layer.cornerRadius =self.height/2;
            self.clipsToBounds = YES;

        }else{
            self.frame = CGRectMake(0, 0 ,  SCREEN_WIDTH, self.height);
        }
    }];
}

- (void)removeViews
{
    if (_viewShow) {
        _viewShow = NO;
        self.frontWindow.windowLevel = UIWindowLevelNormal;
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(0, -self.height, SCREEN_WIDTH, self.height);
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

- (void)hideView
{
    if (_viewShow) {
        _viewShow = NO;
        self.frontWindow.windowLevel = UIWindowLevelNormal;
        self.frame = CGRectMake(0, -self.height, SCREEN_WIDTH, self.height);
        [self removeFromSuperview];
    }
}

- (void)uploadVideo
{
    UIImage *thubm = [ZZUtils getThumbImageWithVideoUrl:self.exportURL];
    [self uploadWithVideoPath:self.exportURL thumb:thubm];
}


- (void)showAnswerSuccessAlertView:(ZZMMDModel *)model
{
    UINavigationController *navCtl = [ZZTabBarViewController sharedInstance].selectedViewController;
    UIViewController *ctl = navCtl.viewControllers.lastObject;
    __weak typeof(ctl)weakCtl = ctl;
    ZZPacketAlertView *packerAlertView = [[ZZPacketAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds withController:weakCtl];
    packerAlertView.shareUrl = [NSString stringWithFormat:@"/%@mmd/%@/page", kBase_URL, model.mid];
    packerAlertView.shareTitle = [NSString stringWithFormat:@"么么答｜%@",model.content];
    packerAlertView.shareContent = [NSString stringWithFormat:@"%@在「空虾」用视频回答了这个问题，快去看看", model.to.nickname];
    packerAlertView.shareImg = nil;
    packerAlertView.uid = model.to.uid;
    packerAlertView.mid = model.mid;
    if (model.answers.count) {
        ZZMMDAnswersModel *answerModel = model.answers[0];
        packerAlertView.userImgUrl = answerModel.video.cover_url;
    }
    
    [packerAlertView.headImgView setUser:model.from width:64 vWidth:12];
    packerAlertView.nameLabel.text = [NSString stringWithFormat:@"%@打赏了",model.from.nickname];
    packerAlertView.moneyLabel.text = [NSString stringWithFormat:@"￥%.2f",model.total_price];
    packerAlertView.packetPriceLabel.text = [NSString stringWithFormat:@"%.2f",model.total_price-model.yj_price];
    packerAlertView.servicePriceLabel.text = [NSString stringWithFormat:@"%.2f",model.yj_price];
    [[UIApplication sharedApplication].keyWindow addSubview:packerAlertView];
}

#pragma mark - private

- (void)uploadWithVideoPath:(NSURL *)videoPath thumb:(UIImage *)thumb
{
    NSData *data = UIImageJPEGRepresentation(thumb, 0.5);
    NSInteger timeInterval = [[NSDate date] timeIntervalSince1970]*1000*1000;
    if (!_tagId) {
        _tagId = [NSString stringWithFormat:@"%ld",timeInterval];//通过时间戳给每个视频打标记
    }
    NSArray<NSString *> *urlArray = [[videoPath absoluteString] componentsSeparatedByString:video_savepath];
    NSMutableDictionary *aDict = [@{@"url": urlArray[1],
                                    @"time":[NSNumber numberWithInteger:[self getVideoTimeDuring:videoPath]],
                                    @"tagId":_tagId
                                    } mutableCopy];
    if ([ZZUserHelper shareInstance].location) {
        CLLocation *location = [ZZUserHelper shareInstance].location;
        NSArray *array = @[[NSNumber numberWithFloat:location.coordinate.longitude],[NSNumber numberWithFloat:location.coordinate.latitude]];
        [aDict setObject:array forKey:@"loc"];
    }
    BOOL isUpdate = NO; //是否是重新录制么么答
    switch (_type) {
        case RecordTypeSK:
        {
            [aDict setObject:@"0" forKey:@"type"];
            if (!isNullString(_content)) {
                [aDict setObject:_content forKey:@"content"];
            }
            if (_labelId) {
                [aDict setObject:_labelId forKey:@"labelId"];
            }
            if (_is_base_sk) {
                [aDict setObject:[NSNumber numberWithBool:_is_base_sk] forKey:@"is_base_sk"];
                [ZZUserHelper shareInstance].uploadingQuestionVideo = YES;
            }
            [[ZZUserHelper shareInstance].uploadVideoArray addObject:_tagId];
        }
            break;
        case RecordTypeMemeda:
        {
            [aDict setObject:@"1" forKey:@"type"];
            [aDict setObject:_mid forKey:@"mid"];
            if (!isNullString(_content)) {
                [aDict setObject:_content forKey:@"content"];
            }
            if (_expiredTime) {
                [aDict setObject:_expiredTime forKey:@"expiredTime"];
            }
            [[ZZUserHelper shareInstance].uploadVideoArray addObject:_mid];
        }
            break;
        case RecordTypeUpdateMemeda:
        {
            if (!isNullString(_content)) {
                [aDict setObject:_content forKey:@"content"];
            }
            [aDict setObject:@"2" forKey:@"type"];
            
            if (!isNullString(_mid)) {
                [aDict setObject:_mid forKey:@"mid"];
            }
            
            if (!isNullString(_expiredTime)) {
                [aDict setObject:_expiredTime forKey:@"expiredTime"];
            }
            [[ZZUserHelper shareInstance].uploadVideoArray addObject:_mid];
            isUpdate = YES;
        }
            break;
        default:
            break;
    }
    
    NSString *mid = _mid;
    NSString *tagId = _tagId;
    
    [ZZUploader putData:data next:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        if (resp) {
            NSString *imgUrl = resp[@"key"];
            [self uploadVideoPath:videoPath thumbUrl:imgUrl aDict:aDict mid:mid isUpdate:isUpdate tagId:tagId];
        } else {
            
            if (self.isIntroduceVideo) {// 如果是录制达人视频
                [GetSendVideoManager() asyncSendVideoFailWithError:aDict];
            }
            [self uploadFailure:aDict];
            [self uploadLogs:info key:key];
         }
    }];
}

- (void)uploadVideoPath:(NSURL *)videoPath thumbUrl:(NSString *)thumbUrl aDict:(NSDictionary *)aDict mid:(NSString *)mid isUpdate:(BOOL)isUpdate tagId:(NSString *)tagId
{
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent)
                                    {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            int value = percent*100;
                                            if (self.isIntroduceVideo && !self.isShowTopUploadStatus) {//如果是录制达人视频, 并且不需要显示状态栏进度 
                                                [GetSendVideoManager() asyncVideoSendProgress:DOUBLE_TO_STRING(percent)];
                                                return ;
                                            }
                                            _statusLabel.text =isIPhoneX?[NSString stringWithFormat:@"发布%d%%",value]: [NSString stringWithFormat:@"视频发布中...%d%%",value];
                                        });
                                        if (!mid) {
                                            [self progressWithTagId:tagId percent:percent];
                                        } else {
                                            [self progressWithTagId:tagId percent:percent];
                                        }
                                    }
                                                                 params:nil
                                                               checkCrc:NO
                                                     cancellationSignal:nil];
    
    NSString *strRandom = @"";
    
    for(int i=0; i<6; i++)
    {
        strRandom = [strRandom stringByAppendingFormat:@"%i",(arc4random() % 9)];
    }
    
    NSString *key;
    NSInteger timeInterval = [[NSDate date] timeIntervalSince1970]*1000*1000;
    if ([ZZUserHelper shareInstance].loginer.uid) {
        key = [NSString stringWithFormat:@"%@/%ld.mp4",[ZZUserHelper shareInstance].loginer.uid,timeInterval+[strRandom integerValue]];
    } else {
        key = [NSString stringWithFormat:@"%@/%ld.mp4",strRandom,timeInterval+[strRandom integerValue]];
    }
    [upManager putFile:[videoPath path] key:key token:[ZZUserHelper shareInstance].uploadToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        if (resp) {
            NSString *videoUrl = resp[@"key"];
            if (!mid) {
                [self uploadSKWithVideoUrl:[NSString stringWithFormat:@"%@",videoUrl] thumbUrl:[NSString stringWithFormat:@"%@",thumbUrl] aDict:aDict videoPath:videoPath tagId:tagId];
            } else {
                [self answerWithVideoUrl:[NSString stringWithFormat:@"%@",videoUrl] thumbUrl:[NSString stringWithFormat:@"%@",thumbUrl] aDict:aDict videoPath:videoPath mid:mid isUpdate:isUpdate tagId:tagId];
            }
        } else {
            if (self.isIntroduceVideo) {
                [GetSendVideoManager() asyncSendVideoFailWithError:aDict];
            }
            [self uploadFailure:aDict];
            [self uploadLogs:info key:key];
        }
    }
                option:uploadOption];
}

- (void)uploadSKWithVideoUrl:(NSString *)videoUrl thumbUrl:(NSString *)thumbUrl aDict:(NSDictionary *)aDict videoPath:(NSURL *)videoPath tagId:(NSString *)tagId
{
    NSMutableDictionary *param = [@{@"video":@{@"cover_url":thumbUrl,
                                               @"video_url":videoUrl,
                                               @"time":[NSNumber numberWithInteger:[self getVideoTimeDuring:videoPath]],
                                               @"width":INT_TO_STRING(self.pixelWidth),
                                               @"height":INT_TO_STRING(self.pixelHeight)
                                               },
                                    @"version":@"2"} mutableCopy];
    if ([ZZUserHelper shareInstance].location) {
        CLLocation *location = [ZZUserHelper shareInstance].location;
        NSArray *array = @[[NSNumber numberWithFloat:location.coordinate.longitude],[NSNumber numberWithFloat:location.coordinate.latitude]];
        [param setObject:array forKey:@"loc"];
    }
    if ([aDict objectForKey:@"content"]) {
        [param setObject:[aDict objectForKey:@"content"] forKey:@"content"];
    }
    if ([aDict objectForKey:@"labelId"]) {
        [param setObject:@[@{@"id":[aDict objectForKey:@"labelId"]}] forKey:@"groups"];
    }
    if ([[aDict objectForKey:@"is_base_sk"] boolValue]) {
        [param setObject:@([[aDict objectForKey:@"is_base_sk"] boolValue]) forKey:@"is_base_sk"];
    }
    if (!self.isRecordVideo) {
        [param setObject:@"1" forKey:@"from_album"];
    }
    if (self.loc_name) {
        [param setObject:self.loc_name forKey:@"loc_name"];
    }
    [ZZRequest method:@"POST" path:@"/api/sk/add" params:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            if (self.isIntroduceVideo) {
                [GetSendVideoManager() asyncSendVideoFailWithError:aDict];
            }
            [self uploadFailure:aDict];
        } else {
            if (self.isIntroduceVideo) {
                // 如果录制达人视频
                NSError *e;
                ZZSKModel *sk = [[ZZSKModel alloc] initWithDictionary:data error:&e];
                [GetSendVideoManager() asyncSendVideoWithVideoId:sk];
            }
            
            if ([[aDict objectForKey:@"is_base_sk"] boolValue]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_PublishedQuestion object:nil];
            }
            [self uploadSuccess:videoPath tagId:tagId mid:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_RecordFinish object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_VideoDataShouldUpdate object:nil];
        }
    }];
}

- (void)answerWithVideoUrl:(NSString *)videoUrl thumbUrl:(NSString *)thumbUrl aDict:(NSDictionary *)aDict videoPath:(NSURL *)videoPath mid:(NSString *)mid isUpdate:(BOOL)isUpdate tagId:(NSString *)tagId
{
//    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
//                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
//    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:videoUrl] options:opts];
//    NSUInteger second = 0;
//    second = urlAsset.duration.value/urlAsset.duration.timescale;
    
    NSMutableDictionary *param = [@{@"video":@{@"video_url":videoUrl,
                                               @"cover_url":thumbUrl,
                                               @"time":[NSNumber numberWithInteger:[self getVideoTimeDuring:videoPath]]},
                                    @"version":@"2"} mutableCopy];
    if ([ZZUserHelper shareInstance].location) {
        CLLocation *location = [ZZUserHelper shareInstance].location;
        NSArray *array = @[[NSNumber numberWithFloat:location.coordinate.longitude],[NSNumber numberWithFloat:location.coordinate.latitude]];
        [param setObject:array forKey:@"loc"];
    }
    if (self.loc_name) {
        [param setObject:self.loc_name forKey:@"loc_name"];
    }
    if ([aDict objectForKey:@"content"]) {
        [param setObject:[aDict objectForKey:@"content"] forKey:@"content"];
    }
    if (isUpdate) {
        ZZMemedaModel *model = [[ZZMemedaModel alloc] init];
        [model updateAnswerMemedaParam:param mid:mid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [self uploadFailure:aDict];
            } else {
                [self uploadSuccess:videoPath tagId:tagId mid:mid];
                NSDictionary *aDict = @{@"mid":mid};
                [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_UploadUpdateVideo object:nil userInfo:aDict];
                [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_VideoDataShouldUpdate object:nil];
            }
        }];
    } else {
        ZZMemedaModel *model = [[ZZMemedaModel alloc] init];
        [model answerMemedaParam:param mid:mid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [self uploadFailure:aDict];
            } else {
                if ([ZZUserHelper shareInstance].unreadModel.my_answer_mmd_count > 0) {
                    [ZZUserHelper shareInstance].unreadModel.my_answer_mmd_count--;
                    [[ZZTabBarViewController sharedInstance] managerAppBadge];
                }
                [self uploadSuccess:videoPath tagId:tagId mid:mid];
                [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_RecordFinish object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_VideoDataShouldUpdate object:nil];
                ZZMMDModel *dataModel = [[ZZMMDModel alloc] initWithDictionary:data error:nil];
                [self showAnswerSuccessAlertView:dataModel];
            }
        }];
    }
}

- (void)uploadFailure:(NSDictionary *)aDict
{
    [[ZZVideoUploadFailureView sharedInstance] showView];
    NSString *tagId = [aDict objectForKey:@"tagId"];
    NSDictionary *userInfo = @{@"tagId":tagId};
    
    NSString *mid = [aDict objectForKey:@"mid"];
    if ([[ZZUserHelper shareInstance].uploadVideoArray containsObject:tagId]) {
        [[ZZUserHelper shareInstance].uploadVideoArray removeObject:tagId];
    }
    if ([[ZZUserHelper shareInstance].uploadVideoArray containsObject:mid]) {
        [[ZZUserHelper shareInstance].uploadVideoArray removeObject:mid];
    }
    
    NSString *key = [NSString stringWithFormat:@"%@%@",[ZZStoreKey sharedInstance].uploadFailureVideo, [ZZUserHelper shareInstance].loginerId];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[ZZKeyValueStore getValueWithKey:key tableName:kTableName_VideoSave]];
    BOOL haveVideo = NO;
    for (NSDictionary *dict in array) {
        if ([[dict objectForKey:@"tagId"] isEqualToString:tagId]) {
            haveVideo = YES;
            break;
        }
    }
    if (!haveVideo) {
        [self saveFailureVideo:aDict];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_FailureUploadVide object:nil userInfo:userInfo];
    [ZZUserHelper shareInstance].uploadingQuestionVideo = NO;
}

- (void)uploadSuccess:(NSURL *)videoPath tagId:(NSString *)tagId mid:(NSString *)mid {
    
    if ([[ZZUserHelper shareInstance].uploadVideoArray containsObject:tagId]) {
        [[ZZUserHelper shareInstance].uploadVideoArray removeObject:tagId];
    }
    if ([[ZZUserHelper shareInstance].uploadVideoArray containsObject:mid]) {
        [[ZZUserHelper shareInstance].uploadVideoArray removeObject:mid];
    }
    
    [self showSuccessStatusView];
    
    NSMutableDictionary *userInfo = [@{@"tagId":tagId} mutableCopy];
    if (mid) {
        [userInfo setObject:mid forKey:@"mid"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_SuccessUploadVide object:nil userInfo:userInfo];
    
    //移除跟上传成功的mid相同的视频
    NSString *key = [NSString stringWithFormat:@"%@%@",[ZZStoreKey sharedInstance].uploadFailureVideo,[ZZUserHelper shareInstance].loginerId];
    NSArray *array = [ZZKeyValueStore getValueWithKey:key tableName:kTableName_VideoSave];
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:array];
    for (NSDictionary *dict in array) {
        NSString *url = [dict objectForKey:@"url"];
        url = [NSString stringWithFormat:@"%@/%@",[ZZFileHelper createPathWithChildPath:video_savepath],url];
        if ([[dict objectForKey:@"mid"] isEqualToString:mid]) {
            [tempArray removeObject:dict];
            [self removeItems:[NSURL fileURLWithPath:url]];
        } else if ([[dict objectForKey:@"tagId"] isEqualToString:tagId]) {
            [tempArray removeObject:dict];
            [self removeItems:[NSURL fileURLWithPath:url]];
        }
    }
    
    [ZZKeyValueStore saveValue:tempArray key:key tableName:kTableName_VideoSave];
}

- (void)progressWithTagId:(NSString *)tagId percent:(CGFloat)percent
{
    NSDictionary *userInfo = @{@"tagId":tagId,
                               @"percent":[NSNumber numberWithFloat:percent]};
    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_VideoUploadProgress object:nil userInfo:userInfo];
}

- (void)saveFailureVideo:(NSDictionary *)aDict
{
    NSString *key = [NSString stringWithFormat:@"%@%@",[ZZStoreKey sharedInstance].uploadFailureVideo,[ZZUserHelper shareInstance].loginerId];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[ZZKeyValueStore getValueWithKey:key tableName:kTableName_VideoSave]];
    if (!array) {
        array = [NSMutableArray array];
    }
    [array insertObject:aDict atIndex:0];
    [ZZKeyValueStore saveValue:array key:key tableName:kTableName_VideoSave];
}

- (void)removeItems:(NSURL *)videoPath
{
    [[NSFileManager defaultManager] removeItemAtURL:videoPath error:nil];
}

#pragma mark -

- (NSUInteger)getVideoTimeDuring:(NSURL *)videoPth
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:videoPth options:opts];
    NSUInteger second = 0;
    second = urlAsset.duration.value/urlAsset.duration.timescale;
    
    return second;
}

- (void)uploadLogs:(QNResponseInfo *)info  key:(NSString *)key
{
    if ([ZZUserHelper shareInstance].unreadModel.open_log) {
        NSString *string = @"上传视频错误";
        NSMutableDictionary *param = [@{@"type":string} mutableCopy];
        if ([ZZUserHelper shareInstance].uploadToken) {
            [param setObject:[ZZUserHelper shareInstance].uploadToken forKey:@"uploadToken"];
        }
        if (info.error) {
            [param setObject:[NSString stringWithFormat:@"%@",info.error] forKey:@"error"];
        }
        if (info.statusCode) {
            [param setObject:[NSNumber numberWithInt:info.statusCode] forKey:@"statusCode"];
        }
        if ([ZZUserHelper shareInstance].isLogin) {
            NSDictionary *dict = @{@"uid":[ZZUserHelper shareInstance].loginer.uid,
                                   @"content":[ZZUtils dictionaryToJson:param]};
            [ZZUserHelper uploadLogWithParam:dict next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                
            }];
        }
    }
}

#pragma mark - 

- (void)setVideoDict:(NSDictionary *)videoDict
{
    NSInteger type = [[videoDict objectForKey:@"type"] integerValue];
    _mid = [videoDict objectForKey:@"mid"];
    _labelId = [videoDict objectForKey:@"labelId"];
    _content = [videoDict objectForKey:@"content"];
    _tagId = [videoDict objectForKey:@"tagId"];
    _is_base_sk = [videoDict objectForKey:@"is_base_sk"];
    
    NSString *url = [videoDict objectForKey:@"url"];
    url = [NSString stringWithFormat:@"%@/%@", [ZZFileHelper createPathWithChildPath:video_savepath], url];
    _exportURL = [NSURL fileURLWithPath:url];
    
    if (type == 1) {
        _type = RecordTypeMemeda;
    } else if (type == 2) {
        _type = RecordTypeUpdateMemeda;
    } else {
        _type = RecordTypeSK;
    }
}

#pragma mark - lazyload

- (UIWindow *)frontWindow
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.windowLevel = UIWindowLevelAlert;
    return window;
}

@end
