//
//  ZZAttentDynamicUserCell.h
//  zuwome
//
//  Created by angBiu on 16/8/24.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZAttentDynamicUserCell : UICollectionViewCell

@property (nonatomic, strong) ZZHeadImageView *headImgView;

- (void)setUser:(ZZUser *)user width:(CGFloat)width;

@end
