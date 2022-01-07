//
//  ZZTaskMoneyInputView.h
//  zuwome
//
//  Created by qiming xiao on 2019/3/20.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZTaskConfig.h"

typedef NS_ENUM(NSInteger, PriceLimiteType) {
    LimiteMaximun,
    LimiteMinimun,
};

@class ZZTaskMoneyView;

@protocol ZZTaskMoneyViewDelegate <NSObject>

- (void)inputView:(ZZTaskMoneyView *)inputView price:(NSString *)price;

@end

@interface ZZTaskMoneyView : UIView

@property (nonatomic, weak) id<ZZTaskMoneyViewDelegate>delegate;

@property (nonatomic, assign) TaskType taskType;

+ (instancetype)createWithPrice:(NSString *)price
                   taskDuration:(NSInteger)duration
                           date:(NSString *)date
                       taskType:(TaskType)taskType;

@end
