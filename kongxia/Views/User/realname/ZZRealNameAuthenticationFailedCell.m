//
//  ZZRealNameAuthenticationFailed.m
//  zuwome
//
//  Created by 潘杨 on 2018/7/5.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZRealNameAuthenticationFailedCell.h"
@interface ZZRealNameAuthenticationFailedCell()
@property (nonatomic,strong) UIView *bgView;

/**
 认证失败的title
 */
@property (nonatomic,strong) UILabel *titlePromptLab;

@property (nonatomic,strong) UIImageView *arrowImageView;

@end
@implementation ZZRealNameAuthenticationFailedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = kBGColor;

        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.titlePromptLab];
        [self.bgView addSubview:self.arrowImageView];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(12);
        make.left.mas_equalTo(self.contentView.mas_left).offset(8);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-8);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
    [self.titlePromptLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(22.5);
        make.centerY.equalTo(self.bgView.mas_centerY);
        
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-14.5);
        make.centerY.equalTo(self.bgView.mas_centerY);

    }];
}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 3;
     
    }
    return _bgView;
}

- (UILabel *)titlePromptLab {
    if (!_titlePromptLab) {
        _titlePromptLab = [[UILabel alloc]init];
        _titlePromptLab.font = CustomFont(15);
        _titlePromptLab.textColor = kBlackColor;
        _titlePromptLab.textAlignment = NSTextAlignmentLeft;
//        _titlePromptLab.text = @"认证失败?";
        _titlePromptLab.text = @"身份信息人工审核";
    }
    return _titlePromptLab;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc]init];
        _arrowImageView.image = [UIImage imageNamed:@"icon_rightBtn2"];
    }
    return _arrowImageView;
}
@end
