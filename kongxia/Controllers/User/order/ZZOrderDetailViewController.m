//
//  ZZOrderDetailViewController.m
//  zuwome
//
//  Created by angBiu on 16/7/4.
//  Copyright © 2016年 zz. All rights reserved.
//

NSString *identifier = @"topiccell";

#import "ZZOrderDetailViewController.h"
#import "ZZOrderOptionsTableViewController.h"
#import "ZZRentChooseSkillViewController.h"
#import "ZZChatViewController.h"
#import "ZZOrderLocationViewController.h"
#import "ZZUserEditViewController.h"
#import "ZZReportViewController.h"
#import "ZZRentViewController.h"
#import "ZZPayViewController.h"
#import "ZZTabBarViewController.h"
#import "ZZLinkWebViewController.h"
#import "ZZOrderCommentViewController.h"
#import "ZZChatServerViewController.h"
#import "ZZOrderRefuseRefundViewController.h"
#import "ZZARRentAlertView.h"
#import "ZZOrderTimeLineView.h"
#import "ZZOrderStatusView.h"
#import "ZZOrderDetailTopicCell.h"
#import "ZZOrderDetailCell.h"
#import "ZZOrderFirstGuideView.h"

#import "ZZMessage.h"
#import "ZZFalsePhoneAlertViewGuide.h"
#import "HttpDNS.h"
#import "ZZNewOrderRefundOptionsViewController.h"//退款流程优化新的订单取消界面
#import "ZZCheckOtherUploadEvidence.h"//查看证据
#import "ZZEvidenceInformationVC.h"
#import "ZZUploadBaseModel.h" //上传证据的基类model
#import "ZZNewOrderRefuseReasonViewController.h"//新的拒绝理由
#import "ZZOrderTalentShowViewController.h"
#import "ZZNewOrderRefundOptionsViewController.h"
@interface ZZOrderDetailViewController () <UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSString            *_loginerId;
    NSArray             *_refundStatusArray;
    NSArray             *_normalStatusArray;
    BOOL                _isFrom; //是否为订单发起方
    NSString            *_userId;//对方的id（用于拉黑）
    OrderDetailType     _detailType;
    BOOL                _firstLoad;
    NSMutableArray      *_messageArray;

    BOOL                _reloadHeadView;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ZZOrderTimeLineView *timeLineView;
 @property (nonatomic, strong) ZZOrder  *order;
@property (nonatomic, strong) ZZMessageResponseModel *responseModel;
@property (nonatomic, assign) BOOL isBan;

@end

@implementation ZZOrderDetailViewController

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kBGColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[ZZOrderDetailTopicCell class] forCellReuseIdentifier:identifier];
        [_tableView registerClass:[ZZCheckOtherUploadEvidence class] forCellReuseIdentifier:@"ZZCheckOtherUploadEvidenceID"];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    }
    
    return _tableView;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ZZOrderDetailCell class] forCellWithReuseIdentifier:@"buttoncell"];
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    
    return _collectionView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _firstLoad = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    _refundStatusArray = @[@"appealing",@"refunding",@"refundHanding",@"refusedRefund",@"refunded"];
    _normalStatusArray = @[@"pending",@"cancel",@"refused",@"paying",@"meeting",@"commenting",@"commented"];
    if (_orderId) {
        [self fetchOrderId:_orderId];
    }
    [self checkInfo];
    
    [self createNavigationLeftButton];
    [self createNavigationRightBtn];
    
    //通知改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderStatusChangeNotification:) name:kMsg_OrderStatusChante object:nil];
}

#pragma mark - UINavigation

- (void)createNavigationLeftButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 44, 44);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -15,0, 0);
    btn.contentEdgeInsets =UIEdgeInsetsMake(0, -20,0, 0);

    if (_firstPay) {
        [btn setImage:[UIImage imageNamed:@"x"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"x"] forState:UIControlStateHighlighted];
    } else {
        [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    }
    [btn addTarget:self action:@selector(navigationLeftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];

    self.navigationItem.leftBarButtonItems =@[leftItem];
}

- (void)navigationLeftBtnClick
{
    if (_firstPay) {
        BOOL haveCtl = NO;
        for (UITableViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[ZZChatViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
                break;
            }
            if ([controller isKindOfClass:[ZZOrderDetailViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
                break;
            }
            if (haveCtl == NO) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)createNavigationRightBtn
{
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
}

- (void)gotoChatServerView
{
    [ZZServerHelper showServer];
//    ZZChatServerViewController *chatService = [[ZZChatServerViewController alloc] init];
//    chatService.conversationType = ConversationType_CUSTOMERSERVICE;
//    chatService.targetId = kCustomerServiceId;
//    chatService.title = @"客服";
//    chatService.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController :chatService animated:YES];
//    //以防融云一更新客服聊天中 用户自己的头像又没了
//    [RCIMClient sharedRCIMClient].currentUserInfo.portraitUri = [ZZUserHelper shareInstance].loginer.avatar;
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

#pragma mark - 订单推送更新

- (void)orderStatusChangeNotification:(NSNotification *)notification
{
    if ([_order.id isEqualToString:[notification.userInfo objectForKey:@"order"]]) {
        [self fetchOrderId:_order.id];
    }
}

#pragma mark - LoadData

// 弹出是否要完善信息
- (void)checkInfo {
    if ([_order.status isEqualToString:@"pending"]) {
        ZZUser *loginer = [ZZUserHelper shareInstance].loginer;
        if (!loginer.height || !loginer.weight) {
            [UIAlertView showWithTitle:@"提示" message:@"完善资料可以提高约见几率" cancelButtonTitle:@"暂不需要" otherButtonTitles:@[@"完善资料"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"完善资料"]) {
                    ZZUserEditViewController *controller = [[ZZUserEditViewController alloc] init];
                    [self.navigationController pushViewController:controller animated:YES];
                }
            }];
        }
    }
}

//检测拉黑状态
- (void)checkBlackStatus
{
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

- (void)fetchOrderId:(NSString *)orderId {
    [ZZHUD showWithStatus:@"加载中..."];
    [ZZOrder loadInfo:orderId next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [ZZHUD dismiss];
            _order = [ZZOrder yy_modelWithDictionary:data];//[[ZZOrder alloc] initWithDictionary:data error:nil];
            
            [self reloadInfo];
            [self checkBlackStatus];
            
            if (!_reloadHeadView) {
                self.tableView.tableHeaderView = [self createHeadViewWithMessage:@""];
            }
            
            if (_detailType == OrderDetailTypePending && !_isFrom) {
                if (![ZZUserHelper shareInstance].firstOrderDetailPage) {
//                    [self createGuideView];
                }
            }
        }
    }];
    
}

- (void)createGuideView
{
    ZZOrderFirstGuideView *guideView = [[ZZOrderFirstGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view.window addSubview:guideView];
    
    [ZZUserHelper shareInstance].firstOrderDetailPage = @"firstOrderDetailPage";
}

- (void)loadMessages {
//    [ZZRequest method:@"GET" path:[NSString stringWithFormat:@"/api/message/order2/%@", _order.id] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
//        if (error) {
//            [ZZHUD showErrorWithStatus:error.message];
//        } else {
//            _responseModel = [ZZMessageResponseModel yy_modelWithJSON:data];
//            if (_responseModel.results.count) {
//                if (_messageArray) {
//                    [_messageArray removeAllObjects];
//                } else {
//                    _messageArray = [NSMutableArray array];
//                }
//                [_messageArray addObjectsFromArray:_responseModel.results];
//                ZZMessage *message = _responseModel.results[0];
//                self.tableView.tableHeaderView = [self createHeadViewWithMessage:message.content];
//                _reloadHeadView = YES;
//                [_tableView reloadData];
//            }
//        }
    
//    }];
    [ZZMessage pullOrder:_order.id next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            NSMutableArray *array = [ZZMessage arrayOfModelsFromDictionaries:data error:nil];
            if (array.count) {
                if (!_messageArray) {
                    _messageArray = @[].mutableCopy;
                }
                
                if (array) {
                    [_messageArray removeAllObjects];
                }
                else {
                    _messageArray = [NSMutableArray array];
                }
                [_messageArray addObjectsFromArray:array];
                ZZMessage *message = array[0];
                self.tableView.tableHeaderView = [self createHeadViewWithMessage:message.content];
                _reloadHeadView = YES;
                [_tableView reloadData];
            }
        }
    }];
}

- (void)reloadInfo
{
    [self managerStatus];
    if (_firstLoad) {
        self.tableView.tableFooterView = [self createFootView];
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left);
            make.right.mas_equalTo(self.view.mas_right);
            make.top.mas_equalTo(self.view.mas_top);
            make.bottom.mas_equalTo(self.view.mas_bottom);
        }];
        _firstLoad = NO;
    } else {
        [self.tableView reloadData];
        [self.collectionView reloadData];
    }
    [self loadMessages];
    

}

- (void)managerStatus
{
    _loginerId = [ZZUserHelper shareInstance].loginerId;
    _isFrom = [_order.from.uid isEqualToString:_loginerId];
    if ([_order.status isEqualToString:@"pending"]) {//等待接受
        _detailType = OrderDetailTypePending;
    }
    if ([_order.status isEqualToString:@"cancel"]) {//取消
        _detailType = OrderDetailTypeCancel;
    }
    if ([_order.status isEqualToString:@"refused"]) {//拒绝
        _detailType = OrderDetailTypeRefused;
    }
    if ([_order.status isEqualToString:@"paying"]) {//待付款
        _detailType = OrderDetailTypePaying;
    }
    if ([_order.status isEqualToString:@"meeting"]) {//见面中
        _detailType = OrderDetailTypeMeeting;
    }
    if ([_order.status isEqualToString:@"commenting"]) {//待评论
        _detailType = OrderDetailTypeCommenting;
    }
    if ([_order.status isEqualToString:@"commented"]) {//已评价
        _detailType = OrderDetailTypeCommented;
    }
    if ([_order.status isEqualToString:@"appealing"]) {//申诉中
        _detailType = OrderDetailTypeAppealing;
    }
    if ([_order.status isEqualToString:@"refunding"]) {//申请退款
        _detailType = OrderDetailTypeRefunding;
    }
    if ([_order.status isEqualToString:@"refundHanding"]) {//退款处理中
        _detailType = OrderDetailTypeRefundHanding;
    }
    if ([_order.status isEqualToString:@"refusedRefund"]) {//拒绝退款
        _detailType = OrderDetailTypeRefusedRefund;
    }
    if ([_order.status isEqualToString:@"refunded"]) {//已经退款
        _detailType = OrderDetailTypeRefunded;
    }
    switch (_detailType) {
        case OrderDetailTypePending:
        case OrderDetailTypeCancel:
        case OrderDetailTypeRefused:
        case OrderDetailTypePaying:
        case OrderDetailTypeMeeting:
        case OrderDetailTypeCommenting:
        case OrderDetailTypeCommented:
            self.navigationItem.title = @"邀约详情";
            break;
 
        default:
        {
            self.navigationItem.title = @"退款详情";
        }
            break;
    }
}

#pragma mark - CreateHeaderAndFootView

- (UIView *)createHeadViewWithMessage:(NSString *)message
{
    __weak typeof(self)weakSelf = self;
    ZZOrderStatusView *statuseView = [[ZZOrderStatusView alloc] initWithFrame:CGRectZero];
    [statuseView setOrder:_order type:_detailType];
    statuseView.contentLabel.text = message;
    statuseView.touchDetail = ^{
        if (!isNullString(message)) {
            [weakSelf showTimeLine];
        }
    };
    CGFloat height = [statuseView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    statuseView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    return statuseView;
}

- (UIView *)createFootView
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180 + 8)];
    
    [footView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(footView.mas_top).offset(8);
        make.left.mas_equalTo(footView.mas_left).offset(8);
        make.right.mas_equalTo(footView.mas_right).offset(-8);
        make.bottom.mas_equalTo(footView.mas_bottom);
    }];
    
    return footView;
}

#pragma mark - UITableViewMethod
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ((!_isFrom&&self.order.refund.remarks)||_detailType ==OrderDetailTypeRefusedRefund||_detailType ==OrderDetailTypeAppealing) {
        if (_detailType == OrderDetailTypeCancel||_detailType == OrderDetailTypeCommenting ||_detailType == OrderDetailTypeCommented) {
            //取消  ,待评论状态 ,已评论状态  都不显示查看证据
            return 1;
        }
        if (self.order.refund.photos.count<=0&&self.order.refund.refuse_photos.count<=0&&[self.order.refund.remarks isEqualToString:@"取消邀约"]) {
            return 1;
        }
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    if (indexPath.row==0) {
        ZZOrderDetailTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        [self setupCell:cell indexPath:indexPath];
        cell.locationClick = ^{
            [weakSelf gotoLocation];
        };
        cell.tapAvatarClick = ^{
            [weakSelf tapAvatar];
        };
        
        cell.capitalFlowProtocolClick = ^{
            [weakSelf showProtocol];
        };
        return cell;
    }
    else{
    ZZCheckOtherUploadEvidence *cell = [tableView dequeueReusableCellWithIdentifier:@"ZZCheckOtherUploadEvidenceID"];
        cell.titleLab.text = (_detailType ==OrderDetailTypeAppealing||_detailType ==OrderDetailTypeRefusedRefund ||(_detailType == OrderDetailTypeRefunded&&self.order.refund.refuse_photos.count>0))?@"查看双方证据":@"查看对方上传证据";
    return cell;
    }
}

- (void)setupCell:(ZZOrderDetailTopicCell *)cell indexPath:(NSIndexPath *)indexPath
{
    [cell setOrder:_order type:_detailType moneyFlowDescript:_responseModel.price_text from:_isFrom];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        __weak typeof(self)weakSelf = self;
        return [tableView fd_heightForCellWithIdentifier:identifier cacheByIndexPath:indexPath configuration:^(id cell) {
            [weakSelf setupCell:cell indexPath:indexPath];
        }];
    }else{
        return 58;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        NSString *urlString = [NSString stringWithFormat:@"%@/api/order/price_detail/page?oid=%@&&access_token=%@",kBase_URL,_order.id,[ZZUserHelper shareInstance].oAuthToken];
        ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc] init];
        controller.urlString = urlString;
        controller.navigationItem.title = @"价格详情";
        [self.navigationController pushViewController:controller animated:YES];
    }
    else {
        ZZEvidenceInformationVC *VC = [[ZZEvidenceInformationVC alloc]init];
        ZZUploadBaseModel *model = [[ZZUploadBaseModel alloc]init];
        model.photos = self.order.refund.photos;
        model.remarks = self.order.refund.remarks;
        model.refuse_photos = self.order.refund.refuse_photos;
        model.refuse_reason = self.order.refund.refuse_reason;
        model.status = self.order.status;
        model.userName =  self.order.from.nickname;
        model.doyenNickName =  self.order.to.nickname;
        VC.model = model;
        [self.navigationController pushViewController:VC animated:YES];
    }
    
}

#pragma mark - UICollectionViewMethod

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (_order.need_deposit) {
        switch (_detailType) {
            case OrderDetailTypePending:
            {
                return 3;
            }
                break;
            case OrderDetailTypeCancel:
            {
                return 1;
            }
                break;
            case OrderDetailTypeRefused:
            {
                return 1;
            }
                break;
            case OrderDetailTypePaying:
            {
                return _isFrom?3:2;
            }
                break;
            case OrderDetailTypeMeeting:
            {
                return 4;
            }
                break;
            case OrderDetailTypeCommenting:
            {
                return 3;
            }
                break;
            case OrderDetailTypeCommented:
            {
                return 3;
            }
                break;
            case OrderDetailTypeAppealing:
            {
                return 1;
            }
                break;
            case OrderDetailTypeRefunding:
            {
                if (_isFrom) {
                    if (_order.cancel_refund_times == 0) {
                        if (_order.paid_at) {
                            return 3;
                        }
                        else {
                            return 2;
                        }
                    }
                    else {
                        return 1;
                    }
                }
                else {
                    return 3;
                }
            }
                break;
            case OrderDetailTypeRefundHanding:
            {
                return 1;
            }
                break;
            case OrderDetailTypeRefusedRefund:
            {
                return 1;
            }
                break;
            case OrderDetailTypeRefunded:
            {
                return 1;
            }
                break;
            default:
                break;
        }
    } else {
        switch (_detailType) {
            case OrderDetailTypePending:
            {
                return _isFrom?2:3;
            }
                break;
            case OrderDetailTypeCancel:
            {
                if (_isFrom) {
                    if ([_order.cancel_type isEqualToString:@"2"]) {
                        return 1;
                    }
                    return 0;
                }
                return 1;
            }
                break;
            case OrderDetailTypeRefused:
            {
                return _isFrom?0:1;
            }
                break;
            case OrderDetailTypePaying:
            {
                return _isFrom?3:2;
            }
                break;
            case OrderDetailTypeMeeting:
            {
                return 4;
            }
                break;
            case OrderDetailTypeCommenting:
            {
                return 3;
            }
                break;
            case OrderDetailTypeCommented:
            {
                return 3;
            }
                break;
            case OrderDetailTypeAppealing:
            {
                return 1;
            }
                break;
            case OrderDetailTypeRefunding:
            {
                if (_isFrom) {
                    if (_order.cancel_refund_times == 0) {
                        if (_order.paid_at) {
                            return 3;
                        }
                        else {
                            return 2;
                        }
                    }
                    else {
                        return 1;
                    }
                }
                else {
                    return 3;
                }
            }
                break;
            case OrderDetailTypeRefundHanding:
            {
                return 2;
            }
                break;
            case OrderDetailTypeRefusedRefund:
            {
                return 0;
            }
                break;
            case OrderDetailTypeRefunded:
            {
                return 0;
            }
                break;
            default:
                break;
        }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZZOrderDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"buttoncell" forIndexPath:indexPath];
    cell.bgView.backgroundColor = [UIColor whiteColor];
    switch (_detailType) {
        case OrderDetailTypePending:
        {
            switch (indexPath.row) {
                case 0:
                    cell.nameLabel.text = _isFrom?@"取消预约":@"拒绝预约";
                    cell.iconImageView.image = [UIImage imageNamed:@"oCancel"];
                    break;
                case 1:
                    cell.nameLabel.text = _isFrom?@"修改预约信息":@"私信";
                    cell.iconImageView.image = [UIImage imageNamed:_isFrom?@"oEdit":@"oChat"];
                    break;
                default:
                    //加了聊天
                    cell.nameLabel.text = _isFrom?@"私信":@"接受预约";
                    if (!_isFrom) {
                        cell.bgView.backgroundColor = [UIColor colorWithHexString:ZWM_YELLOW andAlpha:1];
                    }
                    cell.iconImageView.image = [UIImage imageNamed:_isFrom?@"oChat":@"oAccept"];
                    break;
            }
        }
            break;
        case OrderDetailTypePaying:
        {
            switch (indexPath.row) {
                case 0:
                    cell.nameLabel.text = @"取消预约";
                    cell.iconImageView.image = [UIImage imageNamed:@"oCancel"];
                    break;
                case 1:
                    cell.nameLabel.text = @"私信";
                    cell.iconImageView.image = [UIImage imageNamed:@"oChat"];
                    break;
                default:
                    cell.nameLabel.text = @"去付款";
                    cell.bgView.backgroundColor = [UIColor colorWithHexString:ZWM_YELLOW andAlpha:1];
                    cell.iconImageView.image = [UIImage imageNamed:@"oPay"];
                    break;
            }
        }
            break;
        case OrderDetailTypeMeeting:
        {
            switch (indexPath.row) {
                case 0:
                    cell.nameLabel.text = _isFrom?@"申请退款":@"取消预约";
                    cell.iconImageView.image = [UIImage imageNamed:_isFrom?@"oRefund":@"oCancel"];
                    break;
                case 1: {
                    cell.nameLabel.text = _isFrom ? @"确认完成":@"已到达";
                    cell.nameLabel.textColor = [UIColor blackColor];
                    cell.iconImageView.image = [UIImage imageNamed:@"oMeet"];
                }
                    break;
                case 2:
                    cell.nameLabel.text = @"电话";
                    cell.iconImageView.image = [UIImage imageNamed:@"oPhone"];
                    break;
                default:
                    cell.nameLabel.text = @"私信";
                    cell.iconImageView.image = [UIImage imageNamed:@"oChat"];
                    break;
            }
        }
            break;
        case OrderDetailTypeCommenting:
        {
            if(_order.met && _order.met.to && _order.met.from){
                switch (indexPath.row) {
                    case 0:
                        cell.nameLabel.text = @"电话";
                        cell.iconImageView.image = [UIImage imageNamed:@"oPhone"];
                        break;
                    case 1:
                        cell.nameLabel.text = @"私信";
                        cell.iconImageView.image = [UIImage imageNamed:@"oChat"];
                        break;
                    case 2:
                        cell.nameLabel.text = @"待评价";
                        cell.iconImageView.image = [UIImage imageNamed:@"oComment"];
                        break;
                }
            }
            else{
                switch (indexPath.row) {
                    case 0:
                        cell.nameLabel.text = @"电话";
                        cell.iconImageView.image = [UIImage imageNamed:@"oPhone"];
                        break;
                    case 1:
                        cell.nameLabel.text = @"私信";
                        cell.iconImageView.image = [UIImage imageNamed:@"oChat"];
                        break;
                    case 2:
                        cell.nameLabel.text = @"等待对方确认完成";
                        cell.iconImageView.image = [UIImage imageNamed:@"oComment"];
                        break;
                }
            }
        }
            break;
        case OrderDetailTypeCommented:
        {
            switch (indexPath.row) {
                case 0:
                    cell.nameLabel.text = @"电话";
                    cell.iconImageView.image = [UIImage imageNamed:@"oPhone"];
                    break;
                case 1:
                    cell.nameLabel.text = @"私信";
                    cell.iconImageView.image = [UIImage imageNamed:@"oChat"];
                    break;
                case 2:
                    cell.nameLabel.text = @"已评价";
                    cell.iconImageView.image = [UIImage imageNamed:@"oComment"];
                    break;
            }
        }
            break;
        case OrderDetailTypeRefunding:
        {
            if (!_isFrom) {
                switch (indexPath.row) {
                    case 0:
                        cell.nameLabel.text = @"同意退款";
                        cell.iconImageView.image = [UIImage imageNamed:@"oAccept"];
                        break;
                    case 1:
                        cell.nameLabel.text = @"拒绝退款";
                        cell.iconImageView.image = [UIImage imageNamed:@"oCancel"];
                        break;
                    default:
                        cell.nameLabel.text = @"私信";
                        cell.iconImageView.image = [UIImage imageNamed:@"oChat"];
                        break;
                }
            }
            else {
                if (_order.cancel_refund_times == 0) {
                    if (_order.paid_at) {
                        switch (indexPath.row) {
                            case 0:
                                cell.nameLabel.text = @"撤销退款申请";
                                cell.iconImageView.image = [UIImage imageNamed:@"oAccept"];
                                break;
                            case 1:
                                cell.nameLabel.text = @"修改退款申请";
                                cell.iconImageView.image = [UIImage imageNamed:@"oCancel"];
                                break;
                            default:
                                cell.nameLabel.text = @"私信";
                                cell.iconImageView.image = [UIImage imageNamed:@"oChat"];
                                break;
                        }
                    }
                    else {
                        switch (indexPath.row) {
                            case 0:
                                cell.nameLabel.text = @"撤销退款申请";
                                cell.iconImageView.image = [UIImage imageNamed:@"oAccept"];
                                break;
                            default:
                                cell.nameLabel.text = @"私信";
                                cell.iconImageView.image = [UIImage imageNamed:@"oChat"];
                                break;
                        }
                    }
                }
                else {
                    cell.nameLabel.text = @"私信";
                    cell.iconImageView.image = [UIImage imageNamed:@"oChat"];
                }
                /*
                if (_order.paid_at) {
                    switch (indexPath.row) {
                        case 0:
                            cell.nameLabel.text = @"撤销退款申请";
                            cell.iconImageView.image = [UIImage imageNamed:@"oAccept"];
                            break;
                        case 1:
                            cell.nameLabel.text = @"修改退款申请";
                            cell.iconImageView.image = [UIImage imageNamed:@"oCancel"];
                            break;
                        default:
                            cell.nameLabel.text = @"私信";
                            cell.iconImageView.image = [UIImage imageNamed:@"oChat"];
                            break;
                    }
                }
                else if (_order.cancel_refund_times > 0){
                    cell.nameLabel.text = @"私信";
                    cell.iconImageView.image = [UIImage imageNamed:@"oChat"];
                }
                else {
                    switch (indexPath.row) {
                        case 0:
                            cell.nameLabel.text = @"撤销退款申请";
                            cell.iconImageView.image = [UIImage imageNamed:@"oAccept"];
                            break;
                        default:
                            cell.nameLabel.text = @"私信";
                            cell.iconImageView.image = [UIImage imageNamed:@"oChat"];
                            break;
                    }
                }
                 */
            }
        }
            break;
        case OrderDetailTypeCancel:
        case OrderDetailTypeRefused:
        case OrderDetailTypeAppealing:
        case OrderDetailTypeRefundHanding:
        case OrderDetailTypeRefusedRefund:
        case OrderDetailTypeRefunded:
        {
            switch (indexPath.row) {
                case 0:
                    cell.nameLabel.text = @"私信";
                    cell.iconImageView.image = [UIImage imageNamed:@"oChat"];
                    break;
            }
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (_detailType) {
        case OrderDetailTypePending:
        {
            switch (indexPath.row) {
                case 0:
                    _isFrom?[self cancel]:[self refuse];
                    break;
                case 1:
                    _isFrom?[self edit]:[self chat];
                    break;
                default:
                    //加了聊天
                    _isFrom?[self chat]:[self accept];
                    break;
            }
        }
            break;
        case OrderDetailTypePaying:
        {
            switch (indexPath.row) {
                case 0:
                    [self cancel];
                    break;
                case 1:
                    [self chat];
                    break;
                default:
                    [self pay];
                    break;
            }
        }
            break;
        case OrderDetailTypeMeeting:
        {
            switch (indexPath.row) {
                case 0:
                    _isFrom?[self wantToRefund]:[self cancel];
                    break;
                case 1: {
                    [self met];
                }
                    break;
                case 2:{
                    NSString *fistkey = [NSString stringWithFormat:@"%@%@",@"ZZFalsePhoneAlertViewGuideKey",[ZZUserHelper shareInstance].loginer.uid];
                    NSString *string = [ZZKeyValueStore getValueWithKey:fistkey];
                    if (!string) {
                        [ZZFalsePhoneAlertViewGuide showAlertViewGuideViewWhenFirstIntoSureBack:^{
                               [self call];
                        }];
                    [ZZKeyValueStore saveValue:@"ZZFalsePhoneAlertViewGuideKey" key:fistkey];
                    }else{
                          [self call];
                    }
              
                  
                }
                    break;
                default:
                    [self chat];
                    break;
            }
        }
            break;
        case OrderDetailTypeCommenting:
        {
            if(_order.met && _order.met.to && _order.met.from){
                switch (indexPath.row) {
                    case 0:
                        [self call];
                        break;
                    case 1:
                        [self chat];
                        break;
                    default:
                        [self comment];
                        break;
                }
            }
            else{
                switch (indexPath.row) {
                    case 0:
                        [self call];
                        break;
                    case 1:
                        [self chat];
                        break;
                    default:
                        break;
                }
            }
        }
            break;
        case OrderDetailTypeCommented:
        {
            switch (indexPath.row) {
                case 0:
                    [self call];
                    break;
                case 1:
                    [self chat];
                    break;
                default:
                    break;
            }
        }
            break;
        case OrderDetailTypeRefunding:
        {
            if (!_isFrom) {
                switch (indexPath.row) {
                    case 0:
                        [self refundYes];
                        break;
                    case 1:
                        [self refundNo];
                        break;
                    default:
                        //加了聊天
                        [self chat];
                        break;
                }
            } else {
                if (_order.cancel_refund_times == 0) {
                    if (_order.paid_at) {
                        switch (indexPath.row) {
                            case 0:
                                [self revokeRefund];
                                break;
                            case 1:
                                [self editRefund];
                                break;
                            default:
                                [self chat];
                                break;
                        }
                    }
                    else {
                        switch (indexPath.row) {
                            case 0:
                                [self revokeRefund];
                                break;
                            default:
                                [self chat];
                                break;
                        }
                    }
                }
                else {
                    [self chat];
                }
                /*
                if (_order.paid_at) {
                    switch (indexPath.row) {
                        case 0:
                            [self revokeRefund];
                            break;
                        case 1:
                            [self editRefund];
                            break;
                        default:
                            [self chat];
                            break;
                    }
                }
                else if (_order.cancel_refund_times > 0){
                    [self chat];
                }
                else {
                    switch (indexPath.row) {
                        case 0:
                            [self revokeRefund];
                            break;
                        default:
                            [self chat];
                            break;
                    }
                }
                 */
            }
        }
            break;
        case OrderDetailTypeCancel:
        case OrderDetailTypeRefused:
        case OrderDetailTypeAppealing:
        case OrderDetailTypeRefundHanding:
        case OrderDetailTypeRefusedRefund:
        case OrderDetailTypeRefunded:
        {
            [self chat];
        }
            break;
        default:
            break;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat minWidth = (SCREEN_WIDTH - 16 - 15)/2;
    CGFloat maxWidth = SCREEN_WIDTH - 16;
    switch (_detailType) {
        case OrderDetailTypePending:
        {
            if (indexPath.row == 2) {
                return CGSizeMake(maxWidth, 50);
            }
        }
            break;
        case OrderDetailTypePaying:
        {
            if (indexPath.row == 2) {
                return CGSizeMake(maxWidth, 50);
            }
        }
            break;
        case OrderDetailTypeMeeting:
        {

        }
            break;
        case OrderDetailTypeCommenting:
        {
            if (indexPath.row == 2) {
                return CGSizeMake(maxWidth, 50);
            }
        }
            break;
        case OrderDetailTypeCommented:
        {
            if (indexPath.row == 2) {
                return CGSizeMake(maxWidth, 50);
            }
        }
            break;
        case OrderDetailTypeRefunding:
        {
            if (_order.cancel_refund_times == 0) {
                if (_order.paid_at) {
                    if (indexPath.row == 2) {
                        return CGSizeMake(maxWidth, 50);
                    }
                    else {
                        return CGSizeMake(minWidth, 50);
                    }
                }
                else {
                    return CGSizeMake(minWidth, 50);
                }
            }
            else {
                return CGSizeMake(maxWidth, 50);
            }
            
//            if (indexPath.row == 2) {
//                return CGSizeMake(maxWidth, 50);
//            }
//            if (_order.cancel_refund_times > 0 && !_order.paid_at) {
//                return _isFrom ? CGSizeMake(maxWidth, 50): CGSizeMake(minWidth, 50);
//            }
        }
            break;
        case OrderDetailTypeCancel:
        case OrderDetailTypeRefused:
        case OrderDetailTypeAppealing:
        case OrderDetailTypeRefundHanding:
        case OrderDetailTypeRefusedRefund:
        case OrderDetailTypeRefunded:
        {
            return CGSizeMake(maxWidth, 50);
        }
            break;
        default:
            break;
    }
    
    return CGSizeMake(minWidth, 50);
}

#pragma mark - UIButtonMethod
//TODO: 跳转到H5的保障
- (void)showProtocol {
    NSString *urlString = H5Url.platformGuaranteePayment;
    ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc] init];
    controller.urlString = urlString;
    controller.isShowLeftButton = YES;
    controller.isPush = YES;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

//查看地图
- (void)gotoLocation
{
    ZZOrderLocationViewController *controller = [[ZZOrderLocationViewController alloc] init];
    controller.location = [[CLLocation alloc] initWithLatitude:[_order.loc.lat doubleValue] longitude:[_order.loc.lng doubleValue]];
    controller.name = _order.address;
    controller.navigationItem.title = @"邀约地点";
    [self.navigationController pushViewController:controller animated:YES];
}

//查看时间轴
- (void)showTimeLine
{
    if (_messageArray) {
        if (!_timeLineView) {
            _timeLineView = [[ZZOrderTimeLineView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) order:_order];
            [self.view.window addSubview:_timeLineView];
        }
        _timeLineView.messageArray = _messageArray;
    }
}

//点击头像
- (void)tapAvatar {
    ZZRentViewController *vc = [[ZZRentViewController alloc] init];
    if (_isFrom) {
        vc.uid = _order.to.uid;
    } else {
        vc.uid = _order.from.uid;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

// 取消
- (void)cancel {
    if ([ZZUtils isBan]) {
        return;
    }
    [MobClick event:Event_cancel_order];
    if (_isFrom && _detailType == OrderDetailTypePaying) {
        ZZNewOrderRefundOptionsViewController *controller = [[ZZNewOrderRefundOptionsViewController alloc]init];
        controller.order = self.order;
        controller.isFromChat = NO;
        [self.navigationController pushViewController:controller animated:YES];
        WS(weakSelf);
        controller.callBack = ^(NSString *status) {
            weakSelf.order.status = @"cancel";
            [weakSelf reloadInfo];
            if (weakSelf.callBack) {
                weakSelf.callBack(_order.status);
            }
            [weakSelf reduceOngoingCount];
        };
    } else {
        
        ZZOrderTalentShowViewController *vc = [[ZZOrderTalentShowViewController alloc] init];
        vc.order = _order;
        vc.uid =self.order.from.uid;
        vc.isFrom = _isFrom;

        vc.callBack = ^(NSString *status) {
            _order.status = status;
            [self reloadInfo];
            if (_callBack) {
                _callBack(_order.status);
            }
            [self reduceOngoingCount];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

// 拒绝
- (void)refuse {
    if ([ZZUtils isBan]) {
        return;
    }
    [MobClick event:Event_refuse_order];
    ZZOrderTalentShowViewController *vc = [[ZZOrderTalentShowViewController alloc] init];
    vc.order = self.order;
    vc.isRefusedInvitation = YES;
    vc.isFrom = NO;
    vc.callBack = ^(NSString *status) {
        _order.status = status;
        [self reloadInfo];
        if (_callBack) {
            _callBack(_order.status);
        }
        [self reduceOngoingCount];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

// 编辑约会
- (void)edit {
    
    if ([ZZUtils isBan]) {
        return;
    }
    [MobClick event:Event_modify_order];
    ZZRentChooseSkillViewController *controller = [[ZZRentChooseSkillViewController alloc] init];
    controller.isEdit = YES;
    controller.order = _order;
    ZZNavigationController *nav = [[ZZNavigationController alloc] initWithRootViewController:controller];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orderDidUpdate:)
                                                 name:kMsg_UpdateOrder
                                               object:nil];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)orderDidUpdate:(NSNotification *)sender {
    ZZOrder *order = [[ZZOrder alloc] initWithDictionary:sender.userInfo error:nil];
    if ([_order.id isEqualToString:order.id]) {
        [self fetchOrderId:_order.id];
    }
}

// 聊天
- (void)chat {
    
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
    controller.orderId = _order.id;
    controller.statusChange = ^{
        [self fetchOrderId:_orderId];
    };
    [self.navigationController pushViewController:controller animated:YES];
}

// 接受预约
- (void)accept {
    
    if ([ZZUtils isBan]) {
        return;
    }
    [MobClick event:Event_accept_order];
    [ZZHUD showWithStatus:nil];
    [_order accept:_order.status next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else if (data) {
            [ZZHUD dismiss];
            _order.status = data[@"status"];
            _order.statusText = @"等待付款";
            [self reloadInfo];
            if (_callBack) {
                _callBack(_order.status);
            }
        }
    }];
}

// 付款
- (void)pay {
    
    if ([ZZUtils isBan]) {
        return;
    }
    [MobClick event:Event_pay_order];
    ZZPayViewController *vc = [[ZZPayViewController alloc] init];
    vc.order = _order;
    vc.type = PayTypeOrder;
    vc.didPay = ^() {
        _order.status = @"meeting";
        _order.statusText = @"见面中";
        [self reloadInfo];
        if (_callBack) {
            _callBack(_order.status);
        }
    };
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

//申请退款
- (void)wantToRefund {
    if ([ZZUtils isBan]) {
        return;
    }
    [MobClick event:Event_refund_order];
    ZZNewOrderRefundOptionsViewController *vc = [[ZZNewOrderRefundOptionsViewController alloc] init];
    vc.order = _order;
    vc.callBack = ^(NSString *status) {
        _order.status = status;
        [self reloadInfo];
        if (_callBack) {
            _callBack(_order.status);
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

// 同意退款
- (void)refundYes {
    if ([ZZUtils isBan]) {
        return;
    }
    [MobClick event:Event_refund_yes_order];
    WS(weakSelf);
    if ([self.order.reason_type intValue] == 2 ) {
        ZZARRentAlertView *alertView =   [[ZZARRentAlertView alloc]init];
        alertView.detailTitleLab.text = @"对方选择您的原因退款,同意退款租金将全部返回给对方,并扣相应信任值。";
        [UILabel changeLineSpaceForLabel:alertView.detailTitleLab WithSpace:5];
        [alertView showAlertView];
        [alertView.seeButton setTitle:@"取消" forState:UIControlStateNormal];
        alertView.sureButton.backgroundColor = RGBCOLOR(244, 203, 7);
        [alertView.sureButton setTitle:@"确认" forState:UIControlStateNormal];
        alertView.sureBlock = ^{
            [ZZHUD showWithStatus:@"正在操作..."];
            [weakSelf.order refundYes:_order.status next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                if (error) {
                    [ZZHUD showErrorWithStatus:error.message];
                } else if (data) {
                    [ZZHUD dismiss];
                    weakSelf.order.status = data[@"status"];
                    weakSelf.order.refund.amount = weakSelf.order.refund.price;
                    [weakSelf fetchOrderId:weakSelf.orderId];
                    if (weakSelf.callBack) {
                        weakSelf.callBack(weakSelf.order.status);
                    }
                    [weakSelf reduceOngoingCount];
                }
            }];
        };
    }else{
        [ZZHUD showWithStatus:@"正在操作..."];
        [weakSelf.order refundYes:_order.status next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else if (data) {
                [ZZHUD dismiss];
                weakSelf.order.status = data[@"status"];
                weakSelf.order.refund.amount = weakSelf.order.refund.price;
                [weakSelf fetchOrderId:weakSelf.orderId];
                if (weakSelf.callBack) {
                    weakSelf.callBack(weakSelf.order.status);
                }
                [weakSelf reduceOngoingCount];
            }
        }];
    }
    
}

// 拒绝退款
- (void)refundNo {
    if ([ZZUtils isBan]) {
        return;
    }
    [MobClick event:Event_refund_no_order];
    
    ZZNewOrderRefuseReasonViewController *controller = [[ZZNewOrderRefuseReasonViewController alloc] init];
    
    controller.order = _order;
    [self.navigationController pushViewController:controller animated:YES];
    WS(weakSelf);
    controller.callBack = ^(NSString *status) {
        [weakSelf fetchOrderId:weakSelf.orderId];
        if (_callBack) {
            _callBack(_order.status);
        }
    };
}

- (void)revokeRefund
{
    if ([ZZUtils isBan]) {
        return;
    }
    NSString *string = @"您撤销退意向金申请后，邀约将会继续进行，资金仍由平台监管。您只有一次撤销申请的机会，确定撤销本次退意向金申请吗？";
    if (_order.paid_at) {
        string = @"您撤销退款申请后，邀约将会继续进行，资金仍由平台监管。您只有一次撤销申请的机会，确定撤销本次退款申请吗？";
    }
    [UIAlertView showWithTitle:@"提示" message:string cancelButtonTitle:@"取消" otherButtonTitles:@[@"确认"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [ZZOrder revokeRefundOrder:_order.id status:_order.status next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                if (error) {
                    [ZZHUD showErrorWithStatus:error.message];
                } else {
                    [self fetchOrderId:_order.id];
                }
            }];
        }
    }];
}

- (void)editRefund
{
    if ([ZZUtils isBan]) {
        return;
    }
    ZZNewOrderRefundOptionsViewController *controller = [[ZZNewOrderRefundOptionsViewController alloc] init];
    controller.order = _order;
    controller.isModify = YES;
    controller.callBack = ^(NSString *status) {
        _order.status = status;
        [self reloadInfo];
        if (_callBack) {
            _callBack(_order.status);
        }
    };
    [self.navigationController pushViewController:controller animated:YES];
}

// 已见面
- (void)met {//whw
    if ([ZZUtils isBan]) {
        return;
    }
    if (_isFrom) {
        [MobClick event:Event_from_click_met_order];
        [UIAlertView showWithTitle:@"提示" message:@"邀约是否已顺利完成，确定后款项将会支付给对方" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确认"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self metRequest];
            }
        }];
    } else {
        [MobClick event:Event_to_click_met_order];
        [UIAlertView showWithTitle:@"提示" message:@"确认已到达见面地点？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确认"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self metRequest];
            }
        }];
    }
}

- (void)metRequest
{
    [ZZHUD showWithStatus:@"确认中..."];
    [_order met:[ZZUserHelper shareInstance].location status:_order.status next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else if (data) {
            [ZZHUD dismiss];
            _order.status = data[@"status"];
            _order.met = [[ZZOrderMet alloc] initWithDictionary:data[@"met"] error:nil];
            [self reloadInfo];
            if (_isFrom) {
                if (_callBack) {
                    _callBack(_order.status);
                }
                [self reduceOngoingCount];
            }
        }
    }];
}

// 电话
- (void)call {
    if ([ZZUtils isBan]) {
        return;
    }
    [MobClick event:Event_phone_order];
    
//    BOOL canPlayAudio = YES;
//    NSString *targetId = @"";
//    if (_isFrom) {
//        targetId = _order.to.uid;
//        if (![ZZUtils canPlayAudioWithVersion:_order.to.version]) {
//            canPlayAudio = NO;
//        }
//    } else {
//        targetId = _order.from.uid;
//        if (![ZZUtils canPlayAudioWithVersion:_order.from.version]) {
//            canPlayAudio = NO;
//        }
//    }
    
//    canPlayAudio = NO;
//    if (canPlayAudio) {
////        [[RCCall sharedRCCall] startSingleCall:targetId mediaType:RCCallMediaAudio];
//    } else {
        [ZZHUD showWithStatus:@"正在获取电话"];
        [_order getPhone:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else {
                [ZZHUD dismiss];
                NSString *phNo = data[@"phone"];
                NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
                [[UIApplication sharedApplication] openURL:phoneUrl];
            }
        }];
//    }
}

// 评价
- (void)comment {
    if ([ZZUtils isBan]) {
        return;
    }
    [MobClick event:Event_comment_order];
    ZZOrderCommentViewController *controller = [[ZZOrderCommentViewController alloc] init];
    controller.order = _order;
    controller.successCallBack = ^{
        _order.status = @"commented";
        [self reloadInfo];
        if (_callBack) {
            _callBack(_order.status);
        }
    };
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)reduceOngoingCount
{
    if ([ZZUserHelper shareInstance].unreadModel.order_ongoing_count > 0) {
        [ZZUserHelper shareInstance].unreadModel.order_ongoing_count--;
    }
    [[ZZTabBarViewController sharedInstance] managerAppBadge];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _timeLineView = nil;
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
