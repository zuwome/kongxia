//
//  ZZChuZuPrivateChat.m
//  zuwome
//
//  Created by 潘杨 on 2018/4/24.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZChuZuPrivateChatCell.h"
@interface ZZChuZuPrivateChatCell()
@property (nonatomic, strong) UIView *lineView;//分割线
@property (nonatomic, strong) UIView *bgView;//分割线
@end
@implementation ZZChuZuPrivateChatCell

+ (NSString *)reuseIdentifier {
    return @"ZZChuZuPrivateChatID";
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.openSwitch];
        [self.contentView addSubview:self.titleLable];
        [self.contentView addSubview:self.promptLable];
        [self.contentView addSubview:self.contentLable];
        [self.contentView addSubview:self.lineView];
        self.contentView.backgroundColor = HEXCOLOR(0xF7F7F7);
    }
    return self;
}

- (void)layoutSubviews {
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@35);
        make.left.offset(15);
        make.top.offset(0);
        make.right.offset(-15);
    }];
    [self.openSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentLable.mas_centerY);
        make.right.offset(-15);
    }];
    [self.contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.equalTo(self.openSwitch.mas_left).offset(10);
        make.top.equalTo(self.titleLable.mas_bottom);
        make.height.equalTo(@58);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(self.contentLable.mas_bottom);
        make.right.offset(-15);
        make.height.equalTo(@0.5);
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.titleLable.mas_bottom);
        make.bottom.offset(0);
    }];
    
    [self.promptLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(self.lineView.mas_bottom);
        make.right.offset(-15);
        make.bottom.offset(0);
    }];
    
 
    
}


- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}
- (UILabel *)titleLable {
    if (!_titleLable) {
        _titleLable = [[UILabel alloc]init];
        _titleLable.text = @"开启私信收益";
        _titleLable.textColor = RGBCOLOR(171, 171, 171);
        _titleLable.font = [UIFont systemFontOfSize:12];
        _titleLable.textAlignment = NSTextAlignmentLeft;

    }
    return _titleLable;
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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
