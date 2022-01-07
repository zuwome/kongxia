//
//  ZZMeBiCollectionViewCell.m
//  zuwome
//
//  Created by 潘杨 on 2018/1/2.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZMeBiCollectionViewCell.h"
@interface ZZMeBiCollectionViewCell()

@property (nonatomic,strong)UIView *meBiBackgroundView;

@property (nonatomic,strong)UILabel *meBiTitleLab;

@property (nonatomic,strong)UILabel *meBiSubTitleLab;

@property (nonatomic, strong) UIButton *giveBtn;

@end
@implementation ZZMeBiCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.meBiBackgroundView];
        [self addSubview:self.meBiTitleLab];
        [self addSubview:self.meBiSubTitleLab];
        [self addSubview:self.giveBtn];

    }
    return self;
}

- (void)setMeBiModel:(ZZMeBiModel *)meBiModel {
    
    _meBiModel = meBiModel;
    self.meBiSubTitleLab.text = [NSString stringWithFormat:@"%@元",meBiModel.meBiPrice];
    self.meBiTitleLab.text = [NSString stringWithFormat:@"%@么币",meBiModel.meBi];
    if (meBiModel.give != 0) {
        _giveBtn.hidden = NO;
        self.giveBtn.normalTitle = [NSString stringWithFormat:@"赠送%ld么币", meBiModel.give];
    }
    else {
        _giveBtn.hidden = YES;
    }
    

}
-(void)setSelected:(BOOL)selected {
    if (selected) {
        self.meBiBackgroundView.backgroundColor = RGBCOLOR(240, 203, 7);
        _meBiBackgroundView.layer.borderColor = [RGBCOLOR(37, 39, 43)  CGColor];
        _meBiBackgroundView.layer.borderWidth = 0;
    }
    else{
        self.meBiBackgroundView.backgroundColor = [UIColor whiteColor];
        _meBiBackgroundView.layer.borderWidth = 0.5;

    }
}



- (void)layoutSubviews {
    [self.meBiBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.meBiTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self.mas_centerY).multipliedBy(0.65);
    }];
    [self.meBiSubTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self.mas_centerY).multipliedBy(1.45);
    }];
    
    [_giveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.centerY.equalTo(self.mas_top);
        make.size.mas_equalTo(CGSizeMake(SCALE_SET(75), SCALE_SET(20)));
    }];
}

#pragma mark -懒加载

- (UIView *)meBiBackgroundView {
    if (!_meBiBackgroundView) {
        _meBiBackgroundView = [[UIView alloc]init];
        _meBiBackgroundView.layer.cornerRadius = 3;
        _meBiBackgroundView.clipsToBounds = YES;
        _meBiBackgroundView.layer.borderColor = [RGBCOLOR(37, 39, 43)  CGColor];
        _meBiBackgroundView.layer.borderWidth = 0.5;

    }
    return _meBiBackgroundView;
}

-(UILabel *)meBiTitleLab {
   
    if (!_meBiTitleLab) {
        _meBiTitleLab = [[UILabel alloc]init];
        _meBiTitleLab.textColor =  RGBCOLOR(37, 39, 43);
        _meBiTitleLab.textAlignment = NSTextAlignmentCenter;
        _meBiTitleLab.font = [UIFont systemFontOfSize:17];
        _meBiTitleLab.text = @"**元";

    }
    return _meBiTitleLab;
}
- (UILabel *)meBiSubTitleLab {
    
    if (!_meBiSubTitleLab) {
        _meBiSubTitleLab = [[UILabel alloc]init];
        
        _meBiSubTitleLab.textColor =  RGBCOLOR(128, 128, 128);
        _meBiSubTitleLab.textAlignment = NSTextAlignmentCenter;
        _meBiSubTitleLab.font = [UIFont systemFontOfSize:15];
        _meBiSubTitleLab.text = @"**元";
    }
    return _meBiSubTitleLab;
}

- (UIButton *)giveBtn {
    if (!_giveBtn) {
        _giveBtn = [[UIButton alloc] init];
        [_giveBtn setBackgroundImage:[UIImage imageNamed:@"recharge_give"] forState:UIControlStateNormal];
        _giveBtn.userInteractionEnabled = NO;
        _giveBtn.titleLabel.font = ADaptedFontSCBoldSize(11.0);
    }
    return _giveBtn;
}



@end
