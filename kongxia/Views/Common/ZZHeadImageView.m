//
//  ZZHeadImageView.m
//  zuwome
//
//  Created by angBiu on 16/9/22.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZHeadImageView.h"

@implementation ZZHeadImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _headImgView = [[UIImageView alloc] init];
        _headImgView.contentMode = UIViewContentModeScaleAspectFill;
        _headImgView.userInteractionEnabled = YES;
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

- (void)setUser:(ZZUser *)user anonymousAvatar:(NSString *)anonymousAvatar width:(CGFloat)width vWidth:(CGFloat)vWidth {
    _headImgView.backgroundColor = kBGColor;
    _headImgView.clipsToBounds = YES;
    if ([user.avatar isEqualToString:@"niming"]) {
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:anonymousAvatar]];
    }
    else {
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:[user displayAvatar]]];
    }
    
    _headImgView.layer.cornerRadius = width / 2;
    if (user.weibo.verified) {
        _vImgView.hidden = NO;
        [_vImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.offset(-((2 - sqrt(2)) / 4 * width - vWidth / 2));
            make.size.mas_equalTo(CGSizeMake(vWidth, vWidth));
        }];
    } else {
        _vImgView.hidden = YES;
    }
}

- (void)setUser:(ZZUser *)user width:(CGFloat)width vWidth:(CGFloat)vWidth {
    _headImgView.backgroundColor = kBGColor;
    _headImgView.clipsToBounds = YES;
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:[user displayAvatar]]];
    
    _headImgView.layer.cornerRadius = width/2;
    if (user.weibo.verified) { 
        _vImgView.hidden = NO;
        [_vImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.offset(-((2 - sqrt(2)) / 4 * width - vWidth / 2));
            make.size.mas_equalTo(CGSizeMake(vWidth, vWidth));
        }];
    } else {
        _vImgView.hidden = YES;
    }
}

- (void)userAvatar:(NSString *)avatar verified:(BOOL)verified width:(CGFloat)width vWidth:(CGFloat)vWidth {
    _headImgView.backgroundColor = kBGColor;
    _headImgView.clipsToBounds = YES;
    
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:avatar]];
    
    _headImgView.layer.cornerRadius = width/2;
    if (verified) {
        _vImgView.hidden = NO;
        [_vImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.offset(-((2 - sqrt(2)) / 4 * width - vWidth / 2));
            make.size.mas_equalTo(CGSizeMake(vWidth, vWidth));
        }];
    } else {
        _vImgView.hidden = YES;
    }
}

- (void)tapSelf {
    if (_isAnonymous) {
        [ZZHUD showErrorWithStatus:@"该用户为匿名提问，无法查看"];
        return;
    }
    if (_touchHead) {
        _touchHead();
    }
}

@end
