//
//  ZZNewHomeContentHeadView.m
//  zuwome
//
//  Created by MaoMinghui on 2018/8/16.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZNewHomeContentHeadView.h"

#define lineW 36
#define lineH 5

@interface ZZNewHomeContentHeadView ()

@property (nonatomic, strong) UIButton *nearByBtn;
@property (nonatomic, strong) UIButton *recommendBtn;
@property (nonatomic, strong) UIButton *freshBtn;
@property (nonatomic, strong) UIView *line;

@end

@implementation ZZNewHomeContentHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

- (void)createView {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.line];
    
    [self addSubview:self.recommendBtn];
    [self.recommendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(90, 30));
    }];
    [self addSubview:self.nearByBtn];
    [self.nearByBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(90, 30));
        make.trailing.equalTo(self.recommendBtn.mas_leading).offset(-30);
    }];
    [self addSubview:self.freshBtn];
    [self.freshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(90, 30));
        make.leading.equalTo(self.recommendBtn.mas_trailing).offset(30);
    }];
    
    CGFloat lineX = (SCREEN_WIDTH - lineW) / 2;
    CGFloat lineY = self.frame.size.height / 2 + 10 - lineH + 1;
    self.line.frame = CGRectMake(lineX, lineY, lineW, lineH);
}

- (void)nearByClick {
    [self lineMoveToIndex:0 animated:YES];
    !self.nearByCallback ? : self.nearByCallback();
}

- (void)recommendClick {
    [self lineMoveToIndex:1 animated:YES];
    !self.recommendCallback ? : self.recommendCallback();
}

- (void)freshClick {
    [self lineMoveToIndex:2 animated:YES];
    !self.freshCallback ? : self.freshCallback();
}

- (void)lineMoveToIndex:(NSInteger)index animated:(BOOL)animated {
    CGFloat lineX;
    CGFloat lineY = self.frame.size.height / 2 + 10 - lineH + 1;
    if (index == 0) {
        lineX = self.nearByBtn.center.x - lineW / 2;
    } else if (index == 1) {
        lineX = self.recommendBtn.center.x - lineW / 2;
    } else {
        lineX = self.freshBtn.center.x - lineW / 2;
    }
    CGRect frame = CGRectMake(lineX, lineY, lineW, lineH);
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.line.frame = frame;
        }];
    } else {
        self.line.frame = frame;
    }
    [self resetBtnStyle:index];
}

- (void)resetBtnStyle:(NSInteger)index {
    if (index == 0) {
        [_nearByBtn.titleLabel setFont:[UIFont systemFontOfSize:18 weight:(UIFontWeightBold)]];
        [_recommendBtn.titleLabel setFont:[UIFont systemFontOfSize:16 weight:(UIFontWeightRegular)]];
        [_freshBtn.titleLabel setFont:[UIFont systemFontOfSize:16 weight:(UIFontWeightRegular)]];
    } else if (index == 1) {
        [_nearByBtn.titleLabel setFont:[UIFont systemFontOfSize:16 weight:(UIFontWeightRegular)]];
        [_recommendBtn.titleLabel setFont:[UIFont systemFontOfSize:18 weight:(UIFontWeightBold)]];
        [_freshBtn.titleLabel setFont:[UIFont systemFontOfSize:16 weight:(UIFontWeightRegular)]];
    } else {
        [_nearByBtn.titleLabel setFont:[UIFont systemFontOfSize:16 weight:(UIFontWeightRegular)]];
        [_recommendBtn.titleLabel setFont:[UIFont systemFontOfSize:16 weight:(UIFontWeightRegular)]];
        [_freshBtn.titleLabel setFont:[UIFont systemFontOfSize:18 weight:(UIFontWeightBold)]];
    }
}

- (UIButton *)nearByBtn {
    if (nil == _nearByBtn) {
        _nearByBtn = [[UIButton alloc] init];
        [_nearByBtn setTitle:@"附近" forState:(UIControlStateNormal)];
        [_nearByBtn setTitleColor:kBlackColor forState:(UIControlStateNormal)];
        [_nearByBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_nearByBtn addTarget:self action:@selector(nearByClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _nearByBtn;
}
- (UIButton *)recommendBtn {
    if (nil == _recommendBtn) {
        _recommendBtn = [[UIButton alloc] init];
        [_recommendBtn setTitle:@"推荐" forState:(UIControlStateNormal)];
        [_recommendBtn setTitleColor:kBlackColor forState:(UIControlStateNormal)];
        [_recommendBtn.titleLabel setFont:[UIFont systemFontOfSize:18 weight:(UIFontWeightBold)]];
        [_recommendBtn addTarget:self action:@selector(recommendClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _recommendBtn;
}
- (UIButton *)freshBtn {
    if (nil == _freshBtn) {
        _freshBtn = [[UIButton alloc] init];
        [_freshBtn setTitle:@"新鲜" forState:(UIControlStateNormal)];
        [_freshBtn setTitleColor:kBlackColor forState:(UIControlStateNormal)];
        [_freshBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_freshBtn addTarget:self action:@selector(freshClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _freshBtn;
}
- (UIView *)line {
    if (nil == _line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = kYellowColor;
        _line.layer.cornerRadius = 2;
        _line.layer.masksToBounds = YES;
    }
    return _line;
}

@end
