//
//  ZZCustomChatImage.h
//  zuwome
//
//  Created by 潘杨 on 2018/4/23.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 聊天气泡  44pt
 */
@interface ZZCustomChatImage : UIImageView
- (void)drawInboundsRight:(CGRect )recent;
- (void)drawInboundsleft:(CGRect )recent;
@end
