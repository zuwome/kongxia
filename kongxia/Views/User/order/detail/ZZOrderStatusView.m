//
//  ZZOrderStatusView.m
//  zuwome
//
//  Created by angBiu on 16/7/4.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZOrderStatusView.h"

@implementation ZZOrderStatusView
{
    UIView                  *_statueBgView;
    OrderDetailType         _detailType;
    BOOL                    _isFrom;
    ZZOrder                 *_order;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 3;
        [self addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(8);
            make.right.mas_equalTo(self.mas_right).offset(-8);
            make.width.mas_equalTo(SCREEN_WIDTH - 16);
            make.top.mas_equalTo(self.mas_top).offset(14);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-8);
        }];
        
        _imgView = [[UIImageView alloc] init];
        [bgView addSubview:_imgView];
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(bgView.mas_top).offset(10);
            make.left.mas_equalTo(bgView.mas_left).offset(10);
            make.size.mas_equalTo(CGSizeMake(22, 22));
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:17];
        [bgView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imgView.mas_right).offset(8);
            make.centerY.mas_equalTo(_imgView.mas_centerY);
        }];
        
        UIImageView *arrowImgView = [[UIImageView alloc] init];
        arrowImgView.image = [UIImage imageNamed:@"icon_order_right"];
        [bgView addSubview:arrowImgView];
        
        [arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(bgView.mas_right).offset(-10);
            make.centerY.mas_equalTo(_imgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(5, 11));
        }];
        
        UILabel *infoLabel = [[UILabel alloc] init];
        infoLabel.textAlignment = NSTextAlignmentRight;
        infoLabel.textColor = kBlackTextColor;
        infoLabel.font = [UIFont systemFontOfSize:12];
        infoLabel.text = @"详情";
        [bgView addSubview:infoLabel];
        
        [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(arrowImgView.mas_left).offset(-8);
            make.centerY.mas_equalTo(arrowImgView.mas_centerY);
        }];
        
        UIButton *btn = [[UIButton alloc] init];
        [btn addTarget:self action:@selector(gotoTimeLine) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_imgView.mas_top);
            make.left.mas_equalTo(_imgView.mas_left);
            make.right.mas_equalTo(arrowImgView.mas_right);
            make.bottom.mas_equalTo(_imgView.mas_bottom);
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = kGrayTextColor;
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.numberOfLines = 0;
        [bgView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imgView.mas_left);
            make.right.mas_equalTo(arrowImgView.mas_right);
            make.top.mas_equalTo(_imgView.mas_bottom).offset(5);
        }];
        
        _statueBgView = [[UIView alloc] init];
        _statueBgView.backgroundColor = [UIColor clearColor];
        [bgView addSubview:_statueBgView];
        
        [_statueBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_contentLabel.mas_left);
            make.right.mas_equalTo(arrowImgView.mas_right);
            make.top.mas_equalTo(_contentLabel.mas_bottom).offset(20);
            make.height.mas_equalTo(30);
            make.bottom.mas_equalTo(bgView.mas_bottom).offset(-11);
        }];
        
        bgView.layer.shadowColor = HEXCOLOR(0xdedcce).CGColor;
        bgView.layer.shadowOffset = CGSizeMake(0, 1);
        bgView.layer.shadowOpacity = 0.9;
        bgView.layer.shadowRadius = 1;
    }
    
    return self;
}

- (void)gotoTimeLine
{
    if (_touchDetail) {
        _touchDetail();
    }
}

#pragma mark -

- (void)setOrder:(ZZOrder *)order type:(OrderDetailType)type
{
    _order = order;
    _isFrom = [order.from.uid isEqualToString:[ZZUserHelper shareInstance].loginer.uid];
    NSInteger index = 0;
    NSInteger count = 0;
    _detailType = type;
    switch (type) {
        case OrderDetailTypeAppealing:
        {
            _imgView.image = [UIImage imageNamed:@"icon_order_paying"];
            _titleLabel.text = @"申诉中";
            index = 1;
            count = 3;
        }
            break;
        case OrderDetailTypeRefunding:
        {
            _imgView.image = [UIImage imageNamed:@"icon_order_paying"];
            _titleLabel.text = @"申请退款";
            index = 1;
            count = 3;
        }
            break;
        case OrderDetailTypeRefusedRefund:
        {
            _imgView.image = [UIImage imageNamed:@"icon_order_paying"];
            _titleLabel.text = @"拒绝退款";
            index = 0;
            count = 3;
        }
            break;
        case OrderDetailTypeRefunded:
        {
            _imgView.image = [UIImage imageNamed:@"icon_order_paying"];
            _titleLabel.text = @"已退款";
            index = 2;
            count = 3;
        }
            break;
        case OrderDetailTypeRefundHanding:
        {
            _imgView.image = [UIImage imageNamed:@"icon_order_paying"];
            _titleLabel.text = @"同意退款";
            index = 1;
            count = 3;
        }
            break;
        case OrderDetailTypePending:
        {
            _imgView.image = [UIImage imageNamed:@"icon_order_pending"];
            _titleLabel.text = @"待接受";
            index = 0;
            count = 4;
        }
            break;
        case OrderDetailTypeCancel:
        {
            _imgView.image = [UIImage imageNamed:@"icon_order_end"];
            _titleLabel.text = @"已结束";
            index = 4;
            count = 4;
        }
            break;
        case OrderDetailTypeRefused:
        {
            _imgView.image = [UIImage imageNamed:@"icon_order_end"];
            _titleLabel.text = @"已结束";
            index = 4;
            count = 4;
        }
            break;
        case OrderDetailTypePaying:
        {
            _imgView.image = [UIImage imageNamed:@"icon_order_paying"];
            _titleLabel.text = @"待付款";
            index = 1;
            count = 4;
        }
            break;
        case OrderDetailTypeMeeting:
        {
            _imgView.image = [UIImage imageNamed:@"icon_order_meeting"];
            _titleLabel.text = @"待见面";
            index = 2;
            count = 4;
            if (_order.met && _order.met.to) {
                _titleLabel.text = @"见面中";
            }
        }
            break;
        case OrderDetailTypeCommenting:
        {
            if (_order.met && _order.met.to && _order.met.from) {
                _imgView.image = [UIImage imageNamed:@"icon_order_commentting"];
                _titleLabel.text = @"待评价";
                index = 3;
                count = 4;
            } else {
                _imgView.image = [UIImage imageNamed:@"icon_order_meeting"];
                _titleLabel.text = @"见面中";
                index = 2;
                count = 4;
            }
        }
            break;
        case OrderDetailTypeCommented:
        {
            _imgView.image = [UIImage imageNamed:@"icon_order_end"];
            _titleLabel.text = @"已结束";
            index = 4;
            count = 4;
        }
            break;
        default:
            break;
    }
    
    [self setSelectIndex:index count:count];
}

- (void)setSelectIndex:(NSInteger)index count:(NSInteger)count
{
    [_statueBgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *viewArray = [NSMutableArray array];
    CGFloat width = [ZZUtils widthForCellWithText:@"提交申请" fontSize:12];
    
    if (count == 3) {
        [array addObjectsFromArray:@[@"提交申请",@"处理中",@"处理结果"]];
    } else {
        if (index == 0 || _detailType == OrderDetailTypeCancel || _detailType == OrderDetailTypeRefused) {
            [array addObject:@"待接受"];
        } else {
            [array addObject:@"已接受"];
        }
        if (index <= 1 || _detailType == OrderDetailTypeCancel || _detailType == OrderDetailTypeRefused) {
            [array addObject:@"待付款"];
        } else {
            [array addObject:@"已付款"];
        }
        if (index <= 2 || _detailType == OrderDetailTypeCancel || _detailType == OrderDetailTypeRefused) {
            if (_detailType == OrderDetailTypeMeeting) {
                if (_order.met && _order.met.to) {
                    [array addObject:@"见面中"];
                } else {
                    [array addObject:@"待见面"];
                }
            } else if (_detailType == OrderDetailTypeCommenting) {
                [array addObject:@"见面中"];
            } else {
                [array addObject:@"待见面"];
            }
        } else {
            [array addObject:@"已见面"];
        }
        if (index <= 3 || _detailType == OrderDetailTypeCancel || _detailType == OrderDetailTypeRefused) {
            [array addObject:@"待评价"];
        } else {
            [array addObject:@"已评价"];
        }
    }
    CGFloat space = (SCREEN_WIDTH - 40 - width*count)/(count - 1);
    
    for (int i=0; i<array.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = kBlackTextColor;
        label.font = [UIFont systemFontOfSize:12];
        label.text = array[i];
        [_statueBgView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_statueBgView.mas_left).offset((width+space)*i);
            make.top.mas_equalTo(_statueBgView.mas_top);
            make.width.mas_equalTo(width);
        }];
        
        if (index == i) {
            UIImageView *cycleView = [[UIImageView alloc] init];
            cycleView.image = [UIImage imageNamed:@"icon_order_cycle"];
            [_statueBgView addSubview:cycleView];
            cycleView.layer.cornerRadius = 5;
            [cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(_statueBgView.mas_bottom).offset(-5);
                make.centerX.mas_equalTo(label.mas_centerX);
                make.size.mas_equalTo(CGSizeMake(9, 9));
            }];
            [viewArray addObject:cycleView];
        } else {
            UIView *cycleView = [[UIView alloc] init];
            cycleView.backgroundColor = kBlackTextColor;
            [_statueBgView addSubview:cycleView];
            cycleView.layer.cornerRadius = 2;
            [cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(_statueBgView.mas_bottom).offset(-5);
                make.centerX.mas_equalTo(label.mas_centerX);
                make.size.mas_equalTo(CGSizeMake(4, 4));
            }];
            [viewArray addObject:cycleView];
        }
    }
    
    for (int i=0; i<array.count - 1; i++) {
        UIView *leftView = viewArray[i];
        UIView *rightView = viewArray[i+1];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kBlackTextColor;
        [_statueBgView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftView.mas_right).offset(3);
            make.right.mas_equalTo(rightView.mas_left).offset(-3);
            make.centerY.mas_equalTo(leftView.mas_centerY);
            make.height.mas_equalTo(1);
        }];
    }
}

@end
