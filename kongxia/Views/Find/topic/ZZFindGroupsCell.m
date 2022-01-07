//
//  ZZFindGroupsCell.m
//  zuwome
//
//  Created by YuTianLong on 2018/2/2.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZFindGroupsCell.h"
#import "ZZFindGroupModel.h"

@interface ZZFindGroupsCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ZZFindGroupsCell

+ (NSString *)reuseIdentifier {
    return @"ZZFindGroupsCell";
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        commonInitSafe(ZZFindGroupsCell);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        commonInitSafe(ZZFindGroupsCell);
    }
    return self;
}

commonInitImplementationSafe(ZZFindGroupsCell) {

    self.backgroundColor = [UIColor clearColor];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.userInteractionEnabled = NO;
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(@20);
        make.leading.equalTo(@8);
        make.trailing.equalTo(@(-8));
    }];
}

- (void)setupWithModel:(ZZFindGroupModel *)model {
    self.titleLabel.text = model.content;
}

- (void)setIsSelectGruops:(BOOL)isSelectGruops {
    _isSelectGruops = isSelectGruops;
    
    if (isSelectGruops) {
        self.titleLabel.backgroundColor = RGBCOLOR(244, 203, 7);
        self.titleLabel.layer.masksToBounds = YES;
        self.titleLabel.layer.cornerRadius = 10.0f;
        self.titleLabel.alpha = 1.0f;
        
    } else {
        
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.layer.masksToBounds = NO;
        self.titleLabel.alpha = 0.4f;
    }
}

@end
