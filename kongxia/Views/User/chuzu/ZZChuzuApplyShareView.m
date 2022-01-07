//
//  ZZChuzuApplyShareView.m
//  zuwome
//
//  Created by angBiu on 16/7/22.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChuzuApplyShareView.h"

#import <UMSocialCore/UMSocialCore.h>
#import "ZZUserHelper.h"
#import "ZZChuzuBubbleView.h"
#import "ZZRentShareSnapshotView.h"

@interface ZZChuzuApplyShareView ()

@property (nonatomic, assign) BOOL finish;//是否结束

@end

@implementation ZZChuzuApplyShareView
{
    UIImageView             *_headImgView;
    UIButton                *_selectBtn;
    ZZUser                  *_user;
    UIImageView             *_triangleImgView;
    ZZChuzuBubbleView       *_bubbleView;//气泡
    
    NSArray                 *_selectArray;
    NSArray                 *_unselectArray;
    CGFloat                 _offset;
}

- (instancetype)initWithFrame:(CGRect)frame controller:(UIViewController *)ctl
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _finish = YES;
        _shareCtl = ctl;
        UIImageView *bgImgView = [[UIImageView alloc] init];
        bgImgView.contentMode = UIViewContentModeScaleToFill;
        if (ISiPhone4) {
            bgImgView.image = [UIImage imageNamed:@"icon_chuzu_shareBg_00"];//[ZZUtils imageWithName:@"@2x"];
        } else if (ISiPhone5) {
            bgImgView.image = [UIImage imageNamed:@"icon_chuzu_shareBg_01"];//[ZZUtils imageWithName:@"icon_chuzu_shareBg_01@2x"];
        } else {
            bgImgView.image = [UIImage imageNamed:@"icon_chuzu_shareBg_02"];//[ZZUtils imageWithName:@"icon_chuzu_shareBg_02@2x"];
        }
        [self addSubview:bgImgView];
        
        [bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = kBlackTextColor;
        bgView.alpha = 0.8;
        [self addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        UIButton *cancelBtn = [[UIButton alloc] init];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        [cancelBtn setImage:[UIImage imageNamed:@"icon_cancel"] forState:UIControlStateNormal];
        cancelBtn.imageEdgeInsets = UIEdgeInsetsMake(20, 46, 46, 20);
        [self addSubview:cancelBtn];
        
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.right.mas_equalTo(self.mas_right);
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentRight;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = kYellowColor;
        titleLabel.text = @"稍后分享，完善资料";
        titleLabel.userInteractionEnabled = NO;
        [cancelBtn addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(cancelBtn.mas_right).offset(-15);
            make.centerY.mas_equalTo(cancelBtn.mas_centerY);
        }];
        
        UIView *shareBgView = [[UIView alloc] init];
        [self addSubview:shareBgView];
        
        [shareBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(@40);
        }];
        
        NSArray *normalImgArray = @[@"icon_chuzu_share_wechat_n",@"icon_chuzu_share_qq_n",@"icon_chuzu_share_wb_n",@"icon_chuzu_share_wxFriend_n"];
        NSArray *selectImgArray = @[@"icon_chuzu_share_wechat_p",@"icon_chuzu_share_qq_p",@"icon_chuzu_share_wb_p",@"icon_chuzu_share_wxFriend_p"];
        NSInteger count = 4;
        CGFloat btnWidth = 50;
        CGFloat space = 25;
        CGFloat leftOffset = (SCREEN_WIDTH - count*btnWidth - space*(count - 1))/2;
        _offset = leftOffset + btnWidth/2;
        for (int i=0; i<4; i++) {
            UIButton *btn = [[UIButton alloc] init];
            btn.tag = 100 + i;
            [btn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setImage:[UIImage imageNamed:normalImgArray[i]] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:normalImgArray[i]] forState:UIControlStateHighlighted];
            [btn setImage:[UIImage imageNamed:selectImgArray[i]] forState:UIControlStateSelected];
            [shareBgView addSubview:btn];

            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(shareBgView.mas_left).offset(leftOffset + i*(space+btnWidth));
                make.top.mas_equalTo(shareBgView.mas_top);
                make.bottom.mas_equalTo(shareBgView.mas_bottom);
                make.width.mas_equalTo(btnWidth);
            }];
            
            if (i==3) {
                _selectBtn = btn;
                
                _triangleImgView = [[UIImageView alloc] init];
                _triangleImgView.image = [UIImage imageNamed:@"icon_chuzu_triangle"];
                [self addSubview:_triangleImgView];
                
                [_triangleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(_selectBtn.mas_top);
                    make.centerX.mas_equalTo(_selectBtn.mas_centerX);
                    make.size.mas_equalTo(CGSizeMake(12, 8));
                }];
                
                _bubbleView = [[ZZChuzuBubbleView alloc] init];
                _bubbleView.titleLabel.text = @"哈哈哈";
                [self addSubview:_bubbleView];
                
                [_bubbleView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(_triangleImgView.mas_top);
                    make.center.mas_equalTo(_triangleImgView.mas_centerX);
                    make.height.mas_equalTo(@22);
                }];
                
                [self typeBtnClick:_selectBtn];
            }
        }
        
        UIButton *shareBtn = [[UIButton alloc] init];
        shareBtn.backgroundColor = kYellowColor;
        [shareBtn setTitle:@"分享快照" forState:UIControlStateNormal];
        [shareBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        shareBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        shareBtn.layer.cornerRadius = 3;
        [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:shareBtn];
        
        [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(shareBgView.mas_bottom).offset(35);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(120, 40));
        }];
        
        UILabel *shareLabel = [[UILabel alloc] init];
        shareLabel.textAlignment = NSTextAlignmentCenter;
        shareLabel.textColor = [UIColor whiteColor];
        shareLabel.font = [UIFont systemFontOfSize:15];
        shareLabel.text = @"做自己的经纪人，分享给小伙伴吧";
        [self addSubview:shareLabel];
        
        [shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(shareBgView.mas_top).offset(-55);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
        _applyLabel = [[UILabel alloc] init];
        _applyLabel.textAlignment = NSTextAlignmentCenter;
        _applyLabel.textColor = [UIColor whiteColor];
        _applyLabel.font = [UIFont systemFontOfSize:17];
        _applyLabel.text = @"申请成功";
        [self addSubview:_applyLabel];
        
        [_applyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(shareLabel.mas_top).offset(-10);
            make.centerX.mas_equalTo(shareLabel.mas_centerX);
        }];
        
        _headImgView = [[UIImageView alloc] init];
        _headImgView.contentMode = UIViewContentModeScaleAspectFill;
        _headImgView.layer.cornerRadius = 37;
        _headImgView.clipsToBounds = YES;
        _headImgView.backgroundColor = kGrayTextColor;
        [self addSubview:_headImgView];
        
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_applyLabel.mas_top).offset(-20);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(74, 74));
        }];
        
        WeakSelf;
        _user = [ZZUserHelper shareInstance].loginer;
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:_user.avatar] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            weakSelf.shareImg = image;
        }];
    }
    
    return self;
}

- (void)updateBubbleViewWidth
{
    CGFloat width = [_bubbleView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].width;
    
    [_bubbleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
}

#pragma mark - UIButtonClick

- (void)cancelBtnClick
{
    [self hiddenViews];
    if (_shareCallBack) {
        _shareCallBack();
    }
}

- (void)hiddenViews
{
    [MobClick event:Event_chuzu_share_cancel];
    self.hidden = YES;
    if (!_finish) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animation) object:nil];
    }
}

- (void)typeBtnClick:(UIButton *)sender
{
    if (_bubbleView.hidden) {
        _bubbleView.hidden = NO;
        _triangleImgView.hidden = NO;
    }
    if (sender == _selectBtn) {
        if (sender.selected) {
            sender.selected = NO;
            [self showUnselectText];
            _selectBtn = nil;
        } else {
            sender.selected = YES;
            _selectBtn = sender;
            [self showSelectText];
        }
    } else {
        _selectBtn.selected = NO;
        sender.selected = YES;
        _selectBtn = sender;
        [self showSelectText];
    }
}

- (void)showSelectText
{
    if (!_selectArray) {
        _selectArray = @[@"点击分享将跳转至微信",@"点击分享将跳转至QQ",@"点击分享将跳转至微信微博",@"点击分享将跳转至朋友圈"];
    }
    
    _bubbleView.titleLabel.text = _selectArray[_selectBtn.tag - 100];
    [self viewAnimation];
}

- (void)showUnselectText
{
    if (!_unselectArray) {
        _unselectArray = @[@"微信分享已关",@"QQ分享已关",@"微博分享已关",@"朋友圈分享已关"];
    }
    
    _bubbleView.titleLabel.text = _unselectArray[_selectBtn.tag - 100];
    [self viewAnimation];
}

- (void)viewAnimation
{
    [_triangleImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_selectBtn.mas_top);
        make.centerX.mas_equalTo(_selectBtn.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(12, 8));
    }];
    CGFloat width = [_bubbleView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].width;
    [_bubbleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_triangleImgView.mas_top);
        make.centerX.mas_equalTo(_triangleImgView.mas_centerX);
        make.height.mas_equalTo(@22);
    }];
    switch (_selectBtn.tag - 100) {
        case 0:
        {
            if (_offset < width/2 + 15) {
                [_bubbleView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(_triangleImgView.mas_top);
                    make.left.mas_equalTo(self.mas_left).offset(15);
                    make.height.mas_equalTo(@22);
                }];
            }
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            if (_offset < width/2 + 15) {
                [_bubbleView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(_triangleImgView.mas_top);
                    make.right.mas_equalTo(self.mas_right).offset(-15);
                    make.height.mas_equalTo(@22);
                }];
            }
        }
            break;
        default:
            break;
    }
    
    [self hideViews];
}

- (void)hideViews
{
    if (!_finish) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animation) object:nil];
    }
    [self performSelector:@selector(animation) withObject:nil afterDelay:5];
}

- (void)animation
{
    _bubbleView.hidden = YES;
    _triangleImgView.hidden = YES;
    _finish = YES;
}

- (void)shareBtnClick
{
    [MobClick event:Event_chuzu_share_perfect];
    if (!_selectBtn) {
        [self hiddenViews];
        if (_shareCallBack) {
            _shareCallBack();
        }
        return;
    }

    [self hiddenViews];
    
    ZZRentShareSnapshotView *shotView = [[ZZRentShareSnapshotView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    shotView.user = _user;
    
    [ZZHUD showWithStatus:@"快照生成中..."];
    WeakSelf;
    [shotView getShareSnapshotImage:^(UIImage *image) {
        [ZZHUD dismiss];
        [weakSelf shareImage:image];
    } failure:^{
        [ZZHUD showErrorWithStatus:@"分享失败"];
    }];
}

- (void)shareImage:(UIImage *)image
{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareImageObject *imageObject = [[UMShareImageObject alloc] init];
    imageObject.shareImage = image;
    messageObject.shareObject = imageObject;
    
    WeakSelf;
    switch (_selectBtn.tag - 100) {
        case 0:
        {
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:_shareCtl completion:^(id result, NSError *error) {
                if (!error) {
                    [MobClick event:Event_share_to_wechat];
                    [weakSelf callBack];
                }
            }];
        }
            break;
        case 1:
        {
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_QQ messageObject:messageObject currentViewController:_shareCtl completion:^(id result, NSError *error) {
                if (!error) {
                    [MobClick event:Event_share_to_qq];
                    [weakSelf callBack];
                }
            }];
        }
            break;
        case 2:
        {
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_Sina messageObject:messageObject currentViewController:_shareCtl completion:^(id result, NSError *error) {
                if (!error) {
                    [MobClick event:Event_share_to_weibo];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"分享成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    [weakSelf callBack];
                }
            }];
        }
            break;
        case 3:
        {
            [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatTimeLine messageObject:messageObject currentViewController:_shareCtl completion:^(id result, NSError *error) {
                if (!error) {
                    [MobClick event:Event_share_to_friendcircle];
                    [weakSelf callBack];
                }
            }];
        }
            break;
        default:
            break;
    }
}

- (void)callBack
{
    if (_shareCallBack) {
        _shareCallBack();
    }
}

@end
