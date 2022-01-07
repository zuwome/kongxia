//
//  ZZOrderTimeLineView.h
//  zuwome
//
//  Created by angBiu on 16/7/5.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZOrder;
/**
 *  订单 时间轴
 */
@interface ZZOrderTimeLineView : UIView <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) NSMutableArray *messageArray;

- (id)initWithFrame:(CGRect)frame order:(ZZOrder *)order;

@end
