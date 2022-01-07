//
//  ZZNewHomeServiceCell.m
//  zuwome
//
//  Created by MaoMinghui on 2018/8/16.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZNewHomeServiceCell.h"

@implementation ZZNewHomeServiceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createView];
    }
    return self;
}

- (void)createView {
    for (NSInteger i = 0; i < 3; i++) {
        UIView *item = [self createEnsureItemAtIndex:i];
//        item.backgroundColor = ColorRandomized;
        item.tag = 100 + i;
        [self.contentView addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.width.equalTo(@(SCREEN_WIDTH / 3));
            make.leading.equalTo(@(SCREEN_WIDTH / 3 * i));
            make.bottom.equalTo(self.contentView);
        }];
    }
}

- (UIView *)createEnsureItemAtIndex:(NSInteger)index {
    NSString *title = @"";
    NSString *icon = @"";
    switch (index) {
        case 0:
            title = @"真实资料";
            icon = @"icZhenshiziliaoZhutixiangqing";
            break;
        case 1:
            title = @"资金安全";
            icon = @"icZijinanquanZhutixiangqing";
            break;
        case 2:
            title = @"在线客服";
            icon = @"icZaixiankefuZhutixiangqing";
            break;
    }
    UIView *item = [[UIView alloc] init];
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    img.tag = 1000 + index;
    img.contentMode = UIViewContentModeScaleAspectFit;
    [item addSubview:img];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.tag = 10000 + index;
    titleLab.text = title;
    titleLab.textColor = kBrownishGreyColor;
    titleLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:11 * (SCREEN_WIDTH / 375.0)];
    [item addSubview:titleLab];
    
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(item).offset(14.0);
        make.left.equalTo(item).offset(30.0);
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.bottom.equalTo(item).offset(-6);
    }];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(img);
        make.left.equalTo(img.mas_right).offset(5.0);
    }];
    
    return item;
}

- (void)setIntroduceList:(NSArray *)introduceList {
    [super setIntroduceList:introduceList];
    for (int i = 0; i < 3; i++) {
        ZZHomeIntroduceItemModel *introduce = introduceList[i];
        UIView *item = [self.contentView viewWithTag:100 + i];
        UIImageView *img = [item viewWithTag:1000 + i];
        [img sd_setImageWithURL:[NSURL URLWithString:introduce.url]];
        UILabel *titleLab = [item viewWithTag:10000 + i];
        titleLab.text = introduce.name;
        UILabel *subTitleLab = [item viewWithTag:100000 + i];
        subTitleLab.text = introduce.content;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
