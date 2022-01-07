//
//  ZZPrivateChatPayChatBoxView.m
//  zuwome
//
//  Created by 潘杨 on 2018/3/23.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZPrivateChatPayChatBoxView.h"

@implementation ZZPrivateChatPayChatBoxView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.messageTitleLab];
        [self addSubview:self.imageView];
    }
    return self;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.image = [UIImage imageNamed:@"chatRoom_Tool_TiSi"];
    }
    return _imageView;
}

- (UILabel *)messageTitleLab {
    if (!_messageTitleLab) {
        _messageTitleLab = [[UILabel alloc]init];
        _messageTitleLab.textColor = RGBCOLOR(173, 173, 177);
        _messageTitleLab.textAlignment = NSTextAlignmentCenter;
        _messageTitleLab.font = [UIFont systemFontOfSize:12];
        if (!isNullString([ZZUserHelper shareInstance].configModel.priceConfig.text_chat[@"send_need_cost"])) {
            _messageTitleLab.text = [ZZUserHelper shareInstance].configModel.priceConfig.text_chat[@"send_need_cost"];
        }
        else {
//            _messageTitleLab.text = @"发送每条私信赠送对方2张私信卡";
        }
        
    }
    return _messageTitleLab;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.messageTitleLab.mas_left).offset(-5);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    [self.messageTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    
}

@end
