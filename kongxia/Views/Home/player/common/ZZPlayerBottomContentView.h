//
//  ZZPlayerBottomContentView.h
//  zuwome
//
//  Created by angBiu on 2017/3/10.
//  Copyright © 2017年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZFindVideoModel.h"
#import "TTTAttributedLabel.h"

@interface ZZPlayerBottomContentView : UIView

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) ZZHeadImageView *headImgView;
@property (nonatomic, strong) TTTAttributedLabel *contentLabel;
@property (nonatomic, strong) ZZSKModel *skModel;
@property (nonatomic, strong) ZZMMDModel *mmdModel;

@property (nonatomic, copy) dispatch_block_t touchHead;

@end
