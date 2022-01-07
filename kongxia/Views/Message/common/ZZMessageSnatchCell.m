//
//  ZZMessageSnatchCell.m
//  zuwome
//
//  Created by MaoMinghui on 2018/9/10.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZMessageSnatchCell.h"
#import "ZZWaitingProgressView.h"

@interface ZZMessageSnatchCell ()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *subTitle;
@property (nonatomic, strong) UILabel *snatchCount;
//@property (nonatomic, strong) ZZWaitingProgressView *cycleView;

@end

@implementation ZZMessageSnatchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self.contentView addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@15);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
//    self.cycleView = [[ZZWaitingProgressView alloc] init];
//    _cycleView.animate = YES;
//    _cycleView.isColor = YES;
//    [self.icon addSubview:self.cycleView];
//    [self.cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.icon);
//        make.width.height.equalTo(@33);
//    }];
    
    [self.contentView addSubview:self.snatchCount];
    [self.snatchCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.trailing.equalTo(@-15);
    }];
    
    [self.contentView addSubview:self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.icon.mas_trailing).offset(15);
        make.top.equalTo(self.icon);
        make.height.equalTo(@20);
        make.trailing.equalTo(self.snatchCount.mas_leading).offset(-15);
    }];
    
    [self.contentView addSubview:self.subTitle];
    [self.subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.icon.mas_trailing).offset(15);
        make.bottom.equalTo(self.icon);
        make.height.equalTo(@20);
        make.trailing.equalTo(self.snatchCount.mas_leading).offset(-15);
    }];
}

- (void)setData:(ZZUserUnread *)data {
    self.snatchCount.hidden = data.pd_receive > 0 ? NO : YES;
    self.snatchCount.text = [NSString stringWithFormat:@"%ld",data.pd_receive];
}

- (UIImageView *)icon {
    if (nil == _icon) {
        _icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icYaoyueXx11"]];
    }
    return _icon;
}

- (UILabel *)title {
    if (nil == _title) {
        _title = [[UILabel alloc] init];
        _title.text = @"通告报名中心";
        _title.textColor = kBlackColor;
        _title.font = [UIFont systemFontOfSize:15];
    }
    return _title;
}

- (UILabel *)subTitle {
    if (nil == _subTitle) {
        _subTitle = [[UILabel alloc] init];
        _subTitle.text = @"点击查看最新发布通告";
        _subTitle.textColor = kBrownishGreyColor;
        _subTitle.font = [UIFont systemFontOfSize:13];
    }
    return _subTitle;
}

- (UILabel *)snatchCount {
    if (nil == _snatchCount) {
        _snatchCount = [[UILabel alloc] init];
        _snatchCount.backgroundColor = kRedPointColor;
        _snatchCount.textColor = [UIColor whiteColor];
        _snatchCount.textAlignment = NSTextAlignmentCenter;
        _snatchCount.font = [UIFont systemFontOfSize:12 weight:(UIFontWeightSemibold)];
        _snatchCount.layer.cornerRadius = 10;
        _snatchCount.layer.masksToBounds = YES;
    }
    return _snatchCount;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
