//
//  ZZLiveStreamPublishingViewController.m
//  zuwome
//
//  Created by angBiu on 2017/7/13.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZLiveStreamPublishingViewController.h"
#import "ZZRentViewController.h"
#import "ZZLiveStreamConnectViewController.h"

#import "ZZPublishOrderChooseCell.h"
#import "ZZliveStreamConnectingView.h"
#import "ZZLiveStreamEndAlert.h"
#import "ZZLiveStreamCancelAlert.h"

#import "UITableViewCell+CellAdd.h"
#import "ZZPublishListModel.h"
#import <RongIMLib/RongIMLib.h>
#import "ZZLiveStreamHelper.h"

#import "ZZDateHelper.h"
#import "ZZliveStreamConnectingController.h"
#import "ZZChatCallIphoneManagerNetWork.h"
#import "ZZMeBiViewController.h"

@interface ZZLiveStreamPublishingViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray<ZZPublishListModel *> *dataArray;
@property (nonatomic, strong) NSMutableArray *deleteArray;
@property (nonatomic, strong) ZZRentViewController *rentCtl;
@property (nonatomic, strong) ZZPublishListModel *model;

@property (nonatomic, strong) ZZliveStreamConnectingView *connectingView;
@property (nonatomic, strong) ZZLiveStreamCancelAlert *cancelAlert;
@property (nonatomic, strong) ZZLiveStreamEndAlert *endView;
@property (nonatomic, strong) ZZliveStreamConnectingController *connectingVC;

@property (nonatomic, strong) NSTimer *timer;   // 刷新达人状态计时器
@property (nonatomic, strong) NSTimer *countdown;//倒计时 计时器
//@property (nonatomic, assign) NSInteger during;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger totalDuring;
@property (nonatomic, strong) UILabel *timeLabel;   // 倒计时Label
@property (nonatomic, strong) UILabel *endTipsLable;// 结束文案Lable
@property (nonatomic, strong) UIView *tipView;
@property (nonatomic, strong) UIImageView *animateImgView;

@property (nonatomic, assign) BOOL connecting;//连线中
@property (nonatomic, assign) BOOL receive;     //有无达人抢单
@property (nonatomic, assign) BOOL viewDidAppear;
@property (nonatomic, assign) BOOL showInfo;
//@property (nonatomic, assign) BOOL timeOut;
@property (nonatomic, assign) BOOL noPenalty;//因为对方10秒未接或挂断，不算发单人次数

@end

/**
 *  2018.7.25 - lql
 *  移除BOOL timeOut 标记，原因：timeout默认为no，(!timeout)用于定时器中判否条件之一，且在条件成立后，置为YES，并移除定时器，并不会成为下次循环的判段条件
 *  移除NSInteger during ，原因：查找during的用途，只在定时器中累加，移除定时器和接受超过5个达人时清空,未有其他实际用途
 *  疑问：为什么_timer定时器要以0.1秒为周期循环执行，需要达到毫秒级吗
 */

@implementation ZZLiveStreamPublishingViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [ZZUserHelper shareInstance].isJumpPublish = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    _viewDidAppear = YES;
//    if (_timeOut) {               //梳理逻辑后，认为不需要在此处加超时判断，否则会出现无数据时多次弹窗的问题，超时状态会在计时器结束时改变。
//        [self showAlert];
//    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_connectingView) {
        [_connectingView removeFromSuperview];
    }
    if (_endView) {
        [_endView removeFromSuperview];
    }
    if (_cancelAlert) {
        [_cancelAlert removeFromSuperview];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    _viewDidAppear = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"选择达人";
    
    [self createViews];
    [self createTimer];
    [self loadData];
}

- (void)createViews {
    self.bgImgView.image = [UIImage imageNamed:@"icon_livestream_connect_bg"];
    self.tableView.hidden = NO;
    [self createLeftBtn];
}

- (void)createLeftBtn {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 60,44)];
    btn.contentEdgeInsets =UIEdgeInsetsMake(0, -20,0, 0);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -15,0, 0);
    [ btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItems =@[leftItem];
}

#pragma mark - timer
- (void)createTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(resetTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
    _countdown = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countdownUpdate) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_countdown forMode:NSRunLoopCommonModes];
}

- (void)resetTime {
//    _during++;
    _totalDuring++;
    for (ZZPublishListModel *model in self.dataArray) {
        if (model.pd_graber.remain_time_sponsor != 0) {
            if (model.pd_graber.remain_time_sponsor > 100) {
                model.pd_graber.remain_time_sponsor = model.pd_graber.remain_time_sponsor - 100;
            } else {
                model.pd_graber.remain_time_sponsor = 0;
                if (_model == model) {
                    _rentCtl.canConnect = NO;
                }
            }
        }
    }
    //通知达人cell更新时间信息
    [[NSNotificationCenter defaultCenter] postNotificationName:PublishOrderChooseNotification object:nil];
    if (_totalDuring >= _timeoutCount * 60 * 10) {
        //TODO 此处刷新逻辑待研究
        if (!_showInfo) {
            _showInfo = YES;
            [self.tableView reloadData];
        }
        //无可选达人时，弹出提示，并移除定时器
        if (!_receive) {
            [self clearTimer];
            [self showAlert];
        }
        //判断所有达人选择时间是否超时，是则弹出超时提示，移除定时器_timer
        [self isAllTimeOut];
    }
}

- (void)isAllTimeOut {
    BOOL isTimeOut = YES;
    for (ZZPublishListModel *model in self.dataArray) {
        if (model.pd_graber.remain_time_sponsor != 0) {
            isTimeOut = NO;
            break;
        }
    }
    if (isTimeOut) {
        [self clearTimer];
        [self showAlert];
    }
}

- (void)clearTimer {
//    _during = 0;
    [_timer invalidate];
    _timer = nil;
}

- (void)clearCountdownTimer {
    [_countdown invalidate];
    _countdown = nil;
}

- (void)showAlert {
    if (_viewDidAppear) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!_receive) {
                self.endView.type = 2;
                [self.view.window addSubview:self.endView];
            } else if (!_connectingView) {
                self.endView.type = 4;
                [self.view.window addSubview:self.endView];
            }
        });
    }
}

#pragma mark - data
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveAcceptOrder:) name:kMsg_SnatchPublishOrder object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(snatcherBeSnatechByOther:) name:kMsg_UpdatePublishingList object:nil];
}

- (void)receiveAcceptOrder:(NSNotification *)notification {
    WEAK_SELF();
    _receive = YES;
    NSDictionary *aDict = [notification.userInfo objectForKey:@"pd_graber"];
    ZZPublishListModel *listModel = [[ZZPublishListModel alloc] init];
    ZZPublishModel *model = [[ZZPublishModel alloc] initWithDictionary:aDict error:nil];
    listModel.pd_graber = model;
    listModel.distance = [notification.userInfo objectForKey:@"distance"];
    
//    if (![self.pId isEqualToString:model.pd.id]) {
//        //去重处理，抢单的人的订单id 如果不和当前id一致，则忽略
//        return;
//    }
    NSLog(@"通知获取到的toId: %@   fromId: %@ ",listModel.pd_graber.user.uid, listModel.pd_graber.pd.from.uid);
    // 列表已存在某个人 则不处理
    __block BOOL isHas = NO;
    [self.dataArray enumerateObjectsUsingBlock:^(ZZPublishListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([listModel.pd_graber.user.uid isEqualToString:obj.pd_graber.user.uid]) {
            isHas = YES;
        }
    }];
    if (isHas) {
        return ;
    }
    
    if (model.pd.type == 2 && [model.pd.id isEqualToString:_pId]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 如果已经有5个了，则不再插入
            if (self.dataArray.count >= 5) {
//                _during = 0;
                _showInfo = YES;
                [self showEndFullTips];
                [self.tableView reloadData];
                return ;
            }
            [self.dataArray insertObject:listModel atIndex:0];
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
            _count++;
            
            [weakSelf addTipsView];
            [weakSelf updateSelectCell];
        });
    }
}

//抢单的女方已跟其他连麦了
- (void)snatcherBeSnatechByOther:(NSNotification *)notification {
    ZZSnatchModel *model = [[ZZSnatchModel alloc] initWithDictionary:notification.userInfo error:nil];
    for (ZZPublishListModel *aModel in self.dataArray) {
        if ([aModel.pd_graber.id isEqualToString:model.id]) {
            aModel.pd_graber.remain_time_sponsor = 1;
            break;
        }
    }
}

#pragma mark - data
- (void)loadData {
    WEAK_SELF();
    NSLog(@"获取之前时间 --- %@", [NSDate new]);
    [ZZPublishModel getPublishGraberList:nil pId:_pId next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            NSLog(@"获取之后时间 --- %@", [NSDate new]);
            NSMutableArray<ZZPublishListModel *> *array = [ZZPublishListModel arrayOfModelsFromDictionaries:data error:nil];
            if (array.count == 0) {
                _receive = NO;          //逻辑错误，无数据时，应设置为no
                [self isAllTimeOut];    //原设置_timeOut = YES会造成无数据时弹出两次弹框（选择时间已到和暂无达人）
//                _timeOut = YES;
//                self.endView.type = 4;
//                [self.view.window addSubview:self.endView];
            } else {
                self.dataArray = [NSMutableArray new];
                [self.dataArray addObjectsFromArray:array];
                [self.tableView reloadData];
                [weakSelf addTipsView];
                if (self.dataArray.count != 0) {
                    _receive = YES;
                }
            }
        }
        [self addNotification];
    }];
}

// 删除所有CELL长按显示的View
- (void)removeCellAllLongPressView {
    NSArray<NSIndexPath *> *indexPaths = self.tableView.indexPathsForVisibleRows;
    WEAK_SELF();
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZZPublishOrderChooseCell *cell = [weakSelf.tableView cellForRowAtIndexPath:obj];
        [cell removeView];
    }];
}

- (void)updateSelectCell {
    if (self.tipView) {
        [self removeCellAllLongPressView];
        // 默认背景
        NSArray<NSIndexPath *> *indexPaths = self.tableView.indexPathsForVisibleRows;
        WEAK_SELF();
        [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == 1) {
                ZZPublishOrderChooseCell *cell = [weakSelf.tableView cellForRowAtIndexPath:obj];
                [cell longPressShowView];
            }
        }];
    }
}

// 当第一次安装App时，选择达人列表第一次达到2人时，给予的提示
- (void)addTipsView {
    if ([ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].firstShanZuTipView]) { // 已经提示过则不再提示
        return;
    }
    if (self.dataArray.count < 2) { // 列表的人数没有达人2人，也不提示
        return;
    }
    [ZZKeyValueStore saveValue:@"1" key:[ZZStoreKey sharedInstance].firstShanZuTipView];
    if (!self.tipView) {
        [NSObject asyncWaitingWithTime:1.0f completeBlock:^{
            [self addView];
        }];
    }
}

- (void)addView {
    self.tipView = [UIView new];
    _tipView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    _tipView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [self.view addSubview:self.tipView];
    [self.view bringSubviewToFront:self.tipView];
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 4.0f;
    [self.tipView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@178);
        make.centerX.equalTo(self.tipView);
        make.width.equalTo(@210);
        make.height.equalTo(@90);
    }];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"试试长按屏蔽";
    titleLabel.textColor = RGBCOLOR(244, 203, 7);
    titleLabel.font = [UIFont systemFontOfSize:15];
    
    [bgView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.centerX.equalTo(bgView);
    }];
    
    self.animateImgView = [[UIImageView alloc] init];
    _animateImgView.image = [UIImage imageNamed:@"icon_oval7"];
    _animateImgView.alpha = 1;
    _animateImgView.layer.cornerRadius = 5 / 2.0f;
    _animateImgView.clipsToBounds = YES;
    [bgView addSubview:_animateImgView];
    
    [self.animateImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.leading.equalTo(titleLabel.mas_trailing).offset(10);
        make.width.height.equalTo(@5);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"icon_oval7"];
    imageView.alpha = 1;
    imageView.layer.cornerRadius = 5 / 2.0f;
    imageView.clipsToBounds = YES;
    [bgView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.leading.equalTo(titleLabel.mas_trailing).offset(10);
        make.width.height.equalTo(@5);
    }];

    UILabel *tipLabel = [UILabel new];
    tipLabel.text = @"不再将您的任务推荐给TA";
    tipLabel.font = [UIFont systemFontOfSize:15];
    tipLabel.textColor = kBlackColor;
    [bgView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(bgView);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"知道了" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitleColor:RGBCOLOR(74, 144, 226) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(removeTipViewClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@(-10));
        make.bottom.equalTo(@(-10));
        make.width.equalTo(@60);
        make.height.equalTo(@21);
    }];
    
    // 雷达动效
    [self beginAnimation];
    
    // 默认背景
    NSArray<NSIndexPath *> *indexPaths = self.tableView.indexPathsForVisibleRows;
    WEAK_SELF();
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 1) {
            ZZPublishOrderChooseCell *cell = [weakSelf.tableView cellForRowAtIndexPath:obj];
            [cell longPressShowView];
        }
    }];
}

- (IBAction)removeTipViewClick:(id)sender {
    [self.tipView removeAllSubviews];
    [self.tipView removeFromSuperview];
    self.tipView = nil;
    
    [self removeCellAllLongPressView];
}

- (void)beginAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:3.0]; // 结束时的倍率
    animation.removedOnCompletion = NO;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:1];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 1.5;
    group.removedOnCompletion = NO;
    group.repeatCount = HUGE_VALF;
    group.animations = @[animation,opacityAnimation];
    
    [self.animateImgView.layer addAnimation:group forKey:@"group"];
}

#pragma mark - UITabelViewMethod
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"mycell";
    ZZPublishOrderChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ZZPublishOrderChooseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setData:self.dataArray[indexPath.row]];
    
    WeakSelf;
    __weak typeof(cell)weakCell = cell;
    cell.touchHead = ^{
        [weakSelf removeCellAllLongPressView];
        [weakSelf touchHead:weakCell];
    };
    cell.touchConnect = ^{
        [weakSelf connect:weakCell];
    };
    cell.touchCancel = ^{
        [weakSelf deleteSnatcher:weakCell];
    };
    [cell setLongPressGestureRecognizerBlock:^{
        [weakSelf removeCellAllLongPressView];
        [weakCell longPressShowView];
    }];
    [cell setClickRemoveViewBlock:^{
        [weakCell removeView];
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 117;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell tableView:tableView forRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    headView.backgroundColor = [UIColor clearColor];
    
    [headView addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.equalTo(@0);
        make.width.equalTo(@(SCREEN_WIDTH));
    }];
    [self addCountdownTips];
    [self addEndTip];
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

// 每秒执行
- (void)countdownUpdate {
    if (self.remainingTime == 0) {
        [self clearCountdownTimer];
        [self showEndTimeTips];
    } else {
        self.remainingTime -= 1;
        [self updateTimeTips];
    }
}

// 显示结束文案 (时间结束)
- (void)showEndTimeTips {
    if (self.dataArray.count >= 5) {
        [self showEndFullTips];
        return;
    }
    self.endTipsLable.text = @"报名已截止，所有倒计时结束前若不做选择将视为取消";
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    } completion:^(BOOL finished) {
    }];
}

// 显示结束文案 (人满)
- (void)showEndFullTips {
//    [self clearTimer];
    [self clearCountdownTimer];
    self.endTipsLable.text = @"报名人数已满，所有倒计时结束前若不做选择将视为取消";
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    } completion:^(BOOL finished) {
    }];
}

- (void)updateTimeTips {
    NSString *timeString = [ZZDateHelper getCountdownTimeString:self.remainingTime];
    NSString *tips = @" 后报名结束，您可以现在进行选择，也可以在报名结束后开始选择达人";
    NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", timeString, tips]];
    
    //获取要调整颜色的文字位置,调整颜色
    NSRange range1 = [[hintString string] rangeOfString:timeString];
    [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range1];
    
    NSRange range2 = [[hintString string] rangeOfString:tips];
    [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:range2];
    self.timeLabel.attributedText = hintString;
}

// 添加倒计时文案
- (void)addCountdownTips {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    
    [view addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@15);
        make.top.equalTo(@0);
        make.trailing.equalTo(@(-15));
        make.bottom.equalTo(@(0));
    }];
    
    [self updateTimeTips];
    [self.scrollView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(@0);
        make.height.equalTo(@50);
        make.width.equalTo(@(SCREEN_WIDTH));
    }];
}

// 添加结束标语文案
- (void)addEndTip {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    
    [view addSubview:self.endTipsLable];
    [self.endTipsLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@15);
        make.top.equalTo(@0);
        make.trailing.equalTo(@(-15));
        make.bottom.equalTo(@(0));
    }];
    
    [self.scrollView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(@(SCREEN_WIDTH));
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@50);
    }];
}

#pragma mark - UIButtonMethod
- (void)leftBtnClick {
    if (self.noPenalty) {// 对方10秒内为接或被对方挂断，则不弹窗
        [self popView];
        [self cancelRequest];
        return ;
    }
    
    __block BOOL isShow = NO;
    WeakSelf
    [self.dataArray enumerateObjectsUsingBlock:^(ZZPublishListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.pd_graber.remain_time_sponsor != 0) {
            isShow = YES;
            [weakSelf.view.window addSubview:self.cancelAlert];
            return ;
        }
    }];
    if (isShow) {
        return;
    }
    // 当前没有可选达人直接返回
    [self popView];
    [self cancelRequest];
}

- (void)touchHead:(UITableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    _model = self.dataArray[indexPath.row];
    _rentCtl = [[ZZRentViewController alloc] init];
    _rentCtl.uid = _model.pd_graber.user.uid;
    _rentCtl.user = _model.pd_graber.user;
    _rentCtl.isFromLive = YES;
    _rentCtl.publishId = _model.pd_graber.id;
    _rentCtl.canConnect = _model.pd_graber.remain_time_sponsor == 0 ?NO:YES;
    [self.navigationController pushViewController:_rentCtl animated:YES];
}

- (void)deleteSnatcher:(UITableViewCell *)cell {
    [self deleteRequest:cell];
}

- (void)deleteRequest:(UITableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ZZPublishListModel *model = self.dataArray[indexPath.row];
    if ([self.deleteArray containsObject:model]) {
        return;
    }
    [self.deleteArray addObject:model];
    [ZZPublishModel hideSnatchUser:model.pd_graber.user.uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [self.deleteArray removeObject:model];
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [ZZHUD showSuccessWithStatus:@"屏蔽成功"];
            if ([self.dataArray containsObject:model]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.dataArray indexOfObject:model] inSection:0];
                [self.dataArray removeObject:model];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            }
        }
    }];
}

- (void)connect:(ZZPublishOrderChooseCell *)cell {
    if (_connecting) {
        return;
    }
    WEAK_SELF();
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ZZPublishListModel *model = self.dataArray[indexPath.row];
    if (model.pd_graber.remain_time_sponsor == 0) {
        [ZZHUD showErrorWithStatus:@"对方已在任务中，下次选TA一定要快！"];
    } else {
        // 先更新下最新的余额
        [ZZHUD show];
        [ZZUserHelper requestMeBiAndMoneynext:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            [weakSelf nextStep:cell];
        }];
    }
}

- (void)nextStep:(ZZPublishOrderChooseCell *)cell {
    WeakSelf;
    [[ZZLiveStreamHelper sharedInstance] checkAuthority:^(BOOL authorized) {
        if (authorized) {
            [weakSelf getRoomToken:cell];
        }
    }];
}

- (void)getRoomToken:(ZZPublishOrderChooseCell *)cell {
    if ([ZZLiveStreamHelper sharedInstance].isBusy) {
        return;
    }
    if ([[ZZUserHelper shareInstance].loginer.mcoin integerValue] < [ZZUserHelper shareInstance].configModel.priceConfig.one_card_to_mcoin.integerValue * [ZZUserHelper shareInstance].configModel.priceConfig.per_unit_cost_card.integerValue) {
        WeakSelf
        [UIAlertController presentAlertControllerWithTitle:kMsg_Mebi_NO message:nil doneTitle:@"充值" cancelTitle:@"取消" completeBlock:^(BOOL isCancelled) {
            if (!isCancelled) {
                [MobClick event:Event_click_OneToOneChat_TopUp];
                ZZMeBiViewController *vc = [ZZMeBiViewController new];
                [vc setPaySuccess:^(ZZUser *paySuccesUser) {
                    __strong typeof(weakSelf)strongSelf =weakSelf;
                    NSMutableArray<ZZViewController *> *vcs = [strongSelf.navigationController.viewControllers mutableCopy];
                    [vcs removeLastObject];
                    [strongSelf.navigationController setViewControllers:vcs animated:NO];
                    [strongSelf startToVideoDialingCell:cell];
                }];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
        return;
    }
     NSLog(@"PY_当前发单后的充值");
        [self startToVideoDialingCell:cell];
}

/**
 开始拨打视频
 */
- (void)startToVideoDialingCell:(ZZPublishOrderChooseCell *)cell {
    WEAK_SELF();
    _connecting = YES;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ZZPublishListModel *model = self.dataArray[indexPath.row];
    CGRect rect = [cell.imgView.superview convertRect:cell.imgView.frame toView:self.view.window];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _connectingVC = [ZZliveStreamConnectingController new];
        _connectingVC.user = model.pd_graber.user;
        _connectingVC.showCancel = YES;
        _connectingVC.sourceRect = rect;
        //            WEAK_OBJECT(_uid, weakUid);
        [_connectingVC setConnectVideoStar:^(id data) {
            // 先进入视频页面
            [weakSelf gotoConnectView:model.pd_graber.user.uid data:data];
        }];
        [_connectingVC setNoPenaltyBlock:^(BOOL is) {
            _noPenalty = is;
            [weakSelf noPunish];
        }];
        [weakSelf.navigationController pushViewController:_connectingVC animated:NO];
        [_connectingVC show];
    });
    
    NSString *uid = model.pd_graber.user.uid;
    NSDictionary *param = @{@"uid":uid,@"pdreceive_id":model.pd_graber.id,@"by_mcoin":@(YES)};
    
    [ZZChatCallIphoneManagerNetWork  callIphone:AcceptOrder_callIphoneStyle roomid:nil uid:nil paramDic:param next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        _connecting = NO;
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
            // 当已被对方拉黑 和 已被封禁，则自动返回
            if (error.code == CODE_SHIELDING || error.code == CODE_BANNED) {
                _connectingVC.view.userInteractionEnabled = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [NSObject asyncWaitingWithTime:1.5 completeBlock:^{
                        [_connectingVC.navigationController popViewControllerAnimated:YES];
                    }];
                });
            }
        } else {
            if (![ZZLiveStreamHelper sharedInstance].isBusy) {
                _connectingVC.data = data;
            }
        }
    }];
}

- (void)gotoConnectView:(NSString *)uid data:(id)data {
    WEAK_SELF();
    dispatch_async(dispatch_get_main_queue(), ^{
        //        [_connectingView remove];
        NSMutableArray<ZZViewController *> *vcs = [self.navigationController.viewControllers mutableCopy];
        [vcs removeLastObject];
        
        ZZLiveStreamConnectViewController *controller = [[ZZLiveStreamConnectViewController alloc] init];
        controller.uid = uid;
        controller.isDisableVideo = _connectingVC.stickerBtn.isSelected;
        [vcs addObject:controller];
        [weakSelf.navigationController setViewControllers:vcs animated:YES];
        
        // 再进行视频连接
        ZZLiveStreamHelper *helper = [ZZLiveStreamHelper sharedInstance];
        helper.isUseMcoin = YES;
        helper.targetId = uid;
        helper.data = data;
        [helper connect:^{
        }];
        helper.failureConnect = ^{
            [controller.navigationController popViewControllerAnimated:YES];
        };
    });
}

// 告知服务端，本次不算发单人次数
- (void)noPunish {
    [ZZPublishModel noCounting:_pId next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
    }];
}

- (void)gotoConnectView:(NSString *)uid {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_connectingView remove];
        [self clearTimer];
        ZZLiveStreamConnectViewController *controller = [[ZZLiveStreamConnectViewController alloc] init];
        controller.uid = uid;
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:NO];
    });
}

- (void)cancelRequest {
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/pd/%@/cancel",_pId] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [self popView];
        }
    }];
}

- (void)popView {
    [self clearTimer];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - lazyload
- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:_bgImgView];
        
        [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }
    return _bgImgView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }
    return _tableView;
}

- (ZZLiveStreamCancelAlert *)cancelAlert {
    WeakSelf;
    if (!_cancelAlert) {
        _cancelAlert = [[ZZLiveStreamCancelAlert alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _cancelAlert.touchCancel = ^{
            [weakSelf cancelRequest];
        };
    }
    return _cancelAlert;
}

- (ZZLiveStreamEndAlert *)endView {
    WeakSelf;
    if (!_endView) {
        _endView = [[ZZLiveStreamEndAlert alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _endView.touchSure = ^{
            [weakSelf popView];
        };
    }
    return _endView;
}

- (NSMutableArray<ZZPublishListModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)deleteArray {
    if (!_deleteArray) {
        _deleteArray = [NSMutableArray array];
    }
    return _deleteArray;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2.0, 0);
    }
    return _scrollView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor redColor];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.numberOfLines = 2;
        _timeLabel.text = @"00: 00";
    }
    return _timeLabel;
}

- (UILabel *)endTipsLable {
    if (!_endTipsLable) {
        _endTipsLable = [UILabel new];
        _endTipsLable.textColor = [UIColor whiteColor];
        _endTipsLable.font = [UIFont systemFontOfSize:13];
        _endTipsLable.numberOfLines = 2;
    }
    return _endTipsLable;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
