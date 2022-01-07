//
//  ZZRecordTopicTitleView.m
//  zuwome
//
//  Created by angBiu on 2017/5/17.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZRecordTopicTitleView.h"
@interface ZZRecordTopicTitleView()
@property (nonatomic, strong) UIButton *clickButton;
@end
@implementation ZZRecordTopicTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.alpha = 0.19;
        _bgView.layer.cornerRadius = 3;
        [self addSubview:_bgView];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.clickButton];
        [self addSubview:self.deleteButton];
        _isNoTop = YES;
        [self settingConstraints];
    }
    
    return self;
}

- (void)setIsIntroduceVideo:(BOOL)isIntroduceVideo {
    
    _isIntroduceVideo = isIntroduceVideo;
    if (isIntroduceVideo) {
        _isNoTop = NO;
        _titleLabel.text = @"# 我是达人 #";
        self.userInteractionEnabled = NO;
        self.deleteButton.hidden = YES;
        [self.labelRedPointView removeFromSuperview];
        self.titleLabel.textColor = [UIColor whiteColor];
        _bgView.backgroundColor = kYellowColor;
        _bgView.alpha = 1.0;
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(0);
        }];
    }
}
- (void)setIsRecordTypeMemeda:(BOOL)isRecordTypeMemeda {
    _isRecordTypeMemeda = isRecordTypeMemeda;
    _isNoTop = NO;

    if (_isRecordTypeMemeda) {
        self.userInteractionEnabled = NO;
        self.deleteButton.hidden = YES;
        [self.labelRedPointView removeFromSuperview];
        self.titleLabel.textColor = [UIColor whiteColor];
        _bgView.backgroundColor = kYellowColor;
        _bgView.alpha = 1.0;
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-12);
        }];
    }
}

- (void)setSelectedModel:(ZZTopicGroupModel *)selectedModel
{
    _selectedModel = selectedModel;
    self.titleLabel.text = selectedModel.content;
    _isNoTop = NO;
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-52);
    }];
  
    self.deleteButton.hidden = NO;
}

- (void)btnClick
{
    
    
    [MobClick event:Event_click_record_topic];
    if (_tapSelf) {
        _tapSelf();
    }
    self.labelRedPointView.hidden = YES;
}

/**
 删除按钮
 */
- (void)delegateButtionClick {

    self.deleteButton.hidden = YES;
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-12);
    }];
    _isNoTop = YES;
    if (self.delegateButtionCallback) {
        self.delegateButtionCallback();
    }
}

- (UIButton *)clickButton {
    if (!_clickButton) {
        _clickButton = [[UIButton alloc] init];

        [_clickButton addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clickButton;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.text = @"# 添加话题 获得更多关注 #";
    }
    return _titleLabel;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.hidden = YES;
        [_deleteButton addTarget:self action:@selector(delegateButtionClick) forControlEvents:UIControlEventTouchUpInside];
        [_deleteButton setImage:[UIImage imageNamed:@"icVideoEditHuatiDelete"] forState:UIControlStateNormal];
    }
    return _deleteButton;
}
- (UIView *)labelRedPointView
{
    if (!_labelRedPointView) {
        _labelRedPointView = [[UIView alloc] init];
        _labelRedPointView.layer.cornerRadius = 5;
        _labelRedPointView.backgroundColor = kRedPointColor;
        _labelRedPointView.userInteractionEnabled = NO;
        _labelRedPointView.hidden = YES;
        [self addSubview:_labelRedPointView];
    }
    return _labelRedPointView;
}

- (void)settingConstraints {
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.mas_width);
        make.centerX.mas_equalTo(self);
        make.top.bottom.offset(0);
    }];

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(12);
        make.right.equalTo(self.mas_right).offset(-12);
    }];
    
    [_labelRedPointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_right);
        make.bottom.mas_equalTo(self.bgView.mas_top).offset(2);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    
    [self.clickButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_titleLabel.mas_right);
        make.left.offset(0);
        make.top.bottom.offset(0);
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
}


@end
