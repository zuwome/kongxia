//
//  ZZFastConfirmAlert.h
//  zuwome
//
//  Created by YuTianLong on 2018/1/4.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZFastConfirmAlert : UIView

@property (nonatomic, copy) dispatch_block_t touchCancel;
@property (nonatomic, copy) dispatch_block_t touchSure;

@end
