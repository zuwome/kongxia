//
//  ZZWalletTypeCell.m
//  zuwome
//
//  Created by angBiu on 16/10/19.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZWalletTypeCell.h"

@implementation ZZWalletTypeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _titleLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentLeft textColor:kBlackTextColor fontSize:15 text:@"充值方式"];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        _zfbBtn = [[UIButton alloc] init];
        [_zfbBtn setTitle:@"支付宝" forState:UIControlStateNormal];
        [_zfbBtn setTitle:@"支付宝" forState:UIControlStateSelected];
        [_zfbBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        [_zfbBtn setTitleColor:kBlackTextColor forState:UIControlStateSelected];
        _zfbBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_zfbBtn setImage:[UIImage imageNamed:@"btn_report_n"] forState:UIControlStateNormal];
        [_zfbBtn setImage:[UIImage imageNamed:@"btn_report_p"] forState:UIControlStateSelected];
        [_zfbBtn addTarget:self action:@selector(zfbBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _zfbBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        _zfbBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _zfbBtn.selected = YES;
        [self.contentView addSubview:_zfbBtn];
        
        [_zfbBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.top.mas_equalTo(self.contentView.mas_top);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.width.mas_equalTo(@88);
        }];
        
        _wxBtn = [[UIButton alloc] init];
        [_wxBtn setTitle:@"微信" forState:UIControlStateNormal];
        [_wxBtn setTitle:@"微信" forState:UIControlStateSelected];
        [_wxBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        [_wxBtn setTitleColor:kBlackTextColor forState:UIControlStateSelected];
        _wxBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_wxBtn setImage:[UIImage imageNamed:@"btn_report_n"] forState:UIControlStateNormal];
        [_wxBtn setImage:[UIImage imageNamed:@"btn_report_p"] forState:UIControlStateSelected];
        [_wxBtn addTarget:self action:@selector(wxBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _wxBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        _wxBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.contentView addSubview:_wxBtn];
        
        [_wxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_zfbBtn.mas_left).offset(-8);
            make.top.mas_equalTo(self.contentView.mas_top);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.width.mas_equalTo(@88);
        }];
        
    }
    
    return self;
}

- (void)setViewToRight
{
    [_wxBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_zfbBtn);
    }];
}

- (void)wxBtnClick
{
    _wxBtn.selected = YES;
    _zfbBtn.selected = NO;
    
    if (_selectedIndex) {
        _selectedIndex(1);
    }
}

- (void)zfbBtnClick
{
    _wxBtn.selected = NO;
    _zfbBtn.selected = YES;
    
    if (_selectedIndex) {
        _selectedIndex(2);
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
