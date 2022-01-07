//
//  ZZMyLocationsSelectViewController.h
//  kongxia
//
//  Created by qiming xiao on 2019/10/21.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"
@class ZZMyLocationModel;
typedef NS_ENUM(NSInteger, LocationFrom) {
    FromMyLocations, // 我常出没的地点
    FromNormalTask, // 邀约
    FromFreeTask,   // 活动
};

@class ZZMyLocationsSelectViewController;

@protocol ZZMyLocationsSelectViewControllerDelegate <NSObject>

- (void)viewController:(ZZMyLocationsSelectViewController *)controller didSelectLocations:(NSArray<ZZMyLocationModel *> *)locations;


@end

@interface ZZMyLocationsSelectViewController : ZZViewController

@property (nonatomic, weak) id<ZZMyLocationsSelectViewControllerDelegate> delegate;

@property (nonatomic, assign) LocationFrom from;

- (instancetype)initWithCurrentSelectLocations:(NSArray *)locations from:(LocationFrom)from;

@end

