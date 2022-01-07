//
//  ZZChuzuApplyShareView.h
//  zuwome
//
//  Created by angBiu on 16/7/22.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  出租提交成功后 弹出的分享页
 */
@interface ZZChuzuApplyShareView : UIView

@property (nonatomic, weak) UIViewController *shareCtl;
@property (nonatomic, strong) UIImage *shareImg;
@property (nonatomic, strong) UILabel *applyLabel;
@property (nonatomic, assign) BOOL isFromPage;
@property (nonatomic, copy) dispatch_block_t shareCallBack;

- (instancetype)initWithFrame:(CGRect)frame controller:(UIViewController *)ctl;

@end
