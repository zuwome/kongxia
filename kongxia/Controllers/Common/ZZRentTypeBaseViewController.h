//
//  ZZRentTypeBaseViewController.h
//  zuwome
//
//  Created by angBiu on 16/8/2.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZRentTypeBaseViewController : UIViewController

@property (nonatomic, strong) ZZBaseTableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ZZUser *user;
@property (nonatomic, assign) CGFloat bottomHeight;
@property (nonatomic, assign) CGFloat headViewHeight;
//@property (nonatomic, strong) UIView *headSubview;
@property (nonatomic, assign) BOOL haveAddHeadView;

- (void)gotoLoginView;

@end
