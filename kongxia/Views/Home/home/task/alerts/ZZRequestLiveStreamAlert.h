//
//  ZZRequestLiveStreamAlert.h
//  zuwome
//
//  Created by angBiu on 2017/7/18.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZRequestLiveStreamAlert : UIView

@property (nonatomic, assign) BOOL isPublish;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, copy) dispatch_block_t touchCancel;
@property (nonatomic, copy) dispatch_block_t touchSure;

@end
