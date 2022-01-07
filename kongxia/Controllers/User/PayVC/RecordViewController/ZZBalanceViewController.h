//
//  ZZBalanceViewController.h
//  zuwome
//
//  Created by 潘杨 on 2017/12/29.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//余额的记录
#import "ZZViewController.h"
#import "ZZWalletEmptyView.h"

@interface ZZBalanceViewController : ZZViewController
@property (nonatomic, strong) ZZWalletEmptyView *emptyView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@end
