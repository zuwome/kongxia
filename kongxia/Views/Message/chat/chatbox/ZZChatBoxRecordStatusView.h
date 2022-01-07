//
//  ZZChatBoxRecordStatusView.h
//  zuwome
//
//  Created by angBiu on 2017/7/6.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 录音进度状态view
 */
@interface ZZChatBoxRecordStatusView : UIView

@property (nonatomic, assign) NSInteger duration;

- (void)outsideStatus;
- (void)insideStatus;

@end
