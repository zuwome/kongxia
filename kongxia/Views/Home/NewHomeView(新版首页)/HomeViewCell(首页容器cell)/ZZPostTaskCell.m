//
//  ZZPostTaskCell.m
//  zuwome
//
//  Created by qiming xiao on 2019/4/3.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZPostTaskCell.h"
#import <FLAnimatedImageView.h>
#import <FLAnimatedImage.h>

@interface ZZPostTaskCell ()

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIImageView *rightBgImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) FLAnimatedImageView *postTaskImageView;

@end

@implementation ZZPostTaskCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)goToPostTask {
    if (self.postTaskCallback) {
        self.postTaskCallback();
    }
}

#pragma mark - Layout
- (void)layout {
    [self.contentView addSubview:self.bgImageView];
    [_bgImageView addSubview:self.titleLabel];
    [_bgImageView addSubview:self.subTitleLabel];
    [self.contentView addSubview:self.postTaskImageView];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(7);
        make.bottom.right.equalTo(self).offset(-7);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgImageView).offset(64.0);
        make.top.equalTo(_bgImageView).offset(14.0);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel);
        make.top.equalTo(_titleLabel.mas_bottom).offset(3.0);
    }];
    
    [_postTaskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-3.0);
        make.right.equalTo(self).offset(-15.5);
        make.size.mas_equalTo(CGSizeMake(100, 83));
    }];
}

#pragma mark - getters and setters
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"bannerBg"];
    }
    return _bgImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"你想做什么?";
        _titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        _titleLabel.textColor = kBlackColor;
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.text = @"一大波通告正在来的路上 等会再来";
        _subTitleLabel.font = CustomFont(12);
        _subTitleLabel.textColor = RGBCOLOR(58, 58, 58);
    }
    return _subTitleLabel;
}

- (FLAnimatedImageView *)postTaskImageView {
    if (!_postTaskImageView) {
        _postTaskImageView = [[FLAnimatedImageView alloc] init];
        NSURL *gifLocalUrl = [[NSBundle mainBundle] URLForResource:@"PostTask" withExtension:@"gif"];
        NSData *gifData = [NSData dataWithContentsOfURL:gifLocalUrl];
        FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:gifData];
        _postTaskImageView.animatedImage = image;
        _postTaskImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToPostTask)];
        [_postTaskImageView addGestureRecognizer:tap];
    }
    return _postTaskImageView;
}

- (void)setModel:(PdModel *)model {
    _model = model;
    _titleLabel.text = model.title;
    _subTitleLabel.text = model.content;
}

@end
