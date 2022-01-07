//
//  ZZPostTaskPhotoCell.m
//  zuwome
//
//  Created by qiming xiao on 2019/3/19.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZPostTaskPhotoCell.h"
#import "kongxia-Swift.h"

#import "ZZPostTaskViewModel.h"

@interface ZZPostTaskPhotoCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UILabel *subDesTitleLabel;

@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) ZZPostTaskPhotoView *photoLeft;

@property (nonatomic, strong) ZZPostTaskPhotoView *photoCenter;

@property (nonatomic, strong) ZZPostTaskPhotoView *photoRight;

@property (nonatomic, copy) NSArray<ZZPostTaskPhotoView *> *photosArray;

@end

@implementation ZZPostTaskPhotoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configureData {
        _titleLabel.text = _cellModel.title;
        _subTitleLabel.text = _cellModel.subTitle;
        _subDesTitleLabel.text = _cellModel.subTitle1;
        
        _photoLeft.hidden = YES;
        _photoCenter.hidden = YES;
        _photoRight.hidden = YES;
        
    NSArray *photos = (NSArray *)_cellModel.data;
        if (!photos || photos.count == 0) {
            _photoLeft.hidden = NO;
            [_photoLeft.photoImageView sd_setImageWithURL:[NSURL URLWithString:@""]];
        }
        else {
            if (photos.count == 1) {
                _photoLeft.hidden = NO;
                _photoCenter.hidden = NO;
            }
            else if (photos.count == 2 || photos.count == 3) {
                _photoLeft.hidden = NO;
                _photoCenter.hidden = NO;
                _photoRight.hidden = NO;
            }
            
            for(NSInteger i = 0; i < 3; i++) {
                ZZPostTaskPhotoView *photoImageView = _photosArray[i];
                if (i <= photos.count - 1) {
                    ZZPhoto *photo = photos[i];
                    if (photo.image) {
                        photoImageView.photoImageView.image = photo.image;
                    }
                    else {
                        [photoImageView.photoImageView sd_setImageWithURL:[NSURL URLWithString:photo.url]];
                    }
                }
                else {
                    [photoImageView.photoImageView sd_setImageWithURL:[NSURL URLWithString:@""]];
                }
            }
        }
    
        if (_cellModel.taskType == TaskFree) {
            _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15.0];
            _titleLabel.textColor = RGBCOLOR(63, 58, 58);
            self.backgroundColor = UIColor.whiteColor;
        }
        else {
            _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12.0];
            _titleLabel.textColor = RGBCOLOR(102, 102, 102);
            self.backgroundColor = RGBCOLOR(252, 252, 252);
        }
}

- (void)select:(UITapGestureRecognizer *)recognizer {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:selectedIndex:)]) {
        [self.delegate cell:self selectedIndex:recognizer.view.tag];
    }
}

#pragma mark - UI
- (void)layout {
    self.backgroundColor = RGBCOLOR(252, 252, 252);
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subTitleLabel];
    [self.contentView addSubview:self.subDesTitleLabel];
    [self.contentView addSubview:self.photoLeft];
    [self.contentView addSubview:self.photoCenter];
    [self.contentView addSubview:self.photoRight];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15.0);
        make.left.equalTo(self).offset(15.0);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel);
        make.left.equalTo(_titleLabel.mas_right).offset(4.0);
    }];
    
    [_subDesTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel);
        make.left.equalTo(_subTitleLabel.mas_right).offset(5.0);
    }];
    
    [_photoLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(10.0);
        make.left.equalTo(self).offset(15.0);
        make.size.mas_equalTo(CGSizeMake(90.0, 90.0));
//        make.bottom.equalTo(self).offset(-15.0);
    }];
    
    [_photoCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_photoLeft);
        make.left.equalTo(_photoLeft.mas_right).offset(7.5);
        make.size.mas_equalTo(CGSizeMake(90.0, 90.0));
    }];
    
    [_photoRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_photoLeft);
        make.left.equalTo(_photoCenter.mas_right).offset(7.5);
        make.size.mas_equalTo(CGSizeMake(90.0, 90.0));
    }];
    
//    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self);
//        make.right.equalTo(self).offset(-15.0);
//        make.left.equalTo(self).offset(15.0);
//        make.height.equalTo(@0.5);
//    }];
    
    NSMutableArray *array = @[].mutableCopy;
    [array addObject: _photoLeft];
    [array addObject: _photoCenter];
    [array addObject: _photoRight];
    _photosArray = array.copy;
}

#pragma mark - Getter&Setter
- (void)setCellModel:(ZZPostTaskCellModel *)cellModel {
    _cellModel = cellModel;
    [self configureData];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = [UIFont systemFontOfSize:14];
        _subTitleLabel.textColor = RGBCOLOR(153, 153, 153);
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _subTitleLabel;
}

- (UILabel *)subDesTitleLabel {
    if (!_subDesTitleLabel) {
        _subDesTitleLabel = [[UILabel alloc] init];
        _subDesTitleLabel.font = [UIFont systemFontOfSize:12];
        _subDesTitleLabel.textColor = RGBCOLOR(153, 153, 153);
        _subDesTitleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _subDesTitleLabel;
}

- (ZZPostTaskPhotoView *)photoLeft {
    if (!_photoLeft) {
        _photoLeft = [[ZZPostTaskPhotoView alloc] init];
        _photoLeft.tag = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(select:)];
        [_photoLeft addGestureRecognizer:tap];
    }
    return _photoLeft;
}

- (ZZPostTaskPhotoView *)photoCenter {
    if (!_photoCenter) {
        _photoCenter = [[ZZPostTaskPhotoView alloc] init];
        _photoCenter.tag = 1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(select:)];
        [_photoCenter addGestureRecognizer:tap];
    }
    return _photoCenter;
}

- (ZZPostTaskPhotoView *)photoRight {
    if (!_photoRight) {
        _photoRight = [[ZZPostTaskPhotoView alloc] init];
        _photoRight.tag = 2;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(select:)];
        [_photoRight addGestureRecognizer:tap];
    }
    return _photoRight;
}

//- (UIView *)line {
//    if (!_line) {
//        _line = [[UIView alloc] init];
//        _line.backgroundColor = RGBCOLOR(237, 237, 237);
//    }
//    return _line;
//}


@end

@interface ZZPostTaskPhotoView ()

@end

@implementation ZZPostTaskPhotoView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self layout];
    }
    return self;
}

#pragma mark - UI
- (void)layout {
    self.image = [UIImage imageNamed:@"iconCheckBlack"];
    self.userInteractionEnabled = YES;
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.iconImage];
    [self addSubview:self.photoImageView];
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_iconImage);
        make.top.equalTo(_iconImage.mas_bottom).offset(8.5);
    }];
    
    [_photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - Getter&Setter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = RGBCOLOR(153, 153, 153);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"添加照片";
    }
    return _titleLabel;
}

- (UIImageView *)iconImage {
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc] init];
        _iconImage.image = [UIImage imageNamed:@"icTjtp"];
    }
    return _iconImage;
}

- (UIImageView *)photoImageView {
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc] init];
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _photoImageView.userInteractionEnabled = YES;
        _photoImageView.layer.masksToBounds = YES;
    }
    return _photoImageView;
}

@end
