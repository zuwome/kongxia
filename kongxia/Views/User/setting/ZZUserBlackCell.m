//
//  ZZUserBlackCell.m
//  zuwome
//
//  Created by angBiu on 16/9/21.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZUserBlackCell.h"

#import "ZZUserBlackModel.h"

@implementation ZZUserBlackCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _headImgView = [[ZZHeadImageView alloc] init];
        [self.contentView addSubview:_headImgView];
        
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImgView.mas_right).offset(15);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-90);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:@"取消拉黑" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:kYellowColor forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_cancelBtn];
        
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(70, 50));
        }];
    }
    
    return self;
}

- (void)setData:(ZZUserBlackModel *)model
{
    [_headImgView setUser:model.black.beUser width:50 vWidth:12];
    _titleLabel.text = model.black.beUser.nickname;
}

- (void)cancelBtnClick
{
    if (_touchCancel) {
        _touchCancel();
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
