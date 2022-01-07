//
//  ZZChatOrderDealView.h
//  zuwome
//
//  Created by angBiu on 2017/4/10.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZChatOrderDealView : UIView

@property (nonatomic, copy) dispatch_block_t touchAccept;
@property (nonatomic, copy) dispatch_block_t touchRefuse;

- (void)showView;

@end
