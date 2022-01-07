//
//  ZZOnlineConfirmAlert.h
//  zuwome
//
//  Created by YuTianLong on 2017/11/10.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZOnlineConfirmAlert : UIView

@property (nonatomic, copy) dispatch_block_t touchCancel;
@property (nonatomic, copy) dispatch_block_t touchSure;

@end
