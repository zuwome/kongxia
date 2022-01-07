//
//  ZZChatStatusSheetView.h
//  zuwome
//
//  Created by angBiu on 2016/10/21.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZZOrder.h"

@interface ZZChatStatusSheetView : UIView

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, copy) dispatch_block_t touchCancel;
@property (nonatomic, copy) dispatch_block_t touchEdit;
@property (nonatomic, copy) dispatch_block_t touchReject;
@property (nonatomic, copy) dispatch_block_t touchRefund;
@property (nonatomic, copy) dispatch_block_t touchRent;
@property (nonatomic, copy) dispatch_block_t touchAsk;
@property (nonatomic, copy) dispatch_block_t touchDetail;
@property (nonatomic, copy) dispatch_block_t touchRevokeRefund;
@property (nonatomic, copy) dispatch_block_t touchEditRefund;

- (void)showSheetWithOrder:(ZZOrder *)order type:(OrderDetailType)type;

@end
