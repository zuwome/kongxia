//
//  ZZKTVChooseGiftCountsCell.m
//  kongxia
//
//  Created by qiming xiao on 2019/12/30.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZKTVChooseGiftCountsCell.h"
#import "ZZKTVConfig.h"

@interface ZZKTVChooseGiftCountsCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *minusBtn;

@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, strong) UILabel *countsLabel;

@property (nonatomic, strong) UIView *seperateLine;

@property (nonatomic, strong) UILabel *tipsLabel;

@end

@implementation ZZKTVChooseGiftCountsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
        [self showOrHideBtns:1];
    }
    return self;
}


#pragma mark - public Method
- (void)configureKTVModel:(ZZKTVModel *)model {
    _countsLabel.text = [NSString stringWithFormat:@"%ld", model.gift_count];
    [self showOrHideBtns:model.gift_count];
}


#pragma mark - private method
- (void)showOrHideBtns:(NSInteger)count {
    if (count > 1 && count < 20) {
        _minusBtn.hidden = NO;
        _addBtn.hidden = NO;
    }
    else if (count <= 1) {
        _minusBtn.hidden = YES;
        _addBtn.hidden = NO;
    }
    else {
        _minusBtn.hidden = NO;
        _addBtn.hidden = YES;
    }
}


#pragma mark - response method
- (void)minusAction {
    NSInteger count = [_countsLabel.text intValue];
    if (count == 1) {
        return;
    }
    
    count -= 1;
    _countsLabel.text = [NSString stringWithFormat:@"%ld", count];
    
    [self showOrHideBtns:count];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:counts:)]) {
        [self.delegate cell:self counts:count];
    }
    
    _tipsLabel.text = [NSString stringWithFormat:@"可有%ld位达人抢先唱歌领取礼物", count];
}

- (void)addAction {
    NSInteger count = [_countsLabel.text intValue];
    if (count < 0 || count >= 20) {
        return;
    }
    
    count += 1;
    _countsLabel.text = [NSString stringWithFormat:@"%ld", count];
    
    [self showOrHideBtns:count];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:counts:)]) {
        [self.delegate cell:self counts:count];
    }
    
    _tipsLabel.text = [NSString stringWithFormat:@"可有%ld位达人抢先唱歌领取礼物", count];
}

#pragma mark - UI
- (void)layout {
    self.backgroundColor = UIColor.clearColor;
    
    [self.contentView addSubview:self.bgView];
    [_bgView addSubview:self.titleLabel];
    [_bgView addSubview:self.addBtn];
    [_bgView addSubview:self.countsLabel];
    [_bgView addSubview:self.minusBtn];
    [_bgView addSubview:self.seperateLine];
    [_bgView addSubview:self.tipsLabel];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10.0);
        make.right.equalTo(self.contentView).offset(-10.0);
        make.bottom.top.equalTo(self.contentView);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(_bgView).offset(15.0);
    }];
    
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel);
        make.right.equalTo(_bgView).offset(-15.0);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    [_countsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel);
        make.right.equalTo(_addBtn.mas_left).offset(-10.0);
        make.size.mas_equalTo(CGSizeMake(30, 22));
    }];
    
    [_minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel);
        make.right.equalTo(_countsLabel.mas_left).offset(-10.0);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    [_seperateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgView).offset(15.0);
        make.right.equalTo(_bgView).offset(-15.0);
        make.top.equalTo(_titleLabel.mas_bottom).offset(10.0);
        make.height.equalTo(@0.5);
    }];
    
    [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgView).offset(15.0);
        make.right.equalTo(_bgView).offset(-15.0);
        make.top.equalTo(_seperateLine.mas_bottom).offset(10.0);
    }];
}

#pragma mark - Getter&Setter
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.whiteColor;
        _bgView.layer.cornerRadius = 3;
    }
    return _bgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = ADaptedFontSCBoldSize(16);
        _titleLabel.textColor = RGBCOLOR(63, 58, 58);
        _titleLabel.text = @"包含礼物个数";
    }
    return _titleLabel;
}

- (UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [[UIButton alloc] init];
        _addBtn.normalImage = [UIImage imageNamed:@"changpaicTianjia"];
        [_addBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

- (UIButton *)minusBtn {
    if (!_minusBtn) {
        _minusBtn = [[UIButton alloc] init];
        _minusBtn.normalImage = [UIImage imageNamed:@"icJianshao"];
        [_minusBtn addTarget:self action:@selector(minusAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _minusBtn;
}

- (UILabel *)countsLabel {
    if (!_countsLabel) {
        _countsLabel = [[UILabel alloc] init];
        _countsLabel.font = ADaptedFontMediumSize(17);
        _countsLabel.textColor = RGBCOLOR(102, 102, 102);
        _countsLabel.textAlignment = NSTextAlignmentCenter;
        _countsLabel.text = [NSString stringWithFormat:@"%d", 1];
    }
    return _countsLabel;
}

- (UIView *)seperateLine {
    if (!_seperateLine) {
        _seperateLine = [[UILabel alloc] init];
        _seperateLine.backgroundColor = RGBCOLOR(245, 245, 245);
    }
    return _seperateLine;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.font = ADaptedFontMediumSize(14);
        _tipsLabel.textColor = RGBCOLOR(153, 153, 153);
        _tipsLabel.text = @"可有X位达人抢先唱歌领取礼物";
    }
    return _tipsLabel;
}

@end
