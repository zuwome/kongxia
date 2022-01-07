//
//  ZZRealNameNotMainlandBottomView.h
//  zuwome
//
//  Created by angBiu on 2017/2/23.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 非大陆实名认证bottomview
 */
@interface ZZRealNameNotMainlandBottomView : UIView

@property (nonatomic, weak) UIViewController *weakCtl;
@property (nonatomic, strong) UIButton *applyBtn;
@property (nonatomic, strong) UIImage *firImage;
@property (nonatomic, strong) UIImage *secImage;
@property (nonatomic, strong) NSMutableArray *imgArray;
@property (nonatomic, copy) dispatch_block_t touchApply;

- (void)setModel:(ZZRealname *)model;

@end
