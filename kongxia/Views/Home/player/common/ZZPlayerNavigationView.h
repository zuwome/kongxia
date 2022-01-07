//
//  ZZPlayNavigationView.h
//  zuwome
//
//  Created by angBiu on 2016/12/14.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZVideoCountdownView.h"
#import "ZZSpreadButton.h"

#import "ZZFindVideoModel.h"
#import "ZZUser.h"

@interface ZZPlayerNavigationView : UIView

@property (nonatomic, strong) ZZHeadImageView *headView;
@property (nonatomic, strong) ZZSpreadButton *zanBtn;
@property (nonatomic, strong) UIImageView *zanImgView;
@property (nonatomic, strong) UILabel *zanTitleLabel;
@property (nonatomic, strong) ZZVideoCountdownView *countdownView;
@property (nonatomic, assign) BOOL like_status;
@property (nonatomic, assign) BOOL animateLikeStatus;
@property (nonatomic, strong) NSString *uid;
@property (assign, nonatomic) BOOL isBaseVideo;//代表是看达人视频


@property (nonatomic, copy) dispatch_block_t touchLeft;
@property (nonatomic, copy) dispatch_block_t touchHead;
@property (nonatomic, copy) dispatch_block_t touchAttent;
@property (nonatomic, copy) dispatch_block_t touchRecord;
@property (nonatomic, copy) dispatch_block_t touchMore;
@property (nonatomic, copy) dispatch_block_t touchZan;
@property (nonatomic, copy) void(^touchWX)(NSString *uid);

- (void)setSKData:(ZZSKModel *)model;
- (void)setMMDData:(ZZMMDModel *)model;
- (void)viewAnimation;
- (void)hideAttentView;
- (void)showAttentView;
- (void)setViewAlphaScale:(CGFloat)scale;

@end
