//
//  ZZIDPhotoAddCell.m
//  zuwome
//
//  Created by qiming xiao on 2019/1/16.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZIDPhotoAddCell.h"

@interface ZZIDPhotoAddCell ()

@property (nonatomic, strong) UIImageView *photoBackView;

@property (nonatomic, strong) UIImageView *photoImageView;

@property (nonatomic, strong) UIImageView *descImageView;

@property (nonatomic, strong) UIImageView *warningImageView;

@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation ZZIDPhotoAddCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)idImage:(UIImage *)image {
    _photoImageView.hidden = image ? YES : NO ;
    _photoBackView.image = image;
}

- (void)idImageStr:(NSString *)imageStr {
    _photoImageView.hidden = !isNullString(imageStr) ? YES : NO ;
    
    [_photoBackView sd_setImageWithURL:[NSURL URLWithString:imageStr]
                      placeholderImage:nil
                               options:(SDWebImageRetryFailed)];
}

- (void)desc:(NSString *)desc {
    if (isNullString(desc)) {
        return;
    }
    _warningImageView.hidden = NO;
    _statusLabel.text = desc;
}

- (void)showSelections {
    if (_delegate && [_delegate respondsToSelector:@selector(cell:shouldAddPhoto:)]) {
        [_delegate cell:self shouldAddPhoto:YES];
    }
}

#pragma mark - UI
- (void)layout {
    [self.contentView addSubview:self.photoBackView];
    [self.photoBackView addSubview:self.photoImageView];
    [self.photoBackView addSubview:self.descImageView];
    [self.contentView addSubview:self.warningImageView];
    [self.contentView addSubview:self.statusLabel];
    
    
    [_photoBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(54);
        make.right.equalTo(self.contentView).offset(-54);
        make.top.equalTo(self.contentView).offset(40);
        make.size.mas_equalTo(CGSizeMake(267.0, 341.0));
    }];
    
    [_photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_photoBackView);
        make.size.mas_equalTo(CGSizeMake(44.0, 44.0));
    }];
    
    [_descImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_photoBackView);
        make.bottom.equalTo(_photoBackView).offset(-14.5);
        make.size.mas_equalTo(CGSizeMake(73.0, 32.0));
    }];
    
    [_warningImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(44.0);
        make.top.equalTo(_photoBackView.mas_bottom).offset(13.0);
        make.size.mas_equalTo(CGSizeMake(15.0, 15.0));
    }];
    
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(69);
        make.right.equalTo(self.contentView).offset(-54);
        make.top.equalTo(_photoBackView.mas_bottom).offset(13.0);
        make.bottom.equalTo(self.contentView);
    }];
}

#pragma mark - Setter&Getter
- (UIImageView *)photoBackView {
    if (!_photoBackView) {
        _photoBackView = [[UIImageView alloc] init];
        _photoBackView.backgroundColor = RGBCOLOR(216, 216, 216);
        _photoBackView.layer.cornerRadius = 11.0;
        _photoBackView.userInteractionEnabled = YES;
        _photoBackView.contentMode = UIViewContentModeScaleAspectFill;
        _photoBackView.layer.masksToBounds = YES;
        
//        [_photoBackView sd_setImageWithURL:[NSURL URLWithString:_loginer.id_photo.pic]
//                          placeholderImage:nil
//                                   options:(SDWebImageRetryFailed)];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSelections)];
        [_photoBackView addGestureRecognizer:tap];
    }
    return _photoBackView;
}

- (UIImageView *)photoImageView {
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc] init];
        _photoImageView.image = [UIImage imageNamed:@"addIDPhoto_Big"];
        _photoImageView.userInteractionEnabled = YES;
        
//        if (!isNullString(_loginer.id_photo.pic)) {
//            _photoImageView.hidden = YES;
//        }
    }
    return _photoImageView;
}

- (UIImageView *)descImageView {
    if (!_descImageView) {
        _descImageView = [[UIImageView alloc] init];
        _descImageView.image = [UIImage imageNamed:@"upload"];
        _descImageView.userInteractionEnabled = YES;
    }
    return _descImageView;
}

- (UIImageView *)warningImageView {
    if (!_warningImageView) {
        _warningImageView = [[UIImageView alloc] init];
        _warningImageView.image = [UIImage imageNamed:@"icWarning"];
        _warningImageView.hidden = YES;
    }
    return _warningImageView;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = [UIFont systemFontOfSize:13.0];
        _statusLabel.textColor = RGBCOLOR(231, 74, 70);
        _statusLabel.numberOfLines = 0;
    }
    return _statusLabel;
}
@end
