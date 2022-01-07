//
//  ZZPublishingShineView.h
//  zuwome
//
//  Created by angBiu on 2017/7/13.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZTaskCancelConfirmAlert.h"

@interface ZZPublishingShineView : UIView

@property (nonatomic, strong) NSString *pId;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, assign) NSInteger during;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) ZZTaskCancelConfirmAlert *cancelAlert;

@property (nonatomic, copy) dispatch_block_t touchCancel;

- (void)animate;
- (void)remove;

@end
