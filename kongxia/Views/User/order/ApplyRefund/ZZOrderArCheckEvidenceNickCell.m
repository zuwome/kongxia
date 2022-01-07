//
//  ZZOrderArCheckEvidenceNickCell.m
//  zuwome
//
//  Created by 潘杨 on 2018/5/31.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZOrderArCheckEvidenceNickCell.h"
@interface ZZOrderArCheckEvidenceNickCell()
@property (nonatomic,strong)UILabel *nickNameLab;
@end

@implementation ZZOrderArCheckEvidenceNickCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.nickNameLab];
    }
    return self;
}
- (void)setShowTitle:(NSString *)title detailTitle:(NSString *)detailTitle dataArray:(NSArray*)array viewController:(UIViewController *)viewController {
    [super setShowTitle:title detailTitle:detailTitle dataArray:array viewController:viewController];
    _nickNameLab.text = detailTitle;
}

- (UILabel *)nickNameLab {
    if (!_nickNameLab) {
        _nickNameLab = [[UILabel alloc]init];
        _nickNameLab.textColor = kBlackColor;
        _nickNameLab.font = ADaptedFontBoldSize(15);
        _nickNameLab.textAlignment = NSTextAlignmentLeft;
    }
    return _nickNameLab;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.nickNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.left.offset(14.5);
        make.right.offset(-14.5);
        make.bottom.equalTo(self.lineView.mas_top).offset(-15);
    }];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(14.5);
        make.right.offset(-14.5);
        make.bottom.offset(0);
        make.height.equalTo(@0.5);
    }];
    
}


@end
