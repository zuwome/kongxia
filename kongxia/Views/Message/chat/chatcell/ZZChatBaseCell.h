//
//  ZZChatBaseCell.h
//  zuwome
//
//  Created by angBiu on 16/10/6.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>

#import "ZZChatTimeView.h"
#import "ZZChatReadStatusView.h"
#import "ZZChatBaseModel.h"

#import "UIResponder+ZZRouter.h"
#import "ZZChatConst.h"

@interface ZZChatBaseCell : UITableViewCell

@property (nonatomic, strong) ZZChatBaseModel *dataModel;
@property (nonatomic, strong) ZZChatTimeView *timeView;//时间
//@property (nonatomic, strong) ZZHeadImageView *myHeadImgView;//我的头像
@property (nonatomic, strong) ZZHeadImageView *otherHeadImgView;//对方头像
@property (nonatomic, strong) UIView *bgView;//消息内容 bgview
@property (nonatomic, strong) UIImageView *bubbleImgView;//气泡
@property (nonatomic, strong) ZZChatReadStatusView *readStatusView;//已读 
@property (nonatomic, strong) UIActivityIndicatorView *activityView;//发送中的菊花
@property (nonatomic, strong) UIButton *retryButton;//重新发送按钮
@property (nonatomic, strong) UIView *unreadRedPointView;//语音等 未读的红点
@property (nonatomic, strong) UILabel *countLabel;//倒计时
@property (nonatomic, assign) BOOL isLeft;//是否是对方

@property (nonatomic, copy) dispatch_block_t touchLeftHeadImgView;
@property (nonatomic, copy) dispatch_block_t touchRetry;//重新发送
@property (nonatomic, copy) void(^cellLongPress)(UIView *targetView);

@property (nonatomic, assign) double topOffset;

- (void)setData:(ZZChatBaseModel *)model;
- (void)setUrl:(NSString *)portraitUrl;
+ (UIImage *)resizeWithImage:(UIImage *)image;

@end 
