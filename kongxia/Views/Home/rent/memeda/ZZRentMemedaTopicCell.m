//
//  ZZRentMemedaTopicCell.m
//  zuwome
//
//  Created by angBiu on 16/8/11.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRentMemedaTopicCell.h"
#import "ZZMemedaTopicModel.h"

@implementation ZZRentMemedaTopicCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
    }
    
    return self;
}

- (void)setData:(ZZMemedaTopicModel *)model
{
    _titleLabel.text = model.content;
}

@end
