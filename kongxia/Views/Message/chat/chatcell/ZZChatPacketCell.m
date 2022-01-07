//
//  ZZChatPacketCell.m
//  zuwome
//
//  Created by angBiu on 16/9/27.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZChatPacketCell.h"

#import "ZZChatPacketModel.h"

@implementation ZZChatPacketCell
{
    UIView                      *_packetBgView;
    UILabel                     *_titleLabel;
    UIView                      *_bottomView;
    UIImageView                 *_packetImgView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        _packetBgView = [[UIView alloc] init];
        [self.bgView addSubview:_packetBgView];
        
        [_packetBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.bgView);
        }];
        
        _topImgView = [[UIImageView alloc] init];
        _topImgView.image = [UIImage imageNamed:@"icon_chat_packet_topbg"];
        _topImgView.contentMode = UIViewContentModeScaleToFill;
        [_packetBgView addSubview:_topImgView];
        
        [_topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_packetBgView.mas_left);
            make.top.mas_equalTo(_packetBgView.mas_top);
            make.right.mas_equalTo(_packetBgView.mas_right);
            make.height.mas_equalTo(@28);
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = kYellowColor;
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.text = @"红包留言";
        [_packetBgView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_topImgView.mas_left).offset(8);
            make.centerY.mas_equalTo(_topImgView.mas_centerY);
        }];
        
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [_packetBgView addSubview:_bottomView];
        
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_topImgView.mas_left);
            make.right.mas_equalTo(_topImgView.mas_right);
            make.top.mas_equalTo(_topImgView.mas_bottom);
            make.bottom.mas_equalTo(_packetBgView.mas_bottom);
        }];
        
        _packetImgView = [[UIImageView alloc] init];
        _packetImgView.image = [UIImage imageNamed:@"icon_chat_packet"];
        _packetImgView.contentMode = UIViewContentModeScaleToFill;
        [_bottomView addSubview:_packetImgView];
        
        [_packetImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bottomView.mas_left).offset(8);
            make.centerY.mas_equalTo(_bottomView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(44, 50));
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = kBlackTextColor;
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.numberOfLines = 0;
        [_bottomView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_bottomView.mas_centerY);
            make.left.mas_equalTo(_packetImgView.mas_right).offset(8);
            make.right.mas_equalTo(_bottomView.mas_right).offset(-8);
        }];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(packetClick)];
        [self.bgView addGestureRecognizer:recognizer];
    }
    
    return self;
}

- (void)setData:(ZZChatBaseModel *)model
{
    [super setData:model];

    RCMessage *message = model.message;
    ZZChatPacketModel *packetModel = (ZZChatPacketModel *)message.content;
    _contentLabel.text = packetModel.content;
    
    CGFloat width = SCREEN_WIDTH - 40*2 - 20;
    if (message.messageDirection == MessageDirection_SEND) {
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_topImgView.mas_left).offset(8);
        }];
        [_packetImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bottomView.mas_left).offset(8);
        }];
    } else {
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_topImgView.mas_left).offset(8+8);
        }];
        [_packetImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bottomView.mas_left).offset(8+8);
        }];
        width = width - 8;
    }
    CGFloat height = 0;
    CGFloat contentHeight = [ZZUtils heightForCellWithText:packetModel.content fontSize:14 labelWidth:(width - 44 - 24)];
    if (contentHeight < 80) {
        height = 80 + 28;
    } else {
        height = contentHeight + 28;
    }
    
    [_packetBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(width, height));
    }];
    
//    CALayer *layer = self.bubbleImgView.layer;
//    layer.frame	= (CGRect){{0,0},CGSizeMake(width, height)};
//    _packetBgView.layer.mask = layer;
}

#pragma mark - 

- (void)packetClick
{
    [[self nextResponder] routerEventWithName:ZZRouterEventTapPacket
                                     userInfo:@{@"data":self.dataModel} Cell:self];
}

@end
