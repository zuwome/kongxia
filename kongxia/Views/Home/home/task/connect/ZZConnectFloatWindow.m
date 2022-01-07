//
//  ZZConnectFloatWindow.m
//  zuwome
//
//  Created by angBiu on 2017/7/17.
//  Copyright © 2017年 zz. All rights reserved.
//
/** 用于捕捉挂断的*/
#import "ZZDateHelper.h"
/** 用于捕捉挂断的*/
#import "ZZConnectFloatWindow.h"

#import "ZZTabBarViewController.h"
#import "ZZLiveStreamConnectViewController.h"
#import "ZZLiveStreamHelper.h"

@interface ZZConnectFloatWindow () <ZZLiveStreamHelperDelegate>

@property (nonatomic, assign) CGPoint firstPoint;
@property (nonatomic, assign) CGRect firstRect;

@end

@implementation ZZConnectFloatWindow

+ (ZZConnectFloatWindow *)shareInstance
{
    __strong static ZZConnectFloatWindow *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = kBlackTextColor;
        
        [self addGestureRecognizer];
    }
    
    return self;
}

- (void)addGestureRecognizer
{
    self.userInteractionEnabled = YES;
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:recognizer];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
}

- (void)show
{
    [ZZLiveStreamHelper sharedInstance].delegate = self;
    _viewShow = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)disconnect
{
    if (!_viewShow) {
        return;
    }

    [ZZUserDefaultsHelper setObject:@"悬浮窗挂断" forDestKey:[ZZDateHelper getCurrentDate]];

    [[ZZLiveStreamHelper sharedInstance] disconnect];
    [self remove:NO];
}

- (void)remove:(BOOL)animate
{
    if (!_viewShow) {
        return;
    }
    if (animate) {
        [UIView animateWithDuration:0.3 animations:^{
            [ZZLiveStreamHelper sharedInstance].remoteView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        } completion:^(BOOL finished) {
            [self gotoConnectView];
            [self clearViews];
        }];
    } else {
        [self clearViews];
    }
}

- (void)clearViews
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeAllSubviews];
        [self removeFromSuperview];
        _rechargeing = NO;
        _viewShow = NO;
        [ZZLiveStreamHelper sharedInstance].delegate = nil;
    });
}

#pragma mark - ZZLiveStreamHelperDelegate

- (void)connectLowBalance
{
    if (!_rechargeing) {
        [self remove:YES];
    }
}

- (void)connectNoMoney
{
    [self remove:NO];
}

- (void)connectLowMcoin {//么币不足
    [self remove:YES];
}

- (void)connectNoMcoin {//没有么币
    if (!_rechargeing) {
        [self remove:NO];
    }
}

- (void)connectFinish
{
    [self disconnect];
}

#pragma mark - 

- (void)pan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:self.superview];
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            _firstPoint = point;
            _firstRect = self.frame;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGFloat yOffset = point.y - _firstPoint.y;
            CGFloat xOffset = point.x - _firstPoint.x;
            CGFloat y = _firstRect.origin.y + yOffset;

            CGFloat x = _firstRect.origin.x + xOffset;

            self.top = y;
            self.left = x;
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            
            if (self.top < NAVIGATIONBAR_HEIGHT) {
                self.top = NAVIGATIONBAR_HEIGHT;
            } else if (self.top > SCREEN_HEIGHT - self.height - TABBAR_HEIGHT) {
                self.top = SCREEN_HEIGHT - self.height;
            }
            if (self.left < 0) {
                self.left = 0;
            } else if (self.left > SCREEN_WIDTH - self.width) {
                self.left = SCREEN_WIDTH - self.width;
            }
        }
            break;
        default:
            break;
    }
}

- (void)tap:(UITapGestureRecognizer *)recognizer
{
    if (_rechargeing) {
        ZZTabBarViewController *tabbarCtl = [ZZTabBarViewController sharedInstance];
        UINavigationController *navCtl = tabbarCtl.selectedViewController;
        for (UIViewController *ctl in navCtl.viewControllers) {
            if ([ctl isKindOfClass:[ZZLiveStreamConnectViewController class]]) {
                [navCtl popToViewController:ctl animated:YES];
                [self remove:NO];
                break;
            }
        }
    } else {
        [self remove:YES];
    }
}

- (void)gotoConnectView
{
    if (_rechargeing || !_viewShow) {
        return;
    }
    ZZTabBarViewController *tabbarCtl = [ZZTabBarViewController sharedInstance];
    UINavigationController *navCtl = tabbarCtl.selectedViewController;
    if (_callIphoneViewController) {
         NSLog(@"PY_ 原来的视频通话界面");
        ZZLiveStreamConnectViewController *controller = _callIphoneViewController;
        controller.smallVideoChangeBigVideo = YES;
        controller.acceped = _acceped;
        controller.uid = _uid;
        
        controller.hidesBottomBarWhenPushed = YES;
        [navCtl pushViewController:controller animated:NO];
    }
 
}

@end
