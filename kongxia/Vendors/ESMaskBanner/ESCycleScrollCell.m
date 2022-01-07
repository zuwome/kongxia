//
//  ESCycleScrollCell.m
//  zuwome
//
//  Created by MaoMinghui on 2018/9/16.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ESCycleScrollCell.h"

@interface ESCycleScrollCell ()

@property (nonatomic, strong) UIImageView *cellImageView;

@end

@implementation ESCycleScrollCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:self.cellImageView];
}

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    [self.cellImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}

- (UIImageView *)cellImageView {
    if (nil == _cellImageView) {
        CGRect frame = self.frame;
        frame.origin.x = 15;
        frame.size.width -= 30;
        
        _cellImageView = [[UIImageView alloc] initWithFrame:frame];
        _cellImageView.contentMode = UIViewContentModeScaleAspectFill;
        _cellImageView.clipsToBounds = YES;
    }
    return _cellImageView;
}

@end
