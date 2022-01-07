//
//  ZZNewHomeTopicItemCell.m
//  zuwome
//
//  Created by MaoMinghui on 2018/8/16.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZNewHomeTopicItemCell.h"

@interface ZZNewHomeTopicItemCell ()

@property (nonatomic, strong) UIImageView *topicIcon;
@property (nonatomic, strong) UILabel *topicTitle;

@end

@implementation ZZNewHomeTopicItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

- (void)createView {
    [self.contentView addSubview:self.topicIcon];
    [self.topicIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    [self.contentView addSubview:self.topicTitle];
    [self.topicTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topicIcon.mas_bottom).offset(7.5);
        make.centerX.equalTo(self.contentView);
        make.height.equalTo(@20);
    }];
}

- (void)setTopic:(ZZHomeCatalogModel *)topic {
    _topic = topic;
    self.topicTitle.text = topic.name;
    [self.topicIcon sd_setImageWithURL:[NSURL URLWithString:topic.indexUrl]];
}

- (UIImageView *)topicIcon {
    if (nil == _topicIcon) {
        _topicIcon = [[UIImageView alloc] init];
    }
    return _topicIcon;
}

- (UILabel *)topicTitle {
    if (nil == _topicTitle) {
        _topicTitle = [[UILabel alloc] init];
        _topicTitle.textColor = kBrownishGreyColor;
        _topicTitle.font = [UIFont systemFontOfSize:14];
        _topicTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _topicTitle;
}

@end
