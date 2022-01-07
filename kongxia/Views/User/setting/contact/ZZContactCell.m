//
//  ZZContactCell.m
//  zuwome
//
//  Created by angBiu on 2016/10/26.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZContactCell.h"

@implementation ZZContactCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        _titleLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentLeft textColor:kBlackTextColor fontSize:15 text:@""];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        _statusBtn = [[UIButton alloc] init];
        _statusBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_statusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_statusBtn addTarget:self action:@selector(statusBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _statusBtn.layer.cornerRadius = 2;
        _statusBtn.clipsToBounds = YES;
        _statusBtn.layer.borderWidth = 1;
        [self.contentView addSubview:_statusBtn];
        
        [_statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(49, 22));
            make.left.mas_equalTo(_titleLabel.mas_right).offset(15);
        }];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = kLineViewColor;
        [self.contentView addSubview:_lineView];
        
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.height.mas_equalTo(@0.5);
        }];
    }
    
    return self;
}

- (void)statusBtnClick
{
    if (_touchStatus) {
        _touchStatus();
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
