//
//  ZZMenuView.h
//  zuwome
//
//  Created by angBiu on 2017/3/10.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZMenuView : UIView

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) dispatch_block_t touchDelete;
@property (nonatomic, copy) dispatch_block_t touchReport;

@end
