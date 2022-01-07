//
//  ZZSignUpCityCell.m
//  zuwome
//
//  Created by angBiu on 2016/11/14.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZInternationalCityCell.h"

@implementation ZZInternationalCityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _cityLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentLeft textColor:kBlackTextColor fontSize:15 text:@""];
        [self.contentView addSubview:_cityLabel];
        
        [_cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        _codeLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentRight textColor:kBlackTextColor fontSize:12 text:@""];
        [self.contentView addSubview:_codeLabel];
        
        [_codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
    }
    
    return self;
}

- (void)setData:(ZZInternationalCityModel *)model
{
    _cityLabel.text = model.name;
    _codeLabel.text = model.code;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
