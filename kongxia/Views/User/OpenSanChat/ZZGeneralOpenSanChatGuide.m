//
//  ZZGeneralOpenSanChatGuide.m
//  zuwome
//
//  Created by 潘杨 on 2018/3/28.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZGeneralOpenSanChatGuide.h"
#import "ZZFastChatAgreementVC.h"
//#import "UIView+Twinkle.h"
#import "CABasicAnimation+Ext.h"

@interface ZZGeneralOpenSanChatGuide ()<UIGestureRecognizerDelegate>
@property (nonatomic,strong) UINavigationController *nav;

@property (nonatomic,strong) UILabel *showTitle;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic, strong) NSTimer *timer;

@end
@implementation ZZGeneralOpenSanChatGuide
+ (ZZGeneralOpenSanChatGuide *)generalOpenSanChatGuideWithNav:(UINavigationController *)Nav {
    ZZGeneralOpenSanChatGuide *gudie = [[ZZGeneralOpenSanChatGuide alloc]init];
    [gudie generalOpenSanChatGuideWithNav:Nav];
    return gudie;
}
- (void)generalOpenSanChatGuideWithNav:(UINavigationController *)Nav {
    self.nav = Nav;
}
- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.imageView];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToOpenSanChat)];
        tap1.delegate = self;
        [self addGestureRecognizer:tap1];
        [self addAnimotion];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5
                                                      target:self
                                                    selector:@selector(step:)
                                                    userInfo:nil
                                                     repeats:YES];
        [self.timer fire];
        
        [self addSubview:self.showTitle];
        [self addSubview:self.imageView];

    }
    return self;
}
- (void)goToOpenSanChat {
    BOOL canProceed = [UserHelper canOpenQuickChatWithBlock:^(BOOL success, NSInteger infoIncompleteType, BOOL isCancel) {
        
    }];
    if (!canProceed) {
        return;
    }
    ZZFastChatAgreementVC *vc = [ZZFastChatAgreementVC new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.nav pushViewController:vc animated:YES];
}
-  (void)addAnimotion {
    CGPoint point1 = CGPointMake(SCREEN_WIDTH/2.0f-66, 35);
    CGPoint point2 = CGPointMake(SCREEN_WIDTH/2.0f+66, 38);
    CGPoint point3 = CGPointMake(SCREEN_WIDTH/2.0f+66, 85);
    CGPoint point4 = CGPointMake(SCREEN_WIDTH/2.0f-66, 80);

    NSArray *array = @[[NSValue valueWithCGPoint:point1],[NSValue valueWithCGPoint:point2],[NSValue valueWithCGPoint:point3],[NSValue valueWithCGPoint:point4]];
     for (int x = 0; x<array.count; x++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        [self addSubview:imageView];
         NSValue *value  = array[x];
        imageView.bounds = CGRectMake(0, 0, 8, 8);
        imageView.center = [value CGPointValue];
        imageView.tag = x +100;
        imageView.hidden = YES;
        imageView.image = [UIImage imageNamed:@"OpenSanChatNewAdd_user_star"];
    }
}

- (void)step:(NSTimer *)step
{
    UIImageView *image1 = [self viewWithTag:100];
    image1.hidden = NO;
    [self  starAnimotionImageView:image1];
    
    UIImageView *image2 = [self viewWithTag:101];
    [NSObject asyncWaitingWithTime:0.6 completeBlock:^{
        image2.hidden = NO;
        [self  starAnimotionImageView:image2];
    }];
    
    UIImageView *image3 = [self viewWithTag:102];
    [NSObject asyncWaitingWithTime:1.3 completeBlock:^{
        image3.hidden = NO;
        [self  starAnimotionImageView:image3];
    }];
    
    UIImageView *image4 = [self viewWithTag:103];
    [NSObject asyncWaitingWithTime:2.3 completeBlock:^{
        image4.hidden = NO;
        [self  starAnimotionImageView:image4];
    }];
}

- (void)starAnimotionImageView:(UIImageView *)imageView {
    [imageView.layer addAnimation:[CABasicAnimation animaltionToscale:0 toValue:@3 durTimes:0.25 repeat:1]  forKey:[NSString stringWithFormat:@"animation%d",100]];
    [NSObject asyncWaitingWithTime:0.25 completeBlock:^{
        [imageView.layer addAnimation:[CABasicAnimation animaltionToscale:@3 toValue:0 durTimes:0.25 repeat:1]  forKey:[NSString stringWithFormat:@"animation%d",100]];
    }];
    [NSObject asyncWaitingWithTime:0.5 completeBlock:^{
        imageView.hidden = YES;
    }];
}
- (UILabel *)showTitle {
    if (!_showTitle) {
        _showTitle = [[UILabel alloc]init];
        _showTitle.text = @"开启闪聊 获取更多收益";
        _showTitle.textColor = kBlackColor;
        _showTitle.font = [UIFont systemFontOfSize:15];
        _showTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _showTitle;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.image = [UIImage imageNamed:@"Open_ShanliaokaiqiWode"];
    }
    return _imageView;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
//    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.showTitle.mas_bottom).with.offset(13);
//        make.centerX.equalTo(self.mas_centerX);
//        make.height.equalTo(@40);
//        make.width.equalTo(@132);
//    }];
    
//    [self.showTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.offset(0);
//        make.height.equalTo(@25);
//    }];
    
}
- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

@end
