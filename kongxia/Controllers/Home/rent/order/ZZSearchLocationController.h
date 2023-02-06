//
//  ZZSearchLocationController.h
//  kongxia
//
//  Created by qiming xiao on 2019/8/16.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZZCity.h"
#import "ZZRentDropdownModel.h"

@interface ZZSearchLocationController : ZZViewController

@property (nonatomic, strong) ZZCity *currentSelectCity;

@property (nonatomic, strong) CLLocation *location;

@property (nonatomic, copy) void (^presentBlock)(void);

@property (nonatomic, copy) void (^selectPoiDone)(ZZRentDropdownModel *model);

@property (nonatomic, copy) void (^selectPoi)(ZZRentDropdownModel *model, UIImage *image);

@property (nonatomic, assign) BOOL isFromTaskFree;

@property (nonatomic, assign) BOOL isCityLimited;

- (instancetype)initWithSelectCity:(ZZCity *)city;

@end
//
@interface ZZLocationAlertView : UIView

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *titleLabel;

@end
