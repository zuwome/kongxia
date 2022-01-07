//
//  ZZChatRealTimeEndCell.m
//  zuwome
//
//  Created by angBiu on 2016/11/17.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChatRealTimeEndCell.h"

#import "ZZDateHelper.h"

@implementation ZZChatRealTimeEndCell
{
    UIView          *_bgView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = HEXCOLOR(0xF0F0F0);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _timeView = [[ZZChatTimeView alloc] init];
        [self.contentView addSubview:_timeView];
        
        [_timeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left);
            make.right.mas_equalTo(self.contentView.mas_right);
            make.top.mas_equalTo(self.contentView.mas_top);
            make.height.mas_equalTo(@30);
        }];
        
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = kGrayTextColor;
        _bgView.layer.cornerRadius = 4;
        [self.contentView addSubview:_bgView];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(15);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.text = @"位置共享已结束";
        [_bgView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_bgView.mas_top).offset(3);
            make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-3);
            make.left.mas_equalTo(_bgView.mas_left).offset(5);
            make.right.mas_equalTo(_bgView.mas_right).offset(-5);
        }];
    }
    
    return self;
}

- (void)setData:(ZZChatBaseModel *)model
{
    //是否显示时间
    CGFloat topOffset = 0;
    if (model.showTime) {
        _timeView.hidden = NO;
        _timeView.timeLabel.text = [[ZZDateHelper shareInstance] getMessageChatMessageTime:model.message.sentTime];
        topOffset = 45;
    } else {
        _timeView.hidden = YES;
        topOffset = 15;
    }
    
    [_bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topOffset);
    }];
}

@end
