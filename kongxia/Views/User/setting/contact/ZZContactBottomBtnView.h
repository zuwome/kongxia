//
//  ZZContactBottomBtnView.h
//  zuwome
//
//  Created by angBiu on 2016/10/26.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  设置 --- 屏蔽联系人 底部button
 */
@interface ZZContactBottomBtnView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, assign) BOOL isPB;//是否是屏蔽状态
@property (nonatomic, copy) dispatch_block_t touchBottomView;

@end
