//
//  ZZOrderARSelectButtonCell.m
//  zuwome
//
//  Created by 潘杨 on 2018/5/28.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZOrderARSelectButtonCell.h"
@interface ZZOrderARSelectButtonCell()
@property(nonatomic,strong) UIView *lineView;


@end
@implementation ZZOrderARSelectButtonCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.currentTitleLab];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.button];
    [self.button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];

}



- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = RGBCOLOR(230, 230, 230);
    }
    return _lineView;
}


- (void)click:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.selecetBlock) {
        self.selecetBlock(self);
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.currentTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(14.5);
        make.right.equalTo(self.button.mas_left);
        make.top.bottom.offset(0);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(14.5);
        make.right.offset(-14.5);
        make.top.offset(0);
        make.height.equalTo(@0.5);
    }];

    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.offset(0);
        make.width.equalTo(self.button.mas_height);
    }];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
