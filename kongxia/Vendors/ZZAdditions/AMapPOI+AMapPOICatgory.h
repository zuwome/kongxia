//
//  AMapPOI+AMapPOICatgory.h
//  kongxia
//
//  Created by qiming xiao on 2019/10/24.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AMapSearchKit/AMapSearchKit.h>

@interface AMapPOI (AMapPOICatgory)

// location在我们APP的ID, 目前仅用于我的常出没地点
@property (nonatomic, copy) NSString *oriLocationUID;

@end

