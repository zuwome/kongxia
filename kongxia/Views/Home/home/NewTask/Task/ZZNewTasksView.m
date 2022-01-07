//
//  ZZNewTasksView.m
//  zuwome
//
//  Created by qiming xiao on 2019/4/1.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZNewTasksView.h"

@interface ZZNewTasksView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ZZNewTasksView

//static ZZNewTasksView *_instance;
//static dispatch_once_t singleton_onceToken;
//static dispatch_once_t singleton_share_onceToken;
//
//+ (ZZNewTasksView *)shared {
//    dispatch_once(&singleton_share_onceToken, ^{
//        _instance = [[self alloc] init];
//    });
//    return _instance;
//}
//
//
//+ (id)allocWithZone:(NSZone *)zone {
//    dispatch_once(&singleton_onceToken, ^{
//        _instance = [super allocWithZone:zone];
//    });
//    return _instance;
//}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"ZZNewTasksView is gone");
}

+ (void)showWithCounts:(NSInteger)counts in:(nonnull UIView *)view {
    ZZNewTasksView *countView = [[ZZNewTasksView alloc] initWithFrame:CGRectMake(0.0, 0 - 32.0, SCREEN_WIDTH, 32.0)];
    [view addSubview:countView];
    countView.titleLabel.text = [NSString stringWithFormat:@"已刷新%ld条新的通告",counts];
    [countView show];
}

- (void)show {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect oriFrame = self.frame;
        oriFrame.origin.y += 32;
        self.frame = oriFrame;
    } completion:^(BOOL finished) {
        [self addTimer];
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect oriFrame = self.frame;
        oriFrame.origin.y -= 32;
        self.frame = oriFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)addTimer {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hide];
    });
}

#pragma mark - Layout
- (void)layout {
    self.backgroundColor = RGBCOLOR(250, 124, 100);
    
    [self addSubview:self.titleLabel];
    _titleLabel.frame = self.bounds;
}

#pragma mark - getters and setters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
