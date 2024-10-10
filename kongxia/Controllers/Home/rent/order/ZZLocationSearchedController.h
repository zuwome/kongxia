//
//  ZZLocationSearchedController.h
//  kongxia
//
//  Created by qiming xiao on 2019/8/16.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZZLocationSearchedControllerDelegate <NSObject>

- (void)setSelectedLocationWithLocation:(PoiModel *)poi;

@end

@interface ZZLocationSearchedController : UITableViewController <UISearchBarDelegate, UISearchResultsUpdating>

@property (strong, nonatomic) ZZCity *currentCity;

@property (nonatomic, weak) id<ZZLocationSearchedControllerDelegate> delegate;

@property (nonatomic, assign) BOOL isFromTaskFree;

@property (nonatomic, copy) CLLocation *location;

- (void)setSearchCity:(NSString *)city;

@end

