//
//  ZZSendPacketTopicView.h
//  zuwome
//
//  Created by angBiu on 2017/3/30.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZSendPacketTopicView : UIView <UITextViewDelegate>

@property (nonatomic, strong) UITextView *questionTV;

@property (nonatomic, copy) dispatch_block_t touchRandom;
@property (nonatomic, copy) dispatch_block_t touchTopicInfo;
@property (nonatomic, copy) dispatch_block_t beginEdit;
@property (nonatomic, copy) dispatch_block_t endEdit;

- (void)setQuestion:(NSString *)question;

@end
