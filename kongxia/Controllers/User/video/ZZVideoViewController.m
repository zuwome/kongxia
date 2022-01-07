//
//  ZZMemedaViewController.m
//  zuwome
//
//  Created by angBiu on 16/8/4.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZVideoViewController.h"
#import "ZZMemedaAskViewController.h"
#import "ZZMemedaAnswerViewController.h"
#import "ZZUserVideoViewController.h"

#import "ZZMemedaHeadView.h"
#import "ZZMemedaTypeView.h"
#import "ZZRightShareView.h"

@interface ZZVideoViewController () <UIScrollViewDelegate>
{
    ZZMemedaHeadView                    *_headView;
    UIView                              *_collectionHeadView;
    UIView                              *_tempHeadView;
    ZZMemedaTypeView                    *_typeView;
    ZZScrollView                        *_switchScrollView;
    NSMutableArray                      *_ctlArray;
    ZZRentTypeBaseViewController        *_lastViewController;
    NSInteger                           _currentIndex;
    
    CGFloat                         _headHeight;//头部高度
    CGFloat                         _titleWidth;//每个类别标题的宽度
    CGFloat                         _lastOffsetX;//上次的偏移量
    CGFloat                         _lastOffsetY;//上次的偏移量
    
    BOOL                            _lockObserveParam;//改变布局时不走observer
    BOOL                            _lockDidScrollView;//滑动锁
    BOOL                            _isHeaderViewInTempHeaderView;
    
    BOOL                            _haveLoadData;
    ZZRightShareView                *_shareView;
    ZZMemedaAnswerViewController    *_answerCtl;
}

/** 控制器缓存*/
@property (nonatomic, strong) NSMutableDictionary *cacheDictionaryM;
/** 已经展示的控制器*/
@property (nonatomic, strong) NSMutableDictionary *displayDictionaryM;
/** 偏移量缓存*/
@property (nonatomic, strong) NSMutableDictionary *contentOffsetDictionaryM;
/** UIScrollView缓存*/
@property (nonatomic, strong) NSMutableDictionary *scrollViewCacheDictionryM;
@property (nonatomic, strong) ZZUser *user;

@end

@implementation ZZVideoViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _lockDidScrollView = NO;
    [self managerRedPoint];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的视频";
    
    _user = [ZZUserHelper shareInstance].loginer;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _lockDidScrollView = YES;
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoUpdate:) name:kMsg_SuccessUploadVide object:nil];
}

- (void)loadData
{
    [ZZUser loadUser:_user.uid param:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            _user = [[ZZUser alloc] initWithDictionary:data error:nil];
            [[ZZUserHelper shareInstance] saveLoginer:[_user toDictionary] postNotif:NO];
            
            if (!_haveLoadData) {
                [self createNavigationRightBtn];
                [self createHeadView];
                [self createViews];
            } else {
                _answerCtl.user = _user;
                [_answerCtl.collectionView reloadData];
            }
            _haveLoadData = YES;
        }
    }];
}

- (void)createNavigationRightBtn
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(navigationRightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *more = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = more;
}

- (void)navigationRightBtnClick
{
    NSInteger index = arc4random() % 4;
    NSString *titleStr = @"么么答，红包真心话大冒险，想来挑战吗？";
    NSString *contentStr = [NSString stringWithFormat:@"%@在「空虾」开通了么么答，快去提问吧",_user.nickname];
    switch (index) {
        case 0:
        {
            titleStr = @"么么答，你敢红包提问，我就敢视频接招！";
            contentStr = [NSString stringWithFormat:@"%@在「空虾」开通了么么答，快去挖料吧",_user.nickname];
        }
            break;
        case 1:
        {
            titleStr = @"么么答，红包真心话大冒险，想来挑战吗？";
            contentStr = [NSString stringWithFormat:@"%@在「空虾」开通了么么答，快去提问吧",_user.nickname];
        }
            break;
        case 2:
        {
            titleStr = @"么么答，能赚钱的短视频问答，等你来玩~";
            contentStr = [NSString stringWithFormat:@"%@在「空虾」开通了么么答，快去提问吧",_user.nickname];
        }
            break;
        case 3:
        {
            titleStr = @"么么答，邀请你来玩有趣有料的视频问答~";
            contentStr = [NSString stringWithFormat:@"%@开通了「么么答」，想知道TA更多猛料？抓紧时间来问！",_user.nickname];
        }
            break;
        default:
            break;
    }
    __weak typeof(self)weakSelf = self;
    if (!_shareView) {
        _shareView = [[ZZRightShareView alloc] initWithFrame:CGRectZero withController:weakSelf];
        _shareView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT  -SafeAreaBottomHeight);
        _shareView.itemCount = 4;
        _shareView.shareTitle = titleStr;
        _shareView.shareContent = contentStr;
        _shareView.shareUrl = [NSString stringWithFormat:@"%@/user/%@/mmd/page", kBase_URL, _user.uid];
        _shareView.shareImg = _headView.shareImg;
        _shareView.uid = _user.uid;
        ZZPhoto *photo = [[ZZPhoto alloc] init];
        if (_user.photos.count) {
            photo = _user.photos[0];
        } else {
            photo.url = _user.avatar;
        }
        _shareView.userImgUrl = photo.url;
        [self.view.window addSubview:_shareView];
    } else {
        _shareView.shareTitle = titleStr;
        _shareView.shareContent = contentStr;
        [_shareView show];
    }
}

#pragma mark - CreateViews

- (void)createHeadView
{
    _headView = [[ZZMemedaHeadView alloc] init];
    [_headView setData:_user];
    
    _headHeight = [_headView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    _headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _headHeight);
}

- (void)createViews
{
    __weak typeof(self)weakSelf = self;
    _switchScrollView = [[ZZScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT -SafeAreaBottomHeight)];
    _switchScrollView.showsVerticalScrollIndicator = NO;
    _switchScrollView.showsHorizontalScrollIndicator = NO;
    _switchScrollView.pagingEnabled = YES;
    _switchScrollView.delegate = self;
    _switchScrollView.bounces = NO;
    [self.view addSubview:_switchScrollView];
    
    _collectionHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _headHeight + 44)];
    [_collectionHeadView addSubview:_headView];
    
    _tempHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _collectionHeadView.height)];
    _tempHeadView.userInteractionEnabled = NO;
    [self.view addSubview:_tempHeadView];
    
    [self initControllers];
    
    _typeView = [[ZZMemedaTypeView alloc] initWithFrame:CGRectMake(0, _headHeight, SCREEN_WIDTH, 44)];
    _typeView.touchType = ^(NSInteger index) {
        [weakSelf typeBtnClick:index];
    };
    [self.view addSubview:_typeView];
    
    if ([ZZUserHelper shareInstance].unreadModel.my_ask_mmd) {
        _typeView.redPointView.hidden = NO;
    } else {
        _typeView.redPointView.hidden = YES;
    }
}

- (void)initControllers
{
    _ctlArray = [NSMutableArray array];
    _titleWidth = SCREEN_WIDTH/3.0;
    
    ZZUserVideoViewController *videoCtl = [[ZZUserVideoViewController alloc] init];
    videoCtl.headViewHeight = _collectionHeadView.height;
    videoCtl.user = _user;
    [self addChildViewController:videoCtl];
    [_ctlArray addObject:videoCtl];
    
    _answerCtl = [[ZZMemedaAnswerViewController alloc] init];
    _answerCtl.headViewHeight = _collectionHeadView.height;
    _answerCtl.user = _user;
    _answerCtl.deleteCallBack = ^{
        [videoCtl updateFailureData];
    };
    [self addChildViewController:_answerCtl];
    [_ctlArray addObject:_answerCtl];
    
    ZZMemedaAskViewController *askCtl = [[ZZMemedaAskViewController alloc] init];
    askCtl.headViewHeight = _collectionHeadView.height;
    askCtl.user = _user;
    [self addChildViewController:askCtl];
    [_ctlArray addObject:askCtl];
    
    _switchScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*_ctlArray.count, 0);
    
    [self initViewControllerWithIndex:0];
    
    [self replaceTempHeaderView];
    [self replaceTableViewHeaderView];
    
    [MobClick event:Event_my_mmd_answer];
}

#pragma mark - UIScrollViewMethod

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_lockDidScrollView) return;
    
    CGFloat currentPostion = scrollView.contentOffset.x;
    
    CGFloat offsetX = currentPostion / SCREEN_WIDTH;
    
    CGFloat offX = currentPostion > _lastOffsetX ? ceilf(offsetX) : offsetX;
    
    [self initViewControllerWithIndex:offX];
    
    [self replaceTempHeaderView];
    
    _lastOffsetX = currentPostion;
    
    [self updateContentOffset];
    
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
    NSUInteger leftIndex = (int)value;
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft = 1 - scaleRight;
    
    if (scrollView.contentOffset.x >= 0 && scrollView.contentOffset.x <= scrollView.contentSize.width - SCREEN_WIDTH) {
        CGFloat lineOffsetX = 0;
        if (_lastOffsetX > scrollView.contentOffset.x) {
            lineOffsetX = (leftIndex + 1)*_titleWidth - scaleLeft*_titleWidth;
        } else {
            lineOffsetX = leftIndex*_titleWidth + scaleRight*_titleWidth;
        }
        [_typeView setLineViewOffset:lineOffsetX];
    }
    if (scrollView.contentOffset.x <= 0) {
        [_typeView setLineViewOffset:0];
    }
}

- (void)initViewControllerWithIndex:(NSInteger)index
{
    _lastViewController = _ctlArray[index];
    
    _currentIndex = index;
    
    if ([self.displayDictionaryM objectForKey:@(index)]) return;
    
    ZZRentTypeBaseViewController * cacheViewController = [self.cacheDictionaryM objectForKey:@(index)];
    if (cacheViewController) {
        [self addViewControllerToParentScrollView:cacheViewController index:index];
    }
    [self addViewControllerToParentScrollView:_ctlArray[index] index:index];
    
    if (index == 2) {
        _typeView.redPointView.hidden = YES;
    }
}

- (void)addViewControllerToParentScrollView:(ZZRentTypeBaseViewController *)viewController index:(NSInteger)index{
    
    [self addChildViewController:_ctlArray[index]];
    
    viewController.view.frame = CGRectMake(SCREEN_WIDTH *index, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT -SafeAreaBottomHeight);
    
    [_switchScrollView addSubview:viewController.view];
    
    [self didMoveToParentViewController:viewController];
    
    [self.displayDictionaryM setObject:viewController forKey:@(index)];
    
    if (!viewController.haveAddHeadView) {
        [viewController.collectionView addSubview:_headView];
        viewController.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(_headView.height, 0, 0, 0);
    }
    
    if (![self.cacheDictionaryM objectForKey:@(index)]) {//缓存
        [self.cacheDictionaryM setObject:viewController forKey:@(index)];
        [viewController.collectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:(__bridge void * _Nullable)(viewController.collectionView)];
    }
}

/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _currentIndex = scrollView.contentOffset.x/SCREEN_WIDTH;
    _lastViewController = _ctlArray[_currentIndex];
    switch (_currentIndex) {
        case 0:
        {
//            [MobClick event:Event_my_mmd_seen];
        }
            break;
        case 1:
        {
            [MobClick event:Event_my_mmd_answer];
        }
            break;
        case 2:
        {
            [MobClick event:Event_my_mmd_ask];
        }
            break;
        default:
            break;
    }
    [_typeView setIndex:_currentIndex];
    [self replaceTableViewHeaderView];
    [self updateContentOffset];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    UICollectionView *collectionView = (__bridge id)context;
    if (_lastViewController.collectionView != collectionView) {
        return;
    }
    
    if (_lockObserveParam) {
        _lockObserveParam = NO;
        return;
    }
    CGFloat newValue = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue].y;
    CGFloat oldValue = [[change objectForKey:NSKeyValueChangeOldKey] CGPointValue].y;
    
    if (newValue != oldValue){
        CGFloat y = _headView.height - newValue;
        CGFloat deltaHeight = 0;
        
        if (y <= deltaHeight) {
//            progress = 1;
            _typeView.top = deltaHeight;
            _lastOffsetY = newValue;
            
            [self.contentOffsetDictionaryM setObject:@(newValue) forKey:@(_currentIndex)];
            
        }else{
//            progress = 1-((y-deltaHeight)/(_headView.height - deltaHeight));
            _typeView.top = y;
            _lastOffsetY = newValue;
            [self.contentOffsetDictionaryM removeAllObjects];
        }
    }
}

#pragma mark - PrivateMethod

- (void)replaceTableViewHeaderView
{
    if (_collectionHeadView.subviews.count == 0) {
        _lockObserveParam = YES;
        _isHeaderViewInTempHeaderView = NO;
        [_tempHeadView removeAllSubviews];
        [_headView removeFromSuperview];
        [_lastViewController.collectionView addSubview:_headView];
        _lastViewController.haveAddHeadView = YES;
        
        _lockObserveParam = NO;
        
        if ([self.contentOffsetDictionaryM objectForKey:@(_currentIndex)]) {
            _lastViewController.collectionView.contentOffset = CGPointMake(0, [[self.contentOffsetDictionaryM objectForKey:@(_currentIndex)] floatValue]);
        }else{
            _lastViewController.collectionView.contentOffset = CGPointMake(0, _lastOffsetY);
        }
        
        [self removeViewController];
    }
}

- (void)replaceTempHeaderView{
    
    if (!_isHeaderViewInTempHeaderView) {
        
        _isHeaderViewInTempHeaderView = YES;
        _tempHeadView.top = [_headView convertRect:_headView.frame toView:self.view].origin.y;
        
        [_headView removeFromSuperview];
        
        [_tempHeadView addSubview:_headView];
        
        if (_lastViewController.collectionView.mj_header.isRefreshing || [_lastViewController.collectionView.mj_footer isRefreshing]) {
            [_lastViewController.collectionView.mj_header endRefreshing];
            [_lastViewController.collectionView.mj_footer endRefreshing];
        }
        
        CGFloat deltaHeight = 0;
        if (_tempHeadView.top > deltaHeight) {
            [UIView animateWithDuration:0.4 animations:^{
                _tempHeadView.top = deltaHeight;
            }];
        }
    }
}

- (void)removeViewController{
    
    for (int i = 0; i < _ctlArray.count; i ++) {
        if (i != _currentIndex) {
            if(self.displayDictionaryM[@(i)]){
                [self removeViewControllerToParentScrollView:self.displayDictionaryM[@(i)] index:i];
            }
        }
    }
}

- (void)removeViewControllerToParentScrollView:(UIViewController *)viewController index:(NSInteger)index{
    
    [viewController.view removeFromSuperview];
    [viewController willMoveToParentViewController:nil];
    [viewController removeFromParentViewController];
    [self.displayDictionaryM removeObjectForKey:@(index)];
    
    if (![self.cacheDictionaryM objectForKey:@(index)]) {
        [self.cacheDictionaryM setObject:viewController forKey:@(index)];
    }
}

- (void)updateContentOffset
{
    CGFloat deltaHeight = 0;
    if (_typeView.top  == deltaHeight) {//临界点
        if ([self.contentOffsetDictionaryM objectForKey:@(_currentIndex)]) {
            _lastViewController.collectionView.contentOffset = CGPointMake(0, [[self.contentOffsetDictionaryM objectForKey:@(_currentIndex)] floatValue]);
        } else {
            _lastViewController.collectionView.contentOffset = CGPointMake(0,_headView.height);
        }
    }else{
        if (_lastOffsetY < 0) {
            _lastOffsetY = 0;
            _typeView.top = _headHeight;
        }
        _lastViewController.collectionView.contentOffset = CGPointMake(0, _lastOffsetY);
    }
}

- (void)typeBtnClick:(NSInteger)index
{
    _lockObserveParam = YES;
    
    _switchScrollView.contentOffset = CGPointMake(SCREEN_WIDTH*index, 0);
    [self scrollViewDidScroll:_switchScrollView];
    [self scrollViewDidEndDecelerating:_switchScrollView];
    
    [self removeViewController];
}

- (void)managerRedPoint
{
    NSInteger count = [ZZUserHelper shareInstance].unreadModel.my_answer_mmd_count;
    if (count) {
        _typeView.badgeView.count = count;
        _typeView.badgeView.hidden = NO;
    } else {
        _typeView.badgeView.hidden = YES;
    }
}

- (void)videoUpdate:(NSNotification *)notification
{
    NSDictionary *aDict = notification.userInfo;
    NSString *mid = [aDict objectForKey:@"mid"];
    if (mid) {
        [self managerRedPoint];
    }
}

#pragma mark - Lazy

- (NSMutableDictionary *)cacheDictionaryM{
    if (!_cacheDictionaryM) {
        _cacheDictionaryM = [NSMutableDictionary dictionaryWithCapacity:_ctlArray.count];
    }
    
    return _cacheDictionaryM;
}

- (NSMutableDictionary *)displayDictionaryM{
    if (!_displayDictionaryM) {
        _displayDictionaryM = [NSMutableDictionary dictionaryWithCapacity:_ctlArray.count];
    }
    return _displayDictionaryM;
}

- (NSMutableDictionary *)contentOffsetDictionaryM{
    if (!_contentOffsetDictionaryM) {
        _contentOffsetDictionaryM = [NSMutableDictionary dictionaryWithCapacity:_ctlArray.count];
    }
    return _contentOffsetDictionaryM;
}

- (NSMutableDictionary *)scrollViewCacheDictionryM{
    
    if (!_scrollViewCacheDictionryM) {
        _scrollViewCacheDictionryM = [NSMutableDictionary dictionaryWithCapacity:_ctlArray.count];
    }
    return _scrollViewCacheDictionryM;
}

- (void)dealloc
{
    [self.cacheDictionaryM.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        _lastViewController = self.cacheDictionaryM[obj];
        [_lastViewController.collectionView removeObserver:self forKeyPath:@"contentOffset"];
    }];
    
    [_shareView removeFromSuperview];
    _shareView = nil;
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
