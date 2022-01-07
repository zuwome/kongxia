//
//  ZZLocationSearchedController.h
//  kongxia
//
//  Created by qiming xiao on 2019/8/16.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AMapPOI;

@protocol ZZLocationSearchedControllerDelegate <NSObject>

- (void)setSelectedLocationWithLocation:(AMapPOI *)poi;

@end

@interface ZZLocationSearchedController : UITableViewController <UISearchBarDelegate, UISearchResultsUpdating, AMapSearchDelegate>

@property (nonatomic, assign) BOOL isFromMylocations;

@property (strong, nonatomic) ZZCity *currentCity;

@property (nonatomic, weak) id<ZZLocationSearchedControllerDelegate> delegate;

@property (nonatomic, assign) BOOL isFromTaskFree;

- (void)setSearchCity:(NSString *)city;

@end

