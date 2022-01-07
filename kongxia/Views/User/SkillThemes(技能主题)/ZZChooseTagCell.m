//
//  ZZChooseTagCell.m
//  zuwome
//
//  Created by MaoMinghui on 2018/9/11.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZChooseTagCell.h"

@interface ZZChooseTagCell ()

@property (nonatomic, strong) UIButton *tagLab;

@end

@implementation ZZChooseTagCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self.contentView addSubview:self.tagLab];
    [self.tagLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)setTags:(ZZSkillTag *)tags {
    [self.tagLab setTitle:tags.name forState:(UIControlStateNormal)];
}

- (void)setCellSelected:(BOOL)cellSelected {
    _tagLab.layer.borderWidth = cellSelected ? 0 : 1;
    _tagLab.backgroundColor = cellSelected ? kGoldenRod : [UIColor whiteColor];
    
    _cellSelected = cellSelected;
    _tagLab.selected = cellSelected;
}

- (UIButton *)tagLab {
    if (nil == _tagLab) {
        _tagLab = [[UIButton alloc] init];
        [_tagLab setTitleColor:kBrownishGreyColor forState:(UIControlStateNormal)];
        [_tagLab setTitleColor:kBlackColor forState:(UIControlStateSelected)];
        _tagLab.titleLabel.font = [UIFont systemFontOfSize:13];
        _tagLab.titleLabel.textAlignment = NSTextAlignmentCenter;
        _tagLab.layer.borderWidth = _cellSelected ? 0 : 1;
        _tagLab.layer.borderColor = kGrayLineColor.CGColor;
        _tagLab.backgroundColor = _cellSelected ? kGoldenRod : [UIColor whiteColor];
        _tagLab.userInteractionEnabled = NO;
        _tagLab.layer.masksToBounds = YES;
        _tagLab.layer.cornerRadius = 2;
    }
    return _tagLab;
}

@end
