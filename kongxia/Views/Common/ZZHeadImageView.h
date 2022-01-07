//
//  ZZHeadImageView.h
//  zuwome
//
//  Created by angBiu on 16/9/22.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  圆形加v头像
 */
@interface ZZHeadImageView : UIView

@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UIImageView *vImgView;
@property (nonatomic, assign) BOOL isAnonymous;//匿名头像

@property (nonatomic, copy) dispatch_block_t touchHead;

- (void)setUser:(ZZUser *)user width:(CGFloat)width vWidth:(CGFloat)vWidth;

- (void)setUser:(ZZUser *)user anonymousAvatar:(NSString *)anonymousAvatar width:(CGFloat)width vWidth:(CGFloat)vWidth;

- (void)userAvatar:(NSString *)avatar verified:(BOOL)verified width:(CGFloat)width vWidth:(CGFloat)vWidth;


@end
