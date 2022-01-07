//
//  ZZMessageHeadView.h
//  zuwome
//
//  Created by angBiu on 16/9/12.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZMessageHeadViewCell.h"

#define MsgHeaderHeight 100

/**
 *  消息头部view
 */
@interface ZZMessageHeadView : UIView

@property (nonatomic, strong) NSDictionary *msgListSystemUIDict;

@property (nonatomic, copy) void(^systemCellClick)(ZZMessageHeadViewCell *cell, NSIndexPath *indexPath);

@end
