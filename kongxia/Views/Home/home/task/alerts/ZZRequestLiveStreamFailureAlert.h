//
//  ZZRequestLiveStreamFailureAlert.h
//  zuwome
//
//  Created by angBiu on 2017/7/18.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZRequestLiveStreamFailureAlert : UIView

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, copy) dispatch_block_t touchRecharge;

@end
