//
//  ZZHomeRecommendViewController.h
//  zuwome
//
//  Created by angBiu on 16/7/18.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZViewController.h"
#import "ZZHomeModel.h"
/**
 *  首页 - 新鲜页
 */
@interface ZZHomeRefreshViewController : ZZViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSDictionary *filterDict;
@property (nonatomic, assign) BOOL update;//是否需要更新
@property (nonatomic, assign) BOOL haveGetLocation;
@property (nonatomic, copy) void(^didScroll)(CGFloat offset);
@property (nonatomic, copy) void(^didScrollStatus)(BOOL isShow);
@property (nonatomic, copy) dispatch_block_t callBack;
@property (nonatomic, copy) void(^tapCell)(ZZHomeNearbyModel *model,UIImageView *imgView);
@property (nonatomic, copy) void(^touchCancel)(NSString *uid);

@property (nonatomic, assign) BOOL canScroll;

- (void)updateData;
- (void)refresh;
- (void)refreshCancel:(NSString *)uid;

@end
