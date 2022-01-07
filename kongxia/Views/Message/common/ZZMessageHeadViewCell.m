//
//  ZZMessageHeadViewCell.m
//  zuwome
//
//  Created by MaoMinghui on 2018/7/24.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZMessageHeadViewCell.h"

@interface ZZMessageHeadViewCell ()

@property (nonatomic, strong) UIImageView *cellIcon;
@property (nonatomic, strong) UILabel *cellTitle;
@property (nonatomic, strong) UILabel *unreadCountLabel;

@end

@implementation ZZMessageHeadViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

- (void)createView {
    [self.contentView addSubview:self.cellIcon];
    [self.cellIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(18);
        make.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    
    [self.contentView addSubview:self.cellTitle];
    [self.cellTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cellIcon.mas_bottom).offset(6);
        make.bottom.equalTo(self.contentView).offset(-11);
        make.centerX.equalTo(self.contentView);
        make.height.equalTo(@20);
    }];
    
    [self.contentView addSubview:self.unreadCountLabel];
    [self.unreadCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cellIcon.mas_top);
        make.centerX.equalTo(self.cellIcon.mas_trailing);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
}

- (UIImageView *)cellIcon {
    if (nil == _cellIcon) {
        _cellIcon = [[UIImageView alloc] init];
    }
    return _cellIcon;
}

- (UILabel *)cellTitle {
    if (nil == _cellTitle) {
        _cellTitle = [[UILabel alloc] init];
        _cellTitle.textColor = kBlackColor;
        _cellTitle.font = [UIFont systemFontOfSize:15];
    }
    return _cellTitle;
}

- (UILabel *)unreadCountLabel {
    if (nil == _unreadCountLabel) {
        _unreadCountLabel = [[UILabel alloc] init];
        _unreadCountLabel.layer.cornerRadius = 9;
        _unreadCountLabel.layer.masksToBounds = YES;
        _unreadCountLabel.textAlignment = NSTextAlignmentCenter;
        _unreadCountLabel.textColor = [UIColor whiteColor];
        _unreadCountLabel.font = [UIFont systemFontOfSize:10];
        _unreadCountLabel.backgroundColor = kRedPointColor;
        _unreadCountLabel.text = @"0";
    }
    return _unreadCountLabel;
}

/**
 UI展示
 @param dict cell的title 和cell的image
 @param unReadArray 未读数量
 */
- (void)setMessageStyleWithIndexPath:(NSIndexPath *)indexPath uiDict:(NSDictionary *)dict unReadCountArray:(NSArray *)unReadArray {
    if (indexPath.section > 0) {
        return ;
    }
    self.cellTitle.text = dict[@"title"][indexPath.item];
    self.cellIcon.image = [UIImage imageNamed:dict[@"image"][indexPath.item]];
    NSNumber *unreadCount = @0;
    switch (indexPath.item) {
        case 0:
            unreadCount = [ZZUserHelper shareInstance].unreadModel.hd;
            break;
        case 1:
            unreadCount = [ZZUserHelper shareInstance].unreadModel.system_msg;
            break;
        case 2:
            unreadCount = [ZZUserHelper shareInstance].unreadModel.reply;
            break;
        default:
            break;
    }
    self.unreadCountLabel.hidden = YES;
    if ([unreadCount integerValue] > 0) {
        [self updateCurrentCellunReadCount:unreadCount];
    }
}

/**
 根据cell来更新cell上红点数据
 */
- (void)updateCurrentCellunReadCount:(NSNumber *)unreadCount {
    self.unreadCountLabel.hidden = NO;
    if ([unreadCount integerValue] > 99) {
        self.unreadCountLabel.text = @"99+";
    } else {
        self.unreadCountLabel.text = [NSString stringWithFormat:@"%@",unreadCount];
    }
}

- (NSString *)getUnreadCount {
    return self.unreadCountLabel.text;
}

- (void)hideUnreadLabel {
    self.unreadCountLabel.hidden = YES;
}

@end
