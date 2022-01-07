//
//  ZZPrivateChatPayChatBoxView.h
//  zuwome
//
//  Created by 潘杨 on 2018/3/23.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//私聊付费用户的消息提示框
//如果开通了私聊付费功能,聊天工具栏上面进行提示

#import <UIKit/UIKit.h>

@interface ZZPrivateChatPayChatBoxView : UIView


/**
私聊付费上面的提示Lab
 */
@property(nonatomic,strong) UILabel *messageTitleLab;


@property(nonatomic,strong) UIImageView *imageView;


@end
