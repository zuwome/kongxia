//
//  ZZOrderARBaseCell.m
//  zuwome
//
//  Created by 潘杨 on 2018/5/30.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZOrderARBaseCell.h"

@implementation ZZOrderARBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setImage:[UIImage imageNamed:@"orderAR_icUnselected"] forState:UIControlStateNormal];
        [_button setImage:[UIImage imageNamed:@"orderAR_icSelected"] forState:UIControlStateSelected];
    }
    return _button;
}
- (void)setCurrentTitle:(NSString *)currentTitle {
    if (_currentTitle != currentTitle) {
        _currentTitle = currentTitle;
        _currentTitleLab.text = _currentTitle;
    }
}
- (UILabel *)currentTitleLab {
    if (!_currentTitleLab) {
        _currentTitleLab = [[UILabel alloc]init];
        _currentTitleLab.textAlignment = NSTextAlignmentLeft;
        _currentTitleLab.textColor = kBlackColor;
        _currentTitleLab.font = CustomFont(15);
    }
    return _currentTitleLab;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
