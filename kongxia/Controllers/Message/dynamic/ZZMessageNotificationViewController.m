//
//  ZZMessageDynamicViewController.m
//  zuwome
//
//  Created by angBiu on 16/8/22.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZMessageNotificationViewController.h"
#import "ZZMessageSystemViewController.h"
#import "ZZMessageMyDynamicViewController.h"

#import "ZZMessageNotificationHeadView.h"

@interface ZZMessageNotificationViewController () <UIScrollViewDelegate>
{
    ZZMessageNotificationHeadView           *_headView;
    ZZScrollView                            *_bigScrollView;
    NSMutableArray                          *_ctlArray;
    
    UIViewController                        *_lastViewController;
    CGFloat                                 _lastOffsetX;
    CGFloat                                 _titleWidth;
}

@property (nonatomic, assign) BOOL isUploadVideo;//是否正在上传视频

@end

@implementation ZZMessageNotificationViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createViews];
}

- (void)createViews
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    topView.backgroundColor = kYellowColor;
    [self.view addSubview:topView];
    
    __weak typeof(self)weakSelf = self;
    _headView = [[ZZMessageNotificationHeadView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, isIPhoneX ? 68 : 44)];
    _headView.selectIndex = ^(NSInteger index) {
        [weakSelf typeBtnClick:index];
    };
    _headView.touchLeft = ^{
        [weakSelf leftBtnClick];
    };
    [self.view addSubview:_headView];
    
    if ([ZZUserHelper shareInstance].unreadModel.system_msg) {
        _headView.rightRedPointView.hidden = NO;
    } else {
        _headView.rightRedPointView.hidden = YES;
    }
    
    _bigScrollView = [[ZZScrollView alloc] initWithFrame:CGRectMake(0, isIPhoneX ? 88 : 64, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    _bigScrollView.showsVerticalScrollIndicator = NO;
    _bigScrollView.showsHorizontalScrollIndicator = NO;
    _bigScrollView.pagingEnabled = YES;
    _bigScrollView.delegate = self;
    _bigScrollView.bounces = NO;
    [self.view addSubview:_bigScrollView];
    
    [self.navigationLeftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self initControllers];
}

- (void)initControllers
{
    _titleWidth = SCREEN_WIDTH/2;
    _ctlArray = [NSMutableArray array];
    
    ZZMessageMyDynamicViewController *myCtl = [[ZZMessageMyDynamicViewController alloc] init];
    [self addChildViewController:myCtl];
    [_ctlArray addObject:myCtl];
    
    ZZMessageSystemViewController *sysCtl = [[ZZMessageSystemViewController alloc] init];
    [sysCtl setIsUploadVideoBlock:^(BOOL is) {
        _isUploadVideo = is;
    }];
    [self addChildViewController:sysCtl];
    [_ctlArray addObject:sysCtl];
    
    if (_selectIndex == 1) {
        [MobClick event:Event_click_system_message];
        
        _lastViewController = _ctlArray[1];
        _bigScrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        [_headView setLineIndex:1];
        [_headView setLineViewOffset:SCREEN_WIDTH/2];
        _headView.rightRedPointView.hidden = YES;
    } else {
        [MobClick event:Event_click_dynamic_self];
        
        _lastViewController = _ctlArray[0];
    }
    
    _lastViewController.view.frame = _bigScrollView.bounds;
    [_bigScrollView addSubview:_lastViewController.view];
    
    _bigScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*_ctlArray.count, 0);
    
}

#pragma mark - UIScrollViewDelegate

/** 滚动结束后调用（代码导致） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / _bigScrollView.frame.size.width;
    [_headView setLineIndex:index];
    // 添加控制器
    UIViewController *newController = self.childViewControllers[index];
    if (newController != _lastViewController) {
        _lastViewController = newController;
    }
    
    if (index == 0) {
        [MobClick event:Event_click_dynamic_self];
    } else {
        [MobClick event:Event_click_system_message];
    }
    if (newController.view.superview) return;
    
    newController.view.frame = CGRectMake(index*SCREEN_WIDTH, 0, SCREEN_WIDTH, _bigScrollView.frame.size.height);
    [_bigScrollView addSubview:newController.view];
    
    if (index == 1) {
        _headView.rightRedPointView.hidden = YES;
    }
}

/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
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
        [_headView setLineViewOffset:lineOffsetX];
    }
    if (scrollView.contentOffset.x <= 0) {
        [_headView setLineViewOffset:0];
    }
}

#pragma mark - UIButtonMethod

- (void)typeBtnClick:(NSInteger)index
{
    CGFloat offsetX = index * SCREEN_WIDTH;
    
    CGFloat offsetY = _bigScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    
    [_bigScrollView setContentOffset:offset animated:YES];
}

- (void)leftBtnClick
{
    if (_isUploadVideo) {
        [ZZHUD showTaskInfoWithStatus:@"正在上传视频"];
        return;
    }
    [ZZHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
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
