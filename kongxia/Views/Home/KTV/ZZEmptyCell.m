//
//  ZZEmptyCell.m
//  kongxia
//
//  Created by qiming xiao on 2020/1/13.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

#import "ZZEmptyCell.h"

@interface ZZEmptyCell ()

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *actionBtn;

@property (nonatomic, strong) UIImageView *imageView1;

@property (nonatomic, strong) UIImageView *imageView2;

@end

@implementation ZZEmptyCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layout];
    }
    return self;
}

- (void)configureData:(NSInteger)type {
    NSString *title;
    NSString *icon;
    CGSize iconSize = CGSizeZero;
    BOOL showAction = NO;
    switch (type) {
        case 1: {
            title = @"还没有人发起点唱任务，快来做第一个发起人！";
            icon = @"picFaqichagnpa";
            iconSize = CGSizeMake(133, 85);
            break;
        }
        case 2: {
            title = @"去完成点唱任务，唱首歌就能领礼物";
            icon = @"picWcdchrw";
            iconSize = CGSizeMake(123, 112);
            showAction = YES;
            break;
        }
        case 3: {
            title = @"你太低调了！\n快去发起唱趴，让TA为你唱首歌";
            icon = @"picFaqichagnpa";
            iconSize = CGSizeMake(133, 85);
            break;
        }
        case 4: {
            title = @"去完成点唱任务，唱首歌就能领礼物";
            icon = @"picWcdchrw";
            iconSize = CGSizeMake(123, 112);
            showAction = YES;
            break;
        }
        case 5: {
            title = @"还没有人领取礼物，快来试下，唱歌就能领礼物";
            icon = @"picChgllw";
            iconSize = CGSizeMake(114, 112);
            showAction = NO;
            break;
        }
        default:
            break;
    }
    
    _titleLabel.text = title;
    _iconImageView.image = [UIImage imageNamed:icon];
    [_iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(iconSize);
    }];
    
    _actionBtn.hidden = !showAction;
    _imageView1.hidden = !showAction;
    _imageView2.hidden = !showAction;
}


#pragma mark - response method
- (void)action {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellShowAction:)]) {
        [self.delegate cellShowAction:self];
    }
}


#pragma mark - Layout
- (void)layout {
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.actionBtn];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(35);
        make.size.mas_equalTo(CGSizeMake(133, 112));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(_iconImageView.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(51.0);
        make.left.equalTo(self.contentView).offset(-51.0);
    }];
    
    [_actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(_titleLabel.mas_bottom).offset(16);
        make.size.mas_equalTo(CGSizeMake(60, 22.5));
    }];
    
    _imageView1 = [[UIImageView alloc] init];
    _imageView1.image = [UIImage imageNamed:@"icGengduoWddch"];
    [self.contentView addSubview:_imageView1];
    
    _imageView2 = [[UIImageView alloc] init];
    _imageView2.image = [UIImage imageNamed:@"icGengduoWddch"];
    [self.contentView addSubview:_imageView2];
    
    [_imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_actionBtn);
        make.left.equalTo(_actionBtn.mas_right);
        make.size.mas_equalTo(CGSizeMake(7, 14));
    }];
    [_imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_actionBtn);
        make.left.equalTo(_imageView1.mas_right);
        make.size.mas_equalTo(CGSizeMake(7, 14));
    }];
}

#pragma mark - getters and setters
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = ADaptedFontMediumSize(14);
        _titleLabel.textColor = RGBCOLOR(153, 153, 153);
        _titleLabel.textAlignment = NSTextAlignmentCenter;;
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UIButton *)actionBtn {
    if (!_actionBtn) {
        _actionBtn = [[UIButton alloc] init];
        _actionBtn.normalTitle = @"去看看";
        _actionBtn.normalTitleColor = RGBCOLOR(29, 125, 212);
        _actionBtn.titleLabel.font = ADaptedFontMediumSize(16);
        [_actionBtn addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionBtn;
}

@end
