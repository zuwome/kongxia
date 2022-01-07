//
//  ZZCheckOtherUploadEvidence.m
//  zuwome
//
//  Created by 潘杨 on 2018/5/30.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZCheckOtherUploadEvidence.h"
@interface ZZCheckOtherUploadEvidence ()

@property(nonatomic,strong) UIImageView *arrowImageView;

@property(nonatomic,strong) UIImageView *imageCurrentView;
@property(nonatomic,strong) UIView *bgView;

@end

@implementation ZZCheckOtherUploadEvidence

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor =  HEXCOLOR(0xf5f5f5);
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.imageCurrentView];
        [self.bgView addSubview:self.arrowImageView];
        [self.bgView addSubview:self.titleLab];
    }
    
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(8);
        make.right.offset(-8);
        make.bottom.offset(0);
        make.top.offset(8);
    }];
    [self.imageCurrentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(13);
        make.centerY.equalTo(self.bgView.mas_centerY);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-12);
        make.centerY.equalTo(self.bgView.mas_centerY);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.left.equalTo(self.imageCurrentView.mas_right).offset(9);
    }];
    
}
- (UIImageView *)imageCurrentView {
    if (!_imageCurrentView) {
        _imageCurrentView = [[UIImageView alloc]init];
        _imageCurrentView.image = [UIImage imageNamed:@"icPicEvidence"];
        _imageCurrentView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageCurrentView;
}

-(UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc]init];
        _arrowImageView.image = [UIImage imageNamed:@"icon_fast_right"];
        _arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _arrowImageView;
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.font = CustomFont(13);
        _titleLab.textColor = kBlackTextColor;
        _titleLab.text = @"查看对方上传的证据";
        _titleLab.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLab;
}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 3;
        _bgView.layer.shadowColor = HEXCOLOR(0xdedcce).CGColor;
        _bgView.layer.shadowOffset = CGSizeMake(0, 1);
        _bgView.layer.shadowOpacity = 0.9;
        _bgView.layer.shadowRadius = 1;
    }
    return _bgView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
