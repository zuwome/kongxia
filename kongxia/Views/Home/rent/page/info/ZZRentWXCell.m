//
//  ZZRentWXCell.m
//  zuwome
//
//  Created by angBiu on 2017/6/1.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZRentWXCell.h"



@interface ZZRentWXCell ()

@property (nonatomic, strong) UIView *assistanceContentView;

@end

@implementation ZZRentWXCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.titleLabel.text = @"TA的微信号";
        [self.readBtn setTitle:@"查看" forState:UIControlStateNormal];
        self.contentLabel.hidden = YES;
        
        [self.contentView addSubview:self.assistanceContentView];
        [_assistanceContentView addSubview:self.assistContentLabel];
        [_assistanceContentView addSubview:self.assistBtn];
        
        [_assistanceContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.left.equalTo(self.contentView);
            make.height.equalTo(@33);
        }];
        
        [_assistContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.assistanceContentView).offset(37);
            make.centerY.mas_equalTo(self.assistanceContentView);
        }];
        
        [_assistBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.assistanceContentView.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.assistContentLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(60, 40));
        }];
    }
    return self;
}

- (void)setData:(ZZUser *)user {
    if ([[ZZUserHelper shareInstance].loginer.uid isEqualToString:user.uid]) {
        _readBtn.hidden = YES;
        _contentLabel.hidden = NO;
        self.assistanceContentView.hidden = YES;
        self.titleLabel.text = @"微信号";
        if (user.have_wechat_no) {
            _contentLabel.text = user.wechat.no;
        } else {
            _contentLabel.text = @"填微信 得收益";
        }
    } else {
        self.titleLabel.text = @"TA的微信号";
        if (user.can_see_wechat_no) {
            _readBtn.hidden = YES;
            _contentLabel.hidden = NO;
            _contentLabel.text = user.wechat.no;
            _assistContentLabel.text = @"虚假微信或无法通过添加要如何退款";
            _assistBtn.normalImage = [UIImage imageNamed:@"icProTk_ass"];
        } else {
            _readBtn.hidden = NO;
            _contentLabel.hidden = YES;
            _assistContentLabel.text = @"查看微信后无法添加怎么办?";
            _assistBtn.normalImage = [UIImage imageNamed:@"icProXq"];
        }
        self.assistanceContentView.hidden = NO;
    }
}

- (void)showAssistance {
    if (_delegate && [_delegate respondsToSelector:@selector(cellShowAssistance:)]) {
        [_delegate cellShowAssistance:self];
    }
}

#pragma mark -


- (UIView *)assistanceContentView {
    if (!_assistanceContentView) {
        _assistanceContentView = [[UIView alloc] init];
        _assistanceContentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAssistance)];
        [_assistanceContentView addGestureRecognizer:tap];
    }
    return _assistanceContentView;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        _imgView.image = [UIImage imageNamed:@"icWxhYlzly"];
        [self.contentView addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15.0);
            make.top.equalTo(self).offset(19.0);
            make.size.mas_equalTo(CGSizeMake(20, 17));
        }];
    }
    return _imgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightMedium)];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.imgView.mas_trailing).offset(3.0);
            make.top.equalTo(self.imgView);
        }];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = RGBCOLOR(254, 66, 70);
        _contentLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
        }];
    }
    return _contentLabel;
}

- (UIButton *)readBtn {
    if (!_readBtn) {
        _readBtn = [[UIButton alloc] init];
        [_readBtn setTitleColor:RGBCOLOR(254, 66, 70) forState:UIControlStateNormal];
        _readBtn.titleLabel.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightMedium)];
        
        _readBtn.layer.cornerRadius = 2;
        _readBtn.backgroundColor = RGBACOLOR(254, 66, 70, 0.13);
        _readBtn.userInteractionEnabled = NO;
        [self.contentView addSubview:_readBtn];
        [_readBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.contentLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(60, 32));
        }];
    }
    return _readBtn;
}

- (UILabel *)assistContentLabel {
    if (!_assistContentLabel) {
        _assistContentLabel = [[UILabel alloc] init];
        _assistContentLabel.textColor = RGBCOLOR(116, 116, 116);
        _assistContentLabel.font = ADaptedFontMediumSize(12);
        _assistContentLabel.text = @"查看微信后无法添加怎么办?";
    }
    return _assistContentLabel;
}

- (UIButton *)assistBtn {
    if (!_assistBtn) {
        _assistBtn = [[UIButton alloc] init];
        _assistBtn.normalImage = [UIImage imageNamed:@"icProTk_ass"];
        _assistBtn.userInteractionEnabled = NO;
    }
    return _assistBtn;
}

@end
