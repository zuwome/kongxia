//
//  ZZRentMemedaQuestionCell.m
//  zuwome
//
//  Created by angBiu on 16/8/11.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRentMemedaQuestionCell.h"

#import "ZZMemedaQuestionModel.h"

@implementation ZZRentMemedaQuestionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines = 0;
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.top.mas_equalTo(self.contentView.mas_top).offset(15);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-15);
        }];
    }
    
    return self;
}

- (void)setData:(ZZMemedaQuestionModel *)model
{
    _titleLabel.text = model.content;
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
