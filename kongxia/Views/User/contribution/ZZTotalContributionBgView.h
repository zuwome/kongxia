//
//  ZZTotalContributionBgView.h
//  zuwome
//
//  Created by angBiu on 2016/10/27.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZAttentView.h"

@interface ZZTotalContributionBgView : UIView

@property (nonatomic, strong) UIImageView *topLevelImgView;
@property (nonatomic, strong) ZZHeadImageView *headImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) ZZLevelImgView *levelImgView;
@property (nonatomic, strong) ZZAttentView *attentView;

@property (nonatomic, copy) dispatch_block_t touchHead;

- (void)setData:(ZZUser *)user;
- (void)setAnonymousStatus;

@end
