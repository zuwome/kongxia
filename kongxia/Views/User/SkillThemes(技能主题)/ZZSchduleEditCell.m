//
//  ZZSchduleEditCell.m
//  zuwome
//
//  Created by MaoMinghui on 2018/8/1.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZSchduleEditCell.h"

@interface ZZSchduleEditCell ()

@property (nonatomic, strong) UIButton *scheduleBtn;

@end

@implementation ZZSchduleEditCell

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    [self createView];
}

- (void)createView {
    [self.contentView addSubview:self.scheduleBtn];
    [self.scheduleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    NSString *btnTitle = @"";
    switch (self.indexPath.row) {
        case 0:
        case 1:
        case 2: {
            btnTitle = [[ZZSkillThemesHelper shareInstance] scheduleConvertForKey:[NSString stringWithFormat:@"%ld",self.indexPath.row + 1]];
        } break;
        default: break;
    }
    [self.scheduleBtn setTitle:btnTitle forState:UIControlStateNormal];
    [self.scheduleBtn setTitle:btnTitle forState:UIControlStateSelected];
}

- (void)setCellSelected:(BOOL)cellSelected {
    _cellSelected = cellSelected;
    if (cellSelected) {
        self.scheduleBtn.backgroundColor = RGBCOLOR(244, 203, 7);
        self.scheduleBtn.layer.borderWidth = 0;
    } else {
        self.scheduleBtn.backgroundColor = [UIColor whiteColor];
        self.scheduleBtn.layer.borderWidth = 1;
    }
    self.scheduleBtn.selected = cellSelected;
}

- (UIButton *)scheduleBtn {
    if (nil == _scheduleBtn) {
        _scheduleBtn = [[UIButton alloc] init];
        [_scheduleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_scheduleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        _scheduleBtn.backgroundColor = [UIColor whiteColor];
        _scheduleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _scheduleBtn.layer.masksToBounds = YES;
        _scheduleBtn.layer.cornerRadius = 3;
        _scheduleBtn.layer.borderColor = RGBCOLOR(190, 190, 190).CGColor;
        _scheduleBtn.layer.borderWidth = 1;
        _scheduleBtn.userInteractionEnabled = NO;
    }
    return _scheduleBtn;
}

@end
