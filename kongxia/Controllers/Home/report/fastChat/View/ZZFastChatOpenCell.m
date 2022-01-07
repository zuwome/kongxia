//
//  ZZFastChatOpenCell.m
//  zuwome
//
//  Created by YuTianLong on 2017/12/29.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZFastChatOpenCell.h"

@interface ZZFastChatOpenCell ()


@property (nonatomic, strong) UIView *py_BackgroundView;//背景

@end

@implementation ZZFastChatOpenCell

+ (NSString *)reuseIdentifier {
    return @"ZZFastChatOpenCell";
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        commonInitSafe(ZZFastChatOpenCell);
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        commonInitSafe(ZZFastChatOpenCell);
    }
    return self;
}

commonInitImplementationSafe(ZZFastChatOpenCell) {

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = HEXCOLOR(0xf5f5f5);

    self.leftLabel = [UILabel new];

    self.leftLabel.textColor = kBlackColor;
    self.leftLabel.font = [UIFont systemFontOfSize:15];
    
    self.openSwitch = [[UISwitch alloc] init];
    self.openSwitch.onTintColor = kYellowColor;
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = RGBCOLOR(237, 237, 237);

    [self.py_BackgroundView addSubview:self.leftLabel];
    [self.py_BackgroundView addSubview:self.openSwitch];
    [self.py_BackgroundView addSubview:lineView];
    
    [self.contentView addSubview:self.py_BackgroundView];
    [self.contentView addSubview:self.promptLable];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@15);
        make.centerY.equalTo(self.py_BackgroundView.mas_centerY);
    }];
    
    [self.openSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@(-15));
        make.centerY.equalTo(self.py_BackgroundView.mas_centerY);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.leading.equalTo(@15);
        make.trailing.equalTo(@(-15));
        make.height.equalTo(@0.5);
    }];
    
    
    [self.py_BackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.height.mas_equalTo(AdaptedHeight(54));
    }];
    [self.promptLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.mas_equalTo(self.py_BackgroundView.mas_bottom);
        make.height.mas_equalTo(AdaptedHeight(32));
    }];
}


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
#pragma mark - 懒加载
- (UIView *)py_BackgroundView {
    if (!_py_BackgroundView) {
        _py_BackgroundView = [[UIView alloc]init];;
        _py_BackgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _py_BackgroundView;
}

- (UILabel *)promptLable {
    if (!_promptLable) {
        _promptLable = [[UILabel alloc]init];
        _promptLable.backgroundColor =  HEXCOLOR(0xf5f5f5);
        _promptLable.textAlignment = NSTextAlignmentLeft;
        UIFont *fontFirst = [UIFont fontWithName:@"PingFang-SC-Regular" size:15];
        if (fontFirst == nil) {
            _promptLable.font = [UIFont systemFontOfSize:15];
        }else{
        _promptLable.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
        }
        _promptLable.textColor = RGBCOLOR(171, 171, 171);
    }
    return _promptLable;
}
#pragma mark - Private methods

- (void)setupWithModel:(ZZUser *)model {
    
}

@end
