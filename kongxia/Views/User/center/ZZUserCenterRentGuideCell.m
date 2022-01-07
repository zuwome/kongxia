//
//  ZZUserCenterRentGuideCell.m
//  zuwome
//
//  Created by angBiu on 2017/5/9.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZUserCenterRentGuideCell.h"

@implementation ZZUserCenterRentGuideCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = kGrayContentColor;
        label.font = [UIFont systemFontOfSize:14];
        label.numberOfLines = 0;
        label.text = @"分享时间 成为达人 让更多人发现你";
        [self.contentView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(45);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-30);
            make.top.mas_equalTo(self.contentView.mas_top).offset(15);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-15);
        }];
        
        UIImageView *arrowImgView = [[UIImageView alloc] init];
        arrowImgView.image = [UIImage imageNamed:@"icon_report_right"];
        [self.contentView addSubview:arrowImgView];
        
        [arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(6, 12.5));
        }];
    }
    
    return self;
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
