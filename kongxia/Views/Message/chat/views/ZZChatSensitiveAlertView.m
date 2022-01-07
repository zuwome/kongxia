//
//  ZZChatSensitiveAlertView.m
//  zuwome
//
//  Created by angBiu on 2017/5/17.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZChatSensitiveAlertView.h"

@interface ZZChatSensitiveAlertView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *sureBtn;

@end

@implementation ZZChatSensitiveAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat scale = SCREEN_WIDTH/375.0;
        
        UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        coverView.backgroundColor = HEXACOLOR(0x000000, 0.75);
        [self addSubview:coverView];
        
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 3;
        _bgView.clipsToBounds = YES;
        [self addSubview:_bgView];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(self);
            make.width.mas_equalTo(294*scale);
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"icon_chat_sensitive_top"];
        [_bgView addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_bgView.mas_top).offset(15);
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(96.5*scale, 96.5*scale));
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = kBlackTextColor;
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.text = @"温馨提示";
        [self.bgView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imgView.mas_bottom).offset(10);
            make.centerX.mas_equalTo(_bgView.mas_centerX);
        }];
        
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.textColor = HEXCOLOR(0x999999);
        contentLabel.font = [UIFont systemFontOfSize:14];
        contentLabel.numberOfLines = 0;
        [_bgView addSubview:contentLabel];
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(20);
            make.right.mas_equalTo(_bgView.mas_right).offset(-20);
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(8);
        }];
        
        NSString *string = @"请不要通过微信、QQ或其他外部聊天工具进行沟通，更不要脱离空虾平台担保付款，以避免在交易中被骗导致钱款损失，平台也无法保障到您\n*主动透露联系方式或未通过平台查看微信,将面临50元/次罚款及封禁处理";
        NSMutableAttributedString *attributedString = [ZZUtils setLineSpace:string space:5 fontSize:14 color:HEXCOLOR(0x999999)];
        NSRange range1 = [string rangeOfString:@"不要脱离空虾平台担保付款"];
        NSRange range2 = [string rangeOfString:@"不要"];
        NSRange range3 = [string rangeOfString:@"*主动透露联系方式或未通过平台查看微信,将面临50元/次罚款及封禁处理"];
        if (range1.location != NSNotFound) {
            [attributedString addAttribute:NSForegroundColorAttributeName value:kRedTextColor range:range1];
        }
        if (range2.location != NSNotFound) {
            [attributedString addAttribute:NSForegroundColorAttributeName value:kRedTextColor range:range2];
        }
        if (range3.location != NSNotFound) {
            [attributedString addAttribute:NSForegroundColorAttributeName value:kRedTextColor range:range3];
        }
        contentLabel.attributedText = attributedString;
        contentLabel.textAlignment = NSTextAlignmentCenter;
        
        _sureBtn = [[UIButton alloc] init];
        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_sureBtn setTitle:@"知道了" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:kBlackTextColor forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _sureBtn.backgroundColor = kYellowColor;
        _sureBtn.layer.cornerRadius = 22;
        [_bgView addSubview:_sureBtn];
        
        [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(contentLabel.mas_bottom).offset(15);
            make.centerX.mas_equalTo(_bgView.mas_centerX);
            make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-18);
            make.size.mas_equalTo(CGSizeMake(178*scale, 44));
        }];
        
        _sureBtn.layer.shadowColor = HEXCOLOR(0x979797).CGColor;
        _sureBtn.layer.shadowOffset = CGSizeMake(0, 1);
        _sureBtn.layer.shadowRadius = 1;
        _sureBtn.layer.shadowOpacity = 0.5;
    }
    
    return self;
}

- (void)sureBtnClick
{
    [self removeFromSuperview];
    if (_touchSure) {
        _touchSure();
    }
}

@end
