//
//  ZZTaskPhotosCell.m
//  zuwome
//
//  Created by qiming xiao on 2019/3/20.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTaskPhotosCell.h"
#import "ZZTaskModel.h"

@interface ZZTaskPhotosCell ()

@property (nonatomic, strong) UIView *photoContentView;

@property (nonatomic, copy) NSArray<ZZTaskPhotosImageView *> *imageViewArray;

@end

@implementation ZZTaskPhotosCell
+ (NSString *)cellIdentifier {
    return @"ZZTaskPhotosCell";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)showPhotos:(UITapGestureRecognizer *)recognizer {
    NSInteger tag = recognizer.view.tag;
    NSArray *displayImage = [_item.task.task displayImages:_item.listType == ListAll];
    if ([_item isKindOfClass: [TaskPhotoItem class]]) {
        TaskPhotoItem *item = (TaskPhotoItem *)_item;
        if (item.listType == ListAll) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(cell:showPhotoWith:currentImgStr:)]) {
                [self.delegate cell:self showPhotoWith:item.task currentImgStr:displayImage[tag]];
            }
        }
        else {
            
            if ((TaskImageStatus)[item.task.task.imgsStatus[tag] intValue] == ImageStatusSuccess) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(cell:showPhotoWith:currentImgStr:)]) {
                    [self.delegate cell:self showPhotoWith:item.task currentImgStr:displayImage[tag]];
                }
            }
        }
    }
}

- (void)configureData {
   
    if ([_item isKindOfClass: [TaskPhotoItem class]]) {
        TaskPhotoItem *item = (TaskPhotoItem *)_item;
        
        if (_item.taskType == TaskFree && _item.task.task.isMine && !(_item.task.task.taskStatus == TaskOngoing || _item.task.task.taskStatus == TaskReviewing)) {
            _photoContentView.alpha = 0.6;
        }
        else {
            _photoContentView.alpha = 1.0;
        }
        
        if (_item.taskType == TaskFree) {
            self.backgroundColor = ColorClear;
            _photoContentView.backgroundColor = ColorWhite;
        }
        else {
            self.backgroundColor = RGBCOLOR(252, 252, 252);
            _photoContentView.backgroundColor = ColorClear;
        }
        
        NSArray *displayImage = [item.task.task displayImages:item.listType == ListAll];
        if (displayImage.count > 0) {
            [_imageViewArray enumerateObjectsUsingBlock:^(ZZTaskPhotosImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (displayImage.count == 0) {
                    obj.hidden = YES;
                }
                else {
                    obj.photoImageView.image = [UIImage new];
                    if (idx <= displayImage.count - 1) {
                        NSString *imageStr = displayImage[idx];
                        if (!isNullString(imageStr)) {
                            obj.hidden = NO;
                            if (item.listType == ListAll) {
                                [obj.photoImageView sd_setImageWithURL:[NSURL URLWithString:imageStr] completed:nil];
                                [obj hideDes];
                            }
                            else {
                                [obj configureDataWithStatue:(TaskImageStatus)[item.task.task.imgsStatus[idx] intValue] imageStr:imageStr];
                            }
                        }
                        else {
                            obj.hidden = YES;
                        }
                    }
                    else {
                        obj.hidden = YES;
                    }
                }
            }];
        }
    }
}

#pragma mark - Layout
- (void)layout {
    [self.contentView addSubview:self.photoContentView];
    
    NSMutableArray *imageArray = @[].mutableCopy;
    
    CGFloat offsetXL = 31.0;
    CGFloat offsetXR = 15.0;
    CGFloat offsetY = 0;
    
    CGFloat offsets = 9;
    CGFloat imageSize = (SCREEN_WIDTH - offsetXL - offsetXR - offsets * 2) / 3;
    [_photoContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(7);
        make.right.equalTo(self.contentView).offset(-7);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, imageSize + 13.0));
    }];
    for (int i = 0; i < 3; i++) {
        ZZTaskPhotosImageView *imageView = [[ZZTaskPhotosImageView alloc] initWithScale:imageSize / 99.0];
        imageView.tag = i;
        [_photoContentView addSubview:imageView];
        
        imageView.frame = CGRectMake(offsetXL + (imageSize + offsets) * (i % 3), offsetY, imageSize, imageSize);
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPhotos:)];
        [imageView addGestureRecognizer:tap];
        [imageArray addObject:imageView];
    }
    
    _imageViewArray = imageArray.copy;
}

#pragma mark - Getter&Setter
- (void)setItem:(TaskItem *)item {
    _item = item;
    [self configureData];
}

- (UIView *)photoContentView {
    if (!_photoContentView) {
        _photoContentView = [[UIView alloc] init];
    }
    return _photoContentView;
}

@end

@interface ZZTaskPhotosImageView()

@property (nonatomic, assign) CGFloat scale;


@end

@implementation ZZTaskPhotosImageView
- (instancetype)initWithScale:(NSInteger)scale {
    self = [super init];
    if (self) {
        _scale = scale;
        [self layout];
    }
    return self;
}

#pragma mark - UI
- (void)layout {
    [self addSubview:self.photoImageView];
    [self addSubview:self.statusView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.iconImage];
    
    [_photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(10 * _scale);
    }];
    
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_titleLabel);
        make.bottom.equalTo(_titleLabel.mas_top).offset((-4 * _scale));
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
}

- (void)configureDataWithStatue:(TaskImageStatus)status imageStr:(NSString *)imageStr {
    if (status == ImageStatusSuccess) {
        _photoImageView.hidden = NO;
        _statusView.hidden = YES;
        _titleLabel.hidden = YES;
        _iconImage.hidden = YES;
        [_photoImageView sd_setImageWithURL:[NSURL URLWithString:imageStr] completed:nil];
    }
    else if (status == ImageStatusReview) {
        _statusView.backgroundColor = ColorBlack;
        _statusView.alpha = 0.6;
        _photoImageView.hidden = NO;
        _statusView.hidden = NO;
        _titleLabel.hidden = NO;
        _iconImage.hidden = NO;
        _titleLabel.text = @"审核通过\n后显示";
        [_photoImageView sd_setImageWithURL:[NSURL URLWithString:imageStr] completed:nil];
    }
    else if (status == ImageStatusFail) {
        _statusView.backgroundColor = RGBCOLOR(230, 230, 230);
        _photoImageView.hidden = YES;
        _statusView.hidden = NO;
        _titleLabel.hidden = NO;
        _iconImage.hidden = NO;
        _titleLabel.text = @"内容敏感\n已被屏蔽";
    }
}

- (void)hideDes {
    _statusView.hidden = YES;
    _titleLabel.hidden = YES;
    _iconImage.hidden = YES;
}

#pragma mark - Getter&Setter
- (UIView *)statusView {
    if (!_statusView) {
        _statusView = [[UIView alloc] init];
        
        _statusView.hidden = NO;
    }
    return _statusView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:13 * _scale];
        _titleLabel.textColor = RGBCOLOR(153, 153, 153);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"内容敏感\n已被屏蔽";
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UIImageView *)iconImage {
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc] init];
        _iconImage.image = [UIImage imageNamed:@"copy"];
    }
    return _iconImage;
}

- (UIImageView *)photoImageView {
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc] init];
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _photoImageView.userInteractionEnabled = YES;
        _photoImageView.layer.masksToBounds = YES;
        _photoImageView.hidden = NO;
    }
    return _photoImageView;
}


@end
