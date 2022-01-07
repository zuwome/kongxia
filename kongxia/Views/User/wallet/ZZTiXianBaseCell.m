//
//  ZZTiXianBaseCell.m
//  zuwome
//
//  Created by 潘杨 on 2018/6/12.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZTiXianBaseCell.h"

@implementation ZZTiXianBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = HEXCOLOR(0xf5f5f5);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.bgView];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.shadowColor = RGBCOLOR(216, 216, 216).CGColor;//阴影颜色
        _bgView.layer.shadowOffset = CGSizeMake(0, 1);//偏移距离
        _bgView.layer.shadowOpacity = 0.5;//不透明度
        _bgView.layer.shadowRadius = 2.0f;
        _bgView.layer.cornerRadius = 5.0f;
    }
    return _bgView;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = RGBCOLOR(245, 245, 245);
    }
    return _lineView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
