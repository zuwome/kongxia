//
//  ZZCornerRadiuImageView.m
//  zuwome
//
//  Created by 潘杨 on 2017/12/1.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZCornerRadiuImageView.h"

@implementation ZZCornerRadiuImageView


- (instancetype)initWithFrame:(CGRect)frame headerImageWidth:(CGFloat)width
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        
        _headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, width)];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_headImgView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:_headImgView.bounds.size];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        //设置大小
        maskLayer.frame = _headImgView.bounds;
        //设置图形样子
        maskLayer.path = maskPath.CGPath;
        _headImgView.layer.mask = maskLayer;
        
        _headImgView.contentMode = UIViewContentModeScaleAspectFill;
        _headImgView.backgroundColor = kBGColor;
        [self addSubview:_headImgView];
        
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        _vImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _vImgView.image = [UIImage imageNamed:@"v"];
        _vImgView.contentMode = UIViewContentModeScaleToFill;
        _vImgView.hidden = YES;
        [self addSubview:_vImgView];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelf)];
        [self addGestureRecognizer:recognizer];
    }
    
    return self;
}

- (void)setUser:(ZZUser *)user width:(CGFloat)width vWidth:(CGFloat)vWidth
{
    //头像
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:[user displayAvatar]] placeholderImage:nil options:SDWebImageContinueInBackground progress:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
    
    if (user.weibo.verified) {
        _vImgView.hidden = NO;
        [_vImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.offset(-3);
            make.size.mas_equalTo(CGSizeMake(vWidth, vWidth));
        }];
    } else {
        _vImgView.hidden = YES;
    }
}



- (void)tapSelf
{
    if (_isAnonymous) {
        [ZZHUD showErrorWithStatus:@"该用户为匿名提问，无法查看"];
        return;
    }
    if (_touchHead) {
        _touchHead();
    }
}
@end
