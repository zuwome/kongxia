//
//  ZZChatPacketAlertView.h
//  zuwome
//
//  Created by angBiu on 16/9/28.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  回答私信领取红包弹窗
 */
@interface ZZChatPacketAlertView : UIView

@property (nonatomic, strong) ZZHeadImageView *headImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) dispatch_block_t cancelCallBack;
@property (nonatomic, assign) double price;
@property (nonatomic, assign) double yj_price;

- (void)setData:(ZZUser *)user;

@end
