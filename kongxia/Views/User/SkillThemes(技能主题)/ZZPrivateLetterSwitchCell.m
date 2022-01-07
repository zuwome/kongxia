//
//  ZZPrivateLetterSwitchCell.m
//  zuwome
//
//  Created by MaoMinghui on 2018/9/13.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZPrivateLetterSwitchCell.h"

@interface ZZPrivateLetterSwitchCell ()

@property (nonatomic, strong) UIView *lineView;//分割线

@end

@implementation ZZPrivateLetterSwitchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
- (void)createUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.openSwitch];
    [self.contentView addSubview:self.promptLable];
    [self.contentView addSubview:self.contentLable];
    [self.contentView addSubview:self.lineView];
    
    [self.openSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentLable.mas_centerY);
        make.trailing.offset(-15);
    }];
    [self.contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(15);
        make.trailing.equalTo(self.openSwitch.mas_leading).offset(10);
        make.top.equalTo(@0);
        make.height.equalTo(@60);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(15);
        make.top.equalTo(self.contentLable.mas_bottom);
        make.trailing.offset(-15);
        make.height.equalTo(@0.5);
    }];
    [self.promptLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.height.equalTo(@30);
        make.trailing.offset(-15);
        make.leading.offset(15);
        make.bottom.equalTo(@0);
    }];
}

- (UILabel *)promptLable {
    if (!_promptLable) {
        _promptLable = [[UILabel alloc]init];
        _promptLable.textColor = RGBCOLOR(171, 171, 171);
        _promptLable.font = [UIFont systemFontOfSize:12];
        _promptLable.textAlignment = NSTextAlignmentLeft;
        _promptLable.text = @"收到每条私信可获得收益，24小时内回复自动领取";
    }
    return _promptLable;
}
- (UILabel *)contentLable {
    if (!_contentLable) {
        _contentLable = [[UILabel alloc]init];
        _contentLable.textAlignment = NSTextAlignmentLeft;
        _contentLable.textColor = RGBCOLOR(0, 0, 0 );
        _contentLable.text = @"私信收益";
        
        _contentLable.font = [UIFont systemFontOfSize:15];
    }
    return _contentLable;
}
- (UISwitch *)openSwitch {
    if (!_openSwitch) {
        _openSwitch = [[UISwitch alloc]init];
        _openSwitch.on = YES;
        _openSwitch.onTintColor = kYellowColor;
    }
    return _openSwitch;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = RGBCOLOR(237, 237, 237);
    }
    return _lineView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
