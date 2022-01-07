//
//  ZZPublishOrderExpandSwitchCell.m
//  zuwome
//
//  Created by YuTianLong on 2017/10/12.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZPublishOrderExpandSwitchCell.h"

@interface ZZPublishOrderExpandSwitchCell ()

@property (nonatomic, strong) UISwitch *expandSwitch;

@end

@implementation ZZPublishOrderExpandSwitchCell

+ (NSString *)reuseIdentifier {
    return @"ZZPublishOrderExpandSwitchCell";
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        commonInitSafe(ZZPublishOrderExpandSwitchCell);
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        commonInitSafe(ZZPublishOrderExpandSwitchCell);
    }
    return self;
}

- (void)setIsExpand:(NSString *)isExpand {
    _isExpand = isExpand;
}

commonInitImplementationSafe(ZZPublishOrderExpandSwitchCell) {

    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    _isExpand = @"1";   // 默认自动扩展
    
    UILabel *label = [UILabel new];
    label.text = @"人数不足时自动扩大范围";
    label.textColor = kBlackColor;
    label.font = [UIFont systemFontOfSize:15];
    
    self.expandSwitch = [[UISwitch alloc] init];
    self.expandSwitch.onTintColor = kYellowColor;
    self.expandSwitch.on = YES;
    [self.expandSwitch addTarget:self action:@selector(expandSwitchClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kLineViewColor;
    
    [self.contentView addSubview:label];
    [self.contentView addSubview:self.expandSwitch];
    [self.contentView addSubview:lineView];
    
    [self.expandSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@(-15));
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@15);
        make.top.bottom.equalTo(@0);
        make.trailing.equalTo(self.expandSwitch.mas_leading).offset(-5);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(@0.5);
    }];

}

- (void)expandSwitchClick:(UISwitch *)sender {
    if (sender.on) {
        _isExpand = @"1";
        BLOCK_SAFE_CALLS(self.expandSwitchBlock, @"1");
    } else {
        _isExpand = @"0";
        BLOCK_SAFE_CALLS(self.expandSwitchBlock, @"0");
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
