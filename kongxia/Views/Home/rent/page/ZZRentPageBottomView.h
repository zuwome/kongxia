//
//  ZZRentPageBottomView.h
//  zuwome
//
//  Created by angBiu on 16/8/2.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZTaskConfig.h"
#import "ZZRentViewController.h"

@interface ZZRentPageBottomView : UIView
@property (nonatomic, assign) EntryTarget entryTarget;
@property (nonatomic, strong) UIButton *chatBtn;
@property (nonatomic, strong) UIButton *rentBtn;
@property (nonatomic, strong) UIButton *videoBtn;
@property (nonatomic, strong) UIButton *chooseBtn;

@property (assign, nonatomic) BOOL fromLiveStream;//只显示底部跟她视频

@property (nonatomic, copy) dispatch_block_t touchChat;
@property (nonatomic, copy) dispatch_block_t signup;
@property (nonatomic, copy) dispatch_block_t touchAsk;
@property (nonatomic, copy) dispatch_block_t touchRent;
@property (nonatomic, copy) dispatch_block_t touchChoose;

@end
