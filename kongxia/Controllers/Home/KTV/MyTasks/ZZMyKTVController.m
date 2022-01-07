//
//  ZZMyKTVController.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/27.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZMyKTVController.h"
#import "ZZKTVReceivedGiftsController.h"
#import "ZZKTVMyTasksController.h"
#import "ZZCreateSingingTaskController.h"
#import "ZZKTVPlazaController.h"

#import "ZZKTVConfig.h"

@interface ZZMyKTVController ()<ZZMyKTVControllerHeaderViewDelegate, UIScrollViewDelegate, ZZKTVReceivedGiftsControllerDelegate>

@property (nonatomic, strong) ZZMyKTVControllerHeaderView *headerView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) UIButton *createTaskBtn;

@end

@implementation ZZMyKTVController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNavigations];
    [self layout];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


#pragma mark response method
- (void)createTaskAction {
    [self goCreateTask];
}


#pragma mark - ZZKTVReceivedGiftsControllerDelegate
- (void)switchToTasks:(ZZKTVReceivedGiftsController *)controller {
    if (self.navigationController.viewControllers.count == 2) {
        [self showTasksVC];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark ZZMyKTVControllerHeaderView
- (void)header:(ZZMyKTVControllerHeaderView *)header select:(NSInteger)index {
    _currentPage = index;
    [UIView animateWithDuration:0.3 animations:^{
        [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * index, 0)];
    }];
    
    if (_currentPage == 1) {
        ZZKTVReceivedGiftsController *vc = (ZZKTVReceivedGiftsController *)self.childViewControllers.lastObject;
        if (vc.isTheFirstTime) {
            [vc fresh];
        }
    }
}


#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_headerView offetSet:scrollView.contentOffset.x];
    
    if ((scrollView.contentOffset.x / SCREEN_WIDTH) == 1) {
        ZZKTVReceivedGiftsController *vc = (ZZKTVReceivedGiftsController *)self.childViewControllers.lastObject;
        if (vc.isTheFirstTime) {
            [vc fresh];
        }
    }
}


#pragma mark - Navigator
- (void)goCreateTask {
    ZZCreateSingingTaskController *controller = [[ZZCreateSingingTaskController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)showTasksVC {
    ZZKTVPlazaController *vc = [[ZZKTVPlazaController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark Layout
- (void)layoutNavigations {
    self.title = @"我的点唱Party";
}

- (void)layout {
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.createTaskBtn];
    
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(_headerView.mas_bottom);
    }];
    
    [_createTaskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-20);
        } else {
            make.bottom.equalTo(self.view).offset(-20);
        }
        make.size.mas_equalTo(CGSizeMake(95, 69.5));
    }];
    
    [self initViewControllers];
}

- (void)initViewControllers {
    [self.view layoutIfNeeded];
    // 添加子控制器
    ZZKTVMyTasksController *vc1 = [[ZZKTVMyTasksController alloc] init];
    vc1.parentController = self;
    vc1.view.frame = CGRectMake(0.0, 0.0, SCREEN_WIDTH, _scrollView.height);
    if (vc1.isTheFirstTime) {
        [vc1 fresh];
    }
    
    ZZKTVReceivedGiftsController *vc2 = [[ZZKTVReceivedGiftsController alloc] init];
    vc2.parentController = self;
    vc2.delegate = self;
    vc2.view.frame = CGRectMake(SCREEN_WIDTH, 0.0, SCREEN_WIDTH, _scrollView.height);
    
    [self addChildViewController:vc1];
    [self addChildViewController:vc2];
    [self.scrollView addSubview:self.childViewControllers[0].view];
    [self.scrollView addSubview:self.childViewControllers[1].view];
}

#pragma mark getters and setters
- (ZZMyKTVControllerHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[ZZMyKTVControllerHeaderView alloc] init];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIButton *)createTaskBtn {
    if (!_createTaskBtn) {
        _createTaskBtn = [[UIButton alloc] init];
        _createTaskBtn.normalTitle = @"发起唱趴";
        _createTaskBtn.normalImage = [UIImage imageNamed:@"icFaqichangpa"];
        [_createTaskBtn addTarget:self action:@selector(createTaskAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _createTaskBtn;
}

@end


@interface ZZMyKTVControllerHeaderView ()

@property (nonatomic, strong) UILabel *taskLabel;

@property (nonatomic, strong) UILabel *leadSinggerLabel;

@property (nonatomic, strong) UIView  *navigatorBar;

@end

@implementation ZZMyKTVControllerHeaderView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self layout];
    }
    return self;
}


#pragma mark public Method
- (void)offetSet:(CGFloat)offsetX {
    CGFloat currentOffset = 0.0;
    CGFloat gap = _leadSinggerLabel.center.x - _taskLabel.center.x;
    currentOffset = (gap / SCREEN_WIDTH) * offsetX;

    [_navigatorBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_taskLabel).offset(currentOffset);
    }];
    
    if (offsetX == 0) {
        _taskLabel.font = [UIFont boldSystemFontOfSize:16.0];
        _leadSinggerLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    }
    else if (offsetX == SCREEN_WIDTH) {
        _taskLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _leadSinggerLabel.font = [UIFont boldSystemFontOfSize:16.0];
    }
    
}

#pragma mark response method
- (void)select:(UITapGestureRecognizer *)recoginzier {
    if (self.delegate && [self.delegate respondsToSelector:@selector(header:select:)]) {
        [self.delegate header:self select:recoginzier.view.tag];
    }
}


#pragma mark Layout
- (void)layout {
    [self addSubview:self.navigatorBar];
    [self addSubview:self.taskLabel];
    [self addSubview:self.leadSinggerLabel];
    
    CGFloat labelWidth = 80.0;
    CGFloat toX = (SCREEN_WIDTH - labelWidth * 2 - 29) / 2;
    
    [_taskLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(toX);
    }];
    
    [_leadSinggerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_taskLabel.mas_right).offset(29);
    }];
    
    [_navigatorBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_taskLabel);
        make.bottom.equalTo(self).offset(-15);
        make.width.equalTo(@(34));
        make.height.equalTo(@5.0);
    }];
}


#pragma mark getters and setters
- (UIView *)navigatorBar {
    if (!_navigatorBar) {
        _navigatorBar = [[UIView alloc] init];
        _navigatorBar.backgroundColor = RGBCOLOR(255, 226, 86);
        _navigatorBar.layer.cornerRadius = 2.5;
    }
    return _navigatorBar;
}

- (UILabel *)taskLabel {
    if (!_taskLabel) {
        _taskLabel = [[UILabel alloc] init];
        _taskLabel.textColor = RGBCOLOR(63, 58, 58);
        _taskLabel.font = [UIFont boldSystemFontOfSize:16.0];
        _taskLabel.text = @"我的发起";
        _taskLabel.textAlignment = NSTextAlignmentCenter;
        _taskLabel.tag = 0;
        _taskLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(select:)];
        [_taskLabel addGestureRecognizer:tap];
    }
    return _taskLabel;
}

- (UILabel *)leadSinggerLabel {
    if (!_leadSinggerLabel) {
        _leadSinggerLabel = [[UILabel alloc] init];
        _leadSinggerLabel.textColor = RGBCOLOR(63, 58, 58);
        _leadSinggerLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _leadSinggerLabel.text = @"收到的礼物";
        _leadSinggerLabel.textAlignment = NSTextAlignmentCenter;
        _leadSinggerLabel.tag = 1;
        _leadSinggerLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(select:)];
        [_leadSinggerLabel addGestureRecognizer:tap];
    }
    return _leadSinggerLabel;
}

@end
