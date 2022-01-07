//
//  ZZSignEditDialogView.m
//  zuwome
//
//  Created by MaoMinghui on 2018/8/3.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZSignEditDialogView.h"

@interface ZZSignEditDialogView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *username;
@property (nonatomic, strong) UILabel *skillname;
@property (nonatomic, strong) UITextView *userSign;
@property (nonatomic, strong) UIButton *changeBtn;

@end

@implementation ZZSignEditDialogView

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextBeginPath(ctx);
    
    //begin point
    CGFloat origin_x = rect.origin.x + 25;
    CGFloat origin_y = rect.origin.y + 15;
    //vertex point
    CGFloat line1_x = origin_x + (15 / 2);
    CGFloat line1_y = 0;
    //end point
    CGFloat line2_x = origin_x + 15;
    CGFloat line2_y = origin_y;
    
    CGContextMoveToPoint(ctx, origin_x, origin_y);
    CGContextAddArcToPoint(ctx, line1_x, line1_y, line2_x, line2_y, 2);
    CGContextAddLineToPoint(ctx, line1_x, line1_y);
    CGContextAddLineToPoint(ctx, line2_x, line2_y);
    
    CGContextClosePath(ctx);
    UIColor *fillColor = [UIColor whiteColor];
    CGContextSetFillColorWithColor(ctx, fillColor.CGColor);
    CGContextFillPath(ctx);
}

- (instancetype)init {
    if (self = [super init]) {
        [self createView];
        self.hidden = YES;
    }
    return self;
}

- (void)createView {
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(0, 0, dialogWidth, dialogHeight);
    self.layer.shadowColor = RGBCOLOR(232, 232, 232).CGColor;
    self.layer.shadowOpacity = 1;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(15, 0, 0, 0));
    }];
    [self.bgView addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36, 36));
        make.top.leading.equalTo(@15);
    }];
    [self.bgView addSubview:self.username];
    [self.username mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.icon);
        make.top.equalTo(self.icon);
        make.leading.equalTo(self.icon.mas_trailing).offset(10);
        make.trailing.equalTo(self.bgView).offset(-10);
        make.height.equalTo(@18);
    }];
    [self.bgView addSubview:self.skillname];
    [self.skillname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.icon.mas_trailing).offset(10);
        make.trailing.equalTo(self.bgView).offset(-10);
        make.bottom.equalTo(self.icon);
        make.height.equalTo(@18);
    }];
    [self.bgView addSubview:self.userSign];
    [self.userSign mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.icon);
        make.trailing.equalTo(self.username);
        make.top.equalTo(self.icon.mas_bottom).offset(5);
        make.bottom.equalTo(self.bgView).offset(-10);
        make.height.greaterThanOrEqualTo(@75);
    }];
    [self.bgView addSubview:self.changeBtn];
    [self.changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@5);
        make.trailing.equalTo(@-5);
        make.size.mas_equalTo(CGSizeMake(40, 18));
    }];
}

- (void)dialogShow {
    self.hidden = NO;
    if ([self.userSign.text isEqualToString:@""]) { //无示例时加载示例。
        [self loadDialogContent];
    }
}

- (void)dialogHide {
    self.hidden = YES;
}

- (void)setDialogLocation:(CGPoint)location {
    CGRect frame = self.frame;
    frame.origin.x = location.x;
    frame.origin.y = location.y;
    self.frame = frame;
}
//获取新示例内容，并更新页面 -- TODO
- (void)loadDialogContent {
    switch (self.signEditType) {
        case SignEditTypeSkill:{    //技能示例
            [[ZZSkillThemesHelper shareInstance] getSkillDemoBySid:self.sid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                [self resetView:data];
            }];
        } break;
        case SignEditTypeSign: {    //自我介绍示例
            [[ZZSkillThemesHelper shareInstance] getBioDemo:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                [self resetView:data];
            }];
        } break;
    }
}
- (void)resetView:(id)data {
    if (data) {
        if (data[@"avatar"]) {
            [self.icon sd_setImageWithURL:[NSURL URLWithString:data[@"avatar"]]];
        }
        if (data[@"userName"]) {
            self.username.text = data[@"userName"];
        }
        self.userSign.text = data[@"content"];
        self.skillname.hidden = self.signEditType == SignEditTypeSkill ? NO : YES;
        self.skillname.text = self.signEditType == SignEditTypeSkill ? data[@"themeName"] : @"";
//        if (self.signEditType == SignEditTypeSkill) {
//            [self.userSign mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(_skillname.mas_bottom).offset(5);
//            }];
//        } else {
//            [self.userSign mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(_username.mas_bottom).offset(5);
//            }];
//        }
    }
}

#pragma mark -- lazy load
- (UIView *)bgView {
    if (nil == _bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 5;
    }
    return _bgView;
}
- (UIImageView *)icon {
    if (nil == _icon) {
        _icon = [[UIImageView alloc] init];
        _icon.layer.masksToBounds = YES;
        _icon.layer.cornerRadius = 18;
    }
    return _icon;
}
- (UILabel *)username {
    if (nil == _username) {
        _username = [[UILabel alloc] init];
        _username.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightBold)];
        _username.textColor = RGBCOLOR(102, 102, 102);
    }
    return _username;
}
- (UILabel *)skillname {
    if (nil == _skillname) {
        _skillname = [[UILabel alloc] init];
        _skillname.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightBold)];
        _skillname.textColor = RGBCOLOR(102, 102, 102);
    }
    return _skillname;
}
- (UITextView *)userSign {
    if (nil == _userSign) {
        _userSign = [[UITextView alloc] init];
        _userSign.textColor = RGBCOLOR(136, 136, 136);
        _userSign.font = [UIFont systemFontOfSize:13 weight:(UIFontWeightRegular)];
        _userSign.editable = NO;
        _userSign.textContainer.lineFragmentPadding = 0;
        _userSign.textContainerInset = UIEdgeInsetsZero;
    }
    return _userSign;
}
- (UIButton *)changeBtn {
    if (nil == _changeBtn) {
        _changeBtn = [[UIButton alloc] init];
        [_changeBtn setTitle:@"换一个" forState:UIControlStateNormal];
        [_changeBtn setTitleColor:RGBCOLOR(74, 144, 226) forState:UIControlStateNormal];
        [_changeBtn.titleLabel setFont:[UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)]];
        [_changeBtn addTarget:self action:@selector(loadDialogContent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeBtn;
}

@end
