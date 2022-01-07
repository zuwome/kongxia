//
//  ZZContactViewController.h
//  zuwome
//
//  Created by angBiu on 2016/10/26.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZViewController.h"
/**
 *  设置 ---- 联系人
 */
@interface ZZContactViewController : ZZViewController

@end

@protocol ZZContactViewSearchResultsControllerDelegate <NSObject>

- (void)blockUserDidChanged:(NSMutableArray *)blcokArray;

@end

@interface ZZContactViewSearchResultsController : UITableViewController

@property (nonatomic, weak) id<ZZContactViewSearchResultsControllerDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *blcokArray;//屏蔽的人

@property (nonatomic, strong) NSDictionary *contactPeopleDict;

@property (nonatomic, strong) NSArray *keysArray;

@property (nonatomic, strong) NSMutableArray *searchArray;


@end
