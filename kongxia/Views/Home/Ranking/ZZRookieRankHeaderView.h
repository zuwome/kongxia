//
//  ZZRookieRankHeaderView.h
//  kongxia
//
//  Created by qiming xiao on 2019/12/17.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZRookieRankHeaderView;
@protocol ZZRookieRankHeaderViewDelegate <NSObject>

- (void)headerView:(ZZRookieRankHeaderView *)view showUserInfo:(ZZUser *)userInfo;

- (void)headerView:(ZZRookieRankHeaderView *)view goChat:(ZZUser *)userInfo;

@end


@interface ZZRookieRankHeaderView : UIView

@property (nonatomic, weak) id<ZZRookieRankHeaderViewDelegate> delegate;

- (void)configureTop3:(NSArray<ZZUser *> *)top3Arr;

@end


@class ZZRookieRankHeaderTopView;
@protocol ZZRookieRankHeaderTopViewDelegate <NSObject>

- (void)topViewShowUserInfo:(ZZRookieRankHeaderTopView *)view ;

- (void)topViewShoActions:(ZZRookieRankHeaderTopView *)view;

@end

@interface ZZRookieRankHeaderTopView : UIView

@property (nonatomic, weak) id<ZZRookieRankHeaderTopViewDelegate> delegate;

@property (nonatomic, assign) NSInteger rank;

@property (nonatomic, strong) UIImageView *rank1CrownImageView;

@property (nonatomic, strong) UIImageView *rank1UserIconImageView;

@property (nonatomic, strong) UILabel   *rank1UserNameLabel;

@property (nonatomic, strong) UILabel *rank1PopularityLabel;

@property (nonatomic, strong) UIImageView *rank1PoUpDownImageView;

@property (nonatomic, strong) UIImageView *rank1genderImageView;

@property (nonatomic, strong) ZZLevelImgView *rank1levelView;

@property (nonatomic, strong) UIButton *rank1ChatBtn;

- (instancetype)initWithRank:(NSInteger)rank;

- (void)configureData:(ZZUser *)user;

@end
