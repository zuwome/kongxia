//
//  ZZVideoCountdownView.h
//  zuwome
//
//  Created by angBiu on 16/9/18.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  倒计时view
 */
@interface ZZVideoCountdownView : UIView

@property (nonatomic, copy) dispatch_block_t touchRecord;

- (void)setTimeInterval:(NSTimeInterval)timeInterval;

@end
