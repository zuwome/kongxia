//
//  ZZCommentLabelCell.h
//  zuwome
//
//  Created by angBiu on 2017/4/6.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZCommentLabelCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *labelArray;

@property (nonatomic, copy) void(^chooseLabel)(NSString *label);

@end
