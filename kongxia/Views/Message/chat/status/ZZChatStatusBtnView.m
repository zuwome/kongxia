//
//  ZZChatStatusBtnView.m
//  zuwome
//
//  Created by angBiu on 16/10/18.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChatStatusBtnView.h"

#import "ZZViewHelper.h"

@interface ZZChatStatusBtnView ()

@property (nonatomic, strong) UILabel *frontLabel;

@end

@implementation ZZChatStatusBtnView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 3;
        
        _bgImgView = [[UIImageView alloc] init];
        [self addSubview:_bgImgView];
        
        [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        _titleLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentCenter textColor:kBlackTextColor fontSize:14 text:@""];
        _titleLabel.numberOfLines = 0;
        [self addSubview:_titleLabel];
        
        _frontLabel = [ZZViewHelper createLabelWithAlignment:NSTextAlignmentCenter textColor:[UIColor whiteColor] fontSize:14 text:@""];
        _frontLabel.backgroundColor = HEXCOLOR(0xffe462);
        _frontLabel.numberOfLines = 0;
        [self addSubview:_frontLabel];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelf)];
        recognizer.numberOfTapsRequired = 1;
        [self addGestureRecognizer:recognizer];
    }
    
    return self;
}

- (void)setData:(ZZOrder *)order detaiType:(OrderDetailType)type
{
    BOOL isFrom = [[ZZUserHelper shareInstance].loginer.uid isEqualToString:order.from.uid];
    NSString *widthString = @"哈哈哈哈";
    switch (type) {
        case OrderDetailTypePending:
        {
            self.userInteractionEnabled = YES;
            _titleLabel.text = isFrom ? @"修改预约":@"接受或拒绝";
            if (!isFrom) {
                widthString = @"哈哈哈哈哈";
            }
            _bgImgView.image = [[UIImage imageNamed:@"icon_chat_status_allow"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        }
            break;
        case OrderDetailTypePaying:
        {
            self.userInteractionEnabled = NO;
            _titleLabel.text = @"等待\n对方付款";
            _bgImgView.image = [[UIImage imageNamed:@"icon_chat_status_remindbg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        }
            break;
        case OrderDetailTypeAppealing:
        {
            self.userInteractionEnabled = NO;
            _titleLabel.text = @"申诉中";
            _bgImgView.image = [[UIImage imageNamed:@"icon_chat_status_remindbg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        }
            break;
        case OrderDetailTypeCancel:
        {
            self.userInteractionEnabled = NO;
            _titleLabel.text = @"已取消";
            _bgImgView.image = [[UIImage imageNamed:@"icon_chat_status_ban"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        }
            break;
        case OrderDetailTypeMeeting:
        {
            self.userInteractionEnabled = YES;
            if (isFrom) {
                _titleLabel.text = @"确认完成";
                _bgImgView.image = [[UIImage imageNamed:@"icon_chat_status_allow"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
            } else {
                _titleLabel.text = @"已到达";
                _bgImgView.image = [[UIImage imageNamed:@"icon_chat_status_allow"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
            }
        }
            break;
        case OrderDetailTypeCommenting:
        {
            self.userInteractionEnabled = YES;
            if (isFrom) {
                _titleLabel.text = @"待评价";
                _bgImgView.image = [[UIImage imageNamed:@"icon_chat_status_allow"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
            } else {
                if(order.met && order.met.to && order.met.from) {
                    _titleLabel.text = @"待评价";
                    _bgImgView.image = [[UIImage imageNamed:@"icon_chat_status_allow"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
                } else {
                    self.userInteractionEnabled = NO;
                    _titleLabel.text = @"待完成";
                    _bgImgView.image = [[UIImage imageNamed:@"icon_chat_status_remindbg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
                }
            }
        }
            break;
        case OrderDetailTypeCommented:
        {
            self.userInteractionEnabled = NO;
            _titleLabel.text = @"已评价";
            _bgImgView.image = [[UIImage imageNamed:@"icon_chat_status_ban"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        }
            break;
        case OrderDetailTypeRefunded:
        {
            self.userInteractionEnabled = NO;
            if (order.paid_at) {
                _titleLabel.text = @"已退款";
            } else {
                _titleLabel.text = @"已退\n意向金";
            }
            _bgImgView.image = [[UIImage imageNamed:@"icon_chat_status_ban"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        }
            break;
        case OrderDetailTypeRefundHanding:
        {
            self.userInteractionEnabled = NO;
            _titleLabel.text = @"退款\n处理中";
            _bgImgView.image = [[UIImage imageNamed:@"icon_chat_status_remindbg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        }
            break;
        case OrderDetailTypeRefunding:
        {
            if (isFrom) {
                self.userInteractionEnabled = NO;
                if (order.paid_at) {
                    _titleLabel.text = @"申请\n退款中";
                } else {
                    _titleLabel.text = @"申请退\n意向金中";
                }
                _bgImgView.image = [[UIImage imageNamed:@"icon_chat_status_remindbg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
            } else {
                self.userInteractionEnabled = YES;
                _titleLabel.text = @"查看\n退款详情";
                _bgImgView.image = [[UIImage imageNamed:@"icon_chat_status_allow"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
            }
        }
            break;
        case OrderDetailTypeRefused:
        {
            self.userInteractionEnabled = NO;
            _titleLabel.text = @"已拒绝";
            _bgImgView.image = [[UIImage imageNamed:@"icon_chat_status_ban"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        }
            break;
        case OrderDetailTypeRefusedRefund:
        {
            self.userInteractionEnabled = NO;
            _titleLabel.text = @"拒绝退款";
            _bgImgView.image = [[UIImage imageNamed:@"icon_chat_status_remindbg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        }
            break;
        default:
            break;
    }
    
    CGFloat width = [ZZUtils widthForCellWithText:widthString fontSize:14];
    CGFloat height = [ZZUtils heightForCellWithText:_titleLabel.text fontSize:14 labelWidth:width];
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height + 8);
    }];
    
    _titleLabel.frame = CGRectMake(0, 0, width+12, height+8);
    [_frontLabel.layer removeAllAnimations];
    if (self.userInteractionEnabled) {
        _frontLabel.hidden = NO;
        _frontLabel.frame = CGRectMake(0, -20, width+12, height+8+40);
        [self createMask];
        [self iPhoneFadeWithDuration:1.5];
    } else {
        _frontLabel.hidden = YES;
    }
}

- (void)createMask
{
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = _frontLabel.bounds;
    layer.colors = @[(id)[UIColor clearColor].CGColor,(id)HEXCOLOR(0xffe462).CGColor,(id)[UIColor clearColor].CGColor];
    layer.locations = @[@(0.4),@(0.5),@(0.6)];
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(1, 1);
    _frontLabel.layer.mask = layer;
    
    layer.position = CGPointMake(-_frontLabel.bounds.size.width/4.0, _frontLabel.bounds.size.height/2.0);
}

- (void)iPhoneFadeWithDuration:(NSTimeInterval)duration
{
    CABasicAnimation *basicAnimation = [CABasicAnimation animation];
    basicAnimation.keyPath = @"transform.translation.x";
    basicAnimation.fromValue = @(0);
    basicAnimation.toValue = @(_frontLabel.bounds.size.width+_frontLabel.bounds.size.width/2.0);
    basicAnimation.duration = duration;
    basicAnimation.repeatCount = 2;
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    [_frontLabel.layer.mask addAnimation:basicAnimation forKey:nil];
}

- (void)tapSelf
{
    if (_touchStatusBtn) {
        _touchStatusBtn();
    }
}

@end
