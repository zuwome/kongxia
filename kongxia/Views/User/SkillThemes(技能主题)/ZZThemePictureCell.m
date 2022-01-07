//
//  ZZThemePictureCell.m
//  zuwome
//
//  Created by MaoMinghui on 2018/8/1.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZThemePictureCell.h"

@interface ZZThemePictureCell ()

//@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIImageView *addIcon;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIView *coverBg;
@property (nonatomic, strong) UILabel *coverLabel;
@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation ZZThemePictureCell

- (void)createView{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSArray *gestureArray = [self.contentView.gestureRecognizers copy];
    for (UIGestureRecognizer *gesture in gestureArray) {
        [self.contentView removeGestureRecognizer:gesture];
    }
    
    if (self.cellType == ThemePictureTypeAdd) {
        self.contentView.backgroundColor = RGBCOLOR(236, 236, 236);
        [self.contentView addSubview:self.addIcon];
        [self.addIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.centerY.equalTo(self.contentView).offset(-12);
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
        [self.contentView addSubview:self.tipLabel];
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@17);
            make.centerX.equalTo(self.contentView);
            make.leading.trailing.equalTo(@0);
            make.bottom.equalTo(self.contentView).offset(-8);
        }];
        //添加上传图片点击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPictureClick)];
        [self.contentView addGestureRecognizer:tap];
    }
    if (self.cellType != ThemePictureTypeAdd) {     //添加图片
        [self.contentView addSubview:self.themePicture];    //图片
        [self.themePicture mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
        [self.contentView addSubview:self.progressView];    //图片上传loading
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        [self.contentView addSubview:self.deleteBtn];       //删除按钮
        [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(-6);
            make.trailing.equalTo(self.contentView).offset(6);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
    }
    if (self.cellType == ThemePictureTypeCover) {   //添加封面
        [self.contentView addSubview:self.coverBg];
        [self.coverBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(self.contentView);
            make.height.equalTo(@22);
        }];
        [self.contentView addSubview:self.coverLabel];
        [self.coverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.coverBg);
        }];
    }
    
    [self.contentView bringSubviewToFront:self.deleteBtn];
}

//添加图片
- (void)addPictureClick {
    !self.addPicture ? : self.addPicture();
}

//删除图片
- (void)deletePictureClick {
    !self.deletePicture ? : self.deletePicture();
}

#pragma mark -- setter
- (void)setCellType:(ThemePictureType)cellType {
    _cellType = cellType;
    [self createView];
}

#pragma mark -- lazy load
//- (UIImageView *)imageView {
//    if (nil == _imageView) {
//        _imageView = [[UIImageView alloc] init];
//    }
//    return _imageView;
//}
- (UIImageView *)addIcon {
    if (nil == _addIcon) {
        _addIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ThemePicAdd"]];
    }
    return _addIcon;
}
- (UILabel *)tipLabel {
    if (nil == _tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = @"最多上传3张照片";
        _tipLabel.textColor = RGBCOLOR(153, 153, 153);
        _tipLabel.font = [UIFont systemFontOfSize:12];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}
- (UIView *)coverBg {
    if (nil == _coverBg) {
        _coverBg = [[UIView alloc] init];
        _coverBg.backgroundColor = RGBACOLOR(249, 94, 94, 0.5);
    }
    return _coverBg;
}
- (UILabel *)coverLabel {
    if (nil == _coverLabel) {
        _coverLabel = [[UILabel alloc] init];
        _coverLabel.backgroundColor = [UIColor clearColor];
        _coverLabel.text = @"封面";
        _coverLabel.textColor = [UIColor whiteColor];
        _coverLabel.font = [UIFont systemFontOfSize:14];
        _coverLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _coverLabel;
}
- (UIImageView *)themePicture {
    if (nil == _themePicture) {
        _themePicture = [[UIImageView alloc] init];
        _themePicture.contentMode = UIViewContentModeScaleAspectFill;
        _themePicture.clipsToBounds = YES;
    }
    return _themePicture;
}
- (UIButton *)deleteBtn {
    if (nil == _deleteBtn) {
        _deleteBtn = [[UIButton alloc] init];
        [_deleteBtn setImage:[UIImage imageNamed:@"icDeleteSc"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deletePictureClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}
- (ZZCircleProgressView *)progressView {
    if (nil == _progressView) {
        _progressView = [[ZZCircleProgressView alloc] init];
    }
    return _progressView;
}

@end
