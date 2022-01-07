//
//  ZZTimeSelector.h
//  zuwome
//
//  Created by qiming xiao on 2019/4/1.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZTasks.h"
@class ZZTimeSelector;
@class ZZTimeSelectorTopView;
@class ZZTimeSelectorModel;

@protocol ZZTimeSelectorDelegate <NSObject>

@optional
/*
 * 通告选择时间
 * @param timeModel   具体时间
 * @param duration    通告时长
 */
- (void)timeView:(ZZTimeSelector *)timeView time:(ZZTimeSelectorModel *)timeModel duration:(NSInteger)duration;

/*
 * 通告选择时长
 * @param duration    通告时长
 */
- (void)timeView:(ZZTimeSelector *)timeView chooseDuration:(NSInteger)duration;

/*
 * 活动选择时间
 * @param timeModel    具体时间
 * @param durationDes  活动的时间段
 */
- (void)timeView:(ZZTimeSelector *)timeView time:(ZZTimeSelectorModel *)timeModel durationDes:(NSString *)durationDes;

@end


@interface ZZTimeSelector : UIView

@property (nonatomic, weak) id<ZZTimeSelectorDelegate> delegate;

@property (nonatomic, assign) TaskType taskType;

@property (nonatomic, assign) PostTaskItemType timeType;

//- (instancetype)initWithFrame:(CGRect)frame taskType:(TaskType)taskType;

- (instancetype)initWithFrame:(CGRect)frame taskType:(TaskType)taskType timeType:(PostTaskItemType)timeType;

- (void)showDate:(NSString *)date dateDesc:(NSString *)dateDesc duration:(NSInteger)duration;

- (void)showDate:(NSString *)date dateDesc:(NSString *)dateDesc duratioDes:(NSString *)duratioDes;

- (void)showDurations:(NSInteger)duration;

@end

@interface ZZTimeSelectorTopView : UIView

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *line;

@end

