//
//  UIResponder+ZZRouter.h
//  zuwome
//
//  Created by angBiu on 2016/11/3.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (ZZRouter)

- (void)routerEventWithName:(NSInteger)event userInfo:(NSDictionary *)userInfo Cell:(UITableViewCell *)cell;

@end
