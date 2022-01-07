//
//  ZZWhiteLaceHeadView.m
//  zuwome
//
//  Created by YuTianLong on 2017/12/28.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZWhiteLaceHeadView.h"

@interface ZZWhiteLaceHeadView ()

@property (nonatomic, strong) UIImageView *headImageView;

@end

@implementation ZZWhiteLaceHeadView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        commonInitSafe(ZZWhiteLaceHeadView);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        commonInitSafe(ZZWhiteLaceHeadView);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.width / 2.0f;
    
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = self.headImageView.width / 2.0f;
}

commonInitImplementationSafe(ZZWhiteLaceHeadView) {
    
    self.backgroundColor = [UIColor whiteColor];
    self.headImageView = [UIImageView new];
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
//    self.headImageView.backgroundColor = [UIColor orangeColor];
    
    [self addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(@2);
        make.bottom.trailing.equalTo(@(-2));
    }];
}

- (void)setUrlString:(NSString *)urlString {
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:nil options:(SDWebImageRetryFailed)];
}

@end
