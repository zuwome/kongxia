//
//  ZZLocationViewController.h
//  zuwome
//
//  Created by qiming xiao on 2019/5/8.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZCity.h"
#import "ZZRentDropdownModel.h"

@interface ZZLocationViewController : ZZViewController

@property (strong, nonatomic) ZZCity *city;

@property (copy,nonatomic) void(^selectPoiDone)(ZZRentDropdownModel *model);

@end

@interface ZZRentLocationAlertView1 : UIView

@end
