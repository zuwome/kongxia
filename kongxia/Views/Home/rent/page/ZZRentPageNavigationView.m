//
//  ZZRentPageNavigationView.m
//  zuwome
//
//  Created by angBiu on 16/8/2.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRentPageNavigationView.h"
#import <UMSocialCore/UMSocialCore.h>
#import "ZZIntegralHelper.h"//积分管理类
#import "ZZCommissionShareView.h"
#import "ZZCommissionModel.h"
@interface ZZRentPageNavigationView ()

@property (nonatomic, strong) UIImage *shotImage;

@end

@implementation ZZRentPageNavigationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *topBgImgView = [[UIImageView alloc] init];
        topBgImgView.contentMode = UIViewContentModeScaleToFill;
        topBgImgView.image = [UIImage imageNamed:@"icon_rent_topbg"];
        [self addSubview:topBgImgView];
        
        [topBgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = HEXACOLOR(0xffffff, 0.0);
        [self addSubview:_bgView];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        UIButton *leftBtn = [[UIButton alloc] init];
        [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftBtn];
        
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(STATUSBAR_HEIGHT);
            make.left.mas_equalTo(self.mas_left);
            make.size.mas_equalTo(CGSizeMake(70, 44));
        }];
        
        _leftImgView = [[UIImageView alloc] init];
        _leftImgView.contentMode = UIViewContentModeLeft;
        _leftImgView.image = [UIImage imageNamed:@"icon_rent_left"];
        _leftImgView.userInteractionEnabled = NO;
        [leftBtn addSubview:_leftImgView];
        
        [_leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftBtn.mas_left).offset(15);
            make.centerY.mas_equalTo(leftBtn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(20, 44));
        }];
        
        UIButton *rightBtn = [[UIButton alloc] init];
        [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightBtn];
        
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right);
            make.top.mas_equalTo(self.mas_top).offset(STATUSBAR_HEIGHT);
            make.size.mas_equalTo(CGSizeMake(40, 44));
        }];
        
        _rightImgView = [[UIImageView alloc] init];
        _rightImgView.contentMode = UIViewContentModeRight;
        _rightImgView.image = [UIImage imageNamed:@"icon_rent_right"];
        _rightImgView.userInteractionEnabled = NO;
        [rightBtn addSubview:_rightImgView];
        
        [_rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(rightBtn.mas_right).offset(-15);
            make.centerY.mas_equalTo(rightBtn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(20, 44));
        }];
        
        _codeBtn = [[UIButton alloc] init];
        [_codeBtn addTarget:self action:@selector(codeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_codeBtn];
        
        [_codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(rightBtn.mas_left).offset(-10);
            make.top.mas_equalTo(rightBtn.mas_top);
            make.size.mas_equalTo(CGSizeMake(40, 44));
        }];
        
        _codeImgView = [[UIImageView alloc] init];
        _codeImgView.contentMode = UIViewContentModeBottomRight;
        _codeImgView.image = [UIImage imageNamed:@"icon_rent_code_white"];
        _codeImgView.userInteractionEnabled = NO;
        [_codeBtn addSubview:_codeImgView];
        
        [_codeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_codeBtn.mas_right);
            make.centerY.mas_equalTo(_codeBtn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(18, 18));
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        [self addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(STATUSBAR_HEIGHT);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.right.mas_equalTo(_codeBtn.mas_left).offset(-5);
        }];
    }
    
    return self;
}

- (void)leftBtnClick
{
    if (_touchLeftBtn) {
        _touchLeftBtn();
    }
}

- (void)rightBtnClick
{
    if (_touchRightBtn) {
        _touchRightBtn();
    }
}

- (void)codeBtnClick {
    if (!_user) {
        return;
    }
    
    if (![ZZUtils isUserLogin]) {
        return;
    }
    
    [MobClick event:Event_click_user_detail_codeshare];
    
    [ZZHUD showWithStatus:@"快照生成中..."];
    WeakSelf
    [self fetchInviteWithCompleteBlock:^(ZZCommissionModel *model) {
        if (model) {
            ZZCommissionShareView *view = [[ZZCommissionShareView alloc] initWithInfoModel:model
                                                                                      user:_user
                                                                                     frame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, SCREEN_HEIGHT) entry:CommissionChannelEntryUser];
            [[UIApplication sharedApplication].keyWindow addSubview:view];
            
            UIImage *image = [view cutFromView:view];
            [view removeFromSuperview];
            view = nil;
            if (image) {
                [ZZHUD dismiss];
                [weakSelf shareImage:image];
                weakSelf.shotImage = image;
            }
            else {
                [ZZHUD showErrorWithStatus:@"分享失败"];
            }
        }
    }];
}

- (void)shareImage:(UIImage *)image {
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareImageObject *imageObject = [[UMShareImageObject alloc] init];
    imageObject.shareImage = image;
    messageObject.shareObject = imageObject;
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatTimeLine messageObject:messageObject currentViewController:_ctl completion:^(id result, NSError *error) {
        if (!error) {
            NSLog(@"PY_分享快照成功");
            [ZZHUD showTaskInfoWithStatus:@"分享成功"];

            [ZZIntegralHelper shareTheSnapshotWithType:@"7" success:^{
                NSLog(@"PY_分享快照增加积分成功");
            } failure:^(ZZError *error) {
                [ZZHUD showTastInfoErrorWithString:error.message];
            }];
            [MobClick event:Event_share_to_friendcircle];
        }else{
            [ZZHUD showTastInfoErrorWithString:error.domain];
        }
    }];
}

- (void)fetchInviteWithCompleteBlock:(void(^)(ZZCommissionModel *model))completeBlock {
    [ZZRequest method:@"GET" path:@"/api/getUserInviteCode" params:@{@"id": [ZZUserHelper shareInstance].loginer.uid} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            if (completeBlock) {
                completeBlock(nil);
            }
        }
        else {
            ZZCommissionModel *model = [ZZCommissionModel yy_modelWithDictionary:data];
            if (model && !isNullString(model.inviteURL)) {
                if (completeBlock) {
                    completeBlock(model);
                }
            }
            else {
                if (completeBlock) {
                    completeBlock(nil);
                }
            }
        }
    }];
}

@end
