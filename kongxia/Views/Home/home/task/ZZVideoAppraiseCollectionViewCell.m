//
//  ZZVideoAppraiseCollectionViewCell.m
//  zuwome
//
//  Created by YuTianLong on 2018/1/9.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZVideoAppraiseCollectionViewCell.h"

@interface ZZVideoAppraiseCollectionViewCell ()

@property (nonatomic, strong) UIButton *itemBtn;

@end

@implementation ZZVideoAppraiseCollectionViewCell

+ (NSString *)reuseIdentifier {
    return @"ZZVideoAppraiseCollectionViewCell";
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        commonInitSafe(ZZVideoAppraiseCollectionViewCell);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        commonInitSafe(ZZVideoAppraiseCollectionViewCell);
    }
    return self;
}

commonInitImplementationSafe(ZZVideoAppraiseCollectionViewCell) {
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.itemBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
    self.itemBtn.backgroundColor = [UIColor whiteColor];
    self.itemBtn.titleLabel.font = ISiPhone5 ? [UIFont systemFontOfSize:11] : [UIFont systemFontOfSize:13];
    self.itemBtn.layer.masksToBounds = YES;
    self.itemBtn.layer.cornerRadius = 2.0f;
    self.itemBtn.layer.borderWidth = 1.0f;
    self.itemBtn.layer.borderColor = kBlackColor.CGColor;
    [self.itemBtn addTarget:self action:@selector(itemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:self.itemBtn];
    // 小屏幕手机，缩短item之间的间距
    if (ISiPhone5) {
        [self.itemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@7.5);
            make.leading.trailing.equalTo(@5);
            make.trailing.equalTo(@(-5));
            make.bottom.equalTo(@(-7.5));
        }];
    } else {
        [self.itemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@7.5);
            make.leading.trailing.equalTo(@10);
            make.trailing.equalTo(@(-10));
            make.bottom.equalTo(@(-7.5));
        }];
    }
}

- (void)setupWithString:(NSString *)itemString {
    [self.itemBtn setTitle:itemString forState:UIControlStateNormal];
}

- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    
    self.itemBtn.backgroundColor = isSelect ? RGBCOLOR(244, 203, 7) : [UIColor whiteColor];
}

- (IBAction)itemBtnClick:(id)sender {
    BLOCK_SAFE_CALLS(self.selectItemBlock);
}

@end
