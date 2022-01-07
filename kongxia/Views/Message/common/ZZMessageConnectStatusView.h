//
//  ZZMessageConnectStatusView.h
//  zuwome
//
//  Created by angBiu on 16/7/27.
//  Copyright © 2016年 zz. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  聊天列表顶部连接状态view
 */
@interface ZZMessageConnectStatusView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic, strong) UIViewController *viewController;

@end
