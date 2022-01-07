//
//  ZZRentChatBottomView.h
//  zuwome
//
//  Created by MaoMinghui on 2018/10/15.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZRentChatBottomView : UIView

@property (nonatomic) UIButton *videoBtn;
@property (nonatomic) UIButton *fastChatRentBtn;

@property (nonatomic, copy) void(^videoConnect)(void); //1v1视频咨询
@property (nonatomic, copy) void(^rentNow)(void);      //马上预约

@end

NS_ASSUME_NONNULL_END
