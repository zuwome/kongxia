//
//  ZZChatRealTimeStartCell.m
//  zuwome
//
//  Created by angBiu on 2016/11/17.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChatRealTimeStartCell.h"

@implementation ZZChatRealTimeStartCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        _locationImgView = [[UIImageView alloc] init];
        _locationImgView.image = [UIImage imageNamed:@"blue_location_icon"];
        [self.bgView addSubview:_locationImgView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kBlackTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.text = @"我发起了位置共享";
        [self.bgView addSubview:_titleLabel];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(realTimeClick)];
        [self.bgView addGestureRecognizer:recognizer];
    }
    
    return self;
}

- (void)setData:(ZZChatBaseModel *)model
{
    [super setData:model];
    
    RCMessage *message = model.message;
    
    if (message.messageDirection == MessageDirection_SEND) {
        [_locationImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.bgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(15, 20));
            make.right.mas_equalTo(self.bgView.mas_right).offset(-14);
        }];
        [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_locationImgView.mas_left).offset(-5);
            make.centerY.mas_equalTo(self.bgView.mas_centerY);
            make.left.mas_equalTo(self.bgView.mas_left).offset(24);
        }];
    } else {
        [_locationImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.bgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(15, 20));
            make.left.mas_equalTo(self.bgView.mas_left).offset(14);
        }];
        [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_locationImgView.mas_right).offset(5);
            make.centerY.mas_equalTo(self.bgView.mas_centerY);
            make.right.mas_equalTo(self.bgView.mas_right).offset(-24);
        }];
    }
}

- (void)realTimeClick
{
    [[self nextResponder] routerEventWithName:ZZRouterEventTapRealTime userInfo:@{@"data":self.dataModel} Cell:self];
}

@end
