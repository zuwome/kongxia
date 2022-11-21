//
//  ZZChatBoxMoreActionView.m
//  kongxia
//
//  Created by qiming xiao on 2019/11/5.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZChatBoxMoreActionView.h"

@interface ZZChatBoxMoreActionView ()

@property (nonatomic, copy) NSArray<NSNumber *> *actionsArr;

@property (nonatomic, copy) NSArray<UIView *> *actionViewsArr;

@end

@implementation ZZChatBoxMoreActionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layout];
    }
    return self;
}

#pragma mark - public Method
- (void)canMakeVoiceCall:(BOOL)canMakeVoiceCall {
    if (!canMakeVoiceCall) {
        NSMutableArray *actionsArr = _actionsArr.mutableCopy;
        if ([actionsArr containsObject:@(ChatBoxTypeRecord)]) {
            [actionsArr removeObject: @(ChatBoxTypeRecord)];
        }
        _actionsArr = actionsArr.copy;
        
        NSMutableArray<UIView *> *actionViewsArr = _actionViewsArr.mutableCopy;
        __block UIView *view = nil;
        [actionViewsArr enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.tag == ChatBoxTypeRecord) {
                view = obj;
                *stop = YES;
            }
        }];
        
        if (view) {
            [actionViewsArr removeObject:view];
            [view removeFromSuperview];
            view = nil;
        }
        _actionViewsArr = actionViewsArr.copy;
        [self reLayout];
    }
    
}

- (void)canMakeVideoCall:(BOOL)canMakeVideoCall {
    if (!canMakeVideoCall) {
        NSMutableArray *actionsArr = _actionsArr.mutableCopy;
        if ([actionsArr containsObject:@(ChatBoxTypeVideo)]) {
            [actionsArr removeObject: @(ChatBoxTypeVideo)];
        }
        _actionsArr = actionsArr.copy;
        
        NSMutableArray<UIView *> *actionViewsArr = _actionViewsArr.mutableCopy;
        __block UIView *view = nil;
        [actionViewsArr enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.tag == ChatBoxTypeVideo) {
                view = obj;
                *stop = YES;
            }
        }];
        
        if (view) {
            [actionViewsArr removeObject:view];
            [view removeFromSuperview];
            view = nil;
        }
        _actionViewsArr = actionViewsArr.copy;
        [self reLayout];
    }
}

#pragma mark - private method

#pragma mark - response method
- (void)tapAction:(UITapGestureRecognizer *)recognizer {
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionView:action:)]) {
        [self.delegate actionView:self action:(ChatBoxType)recognizer.view.tag];
    }
}

#pragma mark - Layout
- (void)layout {
    self.backgroundColor = RGBCOLOR(248, 248, 248);
    CGFloat toX = (self.width - 65 * 4) / 5;
    
    NSMutableArray *arr = @[].mutableCopy;
    for (NSInteger i = 0; i < self.actionsArr.count; i++) {
        UIView *actionView = [self createView:(ChatBoxType)[_actionsArr[i] intValue]];
        actionView.frame = CGRectMake(toX + (65 + toX) * (i % 4),
                                      15 + (90 + 15) * (i / 4),
                                      65,
                                      90.0);
        [self addSubview:actionView];
        [arr addObject:actionView];
    }
    
    _actionViewsArr  = arr.copy;
}

- (void)reLayout {
    CGFloat toX = (self.width - 65 * 4) / 5;
    [_actionViewsArr enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(toX + (65 + toX) * (idx % 4), 15 + (90 + 15) * (idx / 4), 65, 90.0);
    }];
}

- (UIView *)createView:(ChatBoxType)boxType {
    UIView *view = [[UIView alloc] init];
    view.tag = boxType;
    NSString *title = nil;
    NSString *icon = nil;
    if (boxType == ChatBoxTypeRecord) {
        title = @"语音";
        icon = @"icYuyin";
    }
    else if (boxType == ChatBoxTypeImage) {
        title = @"照片";
        icon = @"icTupian";
    }
    else if (boxType == ChatBoxTypeShot) {
        title = @"拍摄";
        icon = @"icPaishe";
    }
    else if (boxType == ChatBoxTypePacket) {
        title = @"红包";
        icon = @"icHongbao";
    }
    else if (boxType == ChatBoxTypeBurn) {
        title = @"阅后即焚";
        icon = @"icYuehoujifen";
    }
    else if (boxType == ChatBoxTypeVideo) {
        title = @"视频通话";
        icon = @"icSpth";
    }
    else if (boxType == ChatBoxTypeLocation) {
        title = @"位置";
        icon = @"icWeizhi";
    }
    else if (boxType == ChatBoxTypeGift) {
        title = @"礼物";
        icon = @"icLiwu";
    }
    
    UIImageView *imageview = [[UIImageView alloc] init];
    imageview.contentMode = UIViewContentModeCenter;
    imageview.backgroundColor = UIColor.whiteColor;
    imageview.layer.cornerRadius = 16.0;
    imageview.image = [UIImage imageNamed:icon];
    imageview.layer.cornerRadius = 16.0;
    imageview.userInteractionEnabled = YES;
    [view addSubview:imageview];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    titleLabel.textColor = RGBCOLOR(102, 102, 102);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:titleLabel];
    
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(65, 65));
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.left.right.equalTo(view);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [view addGestureRecognizer:tap];
    
    return view;
}

#pragma mark - getters and setters
- (NSArray<NSNumber *> *)actionsArr {
    if (!_actionsArr) {
        _actionsArr = @[@(ChatBoxTypeRecord), @(ChatBoxTypeImage), @(ChatBoxTypeShot), @(ChatBoxTypeGift), @(ChatBoxTypeBurn), @(ChatBoxTypeVideo)];
//        , @(ChatBoxTypeLocation)
    }
    return _actionsArr;
}
@end
