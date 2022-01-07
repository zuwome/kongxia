//
//  UITableViewCell+CellAdd.m
//  zuwome
//
//  Created by angBiu on 2017/7/11.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "UITableViewCell+CellAdd.h"
#import <objc/runtime.h>

@implementation UITableViewCell (CellAdd)

YYSYNTH_DYNAMIC_PROPERTY_CTYPE(isDisplayed, setDisplayed, BOOL)

- (void)tableView:(UITableView *)tableView forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.isDisplayed) {
        CGRect originFrame = self.frame;
        CGRect frame = self.frame;
        frame.origin.x = tableView.frame.size.width;
        self.frame = frame;
        
        NSTimeInterval duration = 0.5 + (NSTimeInterval)(indexPath.row) / 5.0;
        [UIView animateWithDuration:duration animations:^{
            self.frame = originFrame;
        } completion:nil];
        
        self.displayed = YES;
    }
}

@end
