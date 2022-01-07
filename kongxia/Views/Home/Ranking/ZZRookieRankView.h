//
//  ZZRookieRankView.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/17.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZRookieRankView;
@protocol ZZRookieRankViewDelegate <NSObject>

- (void)view:(ZZRookieRankView *)view showUserInfo:(ZZUser *)userInfo;

- (void)view:(ZZRookieRankView *)view goChat:(ZZUser *)userInfo;

- (void)viewShowTips:(ZZRookieRankView *)view;

- (void)viewShowMine:(ZZRookieRankView *)view;

@end

@interface ZZRookieRankView : UIView

@property (nonatomic, weak) id<ZZRookieRankViewDelegate> delegate;

- (void)configureUser:(ZZUser *)user rank:(NSInteger)rank;

@end
