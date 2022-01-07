//
//  ZZLiveStreamConnectTopView.h
//  zuwome
//
//  Created by angBiu on 2017/7/17.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZLiveStreamConnectTopView : UIView

@property (nonatomic, strong) UIButton *attentBtn;
@property (nonatomic, strong) UILabel *localLabel;
@property (nonatomic, strong) ZZUser *user;
@property (assign, nonatomic) NSInteger follow_status;//是否关注
@property (nonatomic, copy) dispatch_block_t touchAttent;
@property (nonatomic, copy) dispatch_block_t touchReport;
@property (nonatomic, copy) void (^userDetailBlock)(ZZUser *user);

@property (nonatomic, assign) BOOL isConnectHeader;//当前topView是否是使用在视频连接中等待页面
@property (nonatomic, assign) BOOL accept;//

@end
