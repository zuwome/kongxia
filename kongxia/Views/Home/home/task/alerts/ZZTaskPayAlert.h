//
//  ZZTaskPayAlert.h
//  zuwome
//
//  Created by angBiu on 2017/8/8.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZSnatchModel.h"

@interface ZZTaskPayAlert : UIView

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) ZZSnatchDetailModel *model;

@property (nonatomic, copy) dispatch_block_t touchRight;

@end
