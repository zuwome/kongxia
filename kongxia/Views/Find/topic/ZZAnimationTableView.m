//
//  ZZAnimationTableView.m
//  zuwome
//
//  Created by angBiu on 2017/4/18.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZAnimationTableView.h"

@implementation ZZAnimationTableView

float oldOffset;
static float offsetX = 25;

-(void)scrollViewDidScroll:(UIScrollView *)scrollView Animation:(BOOL)animation
{
    NSArray *cellArry = [self visibleCells];
    UITableViewCell *cellFirst = [cellArry firstObject];
//    UITableViewCell *cellLast  = [cellArry lastObject];
    
    for (UITableViewCell *cell in cellArry) {
        {
            CGRect frame = cell.contentView.frame;
            frame.origin.y = 0;
            cell.contentView.frame = frame;
            cell.layer.zPosition = 0;
            cell.alpha = 1;
        };
        {
            CGRect frame = cell.frame;
            frame.origin.x = 0;
            frame.size.width = SCREEN_WIDTH;
            cell.frame = frame;
        };
    }
    
    cellFirst.layer.zPosition = -1;
//    cellLast.layer.zPosition = -1;
    
    if(!(scrollView.contentOffset.y <= 0 || scrollView.contentOffset.y >= (scrollView.contentSize.height-scrollView.frame.size.height))) {
        CGPoint point = [self convertPoint:[self rectForRowAtIndexPath:[self indexPathForCell:cellFirst]].origin toView:[self superview]];
        if(animation) {
            double py =  fabs(point.y);
            float scale;
            scale = (py/cellFirst.height);
            cellFirst.alpha = 1-scale;
            
            CGRect frame = cellFirst.frame;
            frame.origin.x = offsetX*scale;
            frame.size.width = SCREEN_WIDTH - 2*(offsetX*scale);
            cellFirst.frame = frame;
        }
        
        if(0 != point.y)
        {
            CGRect frame = cellFirst.contentView.frame;
            frame.origin.y = -point.y;
            cellFirst.contentView.frame = frame;
            
//            frame = cellLast.contentView.frame;
//            frame.origin.y = - frame.size.height - point.y;
//            cellLast.contentView.frame = frame;
        }
    }
    
    oldOffset = scrollView.contentOffset.y;
}

@end
