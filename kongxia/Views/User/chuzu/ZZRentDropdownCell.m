//
//  ZZRentDropdownCell.m
//  zuwome
//
//  Created by angBiu on 16/6/15.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRentDropdownCell.h"

@implementation ZZRentDropdownCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-60);
            make.bottom.mas_equalTo(self.contentView.mas_centerY).offset(-3);
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = kGrayContentColor;
        _contentLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLabel.mas_left);
            make.right.mas_equalTo(_titleLabel.mas_right);
            make.top.mas_equalTo(self.contentView.mas_centerY).offset(3);
        }];
        
        _clearImgView = [[UIImageView alloc] init];
        _clearImgView.image = [UIImage imageNamed:@"close_small"];
        _clearImgView.contentMode = UIViewContentModeRight;
        _clearImgView.userInteractionEnabled = YES;
        [self.contentView addSubview:_clearImgView];
        
        [_clearImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.width.mas_equalTo(@60);
        }];
        
        _seperateLine = [[UIView alloc] init];
        _seperateLine.backgroundColor = RGBCOLOR(237, 237, 237);
        [self.contentView addSubview:_seperateLine];
        [_seperateLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.height.equalTo(@0.5);
        }];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearClick)];
        recognizer.numberOfTapsRequired = 1;
        [_clearImgView addGestureRecognizer:recognizer];
    }
    
    return self;
}

- (void)clearClick
{
    if (_touchClear) {
        _touchClear();
    }
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
