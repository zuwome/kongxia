//
//  ZZInternationalCitySearchResultController.h
//  kongxia
//
//  Created by qiming xiao on 2019/8/16.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZInternationalCityModel;
@protocol ZZInternationalCitySearchResultControllerDelegate <NSObject>

- (void)selectNation:(ZZInternationalCityModel *)nationModel;

@end

@interface ZZInternationalCitySearchResultController : UITableViewController <UISearchResultsUpdating>

@property (nonatomic, strong) NSMutableArray *dataArray;//总的数据

@property (nonatomic, weak) id<ZZInternationalCitySearchResultControllerDelegate> delegate;

@end


