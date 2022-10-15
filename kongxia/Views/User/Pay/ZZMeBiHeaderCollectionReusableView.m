//
//  ZZMeBiHeaderCollectionReusableView.m
//  zuwome
//
//  Created by 潘杨 on 2018/1/2.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZMeBiHeaderCollectionReusableView.h"

@interface ZZMeBiHeaderCollectionReusableView()
@property (nonatomic,strong) UILabel *meBiDetailInfoLable,*meBiTitleLab;

@property (nonatomic,strong) UIImageView *meBiImageView;

@end
@implementation ZZMeBiHeaderCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self=[super initWithFrame:frame]) {
        [self addSubview:self.meBiDetailInfoLable];
        [self addSubview:self.meBiTitleLab];
        [self addSubview:self.meBiImageView];
    }
    return self;
}

- (void)setUserModel:(ZZUser *)userModel
{
    _userModel = userModel;
    self.meBiDetailInfoLable.text = [NSString stringWithFormat:@"%d",userModel.mcoin != nil ? userModel.mcoin.intValue : 0];
}

-(void)layoutSubviews {
   CGFloat titleWidth = [ZZUtils widthForCellWithText:@"我的么币" fontSize:17];

    [self.meBiDetailInfoLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY).multipliedBy(0.8);
    }];
    [self.meBiTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.meBiImageView.mas_right).with.offset(3.5);
        make.centerY.equalTo(self.mas_centerY).multipliedBy(1.33);
    }];
    [self.meBiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.centerY.equalTo(self.mas_centerY).multipliedBy(1.33);
        make.centerX.mas_equalTo(self).with.offset(-(titleWidth)/2);
        
    }];
}

- (UILabel *)meBiDetailInfoLable {
    
    if (!_meBiDetailInfoLable) {
        _meBiDetailInfoLable  = [[UILabel alloc]init];
        _meBiDetailInfoLable.textAlignment = NSTextAlignmentCenter;
        _meBiDetailInfoLable.textColor = [UIColor blackColor];
        _meBiDetailInfoLable.font = [UIFont systemFontOfSize:44];
        _meBiDetailInfoLable.text = @"0";
    }
    return _meBiDetailInfoLable;
}

- (UILabel *)meBiTitleLab {
    
    if (!_meBiTitleLab) {
        _meBiTitleLab = [[UILabel alloc]init];
        _meBiTitleLab.font = [UIFont systemFontOfSize:15];
        _meBiTitleLab.textColor  = [UIColor blackColor];
        _meBiTitleLab.textAlignment = NSTextAlignmentCenter;
        _meBiTitleLab.text = @"我的么币";
    }
    return _meBiTitleLab;
}

- (UIImageView *)meBiImageView {
    if (!_meBiImageView) {
        _meBiImageView = [[UIImageView alloc]init];
        _meBiImageView.image = [UIImage imageNamed:@"icMebi"];
    }
    return _meBiImageView;
}

@end
