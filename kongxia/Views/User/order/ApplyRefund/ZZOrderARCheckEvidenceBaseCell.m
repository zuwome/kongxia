//
//  ZZOrderARCheckEvidenceBaseCell.m
//  zuwome
//
//  Created by 潘杨 on 2018/5/31.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZOrderARCheckEvidenceBaseCell.h"

@implementation ZZOrderARCheckEvidenceBaseCell

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = RGBCOLOR(230, 230, 230);
    }
    return _lineView;
}
- (void)setShowTitle:(NSString *)title detailTitle:(NSString *)detailTitle dataArray:(NSArray*)array viewController:(UIViewController *)viewController {
    
}

@end
