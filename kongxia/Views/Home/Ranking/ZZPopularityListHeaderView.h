//
//  ZZPopularityListHeaderView.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/17.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZPopularityListHeaderView;
@protocol ZZPopularityListHeaderViewDelegate <NSObject>

- (void)headerView:(ZZPopularityListHeaderView *)view showUserInfo:(ZZUser *)userInfo;

@end

@interface ZZPopularityListHeaderView : UIView

@property (nonatomic, weak) id<ZZPopularityListHeaderViewDelegate> delegate;

- (void)configureTop3:(NSArray<ZZUser *> *)top3Arr;

@end

