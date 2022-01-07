//
//  ZZTaskActivityActionCell.m
//  zuwome
//
//  Created by qiming xiao on 2019/4/24.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTaskActivityActionCell.h"
#import "ZZTaskModel.h"

@interface ZZTaskActivityActionCell ()

@property (nonatomic, strong) UIView   *actionContentImageView;

@property (nonatomic, strong) UIButton *centerActionBtn;

@property (nonatomic, strong) UIButton *rightActionBtn;

@end

@implementation ZZTaskActivityActionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)centerAction {
    // check wechat 查看微信
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:checkWechat:)]) {
        [self.delegate cell:self checkWechat:_item];
    }
}

- (void)rightAction {
    // chat 私聊
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:chat:)]) {
        [self.delegate cell:self chat:_item];
    }
}

- (void)configureData {
    _centerActionBtn.normalTitle = @"查看微信";
    _rightActionBtn.normalTitle = @"私信";
    
    if (!_item.task.from.have_wechat_no || (_item.task.from.have_wechat_no && !_item.task.from.can_see_wechat_no)) {
        _centerActionBtn.hidden = YES;
    }
    else {
        _centerActionBtn.hidden = NO;
    }
}

#pragma mark - Layout
- (void)layout {
    self.backgroundColor = ColorClear;
    [self.contentView addSubview:self.actionContentImageView];
    [_actionContentImageView addSubview:self.centerActionBtn];
    [_actionContentImageView addSubview:self.rightActionBtn];
    
    CGFloat offset = (SCREEN_WIDTH - 14 - 154 * 2) / 3;
    [_actionContentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(7.0);
        make.right.equalTo(self.contentView).offset(-7.0);
        make.height.equalTo(@88);
    }];
    
    [_rightActionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_actionContentImageView).offset(-offset);
        make.bottom.equalTo(_actionContentImageView).offset(-15);
        make.size.mas_equalTo(CGSizeMake(154, 44));
    }];
    
    [_centerActionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_rightActionBtn.mas_left).offset(-offset);
        make.centerY.equalTo(_rightActionBtn);
        make.size.mas_equalTo(CGSizeMake(154, 44));
    }];
    
    [self layoutIfNeeded];
    [self createGradientLayer];
}

- (void)createGradientLayer {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = _centerActionBtn.bounds;
    
    gradient.colors = @[(id)RGBCOLOR(0, 217, 249).CGColor, (id)RGBCOLOR(71, 225, 234).CGColor];
    gradient.locations = @[@0.0, @1.0];
    
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1, 0);
    gradient.cornerRadius = 22.0;
    [_centerActionBtn.layer addSublayer:gradient];
    [_centerActionBtn bringSubviewToFront:_centerActionBtn.titleLabel];
    [_centerActionBtn bringSubviewToFront:_centerActionBtn.imageView];
    [_centerActionBtn setImagePosition:LXMImagePositionLeft spacing:10];
    
    CAGradientLayer *gradient1 = [CAGradientLayer layer];
    gradient1.frame = _rightActionBtn.bounds;
    
    gradient1.colors = @[(id)RGBCOLOR(253, 87, 85).CGColor, (id)RGBCOLOR(252, 27, 141).CGColor];
    gradient1.locations = @[@0.0, @1.0];
    
    gradient1.startPoint = CGPointMake(0, 0);
    gradient1.endPoint = CGPointMake(1, 0);
    gradient1.cornerRadius = 22.0;
    [_rightActionBtn.layer addSublayer:gradient1];
    [_rightActionBtn bringSubviewToFront:_rightActionBtn.titleLabel];
    [_rightActionBtn bringSubviewToFront:_rightActionBtn.imageView];
    [_rightActionBtn setImagePosition:LXMImagePositionLeft spacing:10];
}

#pragma mark - getters and setters
- (void)setItem:(TaskActivityActionsItem *)item {
    _item = item;
    [self configureData];
}

- (UIView *)actionContentImageView {
    if (!_actionContentImageView) {
        _actionContentImageView = [[UIView alloc] init];
        _actionContentImageView.backgroundColor = ColorWhite;
    }
    return _actionContentImageView;
}

- (UIButton *)centerActionBtn {
    if (!_centerActionBtn) {
        _centerActionBtn = [[UIButton alloc] init];
        _centerActionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        _centerActionBtn.normalTitleColor = UIColor.whiteColor;
        _centerActionBtn.normalImage = [UIImage imageNamed:@"icChakanweixin"];
        [_centerActionBtn addTarget:self action:@selector(centerAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _centerActionBtn;
}

- (UIButton *)rightActionBtn {
    if (!_rightActionBtn) {
        _rightActionBtn = [[UIButton alloc] init];
        _rightActionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        _rightActionBtn.normalTitleColor = UIColor.whiteColor;
        _rightActionBtn.normalImage = [UIImage imageNamed:@"icSixinta"];
        [_rightActionBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightActionBtn;
}
@end
