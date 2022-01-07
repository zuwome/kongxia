//
//  ZZMultipleSelectMapViewController.h
//  kongxia
//
//  Created by qiming xiao on 2019/11/29.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"
@class ZZMyLocationModel;

@class ZZMultipleSelectMapViewController;

@protocol ZZMultipleSelectMapViewControllerDelegate <NSObject>

- (void)controller:(ZZMultipleSelectMapViewController *)controller didSelectLocations:(NSArray<ZZMyLocationModel *> *)locations;

@end

@interface ZZMultipleSelectMapViewController : ZZViewController

@property (nonatomic, weak) id<ZZMultipleSelectMapViewControllerDelegate> delegate;

- (instancetype)initWithCurrentSelectLocations:(NSArray *)locations;

@end
