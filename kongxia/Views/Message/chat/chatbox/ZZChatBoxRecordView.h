//
//  ZZChatBoxRecordView.h
//  zuwome
//
//  Created by angBiu on 2017/7/6.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZChatBoxRecordView;

@protocol ZZChatBoxRecordViewDelegate <NSObject>

- (void)recordViewDidBeginRecord;
- (void)recordViewDidEndRecord;
- (void)recordViewDidCancelRecord;
- (void)recordView:(ZZChatBoxRecordView *)recordView insideView:(BOOL)inside;

@end

/**
 录音按钮view
 */
@interface ZZChatBoxRecordView : UIView

@property (nonatomic, assign) BOOL startRecord;
@property (nonatomic, weak) id<ZZChatBoxRecordViewDelegate>delegate;

@property (nonatomic, assign) CGFloat progress;

- (void)beginAnimation;
- (void)endAnimation;

@end
