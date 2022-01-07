//
//  ZZMessageListCellLocationView.h
//  kongxia
//
//  Created by qiming xiao on 2019/11/11.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZMessageBoxModel;

@interface ZZMessageListCellLocationView : UIView

@property (nonatomic, assign) double totalWidth;

- (void)configureUserInfo:(ZZUserInfoModel *)userInfo;

- (void)configureUser:(ZZMessageBoxModel *)boxModel;

@end

