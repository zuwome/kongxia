//
//  ZZIDPhotoStatusCell.m
//  zuwome
//
//  Created by qiming xiao on 2019/1/16.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZIDPhotoStatusCell.h"

@interface ZZIDPhotoStatusCell ()

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UIButton *actionButton;

@end

@implementation ZZIDPhotoStatusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)photoModel:(ZZIDPhoto *)photo {
    // 0.无证件照 1.待审核 2.已审核 3.不通过
    NSString *title = nil, *buttonTitle = @"上传证件照", *iconStr = @"ic_chakan_zjz";
    if (!photo) {
        title = @"展示您普通2寸或其他尺寸纯色背景证件照片，会有效增加你的排名，获取更多收益";
    }
    else if (photo.status == 0) {
        title = @"展示您普通2寸或其他尺寸纯色背景证件照片，会有效增加你的排名，获取更多收益";//@"证件照与头像确认为本人";
    }
    else if (photo.status == 1) {
        title = @"展示您普通2寸或其他尺寸纯色背景证件照片，会有效增加你的排名，获取更多收益";
        buttonTitle = @"证件照审核中";
    }
    else if (photo.status == 2) {
        title = @"展示您普通2寸或其他尺寸纯色背景证件照片，会有效增加你的排名，获取更多收益";
        buttonTitle = @"管理证件照";
    }
    else if (photo.status == 3) {
        title = photo.reason;
        iconStr = @"ID_Photo_DenyIcon";
    }
    
    _descLabel.text = title;
    [_actionButton setTitle:buttonTitle forState:UIControlStateNormal];
    _iconImageView.image = [UIImage imageNamed:iconStr];
}

#pragma mark - UI
- (void)layout {
    [self addSubview:self.iconImageView];
    [self addSubview:self.descLabel];
    [self addSubview:self.actionButton];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(19.0);
        make.top.equalTo(self).offset(19.0);
        make.size.mas_equalTo(CGSizeMake(15.0, 16.0));
    }];
    
    [_actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-15.0);
        make.size.mas_equalTo(CGSizeMake(95.0, 32.0));
    }];
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(19.0);
        make.left.equalTo(_iconImageView.mas_right).offset(6.0);
        make.right.equalTo(_actionButton.mas_left).offset(-23.0);
    }];
}

#pragma mark - Setter&Getter
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.font = [UIFont systemFontOfSize:13.0];
        _descLabel.numberOfLines = 0;
    }
    return _descLabel;
}

- (UIButton *)actionButton {
    if (!_actionButton) {
        _actionButton = [[UIButton alloc] init];
        [_actionButton setTitleColor:RGBCOLOR(254, 66, 70) forState:UIControlStateNormal];
        [_actionButton setBackgroundColor:RGBACOLOR(255, 106, 101, 0.13)];
        _actionButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
        _actionButton.layer.cornerRadius = 2.0;
        _actionButton.userInteractionEnabled = NO;
    }
    return _actionButton;
}
@end
