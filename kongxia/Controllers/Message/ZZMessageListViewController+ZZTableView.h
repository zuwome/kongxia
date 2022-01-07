//
//  ZZMessageListViewController+ZZTableView.h
//  zuwome
//
//  Created by 潘杨 on 2017/12/15.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZMessageListViewController.h"

/**
 *  注：2018.7.24 消息页改版，系统消息改放在tableheader里。防止更改出现bug，tableview的section0（即原系统消息）不移除，改为隐藏。
 */

@interface ZZMessageListViewController (ZZTableView)<UITableViewDataSource,UITableViewDelegate, UIScrollViewDelegate>

- (void)registerCellForTableView:(UITableView *)tableView;

@end
