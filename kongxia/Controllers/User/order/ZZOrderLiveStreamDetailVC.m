//
//  ZZOrderLiveStreamDetailVC.m
//  zuwome
//
//  Created by YuTianLong on 2017/9/29.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZOrderLiveStreamDetailVC.h"
#import "ZZOrderOptionsTableViewController.h"
#import "ZZRentChooseSkillViewController.h"
#import "ZZChatViewController.h"
#import "ZZOrderLocationViewController.h"
#import "ZZUserEditViewController.h"
#import "ZZReportViewController.h"
#import "ZZPayViewController.h"
#import "ZZTabBarViewController.h"

#import "ZZLinkWebViewController.h"
#import "ZZOrderCommentViewController.h"
#import "ZZChatServerViewController.h"
#import "ZZOrderRefuseRefundViewController.h"
#import "WBActionContainerView.h"
#import "ZZVideoAppraiseVC.h"

#import "ZZMessage.h"

#import "HttpDNS.h"

@interface ZZOrderLiveStreamDetailVC ()

@property (nonatomic, strong) ZZOrder *order;       // 订单
@property (nonatomic, assign) BOOL isBan;           // 是否禁用
@property (nonatomic, copy) NSString *userId;       // 对方的id（用于拉黑）
@property (nonatomic, assign) BOOL isFrom;          // 是否为订单发起方
@property (nonatomic, copy) NSString *loginerId;

@property (strong, nonatomic) IBOutlet UIImageView *orderStateIcon;     // 订单状态图标
@property (strong, nonatomic) IBOutlet UILabel *orderStateLabel;        // 订单状态
@property (strong, nonatomic) IBOutlet UILabel *orderContentLabel;      // 订单内容

@property (strong, nonatomic) IBOutlet UIImageView *headImageView;      // 头像
@property (strong, nonatomic) IBOutlet UILabel *nickName;               // 昵称
@property (strong, nonatomic) IBOutlet UILabel *orderPrice;             // 订单金额
@property (strong, nonatomic) IBOutlet UILabel *themelabel;             // 主题
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;              // 视频时间
@property (strong, nonatomic) IBOutlet UIButton *questionBtn;           // ？问号btn
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *orderPriceTrailing;

@property (strong, nonatomic) IBOutlet UIView *certificationContainerView;// 认证容器 View
@property (strong, nonatomic) IBOutlet UILabel *certificationContent;   // 认证信息

@property (strong, nonatomic) IBOutlet UIView *complaintContainerView;  // 申诉容器 View
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *complaintContainerViewHeight;
@property (strong, nonatomic) IBOutlet UILabel *justification;          // 申诉理由
@property (strong, nonatomic) IBOutlet UILabel *result;                 // 申诉结果
@property (strong, nonatomic) IBOutlet UILabel *resultLabel;            // title文本
@property (strong, nonatomic) IBOutlet UIButton *evaluateButton;        // 待评价
@property (strong, nonatomic) IBOutlet UIButton *detailClickBtn;        //详情点击btn

@property (nonatomic, strong) WBActionContainerView *presentSlider;

@end

@implementation ZZOrderLiveStreamDetailVC
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kBGColor;
    [self setupUI];
    if (_orderId) {
        [self fetchOrderId:_orderId];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Getter & Setter

- (WBActionContainerView *)presentSlider {
    if (!_presentSlider) {
        WEAK_SELF();
        ZZVideoAppraiseVC *vc = [[ZZVideoAppraiseVC alloc] init];
        vc.roomId = _order.room;
        vc.oid = _orderId;
        [vc setCancelBlock:^{
            [weakSelf.presentSlider dismiss];
        }];
        [vc setCommentsSuccessBlock:^{
            [weakSelf.presentSlider dismiss];
            [weakSelf fetchOrderId:_orderId];
            BLOCK_SAFE_CALLS(weakSelf.updateListBlock);
        }];
        _presentSlider = [[WBActionContainerView alloc] initWithViewController:vc forHeight:ISiPhone5 ? (SCREEN_HEIGHT / 2.0) + 100 : (SCREEN_HEIGHT / 2.0) + 50];
    }
    return _presentSlider;
}

#pragma mark - Private methods

- (void)setupUI {

    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    
    UIButton *customBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    [customBtn setImage:[UIImage imageNamed:@"icon_customerserveice"] forState:UIControlStateNormal];
    [customBtn addTarget:self action:@selector(gotoChatServerView) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:customBtn];
    
    UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 0, 40, 44)];
    [moreBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(navigationRightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:moreBtn];
    
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    btnItem.width = -16;
    UIBarButtonItem *rightBarButon = [[UIBarButtonItem alloc]initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItems = @[btnItem, rightBarButon];
    
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 25.0f;
    self.headImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAvatar)];
    [self.headImageView addGestureRecognizer:gesture];
}

- (void)gotoChatServerView {
    
    ZZChatServerViewController *chatService = [[ZZChatServerViewController alloc] init];
    chatService.conversationType = ConversationType_CUSTOMERSERVICE;
    chatService.targetId = kCustomerServiceId;
    chatService.title = @"客服";
    chatService.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController :chatService animated:YES];
    //以防融云一更新客服聊天中 用户自己的头像又没了
    [RCIMClient sharedRCIMClient].currentUserInfo.portraitUri = [ZZUserHelper shareInstance].loginer.avatar;
}

- (void)navigationRightBtnClick
{
    [MobClick event:Event_click_order_detail_more];
    if (!_order) {
        return;
    }
    [UIActionSheet showInView:self.view
                    withTitle:nil
            cancelButtonTitle:@"取消"
       destructiveButtonTitle:nil
            otherButtonTitles:@[@"举报", _isBan?@"取消拉黑":@"拉黑"]
                     tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex){
                         if (buttonIndex == 0) {
                             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                 ZZReportViewController *controller = [[ZZReportViewController alloc] init];
                                 ZZNavigationController *navCtl = [[ZZNavigationController alloc] initWithRootViewController:controller];
                                 controller.uid = _userId;
                                 [self.navigationController presentViewController:navCtl animated:YES completion:NULL];
                             });
                         }
                         if (buttonIndex == 1) {
                             if (_isBan) {
                                 [ZZUser removeBlackWithUid:_userId next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                                     if (error) {
                                         [ZZHUD showErrorWithStatus:error.message];
                                     } else if (data) {
                                         _isBan = NO;
                                         
                                         NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                                         
                                         NSMutableArray<NSString *> *muArray = [[userDefault objectForKey:@"BannedVideoPeople"] mutableCopy];
                                         if (!muArray) {
                                             muArray = @[].mutableCopy;
                                         }
                                         
                                         if ([muArray containsObject:_userId]) {
                                             [muArray removeObject:_userId];
                                         }
                                         
                                         [userDefault setObject:muArray.copy forKey:@"BannedVideoPeople"];
                                         [userDefault synchronize];
                                     }
                                 }];
                             } else {
                                 [ZZUser addBlackWithUid:_userId next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                                     if (error) {
                                         [ZZHUD showErrorWithStatus:error.message];
                                     } else if (data) {
                                         _isBan = YES;
                                     }
                                 }];
                             }
                         }
                     }];
}

//检测拉黑状态
- (void)checkBlackStatus {
    
    ZZUser *loginer = [ZZUserHelper shareInstance].loginer;
    if ([loginer.uid isEqualToString:_order.from.uid]) {
        _userId = _order.to.uid;
    } else {
        _userId = _order.from.uid;
    }
    [[RCIMClient sharedRCIMClient] getBlacklistStatus:_userId success:^(int bizStatus) {
        if (bizStatus == 0) {
            _isBan = YES;
        } else {
            _isBan = NO;
        }
    } error:^(RCErrorCode status) {
    }];
}

// 获取最新订单
- (void)fetchOrderId:(NSString *)orderId {
    [ZZHUD showWithStatus:@"加载中..."];
    WEAK_SELF();
    [ZZOrder loadInfo:orderId next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [ZZHUD dismiss];
            _order = [[ZZOrder alloc] initWithDictionary:data error:nil];
            
            [weakSelf checkBlackStatus];
            [weakSelf loadMessages];        // 加载订单状态原因
            [weakSelf reloadInfo];          //
            [weakSelf updateUI];
        }
    }];
}

- (void)loadMessages {
    WEAK_SELF();
    [ZZMessage pullOrder:_order.id next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            NSMutableArray *array = [ZZMessage arrayOfModelsFromDictionaries:data error:nil];
            if (array.count) {

                ZZMessage *message = array[0];
                weakSelf.orderContentLabel.text = message.content;
            }
        }
    }];
}

// 更新变量
- (void)reloadInfo {
    
    _loginerId = [ZZUserHelper shareInstance].loginerId;
    _isFrom = [_order.from.uid isEqualToString:_loginerId];
}

// 刷新UI
- (void)updateUI {
    
    NSString *headUrl ;
    NSString *nickName ;
//    NSString *status;
    
    if (_isFrom) {
        self.navigationItem.title = _order.to.nickname;
        headUrl = _order.to.avatar;
        nickName = _order.to.nickname;
        
        if (_order.to.weibo.verified) {
            // 微博认证
            self.certificationContainerView.hidden = NO;
            self.certificationContent.text = [NSString stringWithFormat:@"认证: %@", _order.to.weibo.verified_reason];
        } else {
            self.certificationContainerView.hidden = YES;
        }
    } else {
        self.navigationItem.title = _order.from.nickname;
        headUrl = _order.from.avatar;
        nickName = _order.from.nickname;
        
        if (_order.from.weibo.verified) {
            // 微博认证
            self.certificationContainerView.hidden = NO;
            self.certificationContent.text = [NSString stringWithFormat:@"认证: %@", _order.from.weibo.verified_reason];
        } else {
            self.certificationContainerView.hidden = YES;
        }
    }
    
    if ([self.order.status isEqualToString:@"video_completed"]) {
        // 已结束、已完成
        self.complaintContainerViewHeight.constant = 0.0f;
        self.complaintContainerView.hidden = YES;
        self.evaluateButton.hidden = YES;
//        status = @"已结束";
    } else {
        
        // 申诉中..
        if ([self.order.status isEqualToString:@"video_appealing"]) {
//            status = @"申诉中";
            self.resultLabel.hidden = YES;
            self.result.hidden = YES;
            self.justification.text = self.order.report.reason;
            self.evaluateButton.hidden = YES;
        }
        // 已退款..
        else if ([self.order.status isEqualToString:@"video_refunded"]) {
//            status = @"已退款";
            self.justification.text = self.order.report.reason;
            self.result.text = self.order.report.check_reason;
            self.evaluateButton.hidden = YES;
        }
        // 拒绝退款。。。
        else if ([self.order.status isEqualToString:@"video_refuse_refund"]) {
//            status = @"拒绝退款";
            self.justification.text = self.order.report.reason;
            self.result.text = self.order.report.check_reason;
            self.evaluateButton.hidden = YES;
        }
        // 待评价
        else if ([self.order.status isEqualToString:@"video_commenting"]) {
//            status = @"待评价";
            self.justification.text = self.order.report.reason;
            self.result.text = self.order.report.check_reason;
            self.evaluateButton.hidden = NO;
        }
        // 已评价
        else if ([self.order.status isEqualToString:@"video_commented"]) {
            self.justification.text = self.order.report.reason;
            self.result.text = self.order.report.check_reason;
            self.evaluateButton.hidden = YES;
        }
    }

    if (!_isFrom) {//不是订单发起方，永远没有 待评价按钮
        self.evaluateButton.hidden = YES;
    }
    
    self.orderStateLabel.text = _order.statusText;
    // 头像
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:defaultBackgroundImage_SelectTalent options:SDWebImageRetryFailed];
    // 昵称
    self.nickName.text = nickName;
    // 订单金额
    self.orderPrice.text = [NSString stringWithFormat:@"¥%@",[ZZUtils dealAccuracyNumber:_order.totalPrice]];
    // 主题
    self.themelabel.text = [NSString stringWithFormat:@"主题：%@", _order.skill.name];
    // 时间
    self.timeLabel.text = [NSString stringWithFormat:@"%@", _order.hours_text];
    
    // 线上单，达人方不可点击查看详情
    if (_order.type == 4) {//线上单
//        if (!_isFrom) {//达人方(不是发起方)
//            self.questionBtn.hidden = YES;//隐藏问号
//            self.detailClickBtn.hidden = YES;//隐藏点击btn
//            self.orderPriceTrailing.constant = 16.0f;
//        }
        // 所有方 都不能点击么币详情
        self.questionBtn.hidden = YES;//隐藏问号
        self.detailClickBtn.hidden = YES;//隐藏点击btn
        self.orderPriceTrailing.constant = 16.0f;
    }
    
    if (_order.type == 4) {//闪聊的情况下，才会显示么币
        if (_isFrom) {
            self.orderPrice.text = [NSString stringWithFormat:@"%@么币", [ZZUtils dealAccuracyNumber:_order.totalPrice]];
        } else {
            self.orderPrice.text = [NSString stringWithFormat:@"¥ %@", [ZZUtils dealAccuracyNumber:_order.totalPrice]];
        }
    }
}

- (void)tapAvatar {
    ZZRentViewController *vc = [[ZZRentViewController alloc] init];
    if (_isFrom) {
        vc.uid = _order.to.uid;
    } else {
        vc.uid = _order.from.uid;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

// 聊天
- (IBAction)oChat:(id)sender {
    
    if ([ZZUtils isBan]) {
        return;
    }
    [MobClick event:Event_chat_order];
    if (_isFromChat) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    ZZChatViewController *controller = [[ZZChatViewController alloc] init];
    controller.uid = _isFrom?_order.to.uid:_order.from.uid;
    controller.nickName = _isFrom?_order.to.nickname:_order.from.nickname;
    controller.portraitUrl = _isFrom?_order.to.avatar:_order.from.avatar;
    controller.isFromOrderDetail = YES;
//    controller.orderId = _order.id;
    controller.statusChange = ^{
        [self fetchOrderId:_orderId];
    };
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)evaluateClick:(UIButton *)sender {
    [self.presentSlider present];
}

// 订单价格详情

- (IBAction)orderDetailPrice:(id)sender {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/api/order/price_detail/page?oid=%@&&access_token=%@",kBase_URL,_order.id,[ZZUserHelper shareInstance].oAuthToken];
    ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc] init];
    controller.urlString = urlString;
    controller.navigationItem.title = @"价格详情";
    [self.navigationController pushViewController:controller animated:YES];
}

@end
