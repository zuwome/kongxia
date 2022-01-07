//
//  ZZAuthenticationFailedUploadImageView.m
//  zuwome
//
//  Created by 潘杨 on 2018/7/6.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZAuthenticationFailedUploadImageView.h"
@interface ZZAuthenticationFailedUploadImageView()
@property (nonatomic,strong) UILabel *titleLab;


@property (nonatomic,strong) UILabel *detailTitleLab;
@property (nonatomic,strong) UILabel *detailTitleSubLab;
@property (nonatomic,strong) UILabel *detailTitleSubSecndLab;


@end


@implementation ZZAuthenticationFailedUploadImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLab];
        [self addSubview:self.uploadImageButton];

        [self addSubview:self.detailTitleSubSecndLab];
        [self addSubview:self.detailTitleSubLab];
        [self addSubview:self.detailTitleLab];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(17);
    }];
    
    [self.uploadImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.offset(51);
    make.height.equalTo(self.uploadImageButton.mas_width).multipliedBy(183.5/345);
    }];
    
    [self.detailTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(self.uploadImageButton.mas_bottom).offset(20);
        
    }];
    
    [self.detailTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(self.uploadImageButton.mas_bottom).offset(20);
        
    }];
    [self.detailTitleSubLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(self.detailTitleLab.mas_bottom).offset(6);
        
    }];
    [self.detailTitleSubSecndLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(self.detailTitleSubLab.mas_bottom).offset(6);
        
    }];
    
}




- (UILabel *)detailTitleLab {
    if (!_detailTitleLab) {
        _detailTitleLab = [[UILabel alloc]init];
        _detailTitleLab.font = CustomFont(15);
        _detailTitleLab.textColor = kBlackTextColor;
        _detailTitleLab.text =  @"照片要求如下:";
    }
    return _detailTitleLab;
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.font = CustomFont(15);
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.textColor = kBlackTextColor;
        _titleLab.text = @"上传手持证件正面照片";
    }
    return _titleLab;
}

- (UILabel *)detailTitleSubLab {
    if (!_detailTitleSubLab) {
        _detailTitleSubLab = [[UILabel alloc]init];
        _detailTitleSubLab.font = CustomFont(13);
        _detailTitleSubLab.textAlignment = NSTextAlignmentLeft;
        _detailTitleSubLab.textColor = kBlackColor;
        _detailTitleSubLab.text = @"1.需本人手持证件（带有头像照片的一面）";
    }
    return _detailTitleSubLab;
}

- (UILabel *)detailTitleSubSecndLab {
    if (!_detailTitleSubSecndLab) {
        _detailTitleSubSecndLab = [[UILabel alloc]init];
        _detailTitleSubSecndLab.font = CustomFont(13);
        _detailTitleSubSecndLab.textAlignment = NSTextAlignmentLeft;
        _detailTitleSubSecndLab.textColor = kBlackColor;
        _detailTitleSubSecndLab.text = @"2.证件上的信息/号码/住址清晰可见";
    }
    return _detailTitleSubSecndLab;
}

- (UIButton *)uploadImageButton {
    if (!_uploadImageButton) {
        _uploadImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_uploadImageButton addTarget:self action:@selector(uploadImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_uploadImageButton setImage:[UIImage imageNamed:@"icPhotoPaperwork"] forState:UIControlStateNormal];
        _uploadImageButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _uploadImageButton;
}


- (void)uploadImageButtonClick:(UIButton *)sender {
    if (_uploadImageBlock) {
        _uploadImageBlock(sender);
    }
}


@end
