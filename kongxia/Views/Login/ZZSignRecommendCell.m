//
//  ZZSignRecommendCell.m
//  zuwome
//
//  Created by angBiu on 2017/6/13.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZSignRecommendCell.h"

@implementation ZZSignRecommendCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.imgView.layer.cornerRadius = 3;
        self.statusBtn.hidden = NO;
    }
    
    return self;
}

- (void)setData:(ZZUser *)user
{
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:user.avatar]];
}

#pragma mark - lazyload

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.backgroundColor = kGrayTextColor;
        _imgView.clipsToBounds = YES;
        [self.contentView addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
        
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = HEXACOLOR(0x000000, 0.3);
        [self.contentView addSubview:_coverView];
        
        [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
    }
    return _imgView;
}

- (UIButton *)statusBtn
{
    if (!_statusBtn) {
        _statusBtn = [[UIButton alloc] init];
        _statusBtn.userInteractionEnabled = NO;
        [_statusBtn setImage:[UIImage imageNamed:@"icon_selected_n"] forState:UIControlStateNormal];
        [_statusBtn setImage:[UIImage imageNamed:@"icon_selected_p"] forState:UIControlStateSelected];
        [self.contentView addSubview:_statusBtn];
        
        [_statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-4);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-4);
            make.size.mas_equalTo(CGSizeMake(18, 18));
        }];
    }
    return _statusBtn;
}

@end
