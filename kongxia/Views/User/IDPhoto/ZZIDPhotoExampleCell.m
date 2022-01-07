//
//  ZZIDPhotoExampleCell.m
//  zuwome
//
//  Created by qiming xiao on 2019/1/16.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZIDPhotoExampleCell.h"

@interface ZZIDPhotoExampleCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UIImageView *example1ImageView;

@property (nonatomic, strong) UIImageView *example2ImageView;

@property (nonatomic, strong) UIImageView *example3ImageView;

@property (nonatomic, strong) UILabel *descriptLabel;
@end

@implementation ZZIDPhotoExampleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
        
    }
    return self;
}

- (void)tips:(NSString *)tips {
    if (!isNullString(tips)) {
        _descriptLabel.attributedText = [self attributesForTips:tips];
    }
}

- (NSAttributedString *)attributesForTips:(NSString *)tips {
    NSMutableAttributedString *mutbaleAttr = [[NSMutableAttributedString alloc] initWithString:tips attributes:nil];
    
    // 字体
    [mutbaleAttr addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:13.0]
                        range:NSMakeRange(0, mutbaleAttr.length)];
    
    // 字体颜色
    [mutbaleAttr addAttribute:NSForegroundColorAttributeName
                        value:RGBCOLOR(153, 153, 153)
                        range:NSMakeRange(0, mutbaleAttr.length)];
    
    // 行高
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [mutbaleAttr addAttribute:NSParagraphStyleAttributeName
                        value:paragraphStyle
                        range:NSMakeRange(0, mutbaleAttr.length)];
    
    return mutbaleAttr.copy;
}

#pragma mark - UI
- (void)layout {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subTitleLabel];
    [self.contentView addSubview:self.example1ImageView];
    [self.contentView addSubview:self.example2ImageView];
    [self.contentView addSubview:self.example3ImageView];
    [self.contentView addSubview:self.descriptLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(35.0);
        make.leading.equalTo(self.contentView).offset(41.0);
        make.trailing.equalTo(self.contentView).offset(-41.0);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(6);
        make.left.equalTo(self.contentView).offset(41.0);
        make.right.equalTo(self.contentView).offset(-41.0);
    }];
    
    CGSize imageSize = CGSizeMake(91.0, 117.0);
    CGFloat offset = (SCREEN_WIDTH - imageSize.width * 3 - 41.0 * 2) * 0.5;
    [_example2ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(_subTitleLabel.mas_bottom).offset(25.0);
        make.size.mas_equalTo(imageSize);
    }];

    [_example1ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_example2ImageView);
        make.size.mas_equalTo(imageSize);
        make.right.equalTo(_example2ImageView.mas_left).offset(-offset);
    }];

    [_example3ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_example2ImageView);
        make.size.mas_equalTo(imageSize);
        make.left.equalTo(_example2ImageView.mas_right).offset(offset);
    }];

    [_descriptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(41.0);
        make.right.equalTo(self.contentView).offset(-41.0);
        make.top.equalTo(_example2ImageView.mas_bottom).offset(32.0);
        make.bottom.equalTo(self.contentView).offset(-40.0);
    }];

}

#pragma mark - Setter&Getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = RGBCOLOR(63, 58, 58);
        _titleLabel.font = [UIFont systemFontOfSize:17.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"示例照片";
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textColor = RGBCOLOR(63, 58, 58);
        _subTitleLabel.font = [UIFont systemFontOfSize:11.0];
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        
        _subTitleLabel.text = @"（标准证件照，或比例合适、背景干净的照片会通过审核）";
    }
    return _subTitleLabel;
}

- (UIImageView *)example1ImageView {
    if (!_example1ImageView) {
        _example1ImageView = [[UIImageView alloc] init];
        _example1ImageView.contentMode = UIViewContentModeScaleAspectFill;
        _example1ImageView.image = [UIImage imageNamed:@"icPic1Sltp"];
    }
    return _example1ImageView;
}

- (UIImageView *)example2ImageView {
    if (!_example2ImageView) {
        _example2ImageView = [[UIImageView alloc] init];
        _example2ImageView.contentMode = UIViewContentModeScaleAspectFill;
        _example2ImageView.image = [UIImage imageNamed:@"icPic2Sltp"];
    }
    return _example2ImageView;
}

- (UIImageView *)example3ImageView {
    if (!_example3ImageView) {
        _example3ImageView = [[UIImageView alloc] init];
        _example3ImageView.contentMode = UIViewContentModeScaleAspectFill;
        _example3ImageView.image = [UIImage imageNamed:@"icPic3Sltp"];
    }
    return _example3ImageView;
}

- (UILabel *)descriptLabel {
    if (!_descriptLabel) {
        _descriptLabel = [[UILabel alloc] init];
        _descriptLabel.numberOfLines = 0;
        _descriptLabel.attributedText = [self attributesForTips:@"1.可以上传1寸、2寸等常见尺寸标准证件照。\n2.也可以按照标准证件照的站位自行拍摄，照片必须为本人正脸五官清晰照。\n3.审核通过后展示，将有效提升您的排名，获得更多收益."];
    }
    return _descriptLabel;
}

@end
