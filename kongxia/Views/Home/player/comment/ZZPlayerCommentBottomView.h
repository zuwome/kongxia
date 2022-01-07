//
//  ZZPlayerCommentBottomView.h
//  zuwome
//
//  Created by angBiu on 2016/12/28.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZInputView.h"

@interface ZZPlayerCommentBottomView : UIView

@property (nonatomic, strong) YZInputView *inputTF;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) NSString *commentNameString;
@property (nonatomic, strong) NSString *replyId;

@property (nonatomic, copy) void(^sendComment)(NSString *comment, NSString *replyId);

- (void)disabledStatus;
- (void)normalStatus;

@end
