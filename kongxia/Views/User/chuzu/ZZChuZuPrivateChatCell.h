//
//  ZZChuZuPrivateChat.h
//  zuwome
//
//  Created by 潘杨 on 2018/4/24.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 达人出租私聊收费
 */
@interface ZZChuZuPrivateChatCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLable;//标题
@property (nonatomic, strong) UILabel *contentLable;//内容
@property (nonatomic, strong) UILabel *promptLable;//提示
@property (nonatomic, strong) UISwitch *openSwitch;//开关
+ (NSString *)reuseIdentifier;

@end
