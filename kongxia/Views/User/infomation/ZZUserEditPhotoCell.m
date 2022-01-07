//
//  ZZUserEditPhotoCell.m
//  zuwome
//
//  Created by angBiu on 2017/3/8.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZUserEditPhotoCell.h"

@implementation ZZUserEditPhotoCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.contentView.backgroundColor = kBGColor;
        self.contentView.layer.borderColor = RGBCOLOR(196, 44, 59).CGColor;
        
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
        [self.contentView addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
        
        _coverBgView = [[UIView alloc] init];
        _coverBgView.backgroundColor = HEXACOLOR(0x000000, 0.7);
        [self.contentView addSubview:_coverBgView];
        
        [_coverBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
        
//        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//        _indicatorView.hidesWhenStopped = YES;
//        [self.contentView addSubview:_indicatorView];
//        
//        [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.mas_equalTo(self.contentView.mas_centerX);
//            make.centerY.mas_equalTo(self.contentView.mas_centerY);
//            make.size.mas_equalTo(CGSizeMake(30, 30));
//        }];
        
        _progressView = [[ZZCircleProgressView alloc] init];
        [self.contentView addSubview:_progressView];
        
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
        
        self.errorView.hidden = YES;
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelf)];
        [self addGestureRecognizer:recognizer];
        
    }
    return self;
}

- (UIView *)errorView {
    if (!_errorView) {
        _errorView = [[UIView alloc] init];
        [self.contentView addSubview:_errorView];
        
        [_errorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.left.mas_equalTo(self.contentView.mas_left).offset(10);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        }];
        
        _errorImgView = [[UIImageView alloc] init];
        _errorImgView.image = [UIImage imageNamed:@"icon_user_photoerror"];
        [_errorView addSubview:_errorImgView];
        
        [_errorImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_errorView.mas_centerX);
            make.top.mas_equalTo(_errorView.mas_top);
            make.size.mas_equalTo(CGSizeMake(24, 24));
        }];
        
        _errorLabel = [[UILabel alloc] init];
        _errorLabel.textAlignment = NSTextAlignmentCenter;
        _errorLabel.textColor = kRedTextColor;
        _errorLabel.font = [UIFont systemFontOfSize:15];
        _errorLabel.text = @"头像位置只能放置本人正脸五官清晰的照片哦";
        _errorLabel.numberOfLines = 0;
        [_errorView addSubview:_errorLabel];
        
        [_errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(_errorView);
            make.top.mas_equalTo(_errorImgView.mas_bottom).offset(10);
        }];
    }
    return _errorView;
}

- (void)tapSelf
{
    if (_touchSelf) {
        _touchSelf();
    }
}

@end
