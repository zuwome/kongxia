//
//  ZZRentRangeTableViewCell.m
//  zuwome
//
//  Created by wlsy on 16/1/21.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRentRangeTableViewCell.h"

@implementation ZZRentRangeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    _wrapperView.backgroundColor = [UIColor whiteColor];
    
    _wrapperView.layer.shadowColor = HEXCOLOR(0xdedcce).CGColor;
    _wrapperView.layer.shadowOffset = CGSizeMake(0, 1);
    _wrapperView.layer.shadowOpacity = 0.9;
    _wrapperView.layer.shadowRadius = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)tapRemove:(UIButton *)sender {
    if (_tapDeleteNext) {
        _tapDeleteNext(sender);
    }
}

@end
