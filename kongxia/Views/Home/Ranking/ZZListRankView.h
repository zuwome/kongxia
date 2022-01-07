//
//  ZZListRankView.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/17.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZListRankView;
@protocol ZZListRankViewDelegate <NSObject>

- (void)view:(ZZListRankView *)view showUserInfo:(ZZUser *)userInfo;

- (void)view:(ZZListRankView *)view goChat:(ZZUser *)userInfo;

@optional
- (void)viewShowTips:(ZZListRankView *)view;

- (void)viewShowMine:(ZZListRankView *)view;

@end


@interface ZZListRankView : UIView

@property (nonatomic, weak) id<ZZListRankViewDelegate> delegate;

@property (nonatomic, assign) BOOL isRookie;

- (void)configureUser:(ZZUser *)user rank:(NSInteger)rank;

- (void)configureMyRank:(ZZUser *)user rank:(NSInteger)rank isRookie:(BOOL)isRookie;


@end

