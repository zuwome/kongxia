//
//  ZZCityViewController.h
//  zuwome
//
//  Created by angBiu on 16/7/27.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZViewController.h"
/**
 *  首页左上角选择城市
 */
@class ZZCity;
@interface ZZCityViewController : ZZViewController

@property (nonatomic, assign) BOOL isPush;

@property (nonatomic, copy) void(^selectCity)(NSString *cityName);

@property (nonatomic, copy) void(^selectedCity)(ZZCity *city);

@end

@protocol ZZCitySearchViewControllerDelegate <NSObject>

- (void)selectCity:(ZZCity *)city;

@end

@interface ZZCitySearchViewController : UITableViewController

@property (nonatomic, weak) id<ZZCitySearchViewControllerDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *cityArray;

@end
