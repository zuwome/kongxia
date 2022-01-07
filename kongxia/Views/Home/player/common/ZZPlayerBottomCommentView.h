//
//  ZZPlayerBottomCommentView.h
//  zuwome
//
//  Created by angBiu on 2017/3/10.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZInputView.h"
#import "ZZCommentModel.h"

@interface ZZPlayerBottomCommentView : UIView

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) YZInputView *inputView;
@property (nonatomic, strong) UIImageView *packetImgView;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) NSString *replyId;
@property (nonatomic, strong) NSString *commentNameString;
@property (nonatomic, strong) UIImageView *bgImageView;//背景颜色
@property (nonatomic, copy) dispatch_block_t touchPacket;
@property (nonatomic, copy) void(^sendComment)(NSString *comment, NSString *replyId);

- (void)setCommentModel:(ZZCommentModel *)model;
- (void)keyboardShowStatus;
- (void)normalClearStatus;
- (void)normalWhiteStatus:(CGFloat)scale;

@end
