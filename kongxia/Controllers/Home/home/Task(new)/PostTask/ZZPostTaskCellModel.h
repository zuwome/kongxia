//
//  ZZPostTaskCellModel.h
//  kongxia
//
//  Created by qiming xiao on 2019/9/25.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZTaskConfig.h"

@interface ZZPostTaskCellModel : NSObject

@property (nonatomic, assign) TaskType taskType;

@property (nonatomic, assign) PostTaskItemType type;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, copy) NSString *className;

@property (nonatomic, copy) NSString *cellIdentifier;

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *subTitle;

@property (nonatomic, copy) NSString *subTitle1;

@property (nonatomic, strong) id data;

@property (nonatomic, assign) UITableViewCellAccessoryType accessoryType;

// for 主题标签
@property (nonatomic, copy) NSArray<NSNumber *> *tagsFrameArray;

- (UITableViewCellAccessoryType)accessoryType;

- (instancetype)initWithTaskType:(TaskType)taskType itemType:(PostTaskItemType)itemType;

- (void)configureData:(id)data;

/**
*  普通通告时间
*/
- (NSString *)fetchConfiguretartTime:(NSString *)startTime startTimeDescript:(NSString *)startTimeDescript hour:(NSInteger)hour;

- (void)configureStartTime:(NSString *)startTime startTimeDescript:(NSString *)startTimeDescript hour:(NSInteger)hour;

/**
*  活动时间
*/
- (void)configureStartTime:(NSString *)startTime startTimeDescript:(NSString *)startTimeDescript durationDes:(NSString *)durationDes;

/**
 *  通告主题标签
 */
- (void)configureThemeTags;

@end

