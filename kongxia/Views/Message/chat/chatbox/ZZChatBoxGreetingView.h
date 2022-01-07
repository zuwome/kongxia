//
//  ZZChatBoxGreetingView.h
//  zuwome
//
//  Created by MaoMinghui on 2018/9/4.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *  常用语界面
 */

@interface ZZChatBoxGreetingView : UIView

@property (nonatomic, copy) void(^selectGreeting)(NSString *greeting);
@property (nonatomic, copy) void(^sendGreeting)(NSString *greeting);

@end
