//
//  ZZCustomButtom.m
//  zuwome
//
//  Created by 潘杨 on 2017/12/29.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZCustomButtom.h"
@interface ZZCustomButtom ()
@property (nonatomic,strong) UIImageView *buttonImageView;
@property (nonatomic,strong) UILabel *butonTitleLab;//标题
@property (nonatomic,assign) CGFloat titleWidth;//文字的宽度
@end
@implementation ZZCustomButtom

- (instancetype)initWithFrame:(CGRect)frame withImageName:(NSString *)imageName titleName:(NSString *)titleName subtitleName:(NSString *)subtitle {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _titleWidth = [ZZUtils widthForCellWithText:titleName fontSize:17];

        [self addSubview:self.numMoneyLab];
        [self addSubview:self.buttonImageView];
        [self addSubview:self.butonTitleLab];
        
        self.buttonImageView.image = [UIImage imageNamed:imageName];
        self.butonTitleLab.text = titleName;
        self.numMoneyLab.text = subtitle;
    }
    return self;
}
- (UILabel *)numMoneyLab {
    
    if (!_numMoneyLab) {
        _numMoneyLab = [[UILabel alloc]init];
        _numMoneyLab.font = [UIFont systemFontOfSize:17];
        _numMoneyLab.textColor  = [UIColor blackColor];
        _numMoneyLab.textAlignment = NSTextAlignmentCenter;
    }
    return _numMoneyLab;
}
- (UILabel *)butonTitleLab {
    
    if (!_butonTitleLab) {
        _butonTitleLab = [[UILabel alloc]init];
        _butonTitleLab.font = [UIFont systemFontOfSize:15];
        _butonTitleLab.textColor  = [UIColor blackColor];
        _butonTitleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _butonTitleLab;
}

- (UIImageView *)buttonImageView {
    if (!_buttonImageView) {
        _buttonImageView = [[UIImageView alloc]init];
    }
    return _buttonImageView;
}


-(void)layoutSubviews {
    
    [_numMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.centerY.equalTo(self.mas_centerY).multipliedBy(1.29);
    }];

    [_buttonImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.centerY.equalTo(self.mas_centerY).multipliedBy(0.68);
        make.centerX.mas_equalTo(self).with.offset(-(_titleWidth)/2);
    }];

    [_butonTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.buttonImageView.mas_right).with.offset(3.5);
        make.centerY.equalTo(self.mas_centerY).multipliedBy(0.68);
    }];
}

@end
