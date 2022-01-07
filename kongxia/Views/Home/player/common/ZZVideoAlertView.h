//
//  ZZVideoAlertView.h
//  zuwome
//
//  Created by angBiu on 16/8/13.
//  Copyright © 2016年 zz. All rights reserved.
//

typedef NS_ENUM(NSInteger, AlertPayType) {
    AlertPayTypeMemeda,
    AlertPayTypeDashang,
    AlertPayTypePacket
};

#import <UIKit/UIKit.h>
#import "ZZMemedaModel.h"
#import "ZZSKModel.h"
#import "ZZMoneyTextField.h"
/**
 *  查看视频 打赏弹窗
 */
@interface ZZVideoAlertView : UIView

@property (nonatomic, strong) NSArray *moneyArray;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) ZZMoneyTextField *inputTF;
@property (nonatomic, strong) ZZUser *user;
@property (nonatomic, assign) double price;
@property (nonatomic, assign) AlertPayType type;
@property (nonatomic, assign) BOOL isAnonymous;//是否是匿名
@property (nonatomic, assign) double serviceScale;//抽佣比例
@property (nonatomic, assign) BOOL isInYellow;//涉黄

@property (assign, nonatomic) BOOL fromLiveStream;//只显示底部跟她视频

//提问么么答的参数
@property (weak, nonatomic) UIViewController *ctl;
@property (nonatomic, strong) NSMutableArray *topicsArray;
@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSString *mid;
@property (nonatomic, strong) NSString *skId;

@property (nonatomic, copy) dispatch_block_t payCallBack;
@property (nonatomic, copy) dispatch_block_t rechargeCallBack;//充值
@property (nonatomic, copy) dispatch_block_t touchCancel;

- (void)randomMoney;
- (void)randomInputText;
- (void)showFirstResponder;
- (void)showInfoText;
- (void)calculatePrice;

@end
