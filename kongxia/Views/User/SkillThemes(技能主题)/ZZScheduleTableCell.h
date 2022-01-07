//
//  ZZScheduleTableCell.h
//  zuwome
//
//  Created by MaoMinghui on 2018/8/1.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ScheduleTableCellIdentifier @"ScheduleTableCellIdentifier"

@interface ZZScheduleTableCell : UITableViewCell

@property (nonatomic, weak) NSMutableArray *scheduleArray;
@property (nonatomic, copy) dispatch_block_t chooseCallback;    //选择档期回调

@end
