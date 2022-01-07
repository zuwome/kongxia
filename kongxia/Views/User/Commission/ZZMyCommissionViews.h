//
//  ZZMyCommissionViews.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/4.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZCommissionListModel;

@class MyCommissionHeaderView;
@protocol MyCommissionHeaderViewDelegate <NSObject>

- (void)header:(MyCommissionHeaderView *)header enablePush:(BOOL)enablePush;

@end

@interface MyCommissionHeaderView : UIView

@property (nonatomic, weak) id<MyCommissionHeaderViewDelegate> delegate;

- (void)configureIcomes:(ZZCommissionListModel *)model;

@end


@class CommissionHeaderView;
@protocol CommissionHeaderViewDelegate <NSObject>

- (void)header:(CommissionHeaderView *)header enablePush:(BOOL)enablePush;

@end

@interface CommissionHeaderView : UIView

@property (nonatomic, weak) id<CommissionHeaderViewDelegate> delegate;

- (void)configureIcomes:(ZZCommissionListModel *)model;

@end

@interface CommissionTotalInComeView : UIView

- (void)configureIcomes:(ZZCommissionListModel *)model;

@end

@class CommissionScrollHeaderView;
@protocol CommissionScrollHeaderViewDelegate <NSObject>

- (void)header:(CommissionScrollHeaderView *)header select:(NSInteger)index;

@end

@interface CommissionScrollHeaderView : UIView

@property (nonatomic, weak) id<CommissionScrollHeaderViewDelegate> delegate;

- (void)offetSet:(CGFloat)offsetX;

@end
