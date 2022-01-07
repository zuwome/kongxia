//
//  ZZAttentSortTypeView.h
//  zuwome
//
//  Created by angBiu on 2016/12/30.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZAttentSortTypeView : UIView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, copy) dispatch_block_t selectedCallBack;

@end
