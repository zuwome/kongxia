//
//  ZZPacketAlertView.h
//  zuwome
//
//  Created by angBiu on 16/8/26.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UMSocialCore/UMSocialCore.h>
/**
 *  收到红包的alertview
 */
@interface ZZPacketAlertView : UIView

- (instancetype)initWithFrame:(CGRect)frame withController:(UIViewController *)ctl;

@property (nonatomic, strong) ZZHeadImageView *headImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *packetPriceLabel;
@property (nonatomic, strong) UILabel *servicePriceLabel;
@property (nonatomic, strong) NSString *shareUrl;
@property (nonatomic, strong) NSString *shareTitle;
@property (nonatomic, strong) NSString *shareContent;
@property (nonatomic, strong) UIImage *shareImg;
@property (nonatomic, strong) NSString *userImgUrl;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *mid;
@property (nonatomic, copy) dispatch_block_t touchCancel;

@end
