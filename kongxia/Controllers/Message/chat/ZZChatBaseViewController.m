//
//  ZZChatBaseViewController.m
//  zuwome
//
//  Created by angBiu on 16/10/18.
//  Copyright © 2016年 zz. All rights reserved.
//
#import "ZZPrivateChatPayBaseGuide.h"
#import "JX_GCDTimerManager.h"
#import "ZZKeyValueStore.h"
#import "ZZChatBaseViewController.h"
#import "ZZRequestLiveStreamAlert.h"
#import "UIScrollView+XHkeyboardControl.h"
#import "ZZliveStreamConnectingController.h"
#import "ZZRecordViewController.h"
#import "ZZRechargeViewController.h"
#import "ZZVideoMessageCell.h"
#import "ZZVideoMessage.h"
#import "ZZMyWalletViewController.h"//新版的我的钱包
#import "ZZChatManagerNetwork.h"
#import "ZZChatWechatPayCell.h"//微信号评价
#import "ZZChatIDPhotoPayCell.h"
#import "ZZWeiChatEvaluationManager.h"//微信号评价管理类
#import "ZZChatCallIphoneManagerNetWork.h"//连麦管理类
#import "ZZMeBiViewController.h"//么币充值
#import "ZZPrivateChatPayManager.h"//私聊付费
#import "ZZActivityUrlNetManager.h"
#import "ZZPrivateDiffusionView.h"//动效扩散
#import "ZZGifMessageModel.h" //发送gif 图
#import "ZZChatGifCell.h"
#import "ZZPayChatMessageSendAlertView.h"//私信卡提示
#import "ZZPayChatReceiveAlertView.h"//私信卡收钱方提示
#import "kongxia-Swift.h"
#import "ZZTaskFreeActionCell.h"
#import "ZZTaskFreeCell.h"
#import "ZZPlayerViewController.h"
#import "ZZChatShotViewController.h"
#import "ZZChatVideoCell.h"
#import "ZZChatVideoPlayerController.h"

#import "ZZChatGiftCell.h"
#import "ZZChatKTVCell.h"
#import "ZZChatGiftModel.h"
#import "ZZChatKTVModel.h"
#import "ZZGiftModel.h"
#import "ZZBillingRecordsViewController.h"

#import "ZZKTVAudioPlayManager.h"

#define MaxPhotoAlbum 9
@interface ZZChatBaseViewController () <UITableViewDataSource,UITableViewDelegate,ZZChatBoxViewDelegate,ZZRecordManagerDelegate,HZPhotoBrowserDelegate, ZZTaskFreeActionCellDelegate, ZZTaskFreeCellDelegate, TZImagePickerControllerDelegate, ZZChatShotViewControllerDelegate, ZZGiftsViewDelegate, ZZChatGiftCellDelegate, ZZChatKTVCellDelegate, ZZKTVAudioPlayManagerDelegate, ZZChatInviteVideoChatCellDelegate>

@property (nonatomic, assign) BOOL haveLoadData;//是否已经加载过数据了
@property (nonatomic, assign) BOOL noMoreData;//没有更多数据~ 去除head loading
@property (nonatomic, weak) id<RCRealTimeLocationProxy> realTimeLocation;
@property (nonatomic, strong) UIImageView *currentPlayVoiceImgView;//当前正在播放语音的imageview
@property (nonatomic, strong) NSData *currentPlayVoiceData;//当前正在播放语音数据
@property (nonatomic, strong) ZZChatBaseModel *currentPlayVoiceModel;
@property (nonatomic, strong) UIMenuItem *deleteItem;
@property (nonatomic, strong) UIMenuItem *recallItem;
@property (nonatomic, strong) UIMenuItem *theCopyItem;
@property (nonatomic, strong) UIMenuItem *reportItem;
@property (nonatomic, strong) ZZChatBaseModel *longModel;
@property (nonatomic, strong) NSMutableArray *photoArray;
@property (nonatomic, strong) UIImage *currentSelectedImage;
@property (nonatomic, strong) HZPhotoBrowser *browser;

/**
 违禁词的个数
 */
@property (nonatomic,assign) NSInteger bannedWordNum;
@property (nonatomic, assign) BOOL loadPacket;
@property (nonatomic, assign) BOOL isUserScrolling;
@property (nonatomic, assign) BOOL isUpdatingData;//正在插入聊天数据
@property (nonatomic, assign) BOOL isReporting;//正在举报中
@property (nonatomic, strong) NSString *sensitiveStr;//是否是敏感词
@property (nonatomic, strong) NSString *wxSensitive;//是否是微信敏感词（插入购买微信号功能）
@property (nonatomic, strong) ZZChatSensitiveAlertView *thirdAlertView;
@property (nonatomic, strong) ZZliveStreamConnectingView *connectingView;

@property (nonatomic, strong) ZZliveStreamConnectingController *connectingVC;

@property (nonatomic, strong) NSMutableArray *deleteArray;//需要删除的数据
@property (nonatomic, strong) NSMutableArray *countDownArray;//正在倒计时得数据

@property (nonatomic,assign) BOOL isEndAnimation;//动画是否结束了
/**
 第一次是否修改过违禁词
 */
@property (nonatomic, assign) BOOL isModify;

@property (nonatomic, assign) NSInteger currentMessageCounts;

@property (nonatomic, copy) NSString *currentPlayedSongUrl;

@property (nonatomic, strong) ZZKTVAudioPlayManager *audioPlayManager;

@end

@implementation ZZChatBaseViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopPlayVoice];
    if (isNullString(self.boxView.topView.textView.text)) {
        NSString *draft = [[RCIMClient sharedRCIMClient] getTextMessageDraft:ConversationType_PRIVATE
                                                                    targetId:self.uid];
        if (!isNullString(draft)) {
            [[RCIMClient sharedRCIMClient] clearTextMessageDraft:ConversationType_PRIVATE
                                                        targetId:self.uid];
        }
    }
    else {
        [[RCIMClient sharedRCIMClient] saveTextMessageDraft:ConversationType_PRIVATE
                                                   targetId:self.uid
                                                    content:self.boxView.topView.textView.text];
    }
    [self.tableView disSetupPanGestureControlKeyboardHide:NO];
    if (_packetInfoView) {
        [_packetInfoView removeFromSuperview];
    }
    if (_thirdAlertView) {
        [_thirdAlertView removeFromSuperview];
        _thirdAlertView = nil;
    }
    self.isEndAnimation = NO;
    self.showTodayEarnings.hidden = YES;
    
    [self releaseAudioManager];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [ZZUserHelper shareInstance].currentChatUid = nil;
    _isPushingView = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView setupPanGestureControlKeyboardHide:NO];
    [ZZUserHelper shareInstance].currentChatUid = self.uid;
   
    [self getUserUnreadCountAndClear];
    self.isEndAnimation = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self.boxView.topView.textView.text length] > 0) {
        [self.boxView.topView.textView becomeFirstResponder];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = self.nickName;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initViews];
    
}

- (void)releaseAudioManager {
    [self stopPlayingAudios];
    [self.audioPlayManager releasePlayer];
    _audioPlayManager = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_dataArray enumerateObjectsUsingBlock:^(__kindof ZZChatBaseModel * _Nonnull baseModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([baseModel.message.content isKindOfClass:[ZZChatKTVModel class]]) {
                ZZChatKTVModel *model = (ZZChatKTVModel *)baseModel.message.content;
                model.isSongPlaying = NO;
            }
        }];
        _currentPlayedSongUrl = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    });
}

- (void)stopPlayingAudios {
    [self.audioPlayManager stop];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_dataArray enumerateObjectsUsingBlock:^(__kindof ZZChatBaseModel * _Nonnull baseModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([baseModel.message.content isKindOfClass:[ZZChatKTVModel class]]) {
                ZZChatKTVModel *model = (ZZChatKTVModel *)baseModel.message.content;
                model.isSongPlaying = NO;
            }
        }];
        _currentPlayedSongUrl = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    });
}


- (void)setUid:(NSString *)uid {
    if (_uid !=uid) {
        _uid = uid;
        [ZZUserHelper shareInstance].chatUid = uid;
    }
}

- (void)initViews {
    [self registerClass];
    [self createViews];
    [self addNotification];
    [self loadData];
    //判断是消息盒子的就不再加载外部加载了
    if (self.haveLocalMessage == YES&&self.isMessageBox ==NO) {
        [ZZChatManagerNetwork getMessageWithTargetId:_uid isloadSuccess:^(BOOL success) {
            [self loadData];
        }];
    }
  
    //实时共享位置
    [self initRealTime];
    
    if (self.dataArray.count == 0 && ![ZZUserHelper shareInstance].isFirstRent) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ZZChatOrderInfoModel *orderMessage = [ZZChatOrderInfoModel messageWithContent:@"感谢使用空虾，平台提示\n1、平台只视空虾APP聊天凭证为有效证据，请勿使用第三方工具约定邀约内容。\n2、若对方存在粗鲁、诱导平台外交易，诱导额外花费，信息不实等不良或非法行为，请立即匿名举报，核实后将严厉处罚对方。\n3、若对方有违法要求请及时举报并拒绝，如默许、要求第三方平台联系或者报价将视为违规，将会被严厉处罚。\n4、邀约地点务必在人流量大的公众场合，不要乘坐他人交通工具或进入私密场所\n5、平台严禁达人私下加价或索要红包，若遇到此情况，请及时举报，或联系客服反馈"];
            orderMessage.title = @"温馨提示";
            orderMessage.order_id = @"0";
            RCMessage *message = [[RCIMClient sharedRCIMClient] insertOutgoingMessage:ConversationType_PRIVATE targetId:self.uid sentStatus:SentStatus_SENT content:orderMessage];
            if (message != NULL) {
                [self insertSendMessage:message];
            }
        });
    }
    
    _haveCreatedViews = YES;
    
    NSString *draftString = [[RCIMClient sharedRCIMClient] getTextMessageDraft:ConversationType_PRIVATE targetId:self.uid];
    if (!isNullString(draftString)) {
        CGFloat height =[self.boxView.topView.textView setInputViewHeightWhenHaveDraftStringWithString:draftString];
        [self.boxView changeChatToolHeightWithDraftHeight:height];
    }
}

- (void)showGiftIconAnimations {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_boxView.topView showGiftAnimations];
    });
    
}

- (void)calCurrentMessageCounts {
    NSArray<RCMessage *> *array = [[RCIMClient sharedRCIMClient] getLatestMessages:ConversationType_PRIVATE targetId:_user.uid count:15];
    NSInteger count = array.count;
    _currentMessageCounts = count;
}

- (void)addMessageCount {
    if (_currentMessageCounts < 15) {
        _currentMessageCounts++;
        
        if (_currentMessageCounts >= 15) {
            [self showGiftIconAnimations];
        }
    }
}

/**
 * 是不是活跃的打招呼回复用户
 * 在15天之内回复超过5个人, 超过15天开始重新计算
 */
- (BOOL)isHighlyActiveReplyUserTo {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    formatter.timeZone = [NSTimeZone localTimeZone];
    NSString *currentDate = [formatter stringFromDate:date];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray<NSDictionary *> *highlyActiveUsers = [[userDefault objectForKey:@"highlyActiveUsers"] mutableCopy];
    
    if (!highlyActiveUsers) {
        highlyActiveUsers = @[].mutableCopy;
    }
    
    __block NSMutableDictionary *userInfoDic = nil;
    __block NSInteger index = -1;
    [highlyActiveUsers enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *uid = obj[@"uid"];
        if (!isNullString(uid) && [uid isEqualToString:[ZZUserHelper shareInstance].loginer.uid]) {
            userInfoDic = obj.mutableCopy;
            index = idx;
            *stop = YES;
        }
    }];
    
    // 如果没有数据 写进去
    if (!userInfoDic) {
        NSArray *sayHiUsers = @[_uid];
        NSDictionary *userInfo = @{
            @"uid" : [ZZUserHelper shareInstance].loginer.uid,
            @"activeDate": currentDate,
            @"sayHiUsers" : sayHiUsers,
        };
        
        [highlyActiveUsers addObject:userInfo];
        [userDefault setObject:highlyActiveUsers.copy forKey:@"highlyActiveUsers"];
        [userDefault synchronize];
        return NO;
    }
    
    // 当时活跃的日期
    NSString *activeDate = userInfoDic[@"activeDate"];
    
    // 大于15天,需要重新统计
    if ([[ZZDateHelper shareInstance] isPassFifteenDay:activeDate]) {
        userInfoDic[@"activeDate"] = currentDate;
        userInfoDic[@"sayHiUsers"] = @[_uid];
        highlyActiveUsers[index] = userInfoDic.copy;
        [userDefault setObject:highlyActiveUsers.copy forKey:@"highlyActiveUsers"];
        [userDefault synchronize];
        return NO;
    }
    
    // 所有打招呼的人
    NSMutableArray *sayHiusers = [userInfoDic[@"sayHiUsers"] mutableCopy];
    
    // 不能出现重复的人
    if ([sayHiusers containsObject:_uid]) {
        return NO;
    }
    
    [sayHiusers addObject: _uid];
    userInfoDic[@"sayHiUsers"] = sayHiusers;
    highlyActiveUsers[index] = userInfoDic.copy;
    [userDefault setObject:highlyActiveUsers.copy forKey:@"highlyActiveUsers"];
    [userDefault synchronize];
    
    // 是否超过指定人数
    if (sayHiusers.count >= [ZZUserHelper shareInstance].configModel.sayhi_config.count) {
        return YES;
    }
    else {
        return NO;
    }
}

#pragma mark - 私聊付费模块
- (void)privateChatPayManagerCallBack:(void(^)(ZZPrivateChatPayModel *payModel))privateChatPayCallBack {
    [ZZPrivateChatPayManager requestUserInfoAndSensitiveNumberWithUid:self.uid privateChatPay:^(ZZPrivateChatPayModel *payModel) {
        NSLog(@"PY_当前的用户是否可以私聊付费%d",payModel.isPay);
        [ZZUserHelper shareInstance].consumptionMebi = 0;
        self.payChatModel = payModel;
        //为过审，隐藏私信付费弹窗
//        [self alertPayChatprompt];
        self.payChatModel.isFirst = YES;
        [self updateStateIsFirstIntoRoom:YES];
        if (privateChatPayCallBack) {
            privateChatPayCallBack(payModel);
        }
    }];
}

/**
 弹出私聊付费的  提示
 */
- (void)alertPayChatprompt {
    if (self.payChatModel.open_charge&&![ZZUserHelper shareInstance].loginer.open_charge) {
        //只有对方开启的情况下提示
        [ZZPayChatMessageSendAlertView showAlertView];
    }
    else if([ZZUserHelper shareInstance].loginer.open_charge){
        //双方都开启的情况下提示收钱
        [ZZPayChatReceiveAlertView showAlertView];
    }
}

- (void)updatePriveChatState {
    self.payChatBoxView.hidden = NO;
    self.payChatBoxView.top =  self.boxView.top-30;
    CGFloat boom =  self.view.frame.size.height -self.payChatBoxView.top;
    [self setTableViewInsetsWithBottomValue:boom];
  
}

/**
 私聊付费模式请求数据
 */
- (void)updateStateIsFirstIntoRoom:(BOOL)isFirst  {
    dispatch_async(dispatch_get_main_queue(), ^{
        ZZUser *user = [ZZUserHelper shareInstance].loginer;
        
        // 服务端是否允许客户端开启私聊付费接口
        if (!self.payChatModel.globaChatCharge || !self.payChatModel.isChange) {
            self.payChatBoxView.hidden = YES;
            return ;
        }
        
        // 优享订单期间
        if (self.payChatModel.wechat_flag) {
            if (self.payChatModel.wechat_flag && (user.open_charge || self.payChatModel.open_charge)) {
                // 订单期间,文案显示
                if (!self.payChatModel.open_charge && user.open_charge) {
                    // 受益方
                    self.payChatBoxView.messageTitleLab.text = self.payChatModel.b_wechat_text;
                }
                if (self.payChatModel.open_charge && !user.open_charge) {
                    // 消费方
                    self.payChatBoxView.messageTitleLab.text = self.payChatModel.a_wechat_text;
                }
                if (self.payChatModel.open_charge && user.open_charge) {
                    // 同时开启
                    self.payChatBoxView.messageTitleLab.text = self.payChatModel.b_wechat_text;
                }
            
                if (self.payChatModel.isPay) {
                    self.boxView.topView.statusModel.chat_status = 1;
                    self.boxView.topView.isMessageBox = NO;
                }
                [self updatePriveChatState];
            }
            return;
        }
        
        // 非订单期间  互粉期间
        if (self.payChatModel.following_flag) {
            if (self.payChatModel.open_charge || user.open_charge) {
                if (!self.payChatModel.open_charge && user.open_charge) {
                    // 受益方
                    self.payChatBoxView.messageTitleLab.text = self.payChatModel.b_following_text;
                }
                if (self.payChatModel.open_charge && !user.open_charge) {
                    // 消费方
                    self.payChatBoxView.messageTitleLab.text =  self.payChatModel.a_following_text;
                }
                if (self.payChatModel.open_charge && user.open_charge) {
                    // 同时开启
                    self.payChatBoxView.messageTitleLab.text = self.payChatModel.b_following_text;
                }
                if (self.payChatModel.isPay) {
                    self.boxView.topView.statusModel.chat_status = 1;
                    self.boxView.topView.isMessageBox = NO;
                }
                [self updatePriveChatState];
            }
            return;
        }
        
        // 非订单期间  非互粉期间
        if (user.open_charge || self.payChatModel.open_charge) {
            if (!self.payChatModel.open_charge && user.open_charge) {
                // 受益方
                if ((isFirst && self.payChatModel.wait_answerCout > 0) || !isFirst) {
                    self.payChatBoxView.messageTitleLab.text = [ZZUserHelper shareInstance].configModel.priceConfig.text_chat[@"answer_get_money"];
                }
            }
            
            if (self.payChatModel.open_charge && !user.open_charge) {
                // 消费方
                self.payChatBoxView.messageTitleLab.text = [ZZUserHelper shareInstance].configModel.priceConfig.text_chat[@"send_need_cost"];
            }
            
            if (self.payChatModel.open_charge && user.open_charge) {
                // 同时开启
                if ((isFirst && self.payChatModel.wait_answerCout > 0) || !isFirst) {
                    self.payChatBoxView.messageTitleLab.text = [ZZUserHelper shareInstance].configModel.priceConfig.text_chat[@"send_and_answer"];
                }
                else {
                    self.payChatBoxView.messageTitleLab.text = [ZZUserHelper shareInstance].configModel.priceConfig.text_chat[@"send_need_cost"];
                }
            }
            
            if (self.payChatModel.isPay) {
                self.boxView.topView.statusModel.chat_status = 1;
                self.boxView.topView.isMessageBox = NO;
            }
            [self updatePriveChatState];
        }
    });
}

#pragma mark - 金币飞的效果
/**
 展示今日收益的动画
 */
- (void)showTodayAnimation {
    
    NSString *key = [NSString stringWithFormat:@"%@_private_chat_%@",[ZZUserHelper shareInstance].loginer.uid,self.uid];
    NSNumber *number = [ZZKeyValueStore getValueWithKey:key];

    if (self.payChatModel.isChange && [number integerValue] !=self.payChatModel.answeredCout+self.payChatModel.wait_answerCout&&(self.payChatModel.answeredCout>0||self.payChatModel.wait_answerCout>0)) {
        if (self.payChatModel.answeredCout<=0) {
            self.payChatModel.answeredCout = 0;
        }
        
        NSInteger perCard = [[ZZUserHelper shareInstance].configModel.priceConfig.per_chat_give_card intValue] > 0 ? [[ZZUserHelper shareInstance].configModel.priceConfig.per_chat_give_card intValue] : 1;
        self.showTodayEarnings.getPrivateChatMoneyLab.text = [NSString stringWithFormat:@"%ld",(long)(self.payChatModel.answeredCout * perCard)];

      [ZZPrivateChatPayManager updateMessageListQiPaoiWithISReply:YES messageArray:self.dataArray callBack:^(BOOL isChange){
            [self.tableView reloadData];
        }];
     
        self.payChatModel.answeredCout = self.payChatModel.answeredCout+self.payChatModel.wait_answerCout;
        float repeatNumber = self.payChatModel.wait_answerCout * (float)perCard;
        if (self.payChatModel.wait_answerCout >= 6) {
            repeatNumber = 6;
        }
        self.payChatModel.wait_answerCout = 0;
        [self.tableView layoutIfNeeded];
        self.showTodayEarnings.hidden = NO;
        self.showTodayEarnings.frame = CGRectMake(16, self.payChatBoxView.top-74, 83, 54);
        
        [ZZKeyValueStore saveValue:@(self.payChatModel.answeredCout) key:key];
        if (self.isEndAnimation ) {
            [self.showTodayEarnings addAnimationWithFromCGPoint:CGPointMake(-41, self.showTodayEarnings.center.y) endPoint:CGPointMake(56.5, self.showTodayEarnings.center.y) andWaitTime:0.1 animationKey:@"starflyMoneyCoin"];
        }
    
        [NSObject asyncWaitingWithTime:1 completeBlock:^{
      
            ZZPrivateChatPayMoneyView *flyMoney = [[ZZPrivateChatPayMoneyView alloc]initWithFrame:CGRectMake(19, self.showTodayEarnings.center.y-88, 24, 24) ImageName:@"icMebiQipaoEnter_Fly"];
            [self.view addSubview:flyMoney];
            
         
            if (repeatNumber>1) {
                ZZPrivateDiffusionView *flyMoneySpread1 = [[ZZPrivateDiffusionView alloc]initWithFrame:CGRectMake(19, self.showTodayEarnings.mj_y+6, 25, 25)];
                [self.view addSubview:flyMoneySpread1];
                ZZPrivateChatPayMoneyView *showMoneyImage = [[ZZPrivateChatPayMoneyView alloc]initWithFrame:CGRectMake(17, self.showTodayEarnings.mj_y+4, 28, 28) ImageName:@"icMebiQipaoEnter_Fly"];
                [self.view addSubview:showMoneyImage];
                
                [NSObject asyncWaitingWithTime:0.3 completeBlock:^{
                        [flyMoneySpread1 addSpreadAnimationWithRepeat:repeatNumber-1];
                }];
                [NSObject asyncWaitingWithTime:0.3*repeatNumber completeBlock:^{
                    [showMoneyImage removeFromSuperview];
                }];
            }
                        
            [flyMoney addFallingAnimationWithFromCGPoint:flyMoney.center toPoint:CGPointMake(flyMoney.center.x, self.showTodayEarnings.center.y-10) repeat:repeatNumber];
            
            [NSObject asyncWaitingWithTime:0.3*repeatNumber completeBlock:^{
                [self.showTodayEarnings addSplashAnimation];
            }];
            self.showTodayEarnings.getPrivateChatMoneyLab.text = [NSString stringWithFormat:@"%ld",(long)(self.payChatModel.answeredCout * perCard)];
            
            self.isEndAnimation = NO;
               [[JX_GCDTimerManager sharedInstance] scheduledDispatchTimerWithName:@"Delay" timeInterval:1+repeatNumber*0.3+0.1 queue:nil repeats:NO actionOption:AbandonPreviousAction action:^{
                   dispatch_async(dispatch_get_main_queue(), ^{
                    self.isEndAnimation = YES;
                    [self.showTodayEarnings addAnimationWithFromCGPoint:CGPointMake(56.5, self.showTodayEarnings.center.y) endPoint:CGPointMake(-41, self.showTodayEarnings.center.y) andWaitTime:0.2 animationKey:@"EndflyMoneyCoin"];
                   });
                  
               }];
        }];
    }
}

- (void)registerClass {
    [self.tableView registerClass:[ZZChatTextCell class]
           forCellReuseIdentifier:ChatText];
    
    [self.tableView registerClass:[ZZChatImageCell class]
           forCellReuseIdentifier:ChatImage];
    
    [self.tableView registerClass:[ZZChatVoiceCell class]
           forCellReuseIdentifier:ChatVoice];
    
    [self.tableView registerClass:[ZZChatLocationCell class]
           forCellReuseIdentifier:ChatLoacation];
    
    [self.tableView registerClass:[ZZChatRealTimeStartCell class]
           forCellReuseIdentifier:ChatRealTimeStart];
    
    [self.tableView registerClass:[ZZChatRealTimeEndCell class]
           forCellReuseIdentifier:ChatRealTimeEnd];
    
    [self.tableView registerClass:[ZZChatPacketCell class]
           forCellReuseIdentifier:ChatPacket];
    
    [self.tableView registerClass:[ZZChatNotificationCell class]
           forCellReuseIdentifier:ChatInfoNotification];
    
    [self.tableView registerClass:[ZZChatOrderInfoCell class]
           forCellReuseIdentifier:ChatOrderInfo];
    
    [self.tableView registerClass:[ZZChatConnectCell class]
           forCellReuseIdentifier:ChatConnect];
    
    [self.tableView registerClass:[ZZVideoMessageCell class]
           forCellReuseIdentifier:ChatVideoMessageCell];
    
    [self.tableView registerClass:[ZZChatVideoCell class]
    forCellReuseIdentifier:SightVideoText];
    
    [self.tableView registerClass:[ZZChatWechatPayCell class]
           forCellReuseIdentifier:ChatWechatPayModel];
    
    [self.tableView registerClass:[ZZChatIDPhotoPayCell class]
           forCellReuseIdentifier:ChatIDPhotoPayCellIdentifier];
    
    [self.tableView registerClass:[ZZChatGifCell class]
           forCellReuseIdentifier:ChatGifMessageCell];
    
    [self.tableView registerClass:[ZZTaskFreeActionCell class]
           forCellReuseIdentifier:@"ZZTaskFreeActionCell"];
    
    [self.tableView registerClass:[ZZTaskFreeCell class]
           forCellReuseIdentifier:[ZZTaskFreeCell cellIdentifier]];
    
    [self.tableView registerClass:[ZZChatGiftCell class]
           forCellReuseIdentifier:ChatGiftCell];
    
    [self.tableView registerClass:[ZZChatKTVCell class] forCellReuseIdentifier:ChatKTVCell];
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveMessageNofitication:) name:kMsg_ReceiveMessage object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveReadNotification:) name:RCLibDispatchReadReceiptNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(messageSendNotification:) name:kMsg_SendMessage object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveRecallNotification:) name:RCKitDispatchRecallMessageNotification object:nil];
    
    [self checkBurnAfterReading];
}

/**
 检测阅后即焚
 */
- (void)checkBurnAfterReading {
    WS(weakSelf);
    [[JX_GCDTimerManager sharedInstance] scheduledDispatchTimerWithName:@"AfterReading" timeInterval:1 queue:nil repeats:YES actionOption:AbandonPreviousAction action:^{
        [weakSelf timerEvent];
    }];
}

/**
 阅后即焚
 */
- (void)timerEvent {
    BOOL isHaveBurnAfterRead = NO ;
    for (ZZChatBaseModel *model in _dataArray) {
        if (model.count == 1) {
            [self.deleteArray addObject:model];
        }
        if (model.count != 0) {
            model.count--;
            isHaveBurnAfterRead = YES;
        }
    }
    if (isHaveBurnAfterRead) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_BurnAfterReadCount object:nil];
        if (!self.isUpdatingData) {
            [self burnAfterRead];
        }
    }else{
        [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:@"AfterReading" ];
    }
}

- (void)createViews {
    WeakSelf;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.boxView];
    
    self.payChatBoxView.frame = CGRectMake(0.0, _boxView.top - 30.0, SCREEN_WIDTH, 30.0);
    
    self.tableView.keyboardWillChange = ^(CGRect keyboardRect, UIViewAnimationOptions options, double duration, BOOL showKeyboard) {
        if (weakSelf.boxView.topView.status == ChatBoxStatusShowKeyboard) {
            [UIView animateWithDuration:duration
                                  delay:0.0
                                options:options
                             animations:^{
                                 CGFloat keyboardY = [weakSelf.view convertRect:keyboardRect fromView:nil].origin.y;
                                 CGFloat inputViewFrameY = keyboardY - weakSelf.boxView.topView.height;

                                 if (!showKeyboard) {
                                     inputViewFrameY = inputViewFrameY - SafeAreaBottomHeight;
                                 }
                                 weakSelf.boxView.top = inputViewFrameY;
                                 if (weakSelf.payChatModel.isChange) {
                                     weakSelf.payChatBoxView.top =  weakSelf.boxView.top - 30;
                                     [weakSelf setTableViewInsetsWithBottomValue:weakSelf.view.frame.size.height
                                      - inputViewFrameY+30];
                                 }else{
                                     [weakSelf setTableViewInsetsWithBottomValue:weakSelf.view.frame.size.height
                                      - inputViewFrameY];
                                 }
                                 if (showKeyboard) {
                                     [weakSelf scrollToBottom:YES finish:nil];//偶尔会执行两次
                                 };
                             }
                             completion:nil];
        }
        else if (weakSelf.boxView.topView.status == ChatBoxStatusNormal) {
            [UIView animateWithDuration:duration
                                  delay:0.0
                                options:options
                             animations:^{
                                 weakSelf.boxView.top = SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 20;
                                 if (weakSelf.payChatModel.isChange) {
                                     weakSelf.payChatBoxView.top =  weakSelf.boxView.top-30;
                                      [weakSelf setTableViewInsetsWithBottomValue:weakSelf.boxView.topView.height+30];
                                 }else{
                                       [weakSelf setTableViewInsetsWithBottomValue:weakSelf.boxView.topView.height];
                                 }
                                 
                                 
                             }
                             completion:nil];
        }
    };
    self.tableView.keyboardDidHide = ^() {
        [weakSelf endEditing];
    };
}

- (void)showGiftView {
    if (!_user) {
        return;
    }
    
    if (!_giftHelper) {
        _giftHelper = [[ZZGiftHelper alloc] initWithUser:self.user];
    }
    self.giftHelper.user = self.user;
    ZZGiftsView *giftView = [[ZZGiftsView alloc] initWithFrame:self.view.bounds];
    giftView.giftHelper = self.giftHelper;
    giftView.parentVC = self;
    giftView.delegate = self;
    
    [self.view addSubview:giftView];
    
    [giftView show];
}

- (void)initRealTime {
    WeakSelf;
    [[RCRealTimeLocationManager sharedManager] getRealTimeLocationProxy:ConversationType_PRIVATE targetId:self.uid success:^(id<RCRealTimeLocationProxy> realTimeLocation) {
        weakSelf.realTimeLocation = realTimeLocation;
    } error:^(RCRealTimeLocationErrorCode status) {
        NSLog(@"get location share failure with code %d", (int)status);
    }];
}

#pragma mark - UITableVieMethod
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    ZZChatBaseModel *model = self.dataArray[self.dataArray.count - 1 - indexPath.row];
    NSString *identifier = [ZZChatUtil getIdentifierStringWithMessage:model];
    
    if ([model.userModifyIdentifer isEqualToString:@"TaskFreeCell"]) {
        ZZTaskFreeActionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZZTaskFreeActionCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.info = model.info;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if ([identifier isEqualToString:ChatTaskFreeModelMessageCell]) {
        // 活动的
        ZZTaskFreeCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZTaskFreeCell cellIdentifier] forIndexPath:indexPath];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configureModel:model userAvatar:self.portraitUrl];
        return cell;
    }
    else if ([identifier isEqualToString:ChatRealTimeEnd]) {
        ZZChatRealTimeEndCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ZZChatRealTimeEndCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell setData:model];
        return cell;
    }
    else if ([identifier isEqualToString:ChatInfoNotification]) {
        ZZChatNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ZZChatNotificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell setData:model name:_nickName];
        __weak typeof(cell)weakCell = cell;
        cell.touchReport = ^{
            [weakSelf reportUser:[weakSelf.tableView indexPathForCell:weakCell] isThird:NO];
        };
        cell.touchAddBlack = ^{
            [weakSelf addToBlack];
        };
        cell.touchThirdReport = ^{
            [weakSelf reportUser:[weakSelf.tableView indexPathForCell:weakCell] isThird:YES];
        };
        cell.touchSendPacket = ^{
            [weakSelf gotoMemedaView];
        };
        cell.touchChatServer = ^{
            [weakSelf gotoChatServerView];
        };
        cell.touchGoAddWeiChat = ^{
            [weakSelf addWeChat];
        };
        cell.touchGoCheckWeChat = ^{
            [weakSelf gotoWXView];
        };
        cell.touchGoCheckIncome = ^{
            [weakSelf goToMyIncomRecords];
        };
        return cell;
    }
    else if ([identifier isEqualToString:ChatOrderInfo]) {
        ZZChatOrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ZZChatOrderInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell setData:model];
        return cell;
    }
    else if ([identifier isEqualToString:ChatWechatPayModel]) {
        // 微信号评价
        ZZChatWechatPayCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ZZChatWechatPayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.uid = _uid;
        [cell setData:model];
        return cell;
    }
    else if ([identifier isEqualToString:ChatIDPhotoPayCellIdentifier]) {
        // 查看证件照
        ZZChatIDPhotoPayCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ZZChatIDPhotoPayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.uid = _uid;
        [cell setData:model];
        return cell;
    }
    else if ([identifier isEqualToString:ChatConnect]) {
        ZZChatConnectCell *cell = [tableView dequeueReusableCellWithIdentifier:ChatConnect];
        if (!cell) {
            cell = [[ZZChatConnectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell setData:model];
        cell.touchWX = ^{
            [weakSelf gotoWXView];
        };
        cell.touchVideo = ^{
            [weakSelf liveStreamConnect];
        };
        cell.touchWallet = ^{
            [weakSelf gotoWalletView];
        };
        return cell;
    }
    else if ([identifier isEqualToString:ChatPacket]) {
        // 红包
        ZZChatPacketCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ZZChatPacketCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }

        [cell setData:model];
        return cell;
    }
    else if ([identifier isEqualToString:ChatGiftCell]) {
        // 红包
        ZZChatGiftCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ZZChatGiftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }

        [self setupCell:cell model:model];
        cell.delegate = self;
        return cell;
    }
    else if ([identifier isEqualToString:ChatKTVCell]) {
        // 唱趴
        ZZChatKTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ZZChatKTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }

        [self setupCell:cell model:model];
        cell.delegate = self;
        return cell;
    }
    else if ([identifier isEqualToString:ChatInviteVideoChatModelMessageCell]) {
        ZZChatInviteVideoChatCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ZZChatInviteVideoChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.delegate = self;
        [cell setUpWithUserIcon:self.portraitUrl];
        return cell;
    }
    else {
        ZZChatBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ZZChatBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [self setupCell:cell model:model];
        return cell;
    }
}

- (void)setupCell:(ZZChatBaseCell *)cell model:(ZZChatBaseModel *)model; {
    WeakSelf;
    [cell setData:model];
    [cell setUrl:self.portraitUrl];
    __weak typeof(cell)weakCell = cell;
    cell.touchRetry = ^{
        [weakSelf resendMessage:[weakSelf.tableView indexPathForCell:weakCell]];
    };
    cell.touchLeftHeadImgView = ^{
        [weakSelf tapHeadImgView];
    };
    cell.cellLongPress = ^(UIView *targetView){
        [weakSelf showMenuInView:targetView indexPath:[weakSelf.tableView indexPathForCell:weakCell]];
    };
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZChatBaseModel *model = self.dataArray[self.dataArray.count - 1 - indexPath.row];
    if ([model.userModifyIdentifer isEqualToString:@"TaskFreeCell"]) {
        return 124.0;
    }
    else {
        return [ZZChatUtil getCellHeightWithModel:model];
    }
}

#pragma mark - ZZGiftsViewDelegate
- (void)giftView:(ZZGiftsView *)view chooseGift:(ZZGiftModel *)giftModel {
    ZZChatGiftModel *model = [[ZZChatGiftModel alloc] init];
    model.message = @"礼物";
    model.content = @"赠送的礼物";
    model.title = @"礼物";
    model.icon = giftModel.icon;
    model.from_msg_a = giftModel.from_msg_a;
    model.from_msg_b = giftModel.from_msg_b;
    model.to_msg_a = giftModel.to_msg_a;
    model.to_msg_b = giftModel.to_msg_b;
    model.charm_num = giftModel.charm_num;
    model.color = giftModel.color;
    model.lottie = giftModel.lottie;
    [self sendGiftContent:model];
}


#pragma mark - ZZChatShotViewControllerDelegate
- (void)controller:(ZZChatShotViewController *)controller didTakeVideo:(NSURL *)videoURL thumbnail:(UIImage *)thumbnail {
    AVURLAsset *avUrl = [AVURLAsset assetWithURL:videoURL];

    CMTime time = [avUrl duration];

    int seconds = ceil(time.value/time.timescale);

    [self sendVideo:videoURL thumbnail:thumbnail duration:seconds];
}

- (void)controller:(ZZChatShotViewController *)controller didTakePicture:(UIImage *)picture {
    [self sendImageMessage:picture];
}


#pragma mark - ZZKTVAudioPlayManagerDelegate
- (void)managerDidFinish:(ZZKTVAudioPlayManager *)manager {
    [self stopPlayingAudios];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_dataArray enumerateObjectsUsingBlock:^(__kindof ZZChatBaseModel * _Nonnull baseModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([baseModel.message.content isKindOfClass:[ZZChatKTVModel class]]) {
                ZZChatKTVModel *model = (ZZChatKTVModel *)baseModel.message.content;
                model.isSongPlaying = NO;
            }
        }];
        _currentPlayedSongUrl = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    });
}

#pragma mark - ZZChatInviteVideoChatCellDelegate
- (void)startVideoChatWithCell:(ZZChatInviteVideoChatCell *)cell {
    [self liveStreamConnect];
}

#pragma mark - ZZChatKTVCellDelegate
- (void)cell:(ZZChatKTVCell *)cell playSong:(ZZChatKTVModel *)ktvModel {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([ktvModel.songUrl isEqualToString:_currentPlayedSongUrl]) {
            if (self.audioPlayManager.isPlaying) {
                [self.audioPlayManager pause];
                ktvModel.isSongPlaying = NO;
            }
//            else {
//                [self.audioPlayManager play];
//                ktvModel.isSongPlaying = YES;
//            }
            _currentPlayedSongUrl = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
            });
            return;
        }
        
        _currentPlayedSongUrl = ktvModel.songUrl;
        [_dataArray enumerateObjectsUsingBlock:^(__kindof ZZChatBaseModel * _Nonnull baseModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([baseModel.message.content isKindOfClass:[ZZChatKTVModel class]]) {
                ZZChatKTVModel *model = (ZZChatKTVModel *)baseModel.message.content;
                if ([model.songUrl isEqualToString:ktvModel.songUrl]) {
                    model.isSongPlaying = YES;
                }
                else {
                    model.isSongPlaying = NO;
                }
            }
        }];
        [self.audioPlayManager playAudio:ktvModel.songUrl];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    });
    
}


#pragma mark - ZZChatGiftCellDelegate
- (void)cell:(ZZChatGiftCell *)cell didSelectGift:(ZZChatGiftModel *)giftModel {

}

#pragma mark - ZZTaskFreeCellDelegate
/**
 点击活动框框
 */
- (void)cell:(ZZTaskFreeActionCell *)cell didSelect:(ZZTask *)taskModel {
    // 只有在进行中的,并且没有被下推荐的可以点击
    [self checkTaskFreeStatus:taskModel completion:^(BOOL canProceed) {
        if (canProceed) {
            [self showDetailsWithTaskType:TaskFree];
        }
    }];
}

#pragma mark - ZZTaskFreeActionCellDelegate
/**
    活动点击发送
    1.先判断要不要钱.
    2.然后再发送,聊天要自己发
 */
- (void)cell:(ZZTaskFreeActionCell *)cell didSend:(ZZTaskModel *)taskModel {
    if (self.payChatModel.isRequessSuccess
        && self.payChatModel.isPay
        && !self.payChatModel.wechat_flag
        && !self.payChatModel.following_flag) {
        // 私聊付费模式, 如果是优享邀约 不要钱
        
        [ZZUserHelper shareInstance].consumptionMebi += [[ZZUserHelper shareInstance].configModel.priceConfig.per_chat_cost_mcoin integerValue];
        [self askForAPrivateChatFeeAgain];
        
        NSLog(@"PY_私聊付费%@ -- %ld",[ZZUserHelper shareInstance].loginer.mcoin,  (long)[ZZUserHelper shareInstance].consumptionMebi);
        [ZZPrivateChatPayManager payMebiWithPayChatModel:self.payChatModel nav:self.navigationController CallBack:^{
            [ZZUserHelper shareInstance].consumptionMebi -= [[ZZUserHelper shareInstance].configModel.priceConfig.per_chat_cost_mcoin integerValue];
            
        } NoPayCallBack:^{
            [ZZUserHelper shareInstance].consumptionMebi -= [[ZZUserHelper shareInstance].configModel.priceConfig.per_chat_cost_mcoin integerValue];
            
            [self sendMessageWithContent:@"嗨，我对你发布的活动很感兴趣" completion:nil];
            [self sendTaskFree:taskModel];
        } vc:self];
        
    }
    else{
        // 不要钱的聊天
        [self sendMessageWithContent:@"嗨，我对你发布的活动很感兴趣" completion:nil];
        [self sendTaskFree:taskModel];
    }
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath
              atScrollPosition:(UITableViewScrollPosition)position
                      animated:(BOOL)animated {
    if (self.isUserScrolling) {
        return;
    }
    [self.tableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:position
                                  animated:animated];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isUserScrolling = YES;
    self.isUpdatingData = NO;
    [self endEditing];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.isUserScrolling = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!_noMoreData && _haveLoadData && self.dataArray.count >= 10) {
        if (scrollView.contentOffset.y < 0 && _isRefresh == NO) {
            [self loadMoreData];
        }
    }
}

- (void)setTableViewInsetsWithBottomValue:(CGFloat)bottom {
    if (self.tableView.contentInset.bottom != bottom) {
    NSLog(@"PY_设置的偏移量_%f",bottom);
    UIEdgeInsets insets = [self tableViewInsetsWithBottomValue:bottom];
    self.tableView.contentInset = insets;
    self.tableView.scrollIndicatorInsets = insets;
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
        if (rows > 0) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                                  atScrollPosition:UITableViewScrollPositionBottom
                                          animated:NO];
        }
    }
}

- (UIEdgeInsets)tableViewInsetsWithBottomValue:(CGFloat)bottom {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
        insets.top = self.topLayoutGuide.length;
    }
    insets.bottom = bottom;
    return insets;
}

#pragma mark - ZZChatBoxViewDelegate
- (void)startRecordVoiceShouldChangeHeight:(ZZChatBoxView *)boxView {
    if (self.payChatBoxView) {
        self.payChatBoxView.top =  self.boxView.top-30;
    }
}

- (void)endRecordVoiceShouldChangeHeight:(ZZChatBoxView *)boxView {
    if (self.payChatBoxView) {
        self.payChatBoxView.top =  self.boxView.top-30;
    }
}

- (void)chatView:(ZZChatBoxView *)boxView heightChanged:(CGFloat)height toBottom:(BOOL)toBottom {
    self.tableView.top = _orderStatusHeight;
    if (self.payChatModel.isChange) {
        height -= 30;
        self.payChatBoxView.top = _boxView.top - 30.0;
    }
    
    [self setTableViewInsetsWithBottomValue:SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - height - SafeAreaBottomHeight];
    
    if (toBottom) {
        [self scrollToBottom:NO finish:nil];
    }
}

//TODO:发送消息的接口
- (void)chatView:(ZZChatBoxView *)boxView sendTextMessage:(NSString *)messageStr {
    if ([ZZUtils isBan]) {
        return;
    }
    __block NSInteger sendMessageCount = [ZZPrivateChatPayManager questPrivateChatFeeISFirstTenWithUid:self.uid];
    if (sendMessageCount <= 30) {
        NSString *str = [ZZChatUtil getSensitiveStringWithString:messageStr];
        if (!isNullString(str)) {
            [self showOKCancelAlertWithTitle:@"不良信息提示"
                                     message:@"发送不良信息会被封禁处理,\n您发送的消息可能包含不良信息，请遵守社区规则"
                                 cancelTitle:@"撤回" cancelBlock:^{
                self.boxView.topView.textView.text = nil;
            }
                                     okTitle:@"发送"
                                     okBlock:^{
                sendMessageCount +=1;
                NSString *key = [NSString stringWithFormat:@"getBannedNumber%@%@",[ZZUserHelper shareInstance].loginer.uid,self.uid];
                [ZZKeyValueStore saveValue:@(sendMessageCount) key:key];
                [self sendMessageWithContent:messageStr completion:nil];
            }];
        }
    }

    [self sendMessageWithContent:messageStr completion:nil];

}

/**
 文字发送消息

 @param content  消息的内容
 */
- (void)sendMessageWithContent:(NSString *)content completion:(void(^)(BOOL canSend))completion {
    
    WeakSelf;
    NSString *thirdKey = [NSString stringWithFormat:@"ThirdSensitiveMessage%@",self.uid];
    NSString *thirdValue = [ZZKeyValueStore getValueWithKey:thirdKey];
    if (isNullString(thirdValue)) {
        NSString *thirdString = [ZZChatUtil getThirdPayInfoStringWithString:content];
        if (!isNullString(thirdString)) {
            [self endEditing];
            [self.view.window addSubview:self.thirdAlertView];
            _thirdAlertView.touchSure = ^{
                [ZZKeyValueStore saveValue:@"ThirdSensitiveMessage" key:thirdKey];
                weakSelf.boxView.topView.textView.text = content;
                weakSelf.thirdAlertView = nil;
                [weakSelf.boxView.topView.textView becomeFirstResponder];
            };
            return;
        }
    }
    
    // 敏感词检测
    if ([ZZChatUtil isWxSensitiveString:content]) {
        _wxSensitive = content;
    }
    
    NSString *key = [NSString stringWithFormat:@"getBannedNumber%@%@",[ZZUserHelper shareInstance].loginer.uid,self.uid];
    NSString *value = [ZZKeyValueStore getValueWithKey:key];
 
    //
    if (self.payChatModel.isRequessSuccess && self.payChatModel.isPay && !self.payChatModel.wechat_flag && !self.payChatModel.following_flag) {
        //TODO:私聊付费模式, 如果是优享邀约 不要钱
        [ZZUserHelper shareInstance].consumptionMebi += [[ZZUserHelper shareInstance].configModel.priceConfig.per_chat_cost_mcoin integerValue];
        [self askForAPrivateChatFeeAgain];

        NSLog(@"PY_私聊付费%@ -- %ld",[ZZUserHelper shareInstance].loginer.mcoin,  (long)[ZZUserHelper shareInstance].consumptionMebi);
        [ZZPrivateChatPayManager payMebiWithPayChatModel:self.payChatModel nav:self.navigationController CallBack:^{
            [ZZUserHelper shareInstance].consumptionMebi -= [[ZZUserHelper shareInstance].configModel.priceConfig.per_chat_cost_mcoin integerValue];;
            self.boxView.topView.textView.text = content;
            [self endEditing];
            if (completion) {
                completion(NO);
            }
        } NoPayCallBack:^{
            RCTextMessage *message= [RCTextMessage messageWithContent:content];
            NSDictionary *extraDic = @{@"payChat":PrivateChatPay,@"check":@(NO)};
            if (value&&[value intValue]<=30) {
                extraDic =  @{@"payChat":PrivateChatPay,@"check":@(YES)};
            }
            NSString *extra = [ZZUtils dictionaryToJson:extraDic];

            message.extra = self.payChatModel.isThanCheckVersion?extra:PrivateChatPay;
            [self sendMessageContent:message pushContent:content];
            if (completion) {
                completion(YES);
            }
        } vc:self];
        
    }
    else {
        [self askForAPrivateChatFeeAgain];

        if (_isMessageBox && !_isMessageBoxTo) {
            [self sendMessageBox:content];
            return;
        }
        RCTextMessage *message= [RCTextMessage messageWithContent:content];
        NSDictionary *extraDic = @{@"payChat":BurnAfterRead,@"check":@(NO)};
        if (value&&[value intValue]<=30) {
            extraDic =  @{@"payChat":BurnAfterRead,@"check":@(YES)};
        }
        NSString *extra = [ZZUtils dictionaryToJson:extraDic];
        message.extra = self.boxView.topView.isBurnAfterRead?(self.payChatModel.isThanCheckVersion?extra:BurnAfterRead):nil;
        [self sendMessageContent:message pushContent:content];
        
        if (completion) {
            completion(YES);
        }
    }
}

- (void)voiceDidStartRecording {
    self.navigationLeftBtn.userInteractionEnabled = NO;
    self.customBtn.userInteractionEnabled = NO;
    self.moreBtn.userInteractionEnabled = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    for (UIView *view in self.view.subviews) {
        if (view != self.boxView) {
            view.userInteractionEnabled = NO;
        }
    }
}

- (void)voiceDidEndRecording {
    self.navigationLeftBtn.userInteractionEnabled = YES;
    self.customBtn.userInteractionEnabled = YES;
    self.moreBtn.userInteractionEnabled = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    for (UIView *view in self.view.subviews) {
        view.userInteractionEnabled = YES;
    }
}

- (void)chatView:(ZZChatBoxView *)boxView sendVoiceMessage:(NSData *)voiceData during:(long)during {
    if ([ZZUtils isBan]) {
        return;
    }
  __block   RCVoiceMessage *message = [RCVoiceMessage messageWithAudio:voiceData duration:during];
    //私聊付费模式
  if (self.payChatModel.isRequessSuccess&&self.payChatModel.isPay) {
      [ZZUserHelper shareInstance].consumptionMebi += [[ZZUserHelper shareInstance].configModel.priceConfig.per_chat_cost_mcoin integerValue];;
      [self askForAPrivateChatFeeAgain];

      [ZZPrivateChatPayManager  payMebiWithPayChatModel:self.payChatModel nav:self.navigationController CallBack:^{
          [ZZUserHelper shareInstance].consumptionMebi -= [[ZZUserHelper shareInstance].configModel.priceConfig.per_chat_cost_mcoin integerValue];;
      } NoPayCallBack:^{
          NSString *extra = [ZZUtils dictionaryToJson:@{@"payChat":PrivateChatPay,@"check":@(NO)}];
          message.extra  =  self.payChatModel.isThanCheckVersion?extra:PrivateChatPay;
          [self sendMessageContent:message pushContent:@"[语音]"];
      } vc:self];
  }else{
      [self askForAPrivateChatFeeAgain];
      NSString *extra = [ZZUtils dictionaryToJson:@{@"payChat":BurnAfterRead,@"check":@(NO)}];
      message.extra = self.boxView.topView.isBurnAfterRead?(self.payChatModel.isThanCheckVersion?extra:BurnAfterRead):nil;
      [self sendMessageContent:message pushContent:@"[语音]"];
  }
}

- (void)chatView:(ZZChatBoxView *)boxView selectedType:(ChatBoxType)selectedType {
    if ([ZZUtils isBan]) {
        return;
    }

    switch (selectedType) {
        case ChatBoxTypeImage: {
            if (self.payChatModel.isRequessSuccess&&self.payChatModel.isPay) {
                [ZZUserHelper shareInstance].consumptionMebi += [[ZZUserHelper shareInstance].configModel.priceConfig.per_chat_cost_mcoin integerValue];;
                [ZZPrivateChatPayManager payMebiWithPayChatModel:self.payChatModel nav:self.navigationController CallBack:^{
                    [ZZUserHelper shareInstance].consumptionMebi -= [[ZZUserHelper shareInstance].configModel.priceConfig.per_chat_cost_mcoin integerValue];;
                    } NoPayCallBack:^{
                        [ZZUserHelper shareInstance].consumptionMebi -= [[ZZUserHelper shareInstance].configModel.priceConfig.per_chat_cost_mcoin integerValue];
                        [self selectAlbum];
                } vc:self];
            }
            else {
                [self selectAlbum];
            }
        }
            break;
        case ChatBoxTypeVideo: {
            [self liveStreamConnect];
            _isMessageBoxTo = NO;
            break;
        }
        case ChatBoxTypePacket: {
            [self gotoMemedaView];
            break;
        }
        case ChatBoxTypeLocation: {
            WS(weakSelf);
            [UIActionSheet showInView:self.view withTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"发送位置",@"位置实时共享"] tapBlock:^(UIActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    
                    _notUpdateOrder = YES;
                    ZZChatLocationViewController *controller = [[ZZChatLocationViewController alloc] init];
                    controller.locationCallBack = ^(UIImage *image,CLLocation *location,NSString *name) {
                        __strong typeof(weakSelf) strongSelf = weakSelf;

                        RCLocationMessage *message = [RCLocationMessage messageWithLocationImage:image location:location.coordinate locationName:name];
                        //私聊付费模式
                        if (strongSelf.payChatModel.isRequessSuccess&&strongSelf.payChatModel.isPay) {
                            [ZZUserHelper shareInstance].consumptionMebi += [[ZZUserHelper shareInstance].configModel.priceConfig.per_chat_cost_mcoin integerValue];;
                            [self askForAPrivateChatFeeAgain];

                            [ZZPrivateChatPayManager  payMebiWithPayChatModel:strongSelf.payChatModel nav:strongSelf.navigationController CallBack:^{
                                   [ZZUserHelper shareInstance].consumptionMebi -= [[ZZUserHelper shareInstance].configModel.priceConfig.per_chat_cost_mcoin integerValue];;
                            } NoPayCallBack:^{
                                NSString *extra = [ZZUtils dictionaryToJson:@{@"payChat":PrivateChatPay,@"check":@(NO)}];
                                message.extra  = self.payChatModel.isThanCheckVersion?extra:PrivateChatPay;
                                [strongSelf sendMessageContent:message pushContent:@"[位置]"];
                            } vc:self];
                        }else{
                            [self askForAPrivateChatFeeAgain];
                            NSString *extra = [ZZUtils dictionaryToJson:@{@"payChat":BurnAfterRead,@"check":@(NO)}];
                            message.extra = strongSelf.boxView.topView.isBurnAfterRead?(self.payChatModel.isThanCheckVersion?extra:BurnAfterRead):nil;
                            [strongSelf sendMessageContent:message pushContent:@"[位置]"];

                        }
                    };
                    [self.navigationController pushViewController:controller animated:YES];
                } else if (buttonIndex == 1)  {
                    _isMessageBoxTo = NO;
                    _notUpdateOrder = YES;
                    [self gotoRealTimeController];
                }
            }];
             break;
        }
        case ChatBoxTypeRecord : {
            if (self.payChatModel.isRequessSuccess&&self.payChatModel.isPay) {
                [ZZUserHelper shareInstance].consumptionMebi += [[ZZUserHelper shareInstance].configModel.priceConfig.per_chat_cost_mcoin integerValue];;
                [ZZPrivateChatPayManager  payMebiWithPayChatModel:self.payChatModel nav:self.navigationController CallBack:^{
                    [ZZUserHelper shareInstance].consumptionMebi -= [[ZZUserHelper shareInstance].configModel.priceConfig.per_chat_cost_mcoin integerValue];;
                } NoPayCallBack:^{
                    if (self.boxView.topView.status == ChatBoxStatusShowRecord) {
                        self.boxView.topView.status = ChatBoxStatusNormal;
                        [self.boxView.topView.textView textDidChange];
                    } else {
                        self.boxView.topView.status = ChatBoxStatusShowRecord;
                        self.boxView.topView.selectedType = selectedType;
                    }
                    [self.boxView.topView statusChanged];
                    
                } vc:self];
            }else{
                if (self.boxView.topView.status == ChatBoxStatusShowRecord) {
                    self.boxView.topView.status = ChatBoxStatusNormal;
                    [self.boxView.topView.textView textDidChange];
                } else {
                    self.boxView.topView.status = ChatBoxStatusShowRecord;
                    self.boxView.topView.selectedType = selectedType;
                }
                [self.boxView.topView statusChanged];
            }
            break;
        }
        case ChatBoxTypeShot: {
            if (self.payChatModel.isRequessSuccess&&self.payChatModel.isPay) {
                [ZZUserHelper shareInstance].consumptionMebi += [[ZZUserHelper shareInstance].configModel.priceConfig.per_chat_cost_mcoin integerValue];;
                [ZZPrivateChatPayManager payMebiWithPayChatModel:self.payChatModel nav:self.navigationController CallBack:^{
                    [ZZUserHelper shareInstance].consumptionMebi -= [[ZZUserHelper shareInstance].configModel.priceConfig.per_chat_cost_mcoin integerValue];;
                    } NoPayCallBack:^{
                        [ZZUserHelper shareInstance].consumptionMebi -= [[ZZUserHelper shareInstance].configModel.priceConfig.per_chat_cost_mcoin integerValue];
                        [self recordVideo];
                } vc:self];
            }
            else {
                [self recordVideo];
            }
            break;
        }
        case ChatBoxTypeGift: {
            [self showGiftView];
            break;
        }
        default:
            break;
    }
}

- (void)recordVideo {
    [ZZUtils checkRecodeAuth:^(BOOL authorized) {
        if (authorized) {
            ZZChatShotViewController *vc = [[ZZChatShotViewController alloc] init];
            vc.delegate = self;
            [self.navigationController presentViewController:vc animated:YES completion:nil];
        }
    }];
}

- (void)selectAlbum {
    WeakSelf;
    if (![ZZUtils isAllowPhotoLibrary]) return;
    _notUpdateOrder = YES;
    BOOL shouldPay = (self.payChatModel.isRequessSuccess && self.payChatModel.isPay && !self.payChatModel.wechat_flag && !self.payChatModel.following_flag);
    TZImagePickerController *controller = [[TZImagePickerController alloc] initWithMaxImagesCount:4 columnNumber:4 delegate:nil pushPhotoPickerVc:YES isFromChat:YES chatShouldPay:shouldPay];
    controller.isCustomStyle = YES;
    controller.modalPresentationStyle = UIModalPresentationFullScreen;
    controller.navigationBar.barTintColor = RGBCOLOR(63, 58, 58);
    controller.barItemTextColor = UIColor.whiteColor;
    controller.oKButtonTitleColorDisabled = kBlackTextColor;
    controller.oKButtonTitleColorNormal = kYellowColor;
    controller.isFromChat = YES;
    controller.allowPickingVideo = YES;
    if (_isMessageBox && !_isMessageBoxTo) {
        controller.allowPickingVideo = NO;
    }
    
    controller.allowTakePicture = NO;
    controller.allowTakeVideo = NO; // 在内部显示拍照按钮
    controller.allowCameraLocation = NO;
    controller.allowPickingMultipleVideo = NO;
    controller.pickerDelegate = self;
    
    [self presentViewController:controller animated:YES completion:nil];
    [controller setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (photos.count<=0) {
            return ;
        }
        
        [assets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull phAsset, NSUInteger idx, BOOL * _Nonnull stop) {
            if (phAsset.mediaType == PHAssetMediaTypeImage) {
                if (idx < photos.count) {
                    [weakSelf sendImageMessage:photos[idx]];
                }
            }
            else if (phAsset.mediaType == PHAssetMediaTypeVideo) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
                        options.version = PHVideoRequestOptionsVersionCurrent;
                        options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
                        
                        PHImageManager *manager = [PHImageManager defaultManager];
                        [manager requestAVAssetForVideo:phAsset
                                                options:options
                                          resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                                              AVURLAsset *urlAsset = (AVURLAsset *)asset;
                            [weakSelf sendVideo:urlAsset.URL thumbnail:photos[idx] duration:phAsset.duration];
                                          }];
                    
                });
                
            }
        }];
    }];
}

- (void)selectCamera {
    WeakSelf;
    if (![ZZUtils isAllowCamera]) return;
    _notUpdateOrder = YES;
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    imgPicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    imgPicker.finalizationBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
        [picker dismissViewControllerAnimated:YES completion:^{
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            [weakSelf sendImageMessage:image];
        }];
    };
    imgPicker.cancellationBlock = ^(UIImagePickerController *picker) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    };
    [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
}

- (void)liveStreamConnect {
    
    if ([ZZUtils isConnecting]) {
        return;
    }
    
    [ZZHUD show];
    [ZZUserHelper requestMeBiAndMoneynext:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [ZZHUD dismiss];
        
            NSInteger mebi = [data[@"mcoin_total"] integerValue];
            if (mebi <=0) {
                [ZZActivityUrlNetManager loadH5ActiveWithViewController:self isHaveReceived:NO callBack:^{
                  [self gotoChongZhiVCWhenUnderbalance];
                }];
                return;
            }

            NSInteger totalMoney = [ZZUserHelper shareInstance].configModel.priceConfig.one_card_to_mcoin.integerValue * [ZZUserHelper shareInstance].configModel.priceConfig.per_unit_cost_card.integerValue;
            
            if (mebi< totalMoney) {
                [self gotoChongZhiVCWhenUnderbalance];
            }else{
                [self againVideo];
            }
        }
    }];
}

/**
 余额不足的时候前去充值
 */
- (void)gotoChongZhiVCWhenUnderbalance {
    [UIAlertController presentAlertControllerWithTitle:kMsg_Mebi_NO message:nil doneTitle:@"充值" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
        if (!isCancelled) {
            [MobClick event:Event_click_OneToOneChat_TopUp];
            ZZMeBiViewController *vc = [ZZMeBiViewController new];
            WS(weakSelf);
            [vc setPaySuccess:^(ZZUser *paySuccesUser) {
            
                if ([[ZZUserHelper shareInstance].loginer.mcoin integerValue] >=40) {
                    NSMutableArray<ZZViewController *> *vcs = [weakSelf.navigationController.viewControllers mutableCopy];
                    [vcs removeLastObject];
                    [weakSelf.navigationController setViewControllers:vcs animated:NO];
                    [weakSelf againVideo];
                }else{
                    //按照么币充值的最小单位,永远不会触发这个判断,文案就先这样写了
                    [ZZHUD showWithStatus:@"么币不足40,依旧不足聊天哦"];
                }
            }];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];
}

// 再次视频
- (void)againVideo {
    if ([ZZUtils isConnecting]) {
        return;
    }
    _isMessageBoxTo = NO;
    [self nextStep];
}

// 获取最新的余额之后再调起视频
- (void)nextStep {
    WEAK_SELF();
    [[ZZLiveStreamHelper sharedInstance] checkAuthority:^(BOOL authorized) {
        if (authorized) {
            [weakSelf gotoRecode];
        }
    }];
}

- (void)gotoRecode {
    WEAK_SELF();
    //对方
    dispatch_async(dispatch_get_main_queue(), ^{
        ZZUser *user = _user;
        _connectingVC = [ZZliveStreamConnectingController new];
        _connectingVC.user = user;
        _connectingVC.showCancel = YES;
        WEAK_OBJECT(_uid, weakUid);

        [_connectingVC setConnectVideoStar:^(id data) {
            // 先进入视频页面
            [weakSelf gotoConnectView:weakUid data:data];
        }];
        
        [_connectingVC setQuxiao:^(RCMessage *chatMessage, BOOL isSuccess) {
            //取消视屏聊天
             NSLog(@"PY_取消视屏聊天");
            ZZChatBaseModel *model = [[ZZChatBaseModel alloc] init];
            model.message =(RCMessage *)chatMessage;
            long long time = [[NSDate date] timeIntervalSince1970] * 1000;
            model.showTime = [weakSelf sendMessageShouldShowTime:time];
            [weakSelf addMessage:model];
        }];
        
        [weakSelf.navigationController pushViewController:_connectingVC animated:NO];
        [_connectingVC show];
        [weakSelf conncetAuthorized];

    });
}

- (void)conncetAuthorized {
    [ZZChatCallIphoneManagerNetWork callIphone:SureCallIphone_MeBiStyle roomid:nil uid:_uid paramDic:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
            if (error.code == CODE_SHIELDING || error.code == CODE_BANNED) {
                _connectingVC.view.userInteractionEnabled = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [NSObject asyncWaitingWithTime:1.5 completeBlock:^{
                        [_connectingVC.navigationController popViewControllerAnimated:YES];
                    }];
                });
            }
        }
        else {
            if (![ZZLiveStreamHelper sharedInstance].isBusy) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _connectingVC.data = data;
                });
            }
        }
    }];

}

- (void)gotoConnectView:(NSString *)uid data:(id)data {
    WEAK_SELF();
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSMutableArray<ZZViewController *> *vcs = [self.navigationController.viewControllers mutableCopy];
        [vcs removeLastObject];
        
        ZZLiveStreamConnectViewController *controller = [[ZZLiveStreamConnectViewController alloc] init];
        controller.uid = uid;
        controller.isDisableVideo = _connectingVC.stickerBtn.isSelected;
        [vcs addObject:controller];
        [weakSelf.navigationController setViewControllers:vcs animated:YES];
        
        // 再进行视频连接
        ZZLiveStreamHelper *helper = [ZZLiveStreamHelper sharedInstance];
        helper.targetId = uid;
        helper.data = data;
        helper.isUseMcoin = YES;
        [helper connect:^{
             NSLog(@"PY_收到远程消息_进入房间成功");
        }];
        helper.failureConnect = ^{
            [controller.navigationController popViewControllerAnimated:YES];
        };
    });
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset {
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.version = PHVideoRequestOptionsVersionOriginal;
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable avasset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        if (avasset) {
            AVURLAsset *urlAsset = (AVURLAsset *)avasset;
            [self sendVideo:urlAsset.URL thumbnail:coverImage duration:10];
        }
    }];
}

#pragma mark - ZZRecordManagerDelegate
- (void)voiceDidPlayFinished {
    [self burnVoiceWhileEndListen];
    ZZRecordManager *manager = [ZZRecordManager shareManager];
    manager.delegate = nil;
    [self.currentPlayVoiceImgView stopAnimating];
    self.currentPlayVoiceImgView = nil;
    self.currentPlayVoiceData = nil;
    [self playNextUnReadVoice];
}

- (void)burnVoiceWhileEndListen {
    if (_currentPlayVoiceModel && [ZZChatUtil isLocalBurnReadedMessage:_currentPlayVoiceModel]) {
        if (_currentPlayVoiceModel.count == 0) {
            _currentPlayVoiceModel.count = BurnMaxCount;
            [self.countDownArray addObject:_currentPlayVoiceModel];
        }
    }
}

#pragma mark - photobrowser代理方法
// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    return _currentSelectedImage;
}

- (void)photoBrowser:(HZPhotoBrowser *)browser currentIndex:(NSInteger)index {
    HZPhotoItem *item = self.photoArray[index];
    ZZChatImageCell *cell = [self.tableView cellForRowAtIndexPath:item.indexPath];
    CGRect rect = [cell convertRect:cell.bgView.frame toView:self.view];
    rect.origin.y = rect.origin.y + NAVIGATIONBAR_HEIGHT;
    _browser.sourceRect = rect;
    RCImageMessage *message = (RCImageMessage *)item.data;
    _currentSelectedImage = message.thumbnailImage;
    if (rect.size.width == 0 ) {
        _browser.showAnimation = NO;
    } else {
        _browser.showAnimation = YES;
    }
}

// 返回高质量图片的url
- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    NSString *urlStr = [[self.photoArray[index] thumbnail_pic] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    return [NSURL URLWithString:urlStr];
}

#pragma mark - NSNotification
//收到消息通知
- (void)receiveMessageNofitication:(NSNotification *)notification {
    RCMessage *message = [notification.userInfo objectForKey:@"message"];
    if (message.conversationType == ConversationType_PRIVATE) {
        [self addMessageCount];
    }
    
    if ([message.targetId isEqualToString:self.uid]) {
        //TODO:开启动画  如果当前时间为0的话就重置
      
        ZZChatBaseModel *model = [[ZZChatBaseModel alloc] init];
        model.message = message;
        /** 是阅后即焚的消息*/
        if (model.count==1) {
            [self checkBurnAfterReading];
        }
        /***/
        model.showTime = [self sendMessageShouldShowTime:message.sentTime];
        self.payChatModel.isFirst = NO;
        if (self.payChatModel.isChange) {
            if ([ZZChatUtil isPrivChatMessage:model]) {
                self.payChatModel.wait_answerCout+=1 ;
                [self updateStateIsFirstIntoRoom:NO];
            }
        }
        
        if ([message.content isKindOfClass:[ZZChatOrderInfoModel class]]) {
            [self  askForAPrivateChatFeeAgain];
        }
        
        [self addMessage:model];
        if ([ZZChatUtil isReceiveBurnReadedMessage:model]) {
            model.count = BurnMaxCount;
            [self.countDownArray addObject:model];
        }
        if (!self.viewDisappear) {
            [self clearUnreadMessage:[ZZChatUtil shouldSendReadStatus:message]];
        }
        [self didReceiveMessage:message];
        
        if ([ZZChatUtil shouldSendReadStatus:message]) {
            [self setReadStatus];
        }
        if (_isMessageBox && !_isMessageBoxTo) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.boxView.topView.isMessageBox = NO;
                _isMessageBox = NO;
            });
        }
        
        // 插入礼物
        dispatch_async(dispatch_get_main_queue(), ^{
            [_giftHelper reciveANewGift:message showIn:self.view];
        });
    }
}

/**
 收到消息的回执通知
 */
- (void)receiveReadNotification:(NSNotification *)notification {
    NSLog(@"已读消息的条数");
    [self getSendRedMessage];
    //设置消息的已读状态
    [self setReadStatus];
}

/**
 根据targetId更改回执的已读消息的状态
 @param targetId 会话的id
 */
- (void)getSendRedMessage {
    WS(weakSelf);
    [self.dataArray enumerateObjectsUsingBlock:^(ZZChatBaseModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (model.message.messageDirection == MessageDirection_SEND) {
            if (model.message.sentStatus != SentStatus_READ && model.message.sentStatus == SentStatus_SENT) {
                model.message.sentStatus = SentStatus_READ;
                //阅后即焚
                if ([ZZChatUtil isBurnAfterReadMessage:model]) {
                    NSLog(@"是否是阅后即焚%d",[ZZChatUtil isBurnAfterReadMessage:model]);
                    model.count = BurnMaxCount;
                    [self checkBurnAfterReading];
                    [weakSelf.countDownArray addObject:model];
                }
            }
        }
        NSLog(@"已经发送的消息的状态%lu",(unsigned long)model.message.sentStatus)
    }];
}

- (void)setReadStatus {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *indexArray = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in indexArray) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if (self.dataArray.count <= self.dataArray.count - 1 - indexPath.row) {
                //当前的索引大于self.dataArray的容量的数据就跳过当前的循环 防止崩溃
                continue;
            }
            ZZChatBaseModel *model = self.dataArray[self.dataArray.count - 1 - indexPath.row];
            if ([ZZChatUtil isBurnAfterReadMessage:model]) {
                model.count = BurnMaxCount;
                [self.countDownArray addObject:model];
                continue;
            }
            if ([cell isKindOfClass:[ZZChatBaseCell class]]) {
                ZZChatBaseCell *baseCell = (ZZChatBaseCell *)cell;
                //不是对方的头像  不是对方  不是正在发送中 不是重发 消息就设置为已读
                if (!baseCell.isLeft && baseCell.otherHeadImgView.hidden && baseCell.activityView.hidden && baseCell.retryButton.hidden) {
                    baseCell.readStatusView.hidden = NO;
                } else {
                    baseCell.readStatusView.hidden = YES;
                }
            }
        }
    });
}

//收到消息撤回的通知
- (void)receiveRecallNotification:(NSNotification *)notification {
    long messageId = [notification.object longValue];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        WS(weakSelf);
        [self.dataArray enumerateObjectsUsingBlock:^(ZZChatBaseModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            if (model.message.messageId == messageId) {
                [weakSelf replaceModelWithMessageId:messageId model:model index:idx direction:MessageDirection_RECEIVE];
                *stop = YES;
            }
        }];
    });
}

//发送消息回调（针对同一个人得聊天界面）
- (void)messageSendNotification:(NSNotification *)notification {
    ZZChatBaseModel *model = [notification.userInfo objectForKey:@"message"];
   
    if ([model.message.targetId isEqualToString:self.uid]) {
        
        if (![self.dataArray containsObject:model]) {
            [self addMessage:model];
        } else {
            [self reloadCell:model];
        }
    }
}

#pragma mark - Public Method
- (void)scrollToBottom:(BOOL)nolimit finish:(void (^)(void))finish {
    if (self.isUserScrolling) {
        return;
    }
    if ((!_isRefresh && !self.isUpdatingData) || nolimit) {
        [CATransaction begin];
        [CATransaction setCompletionBlock: ^{
            if (finish) {
                finish();
            }
        }];
        NSInteger rows = [self.tableView numberOfRowsInSection:0];
        if (rows > 0) {

            CGSize size = self.tableView.contentSize;
            if (size.height + self.tableView.contentInset.bottom > self.tableView.height) {
                self.tableView.contentOffset = CGPointMake(0, size.height - self.tableView.height + self.tableView.contentInset.bottom);
            } else {
                self.tableView.contentOffset = CGPointMake(0, 0);
            }
        }
        [CATransaction commit];
    }
}

- (void)endEditing {
    [self.boxView endEditing];
    if (self.payChatModel.isChange) {
        self.payChatBoxView.top =  self.boxView.top-30;
    }
}

- (void)didReceiveMessage:(RCMessage *)message {
    
}

- (void)didSendMessage:(ZZChatBaseModel *)model {
    
}

- (void)gotoMemedaView {
    
}

- (void)addToBlack {
    
}

- (void)addWeChat {
    
}

- (void)notifyOther {
    
}

- (void)reloadTableView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)burnAfterRead {
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (ZZChatBaseModel *model in self.deleteArray) {
        if ([_dataArray containsObject:model]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(_dataArray.count - [_dataArray indexOfObject:model] - 1) inSection:0];
            [indexPaths addObject:indexPath];
        }
    }
    if (indexPaths.count != 0) {
        self.isUpdatingData = YES;
        [_dataArray removeObjectsInArray:self.deleteArray];
        for (ZZChatBaseModel *model in self.deleteArray) {
            [[RCIMClient sharedRCIMClient] deleteMessages:@[@(model.message.messageId)]];
        }
        [self.countDownArray removeObjectsInArray:self.deleteArray];
        [self.deleteArray removeAllObjects];
        dispatch_async(dispatch_get_main_queue(), ^{
            [CATransaction begin];
            [CATransaction setCompletionBlock: ^{
                [self animationComplete];
            }];
            [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            [CATransaction commit];
        });
    }
}

- (void)animationComplete {
    self.isUpdatingData = NO;
    if (self.deleteArray.count) {
        [self burnAfterRead];
    }
}

#pragma mark - 重新请求私聊付费数据
- (void)askForAPrivateChatFeeAgain {
     NSLog(@"PY_开始请求私聊付费的数据");
    [ZZPrivateChatPayManager requestUserInfoWithUid:self.uid privateChatPay:^(ZZPrivateChatPayModel *payModel) {
        self.payChatModel.globaChatCharge = payModel.globaChatCharge;
        self.payChatModel.open_charge = payModel.open_charge;
        self.payChatModel.chatUserVersion = payModel.chatUserVersion;
        self.payChatModel.bothfollowing = payModel.bothfollowing;
        self.payChatModel.ordering = payModel.ordering;
        self.payChatModel.isFirst = NO;
        [self updateStateIsFirstIntoRoom:NO];
    }];
}

#pragma mark - 发送消息
/*
 发送礼物消息
 */
- (void)sendGiftContent:(ZZChatGiftModel *)giftContent {
    if (![self canSendMessageWithMessageContent:giftContent]) {
        _sensitiveStr = nil;
        return;
    }
    _isMessageBoxTo = NO;
    
    // 如果是从KTV过来的要显示一个提示来源文案
    [self sendNotificationFromKTV];
    
    WeakSelf;
    ZZChatBaseModel *model = [[ZZChatBaseModel alloc] init];
    RCMessage *message = [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE targetId:self.user.uid content:giftContent pushContent:@"[收到一个礼物]" pushData:[self getPushData] success:^(long messageId) {
        
        [weakSelf reloadCell:model];
        [weakSelf didSendMessage:model];

        // 发送活跃回复用户的接口
        [self sendHighlyActiveReplyUserRequest];
        
        // 第一次发送消息,需要记录用户的UID到本地数据库
        [_giftHelper addChatUser];
        [_boxView hideGiftTipView];
        _isMessageBox = NO;
        _boxView.isMessageBox = NO;
        _boxView.topView.isMessageBox = NO;
        [_boxView.topView swtcihToNormalMode];
        
    } error:^(RCErrorCode nErrorCode, long messageId) {
        [weakSelf reloadCell:model];
        [weakSelf sendMessageFailure:nErrorCode];
        weakSelf.sensitiveStr = nil;
        weakSelf.wxSensitive = nil;
    }];
    
    model.message = message;
    long long time = [[NSDate date] timeIntervalSince1970] * 1000;
    model.showTime = [self sendMessageShouldShowTime:time];
    [self addMessage:model];
}

- (void)sendImageMessage:(UIImage *)image {
    RCImageMessage *imageMessage = [RCImageMessage messageWithImage:image];
    if (self.payChatModel.isRequessSuccess && self.payChatModel.isPay && !self.payChatModel.wechat_flag && !self.payChatModel.following_flag) {
        NSString *extra = [ZZUtils dictionaryToJson:@{@"payChat":PrivateChatPay,@"check":@(NO)}];

        [ZZUserHelper shareInstance].consumptionMebi += [[ZZUserHelper shareInstance].configModel.priceConfig.per_chat_cost_mcoin integerValue];;
        [self askForAPrivateChatFeeAgain];

        //TODO:私聊付费
        [ZZPrivateChatPayManager payMebiWithPayChatModel:self.payChatModel nav:self.navigationController CallBack:^{
            [ZZUserHelper shareInstance].consumptionMebi -= [[ZZUserHelper shareInstance].configModel.priceConfig.per_chat_cost_mcoin integerValue];;
        } NoPayCallBack:^{
            imageMessage.extra = self.payChatModel.isThanCheckVersion?extra:PrivateChatPay;
            [self sendImageContent:imageMessage];
        } vc:self];
    }else{
        [self askForAPrivateChatFeeAgain];
        NSString *extra = [ZZUtils dictionaryToJson:@{@"payChat":BurnAfterRead,@"check":@(NO)}];
        imageMessage.extra = self.boxView.topView.isBurnAfterRead?(self.payChatModel.isThanCheckVersion?extra:BurnAfterRead):nil;
        [self sendImageContent:imageMessage];
    }
}

- (void)sendVideo:(NSURL *)videoURL thumbnail:(UIImage *)thumbnail duration:(NSUInteger)duration {
    RCSightMessage *sightMessage = [RCSightMessage messageWithLocalPath:videoURL.path thumbnail:thumbnail duration:duration];
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    long long totalMilliseconds = interval * 1000;
    NSString *name = [NSString stringWithFormat:@"video_%lld.mp4", totalMilliseconds];
    long long size = [[[NSFileManager defaultManager] attributesOfItemAtPath:videoURL.path error:nil] fileSize];
    [sightMessage setValue:name forKey:@"name"];
    [sightMessage setValue:@(size) forKey:@"size"];

    if (self.payChatModel.isRequessSuccess && self.payChatModel.isPay && !self.payChatModel.wechat_flag && !self.payChatModel.following_flag) {
        NSString *extra = [ZZUtils dictionaryToJson:@{@"payChat":PrivateChatPay,@"check":@(NO)}];

        [ZZUserHelper shareInstance].consumptionMebi += [[ZZUserHelper shareInstance].configModel.priceConfig.per_chat_cost_mcoin integerValue];;
        [self askForAPrivateChatFeeAgain];

        //TODO:私聊付费
        dispatch_async(dispatch_get_main_queue(), ^{
            [ZZPrivateChatPayManager payMebiWithPayChatModel:self.payChatModel nav:self.navigationController CallBack:^{
                [ZZUserHelper shareInstance].consumptionMebi -= [[ZZUserHelper shareInstance].configModel.priceConfig.per_chat_cost_mcoin integerValue];;
            } NoPayCallBack:^{
                sightMessage.extra = self.payChatModel.isThanCheckVersion?extra:PrivateChatPay;
                [self sendVideoContent:sightMessage];
            } vc:self];
        });
        
    }
    else{
        [self askForAPrivateChatFeeAgain];
        NSString *extra = [ZZUtils dictionaryToJson:@{@"payChat":BurnAfterRead,@"check":@(NO)}];
        sightMessage.extra = self.boxView.topView.isBurnAfterRead?(self.payChatModel.isThanCheckVersion?extra:BurnAfterRead):nil;
        [self sendVideoContent:sightMessage];
    }
}

- (void)sendVideoContent:(RCSightMessage *)sightMessage {
    if (![self canSendMessageWithMessageContent:sightMessage]) {
        return;
    }
    _isMessageBoxTo = NO;
    
    // 如果是从KTV过来的要显示一个提示来源文案
    [self sendNotificationFromKTV];
    
    WeakSelf;
    ZZChatBaseModel *model = [[ZZChatBaseModel alloc] init];
    RCMessage *message = [[RCIMClient sharedRCIMClient] sendMediaMessage:ConversationType_PRIVATE targetId:self.uid content:sightMessage pushContent:[ZZChatUtil getPushContent:_showPushName] pushData:[self getPushData] progress:^(int progress, long messageId) {
        NSLog(@"progress is: %d", progress);
        NSInteger index = [weakSelf.dataArray indexOfObject:model];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakSelf.dataArray.count-1-index inSection:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            ZZChatVideoCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
            if (cell) {
                cell.process = progress;
            }
        });
    } success:^(long messageId) {
        [weakSelf reloadCell:model];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf showTodayAnimation];
        });
        // 发送活跃回复用户的接口
        [self sendHighlyActiveReplyUserRequest];
        
        // 第一次发送消息,需要记录用户的UID到本地数据库
        [_giftHelper addChatUser];
        [_boxView hideGiftTipView];
        [self addMessageCount];
    } error:^(RCErrorCode errorCode, long messageId) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf reloadCell:model];
            [self sendMessageFailure:errorCode];
        });
    } cancel:^(long messageId) {
        
    }];
    
    model.message = message;
    long long time = [[NSDate date] timeIntervalSince1970] * 1000;
    model.showTime = [self sendMessageShouldShowTime:time];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addMessage:model];
    });
}

//发送图片内容
- (void)sendImageContent:(RCMessageContent *)messageContent {
    if (![self canSendMessageWithMessageContent:messageContent]) {
        return;
    }
    _isMessageBoxTo = NO;
    
    // 如果是从KTV过来的要显示一个提示来源文案
    [self sendNotificationFromKTV];
    
    WeakSelf;
    ZZChatBaseModel *model = [[ZZChatBaseModel alloc] init];
    RCMessage *message = [[RCIMClient sharedRCIMClient] sendMediaMessage:ConversationType_PRIVATE targetId:self.uid content:messageContent pushContent:[ZZChatUtil getPushContent:_showPushName] pushData:[self getPushData] progress:^(int progress, long messageId) {
        NSInteger index = [weakSelf.dataArray indexOfObject:model];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakSelf.dataArray.count-1-index inSection:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            ZZChatImageCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
            if (cell) {
                cell.process = progress;
            }
        });
    } success:^(long messageId) {
        [weakSelf reloadCell:model];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf showTodayAnimation];
        });
        
        // 发送活跃回复用户的接口
        [self sendHighlyActiveReplyUserRequest];
        
        // 第一次发送消息,需要记录用户的UID到本地数据库
        [_giftHelper addChatUser];
        [_boxView hideGiftTipView];
        [self addMessageCount];
    } error:^(RCErrorCode errorCode, long messageId) {
        [weakSelf reloadCell:model];
        [self sendMessageFailure:errorCode];
    } cancel:^(long messageId) {
        
    }];
    
    model.message = message;
    long long time = [[NSDate date] timeIntervalSince1970] * 1000;
    model.showTime = [self sendMessageShouldShowTime:time];
    [self addMessage:model];
}

//发送消息(文本、语音等)
- (void)sendMessageContent:(RCMessageContent *)messageContent pushContent:(NSString *)pushContent {
    if (![self canSendMessageWithMessageContent:messageContent]) {
        _sensitiveStr = nil;
        return;
    }
    _isMessageBoxTo = NO;
    __block NSString *sensitive = _sensitiveStr;
    __block NSString *wxSensitive = _wxSensitive;
    
    // 如果是从KTV过来的要显示一个提示来源文案
    [self sendNotificationFromKTV];
    
    WeakSelf;
    ZZChatBaseModel *model = [[ZZChatBaseModel alloc] init];
    RCMessage *message = [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE targetId:self.uid content:messageContent pushContent:[ZZChatUtil getPushContent:_showPushName] pushData:[self getPushData] success:^(long messageId) {
        
        [weakSelf reloadCell:model];
        [weakSelf didSendMessage:model];
        if ([messageContent isKindOfClass:[RCTextMessage class]]) {
            RCTextMessage *textMessage = (RCTextMessage *)messageContent;
            NSString *string = [ZZChatUtil getInfoStringWithString:textMessage.content];
            if (!isNullString(string)) {
                [weakSelf sendNotification:string];
            }
        }
//            [weakSelf sendMessageNotification:model];
        if (sensitive) {
            [weakSelf sendSensitiveMessage:sensitive];
            weakSelf.sensitiveStr = nil;
        }
        if (!isNullString(wxSensitive)) {
            [weakSelf insertWxBuyMessage:wxSensitive];
            weakSelf.wxSensitive = nil;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf showTodayAnimation];
        });
        
        // 发送活跃回复用户的接口
        [self sendHighlyActiveReplyUserRequest];
        
        // 第一次发送消息,需要记录用户的UID到本地数据库
        [_giftHelper addChatUser];
        [_boxView hideGiftTipView];
        [self addMessageCount];
    } error:^(RCErrorCode nErrorCode, long messageId) {
        [weakSelf reloadCell:model];
        [weakSelf sendMessageFailure:nErrorCode];
        weakSelf.sensitiveStr = nil;
        weakSelf.wxSensitive = nil;
    }];
    
    model.message = message;
    long long time = [[NSDate date] timeIntervalSince1970] * 1000;
    model.showTime = [self sendMessageShouldShowTime:time];
    [self addMessage:model];
}

- (void)sendMessageFailure:(RCErrorCode)nErrorCode {
    if (nErrorCode == 405) {
        RCInformationNotificationMessage *warningMsg = [RCInformationNotificationMessage notificationWithMessage:@"您的消息已经发出，但被对方拒收" extra:nil];
        RCMessage *message = [[RCIMClient sharedRCIMClient] insertOutgoingMessage:ConversationType_PRIVATE targetId:self.uid sentStatus:SentStatus_SENT content:warningMsg];
        [self insertSendMessage:message];
    } else {
        if ([ZZUserHelper shareInstance].unreadModel.open_log) {
            NSMutableDictionary *param = [@{@"type":@"聊天发送失败",
                                            @"errorcode":[NSNumber numberWithInteger:nErrorCode]} mutableCopy];
            if ([ZZUserHelper shareInstance].IMToken) {
                [param setObject:[ZZUserHelper shareInstance].IMToken forKey:@"imtoken"];
            }
            if ([ZZUserHelper shareInstance].isLogin) {
                NSDictionary *aDict = @{@"uid":[ZZUserHelper shareInstance].loginer.uid,
                                        @"content":[ZZUtils dictionaryToJson:param]};
                [ZZUserHelper uploadLogWithParam:aDict next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                    if (data) {
                        
                    }
                }];
            }
        }
    }
}

/*
 如果是从KTV过来的要显示一个提示来源文案
 */
- (void)sendNotificationFromKTV {
    if (self.giftEntry != GiftEntryKTV) {
        return;
    }
    
    WeakSelf;
    RCInformationNotificationMessage *warningMsg = [RCInformationNotificationMessage notificationWithMessage:@"从唱趴任务向你赠送礼物" extra:nil];
    [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE targetId:self.uid content:warningMsg pushContent:nil pushData:nil success:^(long messageId) {
        weakSelf.giftEntry = GiftEntryNone;
    } error:^(RCErrorCode nErrorCode, long messageId) {
    }];
}

//发送系统通知(敏感词)
- (void)sendNotification:(NSString *)string {
    WeakSelf;
    RCInformationNotificationMessage *warningMsg = [RCInformationNotificationMessage notificationWithMessage:string extra:nil];
    ZZChatBaseModel *model = [[ZZChatBaseModel alloc] init];
    RCMessage *message = [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE targetId:self.uid content:warningMsg pushContent:nil pushData:nil success:^(long messageId) {
        [weakSelf sendMessageNotification:model];
    } error:^(RCErrorCode nErrorCode, long messageId) {
        [weakSelf sendMessageNotification:model];
    }];
    model.message = message;
    model.showTime = NO;
    [self addMessage:model];
}

//是否可以聊天
- (BOOL)canSendMessageWithMessageContent:(RCMessageContent *)messageContent {
    if (self.statusModel.chat_status == 1 || [messageContent isKindOfClass:[ZZChatPacketModel class]] || [messageContent isKindOfClass:[ZZChatGiftModel class]]) {
        return YES;
    }
    else if (self.statusModel.chat_status == 2) {
        RCInformationNotificationMessage *warningMsg = [RCInformationNotificationMessage notificationWithMessage:@"对方还没有回复你的留言，请等待对方回复" extra:nil];
        RCMessage *message = [[RCMessage alloc] initWithType:ConversationType_PRIVATE targetId:self.uid direction:MessageDirection_SEND messageId:-1 content:warningMsg];
        [self insertSendMessage:message];
        return NO;
    }
    return NO;
}

- (void)sendMessageNotification:(ZZChatBaseModel *)model {
    NSDictionary *aDict = @{@"message":model};
    [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_SendMessage object:nil userInfo:aDict];
}

//发送敏感词提示
- (void)sendSensitiveMessage:(NSString *)string {
    WeakSelf;
    ZZChatReportModel *content = [ZZChatReportModel messageWithContent:string];
    content.title = @"立即举报";
    content.content = @"如遇骚扰，请点击此处";
    ZZChatBaseModel *model = [[ZZChatBaseModel alloc] init];
    RCMessage *message = [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE targetId:self.uid content:content pushContent:nil pushData:nil success:^(long messageId) {
        [weakSelf deleteLocalMessage:model.message];
    } error:^(RCErrorCode nErrorCode, long messageId) {
 
    }];
    model.message = message;
}

- (void)sendInviteVideoChatMessage {
    ZZVideoInviteModel *model = [ZZVideoInviteModel messageWithContent:@"她邀请你视频聊天哦"];
    [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE targetId:self.uid content:model pushContent:nil pushData:nil success:^(long messageId) {
    } error:^(RCErrorCode nErrorCode, long messageId) {
    }];
}

- (void)deleteLocalMessage:(RCMessage *)message {
    NSLog(@"%@",[[RCIMClient sharedRCIMClient] deleteMessages:@[@(message.messageId)]] ? @"YES" : @"NO");
}

#pragma mark 发送gif图
- (void)sendGifWhenJudgePrive:(ZZGifMessageModel *)model {
    
    // 如果是从KTV过来的要显示一个提示来源文案
    [self sendNotificationFromKTV];
    
    WeakSelf;
    ZZChatBaseModel *baseModel = [[ZZChatBaseModel alloc] init];
    __block RCMessage *message =  [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE targetId:self.uid content:model pushContent:nil pushData:nil success:^(long messageId) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf reloadCell:baseModel];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf showTodayAnimation];
        });
        
        // 发送活跃回复用户的接口
        [self sendHighlyActiveReplyUserRequest];
        
        // 第一次发送消息,需要记录用户的UID到本地数据库
        [_giftHelper addChatUser];
        [_boxView hideGiftTipView];
    } error:^(RCErrorCode nErrorCode, long messageId) {
        [weakSelf reloadCell:baseModel];
        [weakSelf sendMessageFailure:nErrorCode];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf showTodayAnimation];
        });
        NSLog(@"PY_发送Gif 图失败");
    }];
    baseModel.message = message;
    long long time = [[NSDate date] timeIntervalSince1970] * 1000;
    baseModel.showTime = [self sendMessageShouldShowTime:time];
    [self addMessage:baseModel];
}

- (void)sendGif:(ZZGifMessageModel *)model {
    if (self.payChatModel.isRequessSuccess&&self.payChatModel.isPay) {
        [ZZUserHelper shareInstance].consumptionMebi += [[ZZUserHelper shareInstance].configModel.priceConfig.per_chat_cost_mcoin integerValue];;
        [self askForAPrivateChatFeeAgain];
        [ZZPrivateChatPayManager  payMebiWithPayChatModel:self.payChatModel nav:self.navigationController CallBack:^{
            [ZZUserHelper shareInstance].consumptionMebi -= [[ZZUserHelper shareInstance].configModel.priceConfig.per_chat_cost_mcoin integerValue];;
        } NoPayCallBack:^{
            NSString *extra = [ZZUtils dictionaryToJson:@{@"payChat":PrivateChatPay,@"check":@(NO)}];
            model.extra  = self.payChatModel.isThanCheckVersion?extra:PrivateChatPay ;
            [self sendGifWhenJudgePrive:model];
        } vc:self];
    }
    else{
        [self askForAPrivateChatFeeAgain];
        NSString *extra = [ZZUtils dictionaryToJson:@{@"payChat":BurnAfterRead,@"check":@(NO)}];
        model.extra = self.boxView.topView.isBurnAfterRead ? (self.payChatModel.isThanCheckVersion ? extra:BurnAfterRead) : nil;
        [self sendGifWhenJudgePrive:model];
    }
}

#pragma mark 发送邀请视频
- (void)sendInviteVide {
    
}
#pragma mark - 消息盒子
- (void)sendMessageBox:(NSString *)string {
    NSString *wxSensitive = _wxSensitive;
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/user/%@/say_hi",_uid] params:@{@"content":string} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        _wxSensitive = nil;
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        }
        else {
            RCTextMessage *textMessage= [RCTextMessage messageWithContent:string];
            RCMessage *message = [[RCIMClient sharedRCIMClient] insertOutgoingMessage:ConversationType_PRIVATE targetId:self.uid sentStatus:SentStatus_SENT content:textMessage];
            [self insertSendMessage:message];

//            if (!isNullString([data objectForKey:@"title"])) {
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    ZZChatReportModel *finishModel = [ZZChatReportModel messageWithContent:[data objectForKey:@"title"]];
//                    finishModel.title = [data objectForKey:@"sub_title"];
//                    finishModel.extra = @"packet";
//                    RCMessage *message = [[RCIMClient sharedRCIMClient] insertOutgoingMessage:ConversationType_PRIVATE targetId:self.uid sentStatus:SentStatus_SENT content:finishModel];
//                    [self insertSendMessage:message];
//                });
//            }

            if (!isNullString(wxSensitive)) {
                [self insertWxBuyMessage:wxSensitive];
            }
        }
    }];
}

#pragma mark - 消息处理
- (void)sendMySelfNotification:(NSString *)message {
    RCInformationNotificationMessage *warningMsg = [RCInformationNotificationMessage notificationWithMessage:message extra:nil];
    RCMessage *notificationMessage = [[RCIMClient sharedRCIMClient] insertOutgoingMessage:ConversationType_PRIVATE targetId:self.uid sentStatus:SentStatus_SENT content:warningMsg];
    [self insertSendMessage:notificationMessage];
}

//发送消息插入本地
- (void)insertSendMessage:(RCMessage *)message {
    ZZChatBaseModel *model = [[ZZChatBaseModel alloc] init];
    model.message = message;
    long long time = [[NSDate date] timeIntervalSince1970] * 1000;
    model.showTime = [self sendMessageShouldShowTime:time];
    [self addMessage:model];
}

//重新发送消息
- (void)resendMessage:(NSIndexPath *)indexPath {
    if (self.dataArray.count - 1 - indexPath.row >= self.dataArray.count) {
        return;
    }
    ZZChatBaseModel *model = self.dataArray[self.dataArray.count - 1 - indexPath.row];
    if ([self deleteMessage:model]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            ChatCellType cellType = [ZZChatUtil getCellTypeWithMessage:model];
            switch (cellType) {
                case ChatCellTypeImage: {
                    RCImageMessage *message = (RCImageMessage *)model.message.content;
                    RCImageMessage *newImageMessage = [RCImageMessage messageWithImageURI:message.imageUrl];
                    [self sendImageContent:newImageMessage];
                    break;
                }
                case ChatCellTypeRealTimeStart: {
                    [self gotoRealTimeController];
                    break;
                }
                case ChatCellTypeNofitication: {
                    break;
                }
                case ChatCellTypeGif: {
                    //重新发送gif图
                    ZZGifMessageModel *gifModel = (ZZGifMessageModel *)model.message.content;
                    [self sendGif:gifModel];break;
                }
                case ChatCellTypeSightVideo: {
                    RCSightMessage *message = (RCSightMessage *)model.message.content;
                    [self sendVideoContent:message];
                }
                default: {
                    [self sendMessageContent:model.message.content pushContent:@""];
                    break;
                }
            }
        });
    }
}

- (BOOL)deleteMessage:(ZZChatBaseModel *)model {
    if ([_dataArray containsObject:model]) {
        NSInteger row = self.dataArray.count - 1 - [self.dataArray indexOfObject:model];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [self.dataArray removeObject:model];
        if ([[RCIMClient sharedRCIMClient] deleteMessages:@[@(model.message.messageId)]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
                [ZZUserHelper shareInstance].updateMessageList = YES;
            });
            return YES;
        }
    }
    return NO;
}

//插入消息动画
- (void)insertCellsToTableView:(ZZChatBaseModel *)model {
    dispatch_async(dispatch_get_main_queue(), ^{
        [ZZUserHelper shareInstance].updateMessageList = YES;
        [self.dataArray insertObject:model atIndex:0];
        NSMutableArray *indexPaths = [NSMutableArray array];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0];
        [indexPaths addObject:indexPath];
        [CATransaction begin];
        [CATransaction setCompletionBlock: ^{
            [self animationComplete];
        }];
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        if (!_isRefresh && !self.isUserScrolling) {
            NSInteger rows = [self.tableView numberOfRowsInSection:0];
            if (rows > 0) {
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                                          atScrollPosition:UITableViewScrollPositionNone
                                                  animated:YES];
                
            }
        }
        [CATransaction commit];
    });
}

- (void)addMessage:(ZZChatBaseModel *)model {
    [self insertCellsToTableView:model];
}

//刷新某一行cell
- (void)reloadCell:(ZZChatBaseModel *)model {
    if (!model) {
        return;
    }
    WeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger index = [self.dataArray indexOfObject:model];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArray.count-1-index inSection:0];
        [weakSelf reloadCellWithModel:model indexPath:indexPath];
    });
}

- (void)reloadCellWithModel:(ZZChatBaseModel *)model indexPath:(NSIndexPath *)indexPath  {
    NSString *identifier = [ZZChatUtil getIdentifierStringWithMessage:model];
    if ([identifier isEqualToString:ChatRealTimeEnd]) {
        ZZChatRealTimeEndCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell) {
            [cell setData:model];
        }
    }
    else if ([identifier isEqualToString:ChatInfoNotification]) {
        ZZChatNotificationCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell) {
            [cell setData:model name:_nickName];
        }
    }
    else if ([identifier isEqualToString:ChatOrderInfo]) {
        ZZChatOrderInfoCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell) {
            [cell setData:model];
        }
    }
    else if ([identifier isEqualToString:ChatWechatPayModel]) {
        // 微信
        ZZChatWechatPayCell *cell  = [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell) {
            [cell setData:model];
        }
    }
    else if ([identifier isEqualToString:ChatIDPhotoPayCellIdentifier]) {
        // 证件照
        ZZChatIDPhotoPayCell *cell  = [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell) {
            [cell setData:model];
        }
    }
    else if ([identifier isEqualToString:ChatConnect]) {
        ZZChatConnectCell *cell  = [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell) {
            [cell setData:model];
        }
    }
    else {
        ZZChatBaseCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell) {
            [cell setData:model];
        }
    }
}

//一进界面判断是否有未读 有未读就发送已读回执
- (void)getUserUnreadCountAndClear {
    dispatch_async(dispatch_get_main_queue(), ^{
         NSLog(@"PY_%s获取未读的消息个数",__func__);
        int count = [[RCIMClient sharedRCIMClient] getUnreadCount:ConversationType_PRIVATE targetId:self.uid];
        if (count != 0) {
            BOOL contain = NO;
            NSArray *array = [[RCIMClient sharedRCIMClient] getLatestMessages:ConversationType_PRIVATE targetId:_uid count:count];
            for (RCMessage *message in array) {
                contain = [ZZChatUtil shouldSendReadStatus:message];
                if (contain) {
                    break;
                }
            }
            [ZZUserHelper shareInstance].updateMessageList = YES;
            [self clearUnreadMessage:contain];
        }
    });
}

//设置消息已读 （清楚列表未读数字）
- (void)clearUnreadMessage:(BOOL)read {
    [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:ConversationType_PRIVATE targetId:self.uid];
    if (self.dataArray.count != 0 && read) {
        ZZChatBaseModel *model = self.dataArray[0];
        [[RCIMClient sharedRCIMClient] sendReadReceiptMessage:ConversationType_PRIVATE targetId:self.uid time:model.message.sentTime success:^{
        } error:^(RCErrorCode nErrorCode) {

        }];
    }
}

//cell点击事件
- (void)routerEventWithName:(NSInteger)event userInfo:(NSDictionary *)userInfo Cell:(UITableViewCell *)cell {
    switch (event) {
        case ZZRouterEventPlayVoice: {
            ZZRecordManager *manager = [ZZRecordManager shareManager];
            manager.delegate = self;
            UIImageView *voiceImgView = [userInfo objectForKey:@"target"];
            UIView *unreadPointView = [userInfo objectForKey:@"unreadpoint"];
            ZZChatBaseModel *model = [userInfo objectForKey:@"data"];
            RCVoiceMessage *message = (RCVoiceMessage *)model.message.content;
            if (!message.wavAudioData) {
                return;
            }
            [self burnVoiceWhileEndListen];
            if (unreadPointView.hidden == NO) {
                unreadPointView.hidden = YES;
                model.message.receivedStatus = ReceivedStatus_LISTENED;
                [[RCIMClient sharedRCIMClient] setMessageReceivedStatus:model.message.messageId receivedStatus:ReceivedStatus_LISTENED];
            }
            
            if (self.currentPlayVoiceData) {
                if ([self.currentPlayVoiceData isEqualToData:message.wavAudioData]) {
                    [[ZZRecordManager shareManager] stopPlayRecorder:message.wavAudioData];
                    [voiceImgView stopAnimating];
                    self.currentPlayVoiceImgView = nil;
                    self.currentPlayVoiceData = nil;
                    return;
                } else {
                    [self.currentPlayVoiceImgView stopAnimating];
                    self.currentPlayVoiceImgView = nil;
                    self.currentPlayVoiceData = nil;
                }
            }
            
            [[ZZRecordManager shareManager] startPlayRecorder:message.wavAudioData];
            [voiceImgView startAnimating];
            self.currentPlayVoiceImgView = voiceImgView;
            self.currentPlayVoiceData = message.wavAudioData;
            self.currentPlayVoiceModel = model;
            break;
        }
        case ZZRouterEventTapVideo: {
            [self endEditing];
            ZZChatBaseModel *currentModel = [userInfo objectForKey:@"data"];
            if (![currentModel.message.content isKindOfClass:[RCSightMessage class]]) {
                return;
            }
            RCSightMessage *sightMessage = (RCSightMessage *)currentModel.message.content;
            ZZChatVideoPlayerController *player = [[ZZChatVideoPlayerController alloc] init];
            player.videoUrl = sightMessage.sightUrl;
            [self.navigationController pushViewController:player animated:YES];
            break;
        }
        case ZZRouterEventTapImage: {
            [self endEditing];
            [self.photoArray removeAllObjects];
            ZZChatBaseModel *currentModel = [userInfo objectForKey:@"data"];
            if (![currentModel.message.content isKindOfClass:[RCImageMessage class]]) {
                return;
            }
            HZPhotoItem *currentItem = [[HZPhotoItem alloc] init];
            for (int i=(int)self.dataArray.count-1; i>=0; i--) {
                ZZChatBaseModel *model = self.dataArray[i];
                if ([model.message.content isKindOfClass:[RCImageMessage class]]) {
                    RCImageMessage *message = (RCImageMessage *)model.message.content;
                    HZPhotoItem *item = [[HZPhotoItem alloc] init];
                    item.thumbnail_pic = message.imageUrl;
                    item.indexPath = [NSIndexPath indexPathForRow:(self.dataArray.count - 1 - i) inSection:0];
                    item.data = message;
                    [self.photoArray addObject:item];
                    if (currentModel == model) {
                        currentItem = item;
                        _currentSelectedImage = message.thumbnailImage;
                    }
                }
            }
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.dataArray.count - 1 - [self.dataArray indexOfObject:currentModel]) inSection:0];
            ZZChatImageCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            CGRect rect = [cell convertRect:cell.bgView.frame toView:self.view];
            rect.origin.y = rect.origin.y + NAVIGATIONBAR_HEIGHT;
            
            _browser = [[HZPhotoBrowser alloc] init];
            _browser.sourceRect = rect;
            _browser.showAnimation = YES;
            _browser.imageCount = self.photoArray.count; // 图片总数
            _browser.currentImageIndex = (int)[self.photoArray indexOfObject:currentItem];
            _browser.delegate = self;
            [_browser show];
            break;
        }
        case ZZRouterEventTapLocation: {
            [self endEditing];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                ZZChatBaseModel *model = [userInfo objectForKey:@"data"];
                RCLocationMessage *message = (RCLocationMessage *)model.message.content;
                ZZOrderLocationViewController *controller = [[ZZOrderLocationViewController alloc] init];
                controller.location = [[CLLocation alloc] initWithLatitude:message.location.latitude longitude:message.location.longitude];
                controller.name = message.locationName;
                controller.navigationItem.title = @"位置信息";
                [self.navigationController pushViewController:controller animated:YES];
            });
            break;
        }
        case ZZRouterEventTapRealTime: {
            [self gotoRealTimeController];
            break;
        }
        case ZZRouterEventTapOrderInfo: {
            ZZChatBaseModel *model = [userInfo objectForKey:@"data"];
            if ([model.message.content isKindOfClass:[ZZChatOrderInfoModel class]]) {
                ZZChatOrderInfoModel *orderModel = (ZZChatOrderInfoModel *)model.message.content;
                if (![orderModel.order_id isEqualToString:@"0"]) {
                    if ([orderModel.title isEqualToString:@"申诉中"]) {
                        [self gotoChatServerView];
                    }
                    else {
                        [self gotoOrderDetail:orderModel.order_id];
                    }
                }
                else {
                    [self endEditing];
                }
            }
            else {
                [self notifyOther];
            }
            break;
        }
        case ZZRouterEventTapPacket: {
            [self endEditing];
            ZZChatBaseModel *model = [userInfo objectForKey:@"data"];
            ZZChatPacketModel *packetModel = (ZZChatPacketModel *)model.message.content;
            if (packetModel.mmd_id) {
                if (_loadPacket) {
                    return;
                }
                _loadPacket = YES;
                [ZZHUD showWithStatus:@"加载中..."];
                
                [ZZMemedaModel getMemedaDetaiWithMid:packetModel.mmd_id next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                    _loadPacket = NO;
                    if (error) {
                        [ZZHUD showErrorWithStatus:error.message];
                    } else {
                        [ZZHUD dismiss];
                        ZZMemedaModel *detailModel = [[ZZMemedaModel alloc] initWithDictionary:data error:nil];
                        _packetInfoView = [[ZZChatPacketInfoView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                        [_packetInfoView setModel:detailModel];
                        [self.view.window addSubview:_packetInfoView];
                    }
                }];
            }
            break;
        }
        case ZZWeiChatPayEventTapCall: {
            //弹出微信评价界面
            NSLog(@"PY_聊天室弹出微信评价界面");
            //查看的是别人的
            if (!self.user) {
                return;
            }
            
            ZZWeiChatEvaluationModel *model = [[ZZWeiChatEvaluationModel alloc]init];
            model.type = PaymentTypeWX;
            self.user.can_see_wechat_no = YES;
            model.user = self.user;
            [self endEditing];
            [ZZWeiChatEvaluationManager LookWeiChatWithModel:model watchViewController:self goToBuy:nil recharge:nil touchChangePhone:nil evaluation:^(BOOL goChat) {
                if ([cell isKindOfClass:[ZZChatWechatPayCell class]]) {
                    ZZChatWechatPayCell *customCell = (ZZChatWechatPayCell *)cell;
                    customCell.titleCustomLabel.text = @"已评价";
                }
                if (self.evaluationCallBlack) {
                    self.evaluationCallBlack();
                }
            }];
            break;
        }
        case ZZWeiChatCheckOrder: {
            NSString *wechatOrderID = userInfo[@"wechatOrder"];
            if (!isNullString(wechatOrderID)) {
                ZZWXOrderDetailViewController *orderDetailsVC = [ZZWXOrderDetailViewController createWithOrderID:wechatOrderID];
                [self.navigationController pushViewController:orderDetailsVC animated:YES];
            }
            break;
        }
        case ZZShowUpdateView: {
            ZZUpdateAlertView *alertView = [[ZZUpdateAlertView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            [self.view.window addSubview:alertView];
            break;
        }
        case ZZRouterEventTapCall: {
            break;
        }
        default:
            break;
    }
}

- (void)tapHeadImgView {
    [self gotoUserPage:NO];
}

//显示菜单
- (void)showMenuInView:(UIView *)showInView indexPath:(NSIndexPath *)indexPath {
    [self becomeFirstResponder];
    if (!_theCopyItem) {
        _theCopyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyClick)];
    }
    if (!_deleteItem) {
        _deleteItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteClick)];
    }
    if (!_recallItem) {
        _recallItem = [[UIMenuItem alloc] initWithTitle:@"撤回" action:@selector(recallClick)];
    }
    if (!_reportItem) {
        _reportItem = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(reportBtnClick)];
    }
    if (indexPath.row < self.dataArray.count) {
        ZZChatBaseModel *model = self.dataArray[self.dataArray.count - 1 - indexPath.row];
        _longModel = model;
        
        switch ([ZZChatUtil getCellLongPressTypeWithMessage:model]) {
            case ChatCellLongPressTypeAll: {
                [[UIMenuController sharedMenuController] setMenuItems:@[_theCopyItem,_deleteItem,_recallItem]];
                break;
            }
            case ChatCellLongPressTypeDelete: {
                [[UIMenuController sharedMenuController] setMenuItems:@[_deleteItem]];
                break;
            }
            case ChatCellLongPressTypeDeleteAndCopy: {
                [[UIMenuController sharedMenuController] setMenuItems:@[_theCopyItem,_deleteItem]];
                break;
            }
            case ChatCellLongPressTypeDeleteAndRecall: {
                [[UIMenuController sharedMenuController] setMenuItems:@[_deleteItem,_recallItem]];
                break;
            }
            case ChatCellLongPressTypeDeleteAndReoprt: {
                [[UIMenuController sharedMenuController] setMenuItems:@[_deleteItem,_reportItem]];
                break;
            }
            case ChatCellLongPressTypeDeleteAndCopyAndReport: {
                [[UIMenuController sharedMenuController] setMenuItems:@[_theCopyItem,_deleteItem,_reportItem]];
                break;
            }
            default:
                break;
        }
        
        [[UIMenuController sharedMenuController] setTargetRect:showInView.frame inView:showInView.superview ];
        [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
    }
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

//视图消失如果还在播放语音停止播放
- (void)stopPlayVoice {
    if (self.currentPlayVoiceData && [self.currentPlayVoiceImgView isAnimating]) {
        [[ZZRecordManager shareManager] stopPlayRecorder:self.currentPlayVoiceData];
    }
}

//播放下一条没有播放的语音
- (void)playNextUnReadVoice {
    NSUInteger index = [self.dataArray indexOfObject:self.currentPlayVoiceModel];;
    if (index != NSNotFound) {
        for (NSInteger i=index-1; i>=0; i--) {
            ZZChatBaseModel *model = self.dataArray[i];
            if ([model.message.content isKindOfClass:[RCVoiceMessage class]] && model.message.receivedStatus != ReceivedStatus_LISTENED && model.message.messageDirection != MessageDirection_SEND) {
                NSInteger row = self.dataArray.count - 1 - [self.dataArray indexOfObject:model];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                ZZChatVoiceCell *cell = (ZZChatVoiceCell *)[_tableView cellForRowAtIndexPath:indexPath];
                if (cell) {
                    [cell voiceClick];
                }
                break;
            }
        }
    }
}

//消息推送内容
- (NSString *)getPushData {
    if (!_showPushName) {
        if (!_uid) {
            return nil;
        }
        return [ZZUtils dictionaryToJson:@{
                                           @"rc": @{
                                                    @"fId": [ZZUserHelper shareInstance].loginer.uid,
                                                    @"tId": _uid,
                                                    @"cType": @"PR"
                                                    }
                                           }];
    }
    else {
        return nil;
    }
}

// 发送微信敏感词就插入购买微信
- (void)insertWxBuyMessage:(NSString *)string {
    if (self.user.have_wechat_no && !self.user.can_see_wechat_no) {
        ZZChatConnectModel *content = [ZZChatConnectModel messageWithContent:string];
        content.type = 2;
        RCMessage *message = [[RCIMClient sharedRCIMClient] insertOutgoingMessage:ConversationType_PRIVATE targetId:self.uid sentStatus:SentStatus_SENT content:content];
        [self insertSendMessage:message];
    }
}

#pragma mark - 举报
//举报用户
- (void)reportUser:(NSIndexPath *)indexPath isThird:(BOOL)isThird {
    ZZChatBaseModel *model = self.dataArray[self.dataArray.count - 1 - indexPath.row];
    if ([model.message.content isKindOfClass:[ZZChatReportModel class]]) {
        if (_isReporting) {
            return;
        }
        _isReporting = YES;
        UIImage *image = [ZZUtils getViewImage:self.view.window];
        if (isThird) {
            [self uploadImage:image type:1];
        } else {
            [self uploadImage:image type:0];
        }
    }
}

- (void)uploadImage:(UIImage *)image type:(NSInteger)type {
    [ZZHUD showWithStatus:@"正在举报"];
    [ZZUploader uploadImage:image progress:^(NSString *key, float percent) {
        
    } success:^(NSString *url) {
        NSDictionary *param = @{@"photos":@[url]};
        [self reportWithParam:param type:type];
    } failure:^{
        _isReporting = NO;
        [ZZHUD showErrorWithStatus:@"举报失败，请重试"];
    }];
}

//0、通知消息cell点击的举报1、第三方支付2、举报对方发送的文字或者图片
- (void)reportWithParam:(NSDictionary *)param type:(NSInteger)type {
    [ZZReportModel reportWithParam:param uid:_uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        _isReporting = NO;
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [ZZHUD dismiss];
            switch (type) {
                case 0:
                {
                    ZZChatReportModel *finishModel = [ZZChatReportModel messageWithContent:@"已成功举报，若对方仍进行骚扰，可选择拉黑对方"];
                    finishModel.title = @"拉黑对方";
                    
                    RCMessage *message = [[RCIMClient sharedRCIMClient] insertOutgoingMessage:ConversationType_PRIVATE targetId:self.uid sentStatus:SentStatus_SENT content:finishModel];
                    [self insertSendMessage:message];
                }
                    break;
                case 1:
                {
                    RCInformationNotificationMessage *warningMsg = [RCInformationNotificationMessage notificationWithMessage:@"已成功举报，邀约若存在风险，请谨慎赴约" extra:nil];
                    RCMessage *message = [[RCIMClient sharedRCIMClient] insertOutgoingMessage:ConversationType_PRIVATE targetId:self.uid sentStatus:SentStatus_SENT content:warningMsg];
                    [self insertSendMessage:message];
                }
                    break;
                case 2:
                {
                    [ZZHUD showSuccessWithStatus:@"谢谢您的举报，我们将在2个工作日解决!"];
                }
                    break;
                default:
                    break;
            }
        }
    }];
}

#pragma mark - 发送红包
- (void)sendPacket:(NSString *)content mid:(NSString *)mid {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.boxView.topView.isMessageBox = NO;
        _isMessageBox = NO;
        //发送红包后，不是消息盒子状态了，没更新聊天状态，导致不能发送聊天信息
        self.statusModel.chat_status = 1;
    });
    ZZChatPacketModel *model = [ZZChatPacketModel messageWithContent:content];
    model.content = content;
    model.mmd_id = mid;
    RCMessage *message = [[RCIMClient sharedRCIMClient] insertOutgoingMessage:ConversationType_PRIVATE targetId:self.uid sentStatus:SentStatus_SENT content:model];
    [self insertSendMessage:message];
    
    if (_isInYellow) {
        RCInformationNotificationMessage *warningMsg = [RCInformationNotificationMessage notificationWithMessage:@"您的提问内容可能包含不良信息，可能会被对方举报导致封禁" extra:nil];
        RCMessage *message = [[RCIMClient sharedRCIMClient] insertOutgoingMessage:ConversationType_PRIVATE targetId:self.uid sentStatus:SentStatus_SENT content:warningMsg];
        [self insertSendMessage:message];
    }
    
    [self managerCtl];
    
    // 发送活跃回复用户的接口
    [self sendHighlyActiveReplyUserRequest];
}

// 移除他人么么答主页
- (void)managerCtl {
    NSMutableArray *marr = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in marr) {
        if ([vc isKindOfClass:[ZZRentMemedaViewController class]]) {
            [marr removeObject:vc];
            break;
        }
    }
    self.navigationController.viewControllers = marr;
}

#pragma mark - UIButtonMethod
- (void)copyClick {
    if ([_dataArray containsObject:_longModel]) {
        RCTextMessage *message = (RCTextMessage *)_longModel.message.content;
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = message.content;
    }
}

- (void)deleteClick {
    [self deleteMessage:_longModel];
}

- (void)recallClick {
    if ([_dataArray containsObject:_longModel]) {
        WeakSelf;
        NSUInteger index = [_dataArray indexOfObject:_longModel];
        RCMessage *message = _longModel.message;
        [[RCIMClient sharedRCIMClient] recallMessage:message success:^(long messageId) {
            [weakSelf replaceModelWithMessageId:messageId model:weakSelf.longModel index:index direction:MessageDirection_SEND];
        } error:^(RCErrorCode errorcode) {
            
        }];
    }
}

- (void)reportBtnClick {
    if ([_dataArray containsObject:_longModel]) {
        ZZChatBaseModel *model = _longModel;
        if ([model.message.content isKindOfClass:[RCTextMessage class]]) {
            RCTextMessage *message = (RCTextMessage *)model.message.content;
            [self reportWithParam:@{@"content":message.content} type:2];
        } else if ([model.message.content isKindOfClass:[RCImageMessage class]]) {
            RCImageMessage *message = (RCImageMessage *)model.message.content;
            if (message.thumbnailImage) {
                [self uploadImage:message.thumbnailImage type:2];
            }
        }
    }
}

- (void)replaceModelWithMessageId:(long)messageId model:(ZZChatBaseModel *)model index:(NSUInteger)index direction:(RCMessageDirection)messageDirection {
    RCRecallNotificationMessage *recallContent = [[RCRecallNotificationMessage alloc] init];
    RCMessage *recallMessage = [[RCMessage alloc] initWithType:ConversationType_PRIVATE targetId:self.uid direction:messageDirection messageId:messageId content:recallContent];
    ZZChatBaseModel *recallModel = [[ZZChatBaseModel alloc] init];
    recallModel.message = recallMessage;
    recallModel.showTime = model.showTime;
    [self.dataArray replaceObjectAtIndex:index withObject:recallModel];
    [self reloadTableView];
}

#pragma mark - Navigation
- (void)gotoRealTimeController {
    RealTimeLocationViewController *lsvc = [[RealTimeLocationViewController alloc] init];
    lsvc.realTimeLocationProxy = self.realTimeLocation;
    if ([self.realTimeLocation getStatus] == RC_REAL_TIME_LOCATION_STATUS_INCOMING) {
        [self.realTimeLocation joinRealTimeLocation];
    }else if([self.realTimeLocation getStatus] == RC_REAL_TIME_LOCATION_STATUS_IDLE){
        [self.realTimeLocation startRealTimeLocation];
    }
    [self.navigationController presentViewController:lsvc animated:YES completion:^{
        
    }];
}

- (void)gotoUserPage:(BOOL)showWX {
    [self endEditing];
    if (_isPushingView) {
        return;
    }
    _isPushingView = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ZZRentViewController *controller = [[ZZRentViewController alloc] init];
        controller.uid = self.uid;
        controller.showWX = showWX;
        controller.source = SourceChat;
        [self.navigationController pushViewController:controller animated:YES];
    });
}

- (void)gotoOrderDetail:(NSString *)orderId {
    BOOL isFrom = [[ZZUserHelper shareInstance].loginer.uid isEqualToString:self.order.from.uid];
    [self endEditing];
    if (_isFromOrderDetail && [orderId isEqualToString:_order.id]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if (isFrom && _order.to.banStatus) {
        [self showOKAlertWithTitle:@"提示" message:@"该用户已被封禁!" okTitle:@"确定" okBlock:nil];
        return;
    }
    if (!isFrom && _order.from.banStatus) {
        [self showOKAlertWithTitle:@"提示" message:@"该用户已被封禁!" okTitle:@"确定" okBlock:nil];
        return;
    }
    
    if (_isPushingView) {
        return;
    }
    _isPushingView = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ZZOrderDetailViewController *controller = [[ZZOrderDetailViewController alloc] init];
        controller.orderId = orderId;
        controller.isFromChat = YES;
        [self.navigationController pushViewController:controller animated:YES];
    });
}

- (void)gotoWalletView {
    ZZMyWalletViewController  *controller = [[ZZMyWalletViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)gotoWXView {
    [MobClick event:Event_click_chat_wx];
    [ZZRequest method:@"POST" path:@"/api/mag_click/click" params:@{@"type":@"wechat"} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        NSLog(@"success");
    }];
    [self gotoUserPage:YES];
}

- (void)showDetailsWithTaskType:(TaskType)taskType {
    ZZTasksViewController *vc = [[ZZTasksViewController alloc] initWithTaskType:taskType];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/*
 账单记录
 */
- (void)goToMyIncomRecords {
    ZZBillingRecordsViewController *recordVC = [[ZZBillingRecordsViewController alloc]init];
    recordVC.recordStyle = BillingRecordsStyle_Balance;
    [self.navigationController pushViewController:recordVC animated:YES];
}

#pragma mark - Data
- (void)loadData {
    WeakSelf;
    
    //获取消息最新的10条数据
    NSArray *array = [[RCIMClient sharedRCIMClient] getLatestMessages:ConversationType_PRIVATE targetId:_uid count:10];
    
    [self.dataArray addObjectsFromArray:[self managerTimeWithArray:array isFirst:YES]];
     dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadTableView];
        [self scrollToBottom:NO finish:^{
            weakSelf.haveLoadData = YES;
            [weakSelf animationComplete];
        }];
    });
   
    [NSObject asyncWaitingWithTime:0.1 completeBlock:^{
    [ZZPrivateChatPayManager updateMessageListQiPaoiWithISReply:NO messageArray:self.dataArray callBack:^(BOOL isChange){
            [self.tableView reloadData];
        }];
    }];
  
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_mid) {
            [self sendPacket:_content mid:_mid];
        }
    });
}

static CGPoint delayOffset = {0.0};
- (void)loadMoreData {
    self.headView.hidden = NO;
    [self.headView.indocatorView startAnimating];
    _isRefresh = YES;
    delayOffset = self.tableView.contentOffset;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ZZChatBaseModel *lastModel = [self.dataArray lastObject];
        NSArray *array = [[RCIMClient sharedRCIMClient] getHistoryMessages:ConversationType_PRIVATE targetId:_uid oldestMessageId:lastModel.message.messageId count:10];

        NSMutableArray *newArray = [self managerTimeWithArray:array isFirst:NO];
        [newArray enumerateObjectsUsingBlock:^(ZZChatBaseModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            delayOffset.y += [ZZChatUtil getCellHeightWithModel:model];
        }];
        [self checkBurnAfterReading];
        [self.dataArray addObjectsFromArray:newArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView setContentOffset:delayOffset animated:NO];
        });
        
       [ZZPrivateChatPayManager updateMessageListQiPaoiWithISReply:YES messageArray:self.dataArray callBack:^(BOOL isChange){
            [self reloadTableView];
        }];
     
        [self.headView.indocatorView stopAnimating];
        self.headView.hidden = YES;
        _isRefresh = NO;
      
        [self resetHeadView:array];
    });
}

- (void)resetHeadView:(NSArray *)array {
    if (array.count < 10) {
        _noMoreData = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            _tableView.tableHeaderView = nil;
        });
    }
}

//管理时间显示
- (NSMutableArray *)managerTimeWithArray:(NSArray *)array isFirst:(BOOL)isFirst {
    NSMutableArray *aArray = [NSMutableArray array];
    NSMutableArray *tempArray = [NSMutableArray array];
    long long tempTime = 0;
    int count = (int)array.count;
    for (int i = count - 1; i >= 0; i--) {
        ZZChatBaseModel *model = [[ZZChatBaseModel alloc] init];
        model.message = array[i];
        if (i == count - 1) {
            model.showTime = YES;
            _firstShowTime = model.message.sentTime;
            tempTime = _firstShowTime;
        }
        else {
            if ((model.message.sentTime - tempTime) / (1000 * 60) > CHAT_TIME_SHOW_INTERVAL) {
                model.showTime = YES;
                tempTime = model.message.sentTime;
            }
        }
        if ([ZZChatUtil isLocalBurnReadedMessage:model]) {
            model.count = BurnMaxCount;
            [self.countDownArray addObject:model];
        }
        [aArray addObject:model];
    }
    
    for (int i = count - 1; i >= 0; i--) {
        [tempArray addObject:aArray[i]];
    }
    
    if (isFirst) {
        _lastShowTime = tempTime;
    }
    
    return tempArray;
}

//是否显示时间
- (BOOL)sendMessageShouldShowTime:(long long)time {
    long long interval = 0;
    if (time > _lastShowTime) {
        interval = time - _lastShowTime;
    }
    else {
        interval = _lastShowTime - time;
    }
    if (interval / (1000 * 60) > CHAT_TIME_SHOW_INTERVAL) {
        _lastShowTime = time;
        return YES;
    }
    else {
        return NO;
    }
}

#pragma mark - 活动相关
/**
 抢他的活动
 */
- (void)sendTaskFree:(ZZTaskModel *)model {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (!model) {
            return;
        }
        
        NSDictionary *params = @{
                                 @"from": [ZZUserHelper shareInstance].loginer.uid,
                                 @"to": self.uid,
                                 @"pgid": model.task._id,
                                 @"end_time": model.task.dated_at,
                                 };
        
        [ZZRequest method:@"POST" path:@"/api/pdg/pdgBeUser" params:params next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (!error && [data isKindOfClass:[NSDictionary class]]) {
                model.isChatDidSend = YES;
                
                __block NSInteger cellIndex = -1;
                [self.dataArray enumerateObjectsUsingBlock:^(ZZChatBaseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.userModifyIdentifer isEqualToString:@"TaskFreeCell"]) {
                        *stop = YES;
                        cellIndex = idx;
                    }
                }];
                
                if (cellIndex != -1 ) {
                    [self.dataArray removeObjectAtIndex:cellIndex];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_tableView reloadData];
                        if(self.dataArray.count > 0){
                            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0];
                            [_tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                        }
                    });
                }
            }
        }];
    });
    
}

/**
    检查活动时候不在推荐中等 ,是否可以点击
 */
- (void)checkTaskFreeStatus:(ZZTask *)task completion:(void(^)(BOOL canProceed))completion {
    [ZZRequest method:@"GET" path:@"/api/pdg/getPdgDetail" params:@{@"pdgid": task._id} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        BOOL canProceed = NO;
        if (!error && [data boolValue]) {
            canProceed = YES;
        }
        if (completion) {
            completion(canProceed);
        }
    }];
}

#pragma mark - Request
/**
 *  是不是活跃的打招呼回复用户
 */
- (void)sendHighlyActiveReplyUserRequest {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (!_shouldSendHighlyReplyRequest) {
            return ;
        }
        
        if (![self isHighlyActiveReplyUserTo]) {
            return;
        }
        
        [ZZRequest method:@"POST"
                     path:@"/api/addHighReply"
                   params:@{
                       @"uid" : [ZZUserHelper shareInstance].loginer.uid,
                       @"reply_count" : @([ZZUserHelper shareInstance].configModel.sayhi_config.count),
                       @"gender" : @([ZZUserHelper shareInstance].loginer.gender)
                   }
                     next:nil];
    });
}

#pragma mark - Lazyload
- (ZZKTVAudioPlayManager *)audioPlayManager {
    if (!_audioPlayManager) {
        _audioPlayManager = [[ZZKTVAudioPlayManager alloc] init];
        _audioPlayManager.delegate = self;
    }
    return _audioPlayManager;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height - NAVIGATIONBAR_HEIGHT - 20 - SafeAreaBottomHeight);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = HEXCOLOR(0xF0F0F0);
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditing)];
        tableViewGesture.cancelsTouchesInView = NO;
        [_tableView addGestureRecognizer:tableViewGesture];
        
        //可以通过以下方式禁用
        if (IOS10) {
            UITableView.appearance.estimatedRowHeight = 0;
            UITableView.appearance.estimatedSectionFooterHeight = 0;
            UITableView.appearance.estimatedSectionHeaderHeight = 0;
        }
        else {
            _tableView.estimatedRowHeight = 70;
        }
        [self setTableViewInsetsWithBottomValue:54.0];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

/**
 私聊付费的工具提示
 */
- (ZZPrivateChatPayChatBoxView *)payChatBoxView {
    if (!_payChatBoxView) {
        _payChatBoxView = [[ZZPrivateChatPayChatBoxView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 78 - SafeAreaBottomHeight-30, SCREEN_WIDTH, 30)];
        [self.view addSubview:_payChatBoxView];
        _payChatBoxView.backgroundColor = RGBCOLOR(245, 245, 245);
        _payChatBoxView.layer.shadowColor = HEXCOLOR(0xdedcce).CGColor;
        _payChatBoxView.layer.shadowOffset = CGSizeMake(0, -1);
        _payChatBoxView.layer.shadowOpacity = 0.9;
        _payChatBoxView.layer.shadowRadius = 1;
    }
    return _payChatBoxView;
}

- (ZZChatBoxView *)boxView {
    if (!_boxView) {
        _boxView = [[ZZChatBoxView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - 54 - SafeAreaBottomHeight, SCREEN_WIDTH, 54 + CHATBOX_CONTENT_HEIGHT)];
        if (!self.payChatModel.isPay) {
            _boxView.isMessageBox = _isMessageBox && !_isMessageBoxTo ? YES : NO;
            _boxView.topView.isMessageBox = _isMessageBox && !_isMessageBoxTo ? YES : NO;
        }
        _boxView.delegate = self;
        _boxView.uid = _uid;
        _boxView.topView.uid = _uid;
        WS(weakSelf);
        _boxView.sendMessage = ^(ZZGifMessageModel *model) {
            [weakSelf sendGif:model];
        };
    }
    return _boxView;
}

- (ZZChatHeadLodingView *)headView {
    if (!_headView) {
        _headView = [[ZZChatHeadLodingView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _tableView.tableHeaderView = _headView;
        _headView.hidden = YES;
    }
    return _headView;
}

- (ZZChatSensitiveAlertView *)thirdAlertView {
    if (!_thirdAlertView) {
        _thirdAlertView = [[ZZChatSensitiveAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _thirdAlertView;
}

- (NSMutableArray *)photoArray {
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}

- (ZZChatStatusModel *)statusModel {
    if (!_statusModel) {
        _statusModel = [[ZZChatStatusModel alloc] init];
        _statusModel.chat_status = 1;
    }
    return _statusModel;
}

- (NSMutableArray *)deleteArray {
    if (!_deleteArray) {
        _deleteArray = [NSMutableArray array];
    }
    return _deleteArray;
}

- (NSMutableArray *)countDownArray {
    if (!_countDownArray) {
        _countDownArray = [NSMutableArray array];
    }
    return _countDownArray;
}

/**
 今日收益要做动画,从左到右移动
 */
- (ZZPrivateChatShowMoneyView *)showTodayEarnings {
    if (!_showTodayEarnings) {
        _showTodayEarnings = [[ZZPrivateChatShowMoneyView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:_showTodayEarnings];
    }
    return _showTodayEarnings;
}

#pragma mark - Delloc
- (void)dealloc {
    [self.realTimeLocation quitRealTimeLocation];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_isMessageBoxTo && !_haveLocalMessage) {
        [[RCIMClient sharedRCIMClient] clearMessages:ConversationType_PRIVATE targetId:self.uid];
        [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_PRIVATE targetId:self.uid];
    }
    if (!_isMessageBoxTo) {
        if (_updateMessageBox) {
            _updateMessageBox();
        }
    }
    if (_countDownArray.count != 0) {
        for (ZZChatBaseModel *model in _countDownArray) {
            [[RCIMClient sharedRCIMClient] deleteMessages:@[@(model.message.messageId)]];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
