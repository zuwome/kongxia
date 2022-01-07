//
//  ZZTaskSnatchListViewController.m
//  zuwome
//
//  Created by angBiu on 2017/8/7.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZTaskSnatchListViewController.h"
#import "ZZRentViewController.h"
#import "ZZPayViewController.h"
#import "ZZChatViewController.h"
#import "ZZLinkWebViewController.h"

#import "ZZTaskSnatchListCell.h"
#import "ZZliveStreamConnectingView.h"
#import "ZZLiveStreamEndAlert.h"
#import "ZZLiveStreamCancelAlert.h"
#import "ZZTaskSnatchListBottomView.h"
#import "ZZTaskPayAlert.h"

#import "UITableViewCell+CellAdd.h"
#import "ZZPublishListModel.h"
#import <RongIMLib/RongIMLib.h>
#import "ZZLiveStreamHelper.h"
#import "ZZDateHelper.h"

@interface ZZTaskSnatchListViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<ZZPublishListModel *> *dataArray;
@property (nonatomic, strong) NSMutableArray *deleteArray;
@property (nonatomic, strong) NSMutableArray *seleteArray;

@property (nonatomic, strong) NSMutableArray *removeArray;
@property (nonatomic, strong) NSMutableArray *addArray;
@property (nonatomic, assign) BOOL isUpdatingData;

@property (nonatomic, strong) ZZRentViewController *rentCtl;
@property (nonatomic, strong) ZZPublishListModel *model;
@property (nonatomic, strong) ZZPayViewController *payCtl;

@property (nonatomic, strong) ZZliveStreamConnectingView *connectingView;
@property (nonatomic, strong) ZZLiveStreamCancelAlert *cancelAlert;
@property (nonatomic, strong) ZZLiveStreamEndAlert *endView;
@property (nonatomic, strong) ZZTaskSnatchListBottomView *bottomView;
@property (nonatomic, strong) ZZTaskPayAlert *payAlert;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *countdown;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger during;
@property (nonatomic, strong) NSDate *pushDate;//进入这个页面的时刻，为了程序从后台返回去前台时，刷新倒计时，因为 NSTimer在后台会被挂起
@property (nonatomic, strong) UIView *tipView;
@property (nonatomic, strong) UIImageView *animateImgView;

@property (nonatomic, assign) BOOL receive;
@property (nonatomic, assign) BOOL viewDidAppear;
@property (nonatomic, assign) BOOL timeOut;

@end

@implementation ZZTaskSnatchListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    _viewDidAppear = YES;
    if (_timeOut) {
        [self showAlert];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
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
    if (_payAlert) {
        [_payAlert removeFromSuperview];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
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
    self.pushDate = [NSDate new];
    //增加监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateRemainingTime)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [self createViews];
    [self createTimer];
    [self loadData];
    [self createFirstAlert];
}

- (void)createViews {
    self.bgImgView.image = [UIImage imageNamed:@"icon_livestream_connect_bg"];
    self.tableView.hidden = NO;
    self.bottomView.hidden = NO;
    
    [self createLeftBtn];
}

- (void)createLeftBtn
{
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

- (void)createFirstAlert
{
    if (![ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].firstTaskSnatchListAlert]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.view.window addSubview:self.payAlert];
            self.payAlert.type = 1;
            [ZZKeyValueStore saveValue:@"firstTaskSnatchListAlert" key:[ZZStoreKey sharedInstance].firstTaskSnatchListAlert];
        });
    }
}

#pragma mark - timer

- (void)createTimer {
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(resetTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
//    _countdown = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimeTips) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:_countdown forMode:NSRunLoopCommonModes];
}

- (void)updateTimeTips {
    [self updateTimeText];
}

- (void)updateRemainingTime {
    
    if (_totalDuring <= 0) {
        return;
    }
    NSTimeInterval delta = [[NSDate new] timeIntervalSinceDate:self.pushDate]; // 计算出相差多少秒
    
    _totalDuring = (600 - delta) * 10;//剩余时间
}

- (void)resetTime
{
    _during++;
    if (_totalDuring > 0) {
        _totalDuring--;
        [self updateTimeText];
    }
    if (_payCtl) {
        _payCtl.count = _totalDuring;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:SnatcherListNotification object:nil userInfo:@{@"during":[NSNumber numberWithInteger:_during]}];
    
    if (_totalDuring <= 0) {
        [self clearTimer];
        _timeOut = YES;
        [self showAlert];
        if (_rentCtl) {
            _rentCtl.chooseType = 3;
        }
    }
}

- (void)clearTimer
{
    [_timer invalidate];
    _timer = nil;
    
    [_countdown invalidate];
    _countdown = nil;
}

- (void)showAlert
{
    if (_viewDidAppear) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!_receive) {
                self.endView.type = 2;
                [self.view.window addSubview:self.endView];
            } else if (!_connectingView) {
                self.endView.type = 5;
                [self.view.window addSubview:self.endView];
                if (_count == 1) {
                    self.endView.contentLabel.text = [NSString stringWithFormat:@"您未在%ld分钟内选择达人，当前任务自动取消，请重新发布任务",_validate_count];
                } else {
                    self.endView.contentLabel.text = [NSString stringWithFormat:@"您未在%ld分钟内支付任务金，当前任务已被自动取消，请重新发布任务",_validate_count];
                }
            }
        });
    }
}

#pragma mark - data

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveAcceptOrder:) name:kMsg_SnatchPublishOrder object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(snatcherBeSnatechByOther:) name:kMsg_UpdatePublishingList object:nil];
}

- (void)receiveAcceptOrder:(NSNotification *)notification
{
    _receive = YES;
    NSDictionary *aDict = [notification.userInfo objectForKey:@"pd_graber"];
    ZZPublishListModel *listModel = [[ZZPublishListModel alloc] init];
    ZZPublishModel *model = [[ZZPublishModel alloc] initWithDictionary:aDict error:nil];
    WEAK_SELF();
    // 列表已存在某个人 则不处理
    __block BOOL isHas = NO;
    [self.dataArray enumerateObjectsUsingBlock:^(ZZPublishListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model.pd.from.uid isEqualToString:obj.pd_graber.pd.from.uid]) {
            isHas = YES;
        }
    }];
    if (isHas) {
        return;
    }

    BOOL contain = NO;
    for (ZZPublishListModel *aModel in self.dataArray) {
        if ([aModel.pd_graber.id isEqualToString:model.id]) {
            contain = YES;
            break;
        }
    }
    if (!contain) {
        listModel.pd_graber = model;
        listModel.distance = [notification.userInfo objectForKey:@"distance"];
        if (model.pd.type == 3 && [model.pd.id isEqualToString:_snatchModel.id]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self addData:listModel];
                if (_count == 0) {
                    [self updateTimeText];
                    [self.tableView reloadData];
                    
                    [weakSelf addTipsView];
                }
                _count++;
            });
        }
    }
}
//抢单的女方在那段时间已被被人下单了
- (void)snatcherBeSnatechByOther:(NSNotification *)notification
{
    ZZSnatchModel *model = [[ZZSnatchModel alloc] initWithDictionary:notification.userInfo error:nil];
    for (ZZPublishListModel *aModel in self.dataArray) {
        if ([aModel.pd_graber.id isEqualToString:model.id]) {
            [self deleteData:aModel];
            if (_rentCtl && [_rentCtl.uid isEqualToString:aModel.pd_graber.user.uid]) {
                _rentCtl.chooseType = 3;
            }
            break;
        }
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
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 4.0f;
    [self.tipView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@160);
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
            ZZTaskSnatchListCell *cell = [weakSelf.tableView cellForRowAtIndexPath:obj];
            [cell longPressShowView];
        }
    }];
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

- (IBAction)removeTipViewClick:(id)sender {
    [self.tipView removeAllSubviews];
    [self.tipView removeFromSuperview];
    self.tipView = nil;
    
    [self removeCellAllLongPressView];
}

#pragma mark - data

- (void)loadData
{
    [ZZPublishModel getPublishGraberList:nil pId:_snatchModel.id next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            NSMutableArray *array = [ZZPublishListModel arrayOfModelsFromDictionaries:data error:nil];
            _count = array.count;
            [self updateTimeText];
            if (array.count == 0) {
                _receive = YES;
                _timeOut = YES;
                self.endView.type = 5;
                [self.view.window addSubview:self.endView];
            } else {
                [self.dataArray addObjectsFromArray:array];
                [self.tableView reloadData];
                
                [self addTipsView];
                if (self.dataArray.count != 0) {
                    _receive = YES;
                }
            }
        }
        [self addNotification];
    }];
}

- (void)updateTimeText
{
    
    NSString *timeString = [ZZDateHelper getCountdownTimeString:_totalDuring/10];
    
    NSLog(@"%@", timeString);
    NSString *sumString = @"";
    if (_count == 5) {
        sumString = [NSString stringWithFormat:@"报名人数已满，请在%@时间内选择达人",timeString];
    } else {
        sumString = [NSString stringWithFormat:@"报名人数%ld人，请在%@时间内选择达人",_count,timeString];
    }
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:sumString];
    [attributeString addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0xfc2f52) range:[sumString rangeOfString:timeString]];
    self.timeLabel.attributedText = attributeString;
}

// 删除所有CELL长按显示的View
- (void)removeCellAllLongPressView {
    NSArray<NSIndexPath *> *indexPaths = self.tableView.indexPathsForVisibleRows;
    WEAK_SELF();
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZZTaskSnatchListCell *cell = [weakSelf.tableView cellForRowAtIndexPath:obj];
        [cell removeView];
    }];
}

#pragma mark - UITabelViewMethod

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"mycell";
    
    ZZTaskSnatchListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[ZZTaskSnatchListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell setData:self.dataArray[indexPath.row] during:_during];
    
    WeakSelf;
    __weak typeof(cell)weakCell = cell;
    cell.touchHead = ^{
        [weakSelf removeCellAllLongPressView];
        [weakSelf touchHead:weakCell];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 117;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell tableView:tableView forRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_count != 0) {
        CGFloat height = [ZZUtils heightForCellWithText:self.timeLabel.text fontSize:13 labelWidth:SCREEN_WIDTH - 30] + 16;
        return height;
    } else {
        return 15;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_count != 0) {
        CGFloat height = [ZZUtils heightForCellWithText:self.timeLabel.text fontSize:13 labelWidth:SCREEN_WIDTH - 30] + 16;
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
        
        [headView addSubview:self.timeLabel];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(headView.mas_top).offset(8);
            make.left.mas_equalTo(headView.mas_left).offset(15);
            make.right.mas_equalTo(headView.mas_right).offset(-15);
        }];
        
        return headView;
    } else {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZPublishListModel *model = self.dataArray[indexPath.row];
    if (model.pd_graber.remain_time_sponsor > 0) {
        if ([self.seleteArray containsObject:model]) {
            model.pd_graber.selected = NO;
            [self.seleteArray removeObject:model];
        } else {
            model.pd_graber.selected = YES;
            [self.seleteArray addObject:model];
        }
        self.bottomView.dataArray = self.seleteArray;
    } else {
        [ZZHUD showErrorWithStatus:@"对方的档期已满，下次选TA要快哦"];
    }
}

#pragma mark - 数据插入删除操作

- (void)addData:(ZZPublishListModel *)model
{
    if (_isUpdatingData) {
        [self.addArray addObject:model];
    } else {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:model];
        [self insertCells:array];
    }
}

- (void)insertCells:(NSMutableArray *)array
{
    NSMutableArray *indexPaths = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(ZZPublishListModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.dataArray insertObject:model atIndex:0];
        BOOL contain = NO;
        if ([self.addArray containsObject:model]) {
            [self.addArray removeObject:model];
            contain = YES;
        }
        if (contain) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.addArray.count - 1 - idx) inSection:0];
            [indexPaths addObject:indexPath];
        } else {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [indexPaths addObject:indexPath];
        }
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [CATransaction begin];
        [CATransaction setCompletionBlock: ^{
            [self animationComplete];
        }];
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationRight];
        [CATransaction commit];
    });
}

- (void)deleteData:(ZZPublishListModel *)model
{
    if (_isUpdatingData) {
        [self.deleteArray addObject:model];
    } else {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:model];
        [self deleteCells:array];
    }
}

- (void)deleteCells:(NSMutableArray *)array
{
    NSMutableArray *indexPaths = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(ZZPublishListModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.removeArray insertObject:model atIndex:0];
        if ([self.removeArray containsObject:model]) {
            [self.removeArray removeObject:model];
        }
        if ([self.dataArray containsObject:model]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.dataArray indexOfObject:model] inSection:0];
            [indexPaths addObject:indexPath];
        }
    }];
    [self.dataArray removeObjectsInArray:array];
    [self.seleteArray removeObjectsInArray:array];
    self.bottomView.dataArray = self.seleteArray;
    dispatch_async(dispatch_get_main_queue(), ^{
        [CATransaction begin];
        [CATransaction setCompletionBlock: ^{
            [self animationComplete];
        }];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        [CATransaction commit];
    });
}

- (void)animationComplete
{
    self.isUpdatingData = NO;
    if (self.addArray.count) {
        self.isUpdatingData = YES;
        [self insertCells:self.addArray];
    } else if (self.removeArray.count) {
        self.isUpdatingData = YES;
        [self deleteCells:self.removeArray];
    }
    [self updateTimeText];
}

#pragma mark - UIButtonMethod

- (void)leftBtnClick
{
    [self.view.window addSubview:self.cancelAlert];
}

- (void)touchHead:(UITableViewCell *)cell
{
    WeakSelf;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    _model = self.dataArray[indexPath.row];
    _rentCtl = [[ZZRentViewController alloc] init];
    _rentCtl.uid = _model.pd_graber.user.uid;
    _rentCtl.user = _model.pd_graber.user;
    _rentCtl.isFromLive = YES;
    _rentCtl.chooseType = _model.pd_graber.selected?2:1;
    [self.navigationController pushViewController:_rentCtl animated:YES];
    _rentCtl.chooseSnatcher = ^{
        [weakSelf userPageChooseSnatcher];
    };
}

- (void)userPageChooseSnatcher
{
    if ([self.seleteArray containsObject:_model]) {
        [self.seleteArray removeObject:_model];
        _rentCtl.chooseType = 1;
        _model.pd_graber.selected = NO;
    } else {
        [self.seleteArray addObject:_model];
        _rentCtl.chooseType = 2;
        _model.pd_graber.selected = YES;
    }
    self.bottomView.dataArray = self.seleteArray;
}

- (void)deleteSnatcher:(UITableViewCell *)cell
{
//    if (![ZZKeyValueStore getValueWithKey:[ZZStoreKey sharedInstance].firstDeletePublishAlert]) {
//        ZZLiveStreamEndAlert *alertView = [[ZZLiveStreamEndAlert alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        alertView.type = 3;
//        [self.view.window addSubview:alertView];
//        [ZZKeyValueStore saveValue:@"firstDeletePublishAlert" key:[ZZStoreKey sharedInstance].firstDeletePublishAlert];
//    } else {
//        [self deleteRequest:cell];
//    }
    [self deleteRequest:cell];
}

- (void)deleteRequest:(UITableViewCell *)cell
{
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
            if ([self.dataArray containsObject:model]) {
                [ZZHUD showSuccessWithStatus:@"屏蔽成功"];
                [self deleteData:model];
            }
        }
    }];
}

- (void)cancelRequest
{
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/pd/%@/cancel",_snatchModel.id] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            [self popView];
        }
    }];
}

- (void)popView
{
    [self clearTimer];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rentBtnClick
{
    [self.view.window addSubview:self.payAlert];
    self.payAlert.dataArray = self.seleteArray;
    WeakSelf;
    self.payAlert.touchRight = ^{
        if (weakSelf.seleteArray.count == 1) {
            [weakSelf startTask];
        } else if (weakSelf.seleteArray.count > 1) {
            [weakSelf gotoPay];
        }
    };
}

- (void)startTask
{
    ZZPublishListModel *model = self.seleteArray[0];
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/api/pd/%@/order/add",_snatchModel.id] params:@{@"rid":model.pd_graber.id} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            ZZChatViewController *controller = [[ZZChatViewController alloc] init];
            controller.user = model.pd_graber.user;
            controller.uid = model.pd_graber.user.uid;
            controller.nickName = model.pd_graber.user.nickname;
            controller.portraitUrl = model.pd_graber.user.avatar;
            controller.fromSnatchList = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }];
}

- (void)gotoPay
{
    NSMutableArray *values = [NSMutableArray array];
    for (ZZPublishListModel *model in self.seleteArray) {
        [values addObject:model.pd_graber.id];
    }
    _payCtl = [[ZZPayViewController alloc] init];
    _payCtl.validate_count = _validate_count;
    _payCtl.price = _bottomView.sumPrice;
    _payCtl.type = PayTypeTaskSum;
    _payCtl.values = values;
    _payCtl.pId = _snatchModel.id;
    [self.navigationController pushViewController:_payCtl animated:YES];
}
//抽佣介绍
- (void)gotoYJDetailView
{
    NSString *urlString = [NSString stringWithFormat:@"%@/api/order/price_detail/page?total_price=%@&&access_token=%@&&oid=%@&&type=1",kBase_URL,[ZZUtils dealAccuracyDouble:_bottomView.sumPrice],[ZZUserHelper shareInstance].oAuthToken,_snatchModel.id];
    ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc] init];
    controller.urlString = urlString;
    controller.navigationItem.title = @"价格详情";
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - lazyload

- (UIImageView *)bgImgView
{
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

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT- SafeAreaBottomHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEXACOLOR(0x000000, 0.45);
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(-50);
        }];
    }
    return _tableView;
}

- (ZZTaskSnatchListBottomView *)bottomView
{
    WeakSelf;
    if (!_bottomView) {
        _bottomView = [[ZZTaskSnatchListBottomView alloc] init];
        [self.view addSubview:_bottomView];
        
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.bottom.offset(-SafeAreaBottomHeight);;
            make.height.mas_equalTo(@50);
        }];
        
        _bottomView.dataArray = self.seleteArray;
        _bottomView.price = _snatchModel.price;
        _bottomView.touchRent = ^{
            [weakSelf rentBtnClick];
        };
        _bottomView.touchDetail = ^{
//            [weakSelf gotoYJDetailView];
        };
    }
    return _bottomView;
}

- (ZZLiveStreamCancelAlert *)cancelAlert
{
    WeakSelf;
    if (!_cancelAlert) {
        _cancelAlert = [[ZZLiveStreamCancelAlert alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _cancelAlert.touchCancel = ^{
            [weakSelf cancelRequest];
        };
    }
    return _cancelAlert;
}

- (ZZLiveStreamEndAlert *)endView
{
    WeakSelf;
    if (!_endView) {
        _endView = [[ZZLiveStreamEndAlert alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _endView.touchSure = ^{
            [weakSelf popView];
        };
    }
    return _endView;
}

- (ZZTaskPayAlert *)payAlert
{
    if (!_payAlert) {
        _payAlert = [[ZZTaskPayAlert alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _payAlert;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:13];
    }
    return _timeLabel;
}

- (NSMutableArray<ZZPublishListModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)deleteArray
{
    if (!_deleteArray) {
        _deleteArray = [NSMutableArray array];
    }
    return _deleteArray;
}

- (NSMutableArray *)seleteArray
{
    if (!_seleteArray) {
        _seleteArray = [NSMutableArray array];
    }
    return _seleteArray;
}

- (NSMutableArray *)removeArray
{
    if (!_removeArray) {
        _removeArray = [NSMutableArray array];
    }
    return _removeArray;
}

- (NSMutableArray *)addArray
{
    if (!_addArray) {
        _addArray = [NSMutableArray array];
    }
    return _addArray;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
