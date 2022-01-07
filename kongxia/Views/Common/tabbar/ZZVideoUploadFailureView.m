//
//  ZZVideoUploadFailureView.m
//  zuwome
//
//  Created by angBiu on 2017/4/10.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZVideoUploadFailureView.h"
#import "ZZVideoUploadStatusView.h"

#import "ZZVideoViewController.h"

@interface ZZVideoUploadFailureView ()

@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIButton *retryBtn;
@property (nonatomic, strong) UIWindow *frontWindow;
@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation ZZVideoUploadFailureView

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
        self.frame = CGRectMake(0, -NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT);
        
        self.backgroundColor = HEXCOLOR(0xff7373);
        
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.font = [UIFont systemFontOfSize:14];
        _statusLabel.textColor = [UIColor whiteColor];
        _statusLabel.text = @"您的视频上传失败了";
        [self addSubview:_statusLabel];
        
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.top.mas_equalTo(self.mas_top).offset(20);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
        
        _retryBtn = [[UIButton alloc] init];
        [_retryBtn setTitle:@"重新上传" forState:UIControlStateNormal];
        [_retryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _retryBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_retryBtn addTarget:self action:@selector(retryBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_retryBtn];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_retryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.mas_right);
                make.centerY.mas_equalTo(_statusLabel.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(70, 44));
            }];
        });
      
    }
    
    return self;
}

- (void)showView
{
    ZZVideoUploadStatusView *statusView = [ZZVideoUploadStatusView sharedInstance];
    if (statusView.viewShow) {
        [statusView hideView];
    }
    _viewShow = YES;
    [self.frontWindow addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.height);
    }];
    
    if (_timer) {
        dispatch_source_cancel(_timer);
    }
    
    __block int count = 0;
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0.0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        if (count == 3) {
            _viewShow = NO;
            [UIView animateWithDuration:0.3 animations:^{
                self.frame = CGRectMake(0, -self.height, SCREEN_WIDTH, self.height);
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
            dispatch_source_cancel(_timer);
        }
        count++;
    });
    dispatch_resume(_timer);
}

- (void)hideView
{
    if (_timer) {
        dispatch_source_cancel(_timer);
    }
    _viewShow = NO;
    self.frame = CGRectMake(0, -self.height, SCREEN_WIDTH, self.height);
    [self removeFromSuperview];
}

#pragma mark -

- (void)retryBtnClick
{
    [self hideView];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UITabBarController *tabs = (UITabBarController*)window.rootViewController;
    UINavigationController *navCtl = [tabs selectedViewController];
    ZZVideoViewController *controller = [[ZZVideoViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [navCtl pushViewController:controller animated:YES];
}

#pragma mark - lazyload

- (UIWindow *)frontWindow
{
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal && window.windowLevel <= UIWindowLevelNormal);
        
        if(windowOnMainScreen && windowIsVisible && windowLevelSupported) {
            return window;
        }
    }
    return nil;
}

@end
