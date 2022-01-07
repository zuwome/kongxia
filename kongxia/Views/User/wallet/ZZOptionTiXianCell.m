//
//  ZZOptionTiXianCell.m
//  zuwome
//
//  Created by 潘杨 on 2018/6/12.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZOptionTiXianCell.h"
@interface ZZOptionTiXianCell()
@property (nonatomic,strong) NSArray *titleArray;
@end
@implementation ZZOptionTiXianCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}
- (NSArray *)titleArray {
    if (!_titleArray) {
       _titleArray= @[@"微信"];
    }
    return _titleArray;
}
- (void)setUI {
//    [self.bgView addSubview:self.lineView];
    NSArray *imageNameArray = @[@"icWechatWhitdraw"]; //@[@"icWechatWhitdraw",@"icCardWhitdraw"];
    for (int x =0; x<self.titleArray.count; x++) {
        
        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.text = self.titleArray[x];
        titleLab.textColor = kBlackColor;
        titleLab.textAlignment = NSTextAlignmentLeft;
        titleLab.font = CustomFont(15);
        [self.bgView addSubview:titleLab];
        
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:imageNameArray[x]];
        [self.bgView addSubview:imageView];
        
        UIButton *selectTypeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [selectTypeButton setImage:[UIImage imageNamed:@"orderAR_icUnselected"] forState:UIControlStateNormal];
        [selectTypeButton setImage:[UIImage imageNamed:@"orderAR_icSelected"] forState:UIControlStateSelected];
        [selectTypeButton addTarget:self action:@selector(selectTypeClick:) forControlEvents:UIControlEventTouchUpInside];
        selectTypeButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        selectTypeButton.tag = 100+x;
        if (x==0) {
            selectTypeButton.selected = YES;
            self.lastSelectButton = selectTypeButton;
            
        }
        
        [self.bgView addSubview:selectTypeButton];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.centerY.equalTo(self.bgView.mas_centerY);//.multipliedBy(x==0?0.5:1.5);
            make.height.equalTo(@15);
        }];
        
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).offset(11.5);
            make.centerY.equalTo(imageView.mas_centerY);
            make.width.equalTo(@120);
        }];
        
        [selectTypeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(0);
            make.centerY.equalTo(imageView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
    
    }
    
    
}


/**
 当前选中的充值方式
 @param sender 当前点击的充值按钮
 */
- (void)selectTypeClick:(UIButton *)sender {
    if (self.lastSelectButton !=nil) {
        self.lastSelectButton.selected = NO;
    }
    self.lastSelectButton = sender;
    sender.selected = !sender.selected;
    
    if (self.goTiXianBlock) {
        self.goTiXianBlock(self.titleArray[sender.tag -100]);
    }
}



-(void)layoutSubviews {
    [super layoutSubviews];
//    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.offset(0);
//        make.centerY.equalTo(self.bgView.mas_centerY);
//        make.height.equalTo(@0.5);
//    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(7.5);
        make.right.offset(-7.5);
        make.top.offset(8);
        make.bottom.offset(-8);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
