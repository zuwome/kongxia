//
//  ZZWXReadedView.h
//  zuwome
//
//  Created by angBiu on 2017/6/1.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 查看过的微信
 */
@interface ZZWXReadedView : UIView

@property (nonatomic, copy) void(^gotoChatView)(ZZUser *user);
@property (nonatomic, copy) void(^gotoUserPage)(ZZUser *user);
@property (nonatomic, copy) void(^canScroll)(BOOL canScroll);

@end
