//
//  ZZTaskModel.m
//  zuwome
//
//  Created by qiming xiao on 2019/3/20.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import "ZZTaskModel.h"
#import "ZZDateHelper.h"

@implementation ZZTaskReponseModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"tasksArray": @"data"
                                                                  }];
}

- (void)addMoreTasks:(ZZTaskReponseModel *)taskResponseModel {
    if (!taskResponseModel) {
        return;
    }
    
    NSMutableArray *tasksArray = _tasksArray.mutableCopy;
    [tasksArray addObjectsFromArray:taskResponseModel.tasksArray];
    _tasksArray = tasksArray.copy;
    
    if (taskResponseModel.tasksArray.count != 0) {
        _pageIndex = taskResponseModel.pageIndex;
        _pageSize = taskResponseModel.pageSize;
    }
}

- (void)addTasks:(NSArray<ZZTaskModel *> *)tasksArray {
    NSMutableArray *array = _tasksArray.mutableCopy;
    if (!array) {
        array = @[].mutableCopy;
    }
    
    [array addObjectsFromArray:tasksArray];
    _tasksArray = array.copy;
}

- (void)configureMyTaskModels:(NSArray<ZZTask *> *)taskArray {
    NSMutableArray<ZZTaskModel *><ZZTaskModel> *taskModelArray = @[].mutableCopy;
    [taskArray enumerateObjectsUsingBlock:^(ZZTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZZTaskModel *taskModel = [[ZZTaskModel alloc] init];
        taskModel.task = obj;
        // 我的列表中uuid 才是用户的id.
        taskModel.task.from._id = obj.from.uuid;
        taskModel.from = obj.from;
        [taskModelArray addObject:taskModel];
    }];
    _tasksArray = taskModelArray.copy;
}

- (void)addMoreMyTasks:(NSArray<ZZTask *> *)taskArray {
    NSMutableArray<ZZTaskModel *><ZZTaskModel> *taskModelArray = _tasksArray.mutableCopy;
    if (!taskModelArray) {
        taskModelArray = @[].mutableCopy;
    }
    [taskArray enumerateObjectsUsingBlock:^(ZZTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZZTaskModel *taskModel = [[ZZTaskModel alloc] init];
        taskModel.task = obj;
        // 我的列表中uuid 才是用户的id.
        taskModel.task.from._id = obj.from.uuid;
        taskModel.from = obj.from;
        [taskModelArray addObject:taskModel];
    }];
    _tasksArray = taskModelArray.copy;
}

- (void)filterCanDisplayTask {
    NSMutableArray<ZZTaskModel *> *tasksList = _tasksArray.mutableCopy;
    
    NSMutableArray<ZZTaskModel *> *displayedArray = @[].mutableCopy;
    [tasksList enumerateObjectsUsingBlock:^(ZZTaskModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.task.address_city_name doubleValue] <= obj.task.shield_num) {
            [displayedArray addObject:obj];
        }
    }];
    _tasksArray = displayedArray.copy;
}

@end

@implementation ZZTaskModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"task": @"pd"
                                                                  }];
}

@end

@implementation ZZTask

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    return YES;
}

- (BOOL)isMine {
    return [self.from._id isEqualToString:UserHelper.loginer.uid];
}

- (BOOL)taskIsMine {
    return [self.from.uuid isEqualToString:UserHelper.loginer.uid];
}

- (TaskStatus)taskStatus {
    if (_status == -1) {
        // 待审核
        return TaskReviewing;
    }
    else if (_status == -2) {
        // 不通过
        return TaskReviewFail;
    }
    else if (_status == 0) {
        if (_order_end == 0) {
            return TaskOngoing;
        }
        else if (_order_end == 1) {
            return TaskClose;
        }
        else if (_order_end == 2) {
            return TaskExpired;
        }
        else {
            return TaskNone;
        }
    }
    else {
        if (_status == 1) {
            return TaskExpired;
        }
        else if (_status == 2) {
            return TaskCancel;
        }
        else if (_status == 3) {
            return TaskFinish;
        }
        else {
            return TaskFinish;
        }
    }
}

- (BOOL)isTaskFinished {
    return (self.taskStatus != TaskOngoing && self.taskStatus != TaskClose);
}

- (void)setPrice:(NSString *)price {
    NSString *doubleString     = [NSString stringWithFormat:@"%lf", price.doubleValue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    NSString *convertString    = [decNumber stringValue];
    _price = convertString;
}

- (NSArray *)display_imgs {
    if (!_display_imgs) {
        if (self.isMine) {
            _display_imgs = _imgs;
        }
        else {
            NSMutableArray *displayPhoto = @[].mutableCopy;
            [self.imgs enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ((TaskImageStatus)[self.imgsStatus[idx] intValue] == ImageStatusSuccess && ([obj isKindOfClass:[NSString class]])) {
                    [displayPhoto addObject:obj];
                }
            }];
            _display_imgs = displayPhoto.copy;
        }
    }
    return _display_imgs;
}

- (BOOL)canShowImgs {
    if (self.isMine) {
        if (self.imgs.count == 0) {
            return NO;
        }
        return YES;
    }
    else {
        if (self.imgs.count == 0) {
            return NO;
        }
        else {
            __block BOOL canShow = NO;
            [self.imgsStatus enumerateObjectsUsingBlock:^(NSNumber *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx < self.imgs.count && [obj intValue] == ImageStatusSuccess) {
                    canShow = YES;
                    *stop = YES;
                }
            }];
            return canShow;
        }
    }
}

- (BOOL)canShowImage:(BOOL)isInListAll {
    if (!isInListAll) {
        return self.canShowImgs;
    }
    else {
        __block BOOL canShow = NO;
        [self.imgsStatus enumerateObjectsUsingBlock:^(NSNumber *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx < self.imgs.count && (TaskImageStatus)[self.imgsStatus[idx] intValue] == ImageStatusSuccess) {
                canShow = YES;
                *stop = YES;
            }
        }];
        return canShow;
    }
}

- (NSArray *)displayImages:(BOOL)isInListAll {
    if (self.imgs.count == 0) {
        return nil;
    }
    
    NSMutableArray *displayImages = @[].mutableCopy;
    [self.imgs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (isInListAll) {
            // 全部不显示脏图
            if ((TaskImageStatus)[self.imgsStatus[idx] intValue] == ImageStatusSuccess && ([obj isKindOfClass:[NSString class]])) {
                [displayImages addObject:obj];
            }
        }
        else {
            [displayImages addObject:obj];
        }
    }];
    return displayImages.copy;
}

- (void)setSkill:(NSDictionary *)skill {
    _skill = skill;
    if ([_skill isKindOfClass: [NSDictionary class]]) {
        _skillModel = [[ZZSkill alloc] init];
        _skillModel.skillID = _skill[@"_id"];
        _skillModel.name = _skill[@"name"];
    }
}

- (void)setImgs_status:(NSArray *)imgs_status {
    _imgs_status = imgs_status;
    if (_imgs_status && _imgs_status.count > 0) {
        NSMutableArray *imageStatusArray = @[].mutableCopy;
        [_imgs_status enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass: [NSNull class]]) {
                [imageStatusArray addObject: @(ImageStatusReview)];
            }
            else {
                if ([obj boolValue]) {
                    [imageStatusArray addObject: @(ImageStatusSuccess)];
                }
                else {
                    [imageStatusArray addObject: @(ImageStatusFail)];
                }
            }
        }];
        _imgsStatus = imageStatusArray.copy;
    }
}

- (BOOL)isPassLimitedTime {
    if (![self isNewTask]) {
        return NO;
    }
    NSString *createTimeStr = [ZZDateHelper localTimeStampe:_created_at];
    NSTimeInterval createTimeStamp = createTimeStr.doubleValue;
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval timeStamp = [date timeIntervalSince1970];
    
    NSTimeInterval timeGap = timeStamp - createTimeStamp;
    return (timeGap >= 60 * 30);
}

- (BOOL)isNewTask {
    BOOL isNew = NO;
    if (_pd_version) {
        if ([ZZUtils compareVersionFrom:@"4.0.0" to:_pd_version] != NSOrderedDescending) {
            isNew = YES;
        }
    }
    return isNew;
}

- (BOOL)didUserPicked:(NSString *)userID {
    __block BOOL didPicked = NO;
    [_pickSignupersArr enumerateObjectsUsingBlock:^(ZZTaskSignuperModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.user.uuid isEqualToString:userID]) {
            didPicked = YES;
            *stop = YES;
        }
    }];
    return didPicked;
}

@end
