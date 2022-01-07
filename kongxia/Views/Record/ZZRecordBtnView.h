//
//  ZZRecordBtnView.h
//  zuwome
//
//  Created by angBiu on 2016/12/12.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZZRecordBtnViewDelegate <NSObject>

- (void)recordViewBeginDelayReocrd;
- (void)recordViewStatrRecord;
- (void)recordViewEndRecord;
- (void)recordViewTooShort;
- (void)recordViewProgressing;

@end

@interface ZZRecordBtnView : UIView

@property (nonatomic, weak) id<ZZRecordBtnViewDelegate>delegate;

@property (nonatomic, assign) NSInteger minDuring;//最小时长(s)
@property (nonatomic, assign) BOOL isDelay;//是否是延迟拍摄
@property (nonatomic, assign) BOOL haveStartRecord;
@property (nonatomic, assign) NSInteger count;

- (void)viewTransfrom;
- (void)startTimer;
- (void)showInfoText:(NSString *)text;
- (void)beginRecord;
- (void)finishRecord:(BOOL)limit;

@end
