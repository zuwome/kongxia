//
//  ZZChatStatusSheetView.m
//  zuwome
//
//  Created by angBiu on 2016/10/21.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChatStatusSheetView.h"

@implementation ZZChatStatusSheetView
{
    NSArray              *_titleArray;
    NSArray              *_imgArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        UIButton *bgBtn = [[UIButton alloc] init];
        bgBtn.backgroundColor = kBlackTextColor;
        bgBtn.alpha = 0.8;
        [bgBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgBtn];
        
        [bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }
    
    return self;
}

- (void)showSheetWithOrder:(ZZOrder *)order type:(OrderDetailType)type
{
    BOOL isFrom = [order.from.uid isEqualToString:[ZZUserHelper shareInstance].loginerId];
    switch (type) {
        case OrderDetailTypePending:
        {
            if (isFrom) {
                _titleArray = @[@"  取消预约",@"  修改预约信息"];
                _imgArray = @[@"icon_chat_status_cancel",@"icon_chat_status_edit"];
            } else {
                _titleArray = @[@"  拒绝邀约"];
                _imgArray = @[@"icon_chat_status_refuse"];
            }
        }
            break;
        case OrderDetailTypePaying:
        {
            _titleArray = @[@"  取消预约"];
            _imgArray = @[@"icon_chat_status_cancel"];
        }
            break;
        case OrderDetailTypeMeeting:
        {
            if (isFrom) {
                _titleArray = @[@"  申请退款"];
                _imgArray = @[@"icon_chat_status_refund"];
            } else {
                _titleArray = @[@"  取消预约"];
                _imgArray = @[@"icon_chat_status_cancel"];
            }
        }
            break;
        case OrderDetailTypeRefunding:
        {
            if (isFrom) {
                if (order.cancel_refund_times == 0) {
                    if (order.paid_at) {
                        _titleArray = @[@"  撤销退款申请",@"  修改退款申请"];
                        _imgArray = @[@"icon_chat_status_cancel",@"icon_chat_status_edit"];
                    } else {
                        _titleArray = @[@"  撤销退款申请"];
                        _imgArray = @[@"icon_chat_status_cancel",@"icon_chat_status_edit"];
                    }
                }
                else {
                    _titleArray = @[@"查看邀约详情"];
                    _imgArray = nil;
                }
                
                
            } else {
                _titleArray = @[@"查看邀约详情"];
                _imgArray = nil;
            }
        }
            break;
        case OrderDetailTypeCommenting:
        case OrderDetailTypeCancel:
        case OrderDetailTypeCommented:
        case OrderDetailTypeRefused:
        case OrderDetailTypeRefusedRefund:
        case OrderDetailTypeRefunded:
        {
            _titleArray = @[@"马上预约",@"查看邀约详情"];
            _imgArray = nil;
            
            if (isFrom) {
                if (order.to.rent.status != 2 || !order.to.rent.show) {
                    _titleArray = @[@"查看邀约详情"];
                }
            } else {
                if (order.from.rent.status != 2 || !order.from.rent.show) {
                    _titleArray = @[@"查看邀约详情"];
                }
            }
        }
            break;
        default:
        {
            _titleArray = @[@"查看邀约详情"];
            _imgArray = nil;
        }
            break;
    }
    
    [self addSubview:self.bgView];
    self.bgView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 16+(_titleArray.count+1)*50+SafeAreaBottomHeight);
    UIButton *cancelBtn = [[UIButton alloc] init];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.layer.cornerRadius = 4;
    [_bgView addSubview:cancelBtn];

    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bgView.mas_left).offset(15);
        make.right.mas_equalTo(_bgView.mas_right).offset(-15);
        make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-8-SafeAreaBottomHeight);
        make.height.mas_equalTo(@50);
    }];

    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, _titleArray.count * 50)];
    topView.backgroundColor = [UIColor whiteColor];
    topView.layer.cornerRadius = 4;
    topView.clipsToBounds = YES;
    [_bgView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bgView.mas_left).offset(15);
        make.right.mas_equalTo(_bgView.mas_right).offset(-15);
        make.bottom.mas_equalTo(cancelBtn.mas_top).offset(-6);
        make.height.mas_equalTo(@(50*_titleArray.count));
    }];

    for (int i=0; i<_titleArray.count; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.tag = 100 + i;
        [topView addSubview:btn];
        [btn setTitle:_titleArray[i] forState:UIControlStateNormal];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(topView.mas_left);
            make.right.mas_equalTo(topView.mas_right);
            make.top.mas_equalTo(topView.mas_top).offset(i*50);
            make.height.mas_equalTo(@50);
        }];
        if (_imgArray.count != 0) {
            [btn setImage:[UIImage imageNamed:_imgArray[i]] forState:UIControlStateNormal];
        }
        if (i!=0) {
            UIView *lineView = [[UIView alloc] init];
            lineView.backgroundColor = kLineViewColor;
            [topView addSubview:lineView];

            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(btn.mas_top);
                make.left.mas_equalTo(btn.mas_left);
                make.right.mas_equalTo(btn.mas_right);
                make.height.mas_equalTo(@0.5);
            }];
        }
    }
    
    [self viewUp];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = [UIColor clearColor];
    }
    return _bgView;
}


#pragma mark - UIButtonMethod

- (void)cancelBtnClick
{
    [self viewDown];
}

- (void)typeBtnClick:(UIButton *)sender
{
    
    NSString *string = sender.titleLabel.text;
    if ([string containsString:@"取消预约"]) {
        if (_touchCancel) {
            _touchCancel();
        }
    } else if ([string containsString:@"修改预约信息"]) {
        if (_touchEdit) {
            _touchEdit();
        }
    } else if ([string containsString:@"拒绝邀约"]) {
        if (_touchReject) {
            _touchReject();
        }
    } else if ([string containsString:@"申请退款"]) {
        if (_touchRefund) {
            _touchRefund();
        }
    } else if ([string containsString:@"马上预约"]) {
        if (_touchRent) {
            _touchRent();
        }
    } else if ([string containsString:@"向TA提问"]) {
        if (_touchAsk) {
            _touchAsk();
        }
    } else if ([string containsString:@"查看邀约详情"]) {
        if (_touchDetail) {
            _touchDetail();
        }
    } else if ([string containsString:@"撤销退款申请"]) {
        if (_touchRevokeRefund) {
            _touchRevokeRefund();
        }
    } else if ([string containsString:@"修改退款申请"]) {
        if (_touchEditRefund) {
            _touchEditRefund();
        }
    }
    [self viewDown];

}

#pragma mark -

- (void)viewUp
{
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.frame = CGRectMake(0, SCREEN_HEIGHT - _bgView.height, SCREEN_WIDTH, _bgView.height);
    }];
}

- (void)viewDown
{
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _bgView.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
