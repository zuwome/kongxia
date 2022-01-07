//
//  UIResponder+ZZRouter.m
//  zuwome
//
//  Created by angBiu on 2016/11/3.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "UIResponder+ZZRouter.h"

@implementation UIResponder (ZZRouter)

- (void)routerEventWithName:(NSInteger)event userInfo:(NSDictionary *)userInfo Cell:(UITableViewCell *)cell
{
    [[self nextResponder] routerEventWithName:event userInfo:userInfo Cell:cell];
}

@end
