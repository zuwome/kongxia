//
//  ZZTopicDetailViewController.m
//  zuwome
//
//  Created by angBiu on 2017/4/17.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZTopicDetailViewController.h"
#import "ZZTopicNewViewController.h"
#import "ZZTopicHotViewController.h"
#import "ZZRecordViewController.h"

#import "ZZTopicDetailNavigationView.h"
#import "ZZTopicDetailHeadView.h"
#import "ZZTopicDetailTypeView.h"
#import "ZZRightShareView.h"

@interface ZZTopicDetailViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) ZZScrollView *scrollView;
@property (nonatomic, strong) ZZTopicDetailNavigationView *navView;
@property (nonatomic, strong) ZZTopicDetailHeadView *headView;
@property (nonatomic, strong) ZZTopicDetailTypeView *typeView;
@property (nonatomic, strong) UIView *tempHeadView;
@property (nonatomic, strong) NSMutableArray *ctlArray;
@property (nonatomic, strong) ZZRentTypeBaseViewController *lastViewController;
@property (nonatomic, strong) ZZTopicHotViewController *hotCtl;
@property (nonatomic, strong) ZZTopicNewViewController *theNewCtl;

@property (nonatomic, strong) UIButton *recordBtn;
@property (nonatomic, strong) ZZRightShareView *shareView;

@property (nonatomic, strong) NSMutableDictionary *cacheDictionaryM;/** 控制器缓存*/
@property (nonatomic, strong) NSMutableDictionary *displayDictionaryM;/** 已经展示的控制器*/
@property (nonatomic, strong) NSMutableDictionary *contentOffsetDictionaryM;/** 偏移量缓存*/
@property (nonatomic, assign) BOOL lockObserveParam;//改变布局时不走observer
@property (nonatomic, assign) BOOL isHeaderViewInTempHeaderView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) CGFloat lastOffsetX;
@property (nonatomic, assign) CGFloat lastOffsetY;
@property (nonatomic, assign) CGFloat titleWidth;

@end

@implementation ZZTopicDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_shareView) {
        [_shareView removeFromSuperview];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createViews];
    [self initControllers];
    if (_groupId) {
        [self loadData];
    }
}

- (void)loadData
{
    [ZZTopicModel getTopicDetail:_groupId next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            _groupModel = [[ZZTopicGroupModel alloc] initWithDictionary:data error:nil];
            _hotCtl.groupModel = _groupModel;
            _theNewCtl.groupModel = _groupModel;
            [self setGroupData];
            [_hotCtl updateHeadHeight];
            [_theNewCtl updateHeadHeight];
        }
    }];
}

- (void)createViews
{
    [self.view addSubview:self.scrollView];
    
    [self setGroupData];
    [self.view addSubview:self.tempHeadView];
    [self.view addSubview:self.recordBtn];
    [self fillIphoneX];

}

- (void)setGroupData
{
    [self.headView.topicImgView sd_setImageWithURL:[NSURL URLWithString:self.groupModel.cover_url]];
    self.headView.topicLabel.text = self.groupModel.content;
    self.headView.contentLabel.text = self.groupModel.desc;
    if (self.groupModel.hot) {
        self.headView.typeImgView.hidden = NO;
        self.headView.typeLabel.hidden = NO;
    } else {
        self.headView.typeImgView.hidden = YES;
        self.headView.typeLabel.hidden = YES;
    }
    CGFloat height = [self.headView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    self.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    self.tempHeadView.height = height;
    _hotCtl.headViewHeight = _headView.height + 44;
    _hotCtl.headViewHeight = _headView.height + 44;
    _typeView.top = height;
}

- (void)initControllers
{
    _hotCtl = [[ZZTopicHotViewController alloc] init];
    _hotCtl.headViewHeight = _headView.height + 44;
    _hotCtl.groupModel = _groupModel;
    [self addChildViewController:_hotCtl];
    [self.ctlArray addObject:_hotCtl];
    
    _theNewCtl = [[ZZTopicNewViewController alloc] init];
    _theNewCtl.headViewHeight = _headView.height + 44;
    _theNewCtl.groupModel = _groupModel;
    [self addChildViewController:_theNewCtl];
    [self.ctlArray addObject:_theNewCtl];
    
    _titleWidth = SCREEN_WIDTH/2.0;
    [self initViewControllerWithIndex:0];
    
    [_lastViewController.collectionView addSubview:_headView];
    _lastViewController.haveAddHeadView = YES;
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, 0);
    self.scrollView.contentOffset = CGPointMake(0, 0);
    
    [self replaceTempHeaderView];
    [self replaceCollectionHeaderView];
    
    [self.view addSubview:self.typeView];
    [self.view addSubview:self.navView];
}

#pragma mark - UIScrollViewMethod

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
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
    if (index >= _ctlArray.count) {
        return;
    }
    
    ZZRentTypeBaseViewController *controller = _ctlArray[index];
    if (controller != _lastViewController) {
        _lastViewController = controller;
    }
    
    _currentIndex = index;
    
    if ([self.displayDictionaryM objectForKey:@(index)]) return;
    [self addViewControllerToParentScrollView:_ctlArray[index] index:index];
}

- (void)addViewControllerToParentScrollView:(ZZRentTypeBaseViewController *)viewController index:(NSInteger)index{
    
    [self addChildViewController:_ctlArray[index]];
    
    viewController.view.frame = CGRectMake(SCREEN_WIDTH *index, 0, SCREEN_WIDTH, self.scrollView.height);
    
    [self.scrollView addSubview:viewController.view];
    
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
    [self replaceCollectionHeaderView];
    [self updateContentOffset];
    
    switch (_currentIndex) {
        case 0:
        {
            [MobClick event:Event_click_latest_mmd];
        }
            break;
        case 1:
        {
            [MobClick event:Event_click_hot_mmd];
        }
            break;
        default:
            break;
    }
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
    CGFloat imageHeight = SCREEN_WIDTH/2.3;
    if (collectionView.contentOffset.y < 0) {
        CGFloat height = imageHeight+ABS(collectionView.contentOffset.y);
        CGFloat widht = (height/imageHeight)*SCREEN_WIDTH;
        self.headView.topicImgView.frame = CGRectMake(-(widht - SCREEN_WIDTH)/2.0, imageHeight - height, widht, imageHeight+ABS(collectionView.contentOffset.y));
        collectionView.showsVerticalScrollIndicator = NO;
    } else {
        self.headView.topicImgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, imageHeight);
    }
    CGFloat newValue = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue].y;
    CGFloat oldValue = [[change objectForKey:NSKeyValueChangeOldKey] CGPointValue].y;
    
    if (newValue != oldValue){
        CGFloat y = _headView.height - newValue;
        CGFloat progress = 0;
        CGFloat deltaHeight = NAVIGATIONBAR_HEIGHT;
        
        if (y <= deltaHeight) {
            progress = 1;
            _typeView.top = deltaHeight;
            _lastOffsetY = newValue;
            
            [self.contentOffsetDictionaryM setObject:@(newValue) forKey:@(_currentIndex)];
            
        }else{
            progress = 1-((y-deltaHeight)/(_headView.height - deltaHeight));
            _typeView.top = y;
            _lastOffsetY = newValue;
            [self.contentOffsetDictionaryM removeAllObjects];
        }
        
        self.navView.percent = progress;
    }
}

#pragma mark - PrivateMethod

- (void)replaceCollectionHeaderView
{
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
    CGFloat deltaHeight = NAVIGATIONBAR_HEIGHT;
    if (_typeView.top  == deltaHeight) {//临界点
        if ([self.contentOffsetDictionaryM objectForKey:@(_currentIndex)]) {
            _lastViewController.collectionView.contentOffset = CGPointMake(0, [[self.contentOffsetDictionaryM objectForKey:@(_currentIndex)] floatValue]);
        } else {
            _lastViewController.collectionView.contentOffset = CGPointMake(0,_headView.height);
        }
    }else{
        if (_lastOffsetY < 0) {
            _lastOffsetY = 0;
            _typeView.top = _headView.height;
        }
        _lastViewController.collectionView.contentOffset = CGPointMake(0, _lastOffsetY);
    }
}

#pragma mark - UIButtonMethod

- (void)typeBtnClick:(NSInteger)index
{
    NSInteger lastIndex = [_ctlArray indexOfObject:_lastViewController];
    
    if (lastIndex != index) {
        _lockObserveParam = YES;
        
        _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH*index, 0);
        [self scrollViewDidScroll:_scrollView];
        [self scrollViewDidEndDecelerating:_scrollView];
        
        [self removeViewController];
    }
}

- (void)recordBtnClick
{
    if (![ZZUserHelper shareInstance].isLogin) {
        [self gotoLoginView];
        return;
    }
    [ZZUtils checkRecodeAuth:^(BOOL authorized) {
        if (authorized) {
            [self showRecordView];
        }
    }];
}

- (void)showRecordView
{
    ZZRecordViewController *controller = [[ZZRecordViewController alloc] init];
    controller.type = RecordTypeSK;
    controller.groupModel = _groupModel;
    ZZNavigationController *navCtl = [[ZZNavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navCtl animated:YES completion:nil];
}

- (void)navigationRightBtnClick
{
    WeakSelf;
    if (!_shareView) {
        _shareView = [[ZZRightShareView alloc] initWithFrame:[UIScreen mainScreen].bounds withController:weakSelf];
        _shareView.shareTitle = _groupModel.content;
        _shareView.shareContent = _groupModel.desc;
        _shareView.shareUrl = [NSString stringWithFormat:@"%@/group/%@/videos/page", kBase_URL, _groupModel.groupId];
        UIImage *image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:_groupModel.cover_url];
        _shareView.shareImg = image;
        _shareView.userImgUrl = _groupModel.cover_url;
        _shareView.itemCount = 4;
        [self.view.window addSubview:_shareView];
    } else {
        [_shareView show];
    }
}

#pragma mark - Lazy

- (ZZScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[ZZScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50-SafeAreaBottomHeight)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (ZZTopicDetailNavigationView *)navView
{
    WeakSelf;
    if (!_navView) {
        _navView = [[ZZTopicDetailNavigationView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT)];
        _navView.titleLabel.text = self.groupModel.content;
        _navView.touchLeft = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        _navView.touchRight = ^{
            [weakSelf navigationRightBtnClick];
        };
    }
    return _navView;
}

- (ZZTopicDetailHeadView *)headView
{
    if (!_headView) {
        _headView = [[ZZTopicDetailHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    }
    return _headView;
}

- (ZZTopicDetailTypeView *)typeView
{
    WeakSelf;
    if (!_typeView) {
        _typeView = [[ZZTopicDetailTypeView alloc] initWithFrame:CGRectMake(0, _headView.height, SCREEN_WIDTH, 44)];
        _typeView.selectIndex = ^(NSInteger index) {
            [weakSelf typeBtnClick:index];
        };
    }
    return _typeView;
}

- (UIView *)tempHeadView
{
    if (!_tempHeadView) {
        _tempHeadView = [[UIView alloc] initWithFrame:_headView.bounds];
    }
    return _tempHeadView;
}
/**
 iphonex适配填充颜色
 */
- (void)fillIphoneX {
    UIView *fillView = [[UIView alloc]init];
    fillView.backgroundColor = kYellowColor;
    [self.view addSubview:fillView];
    [fillView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.equalTo(self.recordBtn.mas_bottom);
    }];
}
- (UIButton *)recordBtn
{
    if (!_recordBtn) {
        _recordBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50 - SafeAreaBottomHeight, SCREEN_WIDTH, 50)];
        _recordBtn.backgroundColor = kYellowColor;
        [_recordBtn addTarget:self action:@selector(recordBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *bgView = [[UIView alloc] init];
        bgView.userInteractionEnabled = NO;
        [_recordBtn addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_recordBtn.mas_centerX);
            make.top.bottom.mas_equalTo(_recordBtn);
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"icon_videorec_record"];
        [bgView addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgView.mas_left);
            if (isIPhoneX) {
                make.bottom.offset(0);
            }else{
            make.centerY.mas_equalTo(bgView.mas_centerY);
            }
            make.size.mas_equalTo(CGSizeMake(23.5, 17.5));
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = kBlackTextColor;
        label.font = [UIFont systemFontOfSize:15];
        label.text = @"参与话题";
        [bgView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imgView.mas_right).offset(8);
            make.right.mas_equalTo(bgView.mas_right);
            if (isIPhoneX) {
                make.bottom.offset(0);
            }else{
                make.centerY.mas_equalTo(bgView.mas_centerY);
            }
        }];
    }
    return _recordBtn;
}

- (NSMutableArray *)ctlArray
{
    if (!_ctlArray) {
        _ctlArray = [NSMutableArray array];
    }
    return _ctlArray;
}

- (NSMutableDictionary *)cacheDictionaryM
{
    if (!_cacheDictionaryM) {
        _cacheDictionaryM = [NSMutableDictionary dictionaryWithCapacity:_ctlArray.count];
    }
    return _cacheDictionaryM;
}

- (NSMutableDictionary *)displayDictionaryM
{
    if (!_displayDictionaryM) {
        _displayDictionaryM = [NSMutableDictionary dictionaryWithCapacity:_ctlArray.count];
    }
    return _displayDictionaryM;
}

- (NSMutableDictionary *)contentOffsetDictionaryM
{
    if (!_contentOffsetDictionaryM) {
        _contentOffsetDictionaryM = [NSMutableDictionary dictionaryWithCapacity:_ctlArray.count];
    }
    return _contentOffsetDictionaryM;
}

- (void)dealloc
{
    [self.cacheDictionaryM.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        _lastViewController = self.cacheDictionaryM[obj];
        [_lastViewController.collectionView removeObserver:self forKeyPath:@"contentOffset"];
    }];
    [_shareView removeFromSuperview];
    _shareView = nil;
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
