//
//  ZZRealNameNotMainlandBottomView.m
//  zuwome
//
//  Created by angBiu on 2017/2/23.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZRealNameNotMainlandBottomView.h"

#import "ZZBorderView.h"

@interface ZZRealNameNotMainlandBottomView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *firAddBtn;
@property (nonatomic, strong) UIView *firBgView;
@property (nonatomic, strong) UIImageView *firImgView;
@property (nonatomic, strong) UIButton *secAddBtn;
@property (nonatomic, strong) UIView *secBgView;
@property (nonatomic, strong) UIImageView *secImgView;
@property (nonatomic, strong) UILabel *firInfoLabel;
@property (nonatomic, strong) UILabel *secInfoLabel;
@property (nonatomic, assign) NSInteger index;

@end

@implementation ZZRealNameNotMainlandBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self createViews];
    }
    
    return self;
}

- (void)createViews
{
    self.bgView.hidden = NO;
    self.titleLabel.text = @"上传证件正面彩色清晰照";
    [self.firAddBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.secAddBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.secAddBtn.hidden = YES;
    self.firInfoLabel.numberOfLines = 0;
    self.secInfoLabel.numberOfLines = 0;
    [self.applyBtn addTarget:self action:@selector(applyBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setModel:(ZZRealname *)model
{
    [self.firImgView sd_setImageWithURL:[NSURL URLWithString:model.pic.front]];
    if (model.pic.hold) {
        [self.secImgView sd_setImageWithURL:[NSURL URLWithString:model.pic.hold]];
        self.secAddBtn.hidden = NO;
        self.secImgView.hidden = NO;
        self.secBgView.hidden = YES;
    }
}

#pragma mark - UIButtonMethod

- (void)addBtnClick:(UIButton *)sender
{
    [self.superview endEditing:YES];
    _index = sender.tag - 100;
    BOOL containImage = NO;
    switch (_index) {
        case 0:
        {
            if (_firImage) {
                containImage = YES;
            } else {
                containImage = NO;
            }
        }
            break;
        case 1:
        {
            if (_secImage) {
                containImage = YES;
            } else {
                containImage = NO;
            }
        }
            break;
        default:
            break;
    }
    if (containImage) {
        [UIActionSheet showInView:self.superview withTitle:@"是否删除照片" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"删除"] tapBlock:^(UIActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                [self deleteImageWithIndex:_index];
            }
        }];
    } else {
        [UIActionSheet showInView:self.superview withTitle:@"上传照片" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照",@"从手机相册选择"] tapBlock:^(UIActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                [self gotoCamera];
            }
            if (buttonIndex == 1) {
                [self gotoAlbum];
            }
        }];
    }
}

//相册
- (void)gotoAlbum
{
    __weak typeof(self)weakSelf = self;
  IOS_11_Show
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    [imgPicker setAllowsEditing:YES];
    [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    imgPicker.finalizationBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
       IOS_11_NO_Show
        [picker dismissViewControllerAnimated:YES completion:^{
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            [weakSelf setImage:image];

        }];
    };
    imgPicker.cancellationBlock = ^(UIImagePickerController *picker) {
        IOS_11_NO_Show
        [picker dismissViewControllerAnimated:YES completion:nil];
    };
    [_weakCtl.navigationController presentViewController:imgPicker animated:YES completion:nil];
}




//拍照
- (void)gotoCamera
{
    __weak typeof(self)weakSelf = self;
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    [imgPicker setAllowsEditing:YES];
    [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    imgPicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    imgPicker.finalizationBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
        [picker dismissViewControllerAnimated:YES completion:^{
            UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
            [weakSelf setImage:image];
        }];
    };
    imgPicker.cancellationBlock = ^(UIImagePickerController *picker) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    };
    [_weakCtl.navigationController presentViewController:imgPicker animated:YES completion:nil];
}

- (void)setImage:(UIImage *)image
{
    if (_index == 0) {
        _firImage = image;
        _firImgView.image = image;
        _firBgView.hidden = YES;
        _secAddBtn.hidden = NO;
    } else {
        _secImage = image;
        _secImgView.image = image;
        _secBgView.hidden = YES;
    }
    [self.imgArray addObject:image];
}

- (void)deleteImageWithIndex:(NSInteger)index
{
    if (index == 0) {
        if (_secImage) {
            _firImage = _secImage;
            _firImgView.image = _secImage;
        } else {
            _secAddBtn.hidden = YES;
            _firImage = nil;
            _firImgView.image = nil;
            _firBgView.hidden = NO;
            [self.imgArray removeObject:_firImage];
            return;
        }
    }
    _secImage = nil;
    _secImgView.image = nil;
    _secBgView.hidden = NO;
    [self.imgArray removeObject:_secImage];
}

- (void)applyBtnClick
{
    if (_touchApply) {
        _touchApply();
    }
}

#pragma mark - lazyload

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bgView];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.top.mas_equalTo(self.mas_top).offset(15);
        }];
    }
    return _bgView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [_bgView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(15);
            make.top.mas_equalTo(_bgView.mas_top).offset(10);
        }];
    }
    return _titleLabel;
}

- (UIButton *)firAddBtn
{
    if (!_firAddBtn) {
        _firAddBtn = [[UIButton alloc] init];
        _firAddBtn.tag = 100;
        [_bgView addSubview:_firAddBtn];
        
        [_firAddBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(15);
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(90, 90));
        }];
        
        _firBgView = [[UIView alloc] init];
        _firBgView.userInteractionEnabled = NO;
        [_firAddBtn addSubview:_firBgView];
        
        [_firBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_firAddBtn);
        }];
        
        ZZBorderView *borderView = [[ZZBorderView alloc] init];
        borderView.borderColor = kGrayContentColor;
        borderView.userInteractionEnabled = NO;
        [_firBgView addSubview:borderView];
        
        [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_firBgView);
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"icon_notmainland_logo"];
        imgView.userInteractionEnabled = NO;
        [_firBgView addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_firBgView.mas_top).offset(17);
            make.centerX.mas_equalTo(_firBgView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(36, 34));
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = kGrayContentColor;
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"+ 证件正面";
        label.userInteractionEnabled = NO;
        [_firBgView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(_firBgView);
            make.top.mas_equalTo(imgView.mas_bottom);
        }];
        
        _firImgView = [[UIImageView alloc] init];
        _firImgView.userInteractionEnabled = NO;
        _firImgView.contentMode = UIViewContentModeScaleAspectFit;
        [_firAddBtn addSubview:_firImgView];
        
        [_firImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_firAddBtn);
        }];
    }
    return _firAddBtn;
}

- (UIButton *)secAddBtn
{
    if (!_secAddBtn) {
        _secAddBtn = [[UIButton alloc] init];
        _secAddBtn.tag = 101;
        [_bgView addSubview:_secAddBtn];
        
        [_secAddBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_firAddBtn.mas_right).offset(12);
            make.centerY.mas_equalTo(_firAddBtn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(90, 90));
        }];
        
        _secBgView = [[UIView alloc] init];
        _secBgView.userInteractionEnabled = NO;
        [_secAddBtn addSubview:_secBgView];
        
        [_secBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_secAddBtn);
        }];
        
        ZZBorderView *borderView = [[ZZBorderView alloc] init];
        borderView.borderColor = kGrayContentColor;
        borderView.userInteractionEnabled = NO;
        [_secBgView addSubview:borderView];
        
        [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_secBgView);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = kGrayContentColor;
        label.font = [UIFont systemFontOfSize:38];
        label.text = @"+";
        label.userInteractionEnabled = NO;
        [_secBgView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_secBgView);
        }];
        
        _secImgView = [[UIImageView alloc] init];
        _secImgView.userInteractionEnabled = NO;
        _secImgView.contentMode = UIViewContentModeScaleAspectFit;
        [_secAddBtn addSubview:_secImgView];
        
        [_secImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_secAddBtn);
        }];
    }
    return _secAddBtn;
}

- (UILabel *)firInfoLabel
{
    if (!_firInfoLabel) {
        _firInfoLabel = [[UILabel alloc] init];
        _firInfoLabel.textColor = kGrayContentColor;
        _firInfoLabel.font = [UIFont systemFontOfSize:12];
        [_bgView addSubview:_firInfoLabel];
        
        [_firInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(15);
            make.right.mas_equalTo(_bgView.mas_right).offset(-15);
            make.width.mas_equalTo(SCREEN_WIDTH - 30);
            make.top.mas_equalTo(_firAddBtn.mas_bottom).offset(10);
        }];
        
        NSString *string = @"* 请上传包含:护照类型、个人信息、签发日期信息的证件照片";
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:string];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:kYellowColor range:NSMakeRange(0, 1)];
        _firInfoLabel.attributedText = attributedStr;
    }
    return _firInfoLabel;
}

- (UILabel *)secInfoLabel
{
    if (!_secInfoLabel) {
        _secInfoLabel = [[UILabel alloc] init];
        _secInfoLabel.textColor = kGrayContentColor;
        _secInfoLabel.font = [UIFont systemFontOfSize:12];
        _secInfoLabel.text = @"有效证件包括：大陆通行证，台胞证，护照，提交审核后，1-2个工作日处理结果将通知你";
        [_bgView addSubview:_secInfoLabel];
        
        [_secInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(15);
            make.right.mas_equalTo(_bgView.mas_right).offset(-15);
            make.width.mas_equalTo(SCREEN_WIDTH - 30);
            make.top.mas_equalTo(_firInfoLabel.mas_bottom).offset(5);
            make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-15);
        }];
    }
    return _secInfoLabel;
}

- (UIButton *)applyBtn
{
    if (!_applyBtn) {
        _applyBtn = [[UIButton alloc] init];
        [_applyBtn setTitle:@"提交审核" forState:UIControlStateNormal];
        [_applyBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        _applyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _applyBtn.backgroundColor = kYellowColor;
        _applyBtn.layer.cornerRadius = 3;
        [self addSubview:_applyBtn];
        
        [_applyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.right.mas_equalTo(self.mas_right).offset(-15);
            make.top.mas_equalTo(_bgView.mas_bottom).offset(15);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-20);
            make.height.mas_equalTo(@50);
        }];
    }
    return _applyBtn;
}

- (NSMutableArray *)imgArray
{
    if (!_imgArray) {
        _imgArray = [NSMutableArray array];
    }
    return _imgArray;
}

@end
