//
//  ZZRentSignCell.m
//  zuwome
//
//  Created by angBiu on 16/6/1.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRentSignCell.h"

@implementation ZZRentSignCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _signLabel = [[UILabel alloc] init];
        _signLabel.textAlignment = NSTextAlignmentLeft;
        _signLabel.textColor = kBlackTextColor;
        _signLabel.font = [UIFont systemFontOfSize:15];
        _signLabel.numberOfLines = 0;
        [self.contentView addSubview:_signLabel];
        
        [_signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.top.mas_equalTo(self.contentView.mas_top).offset(10);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
        }];
    }
    
    return self;
}

- (void)setData:(ZZUser *)user
{
    NSString *str;
    if (isNullString(user.bio)) {
        str = @"没个性，不签名";
    }
    else {
        str = [NSString stringWithFormat:@"签名：%@",user.bio];
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:str];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:6];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.length)];
    
    _signLabel.attributedText = attributedString;
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
