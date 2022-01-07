//
//  ZZMessageAttentDynamicViewController.h
//  zuwome
//
//  Created by angBiu on 16/8/22.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  关注人的动态
 */
@interface ZZAttentDynamicViewController : UIViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) dispatch_block_t pushCallBack;
@property (nonatomic, copy) void(^didScroll)(CGFloat offset);
@property (nonatomic, copy) void(^didScrollStatus)(BOOL isShow);

@end
