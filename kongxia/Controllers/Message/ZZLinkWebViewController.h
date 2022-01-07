//
//  ZZLinkWebViewController.h
//  zuwome
//
//  Created by angBiu on 16/8/19.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZViewController.h"
/**
 *  链接跳转界面
 */
@interface ZZLinkWebViewController : ZZViewController

@property (nonatomic, strong) NSString *urlString;
//@property (nonatomic, assign) BOOL isPresent;
@property (nonatomic, assign) BOOL showShare;
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSString *shareTitle;
@property (nonatomic, strong) NSString *shareContent;
@property (nonatomic, assign) BOOL isHideBar;
@property (nonatomic, assign) BOOL isPush;
@property (nonatomic, assign) BOOL isHideNavigationBarWhenUp;//当上滑的时候隐藏导航
@property (nonatomic, assign) BOOL isPushNOHideNav;//导航是否不消失  yes  不消失  NO消失
@property (nonatomic, assign) BOOL isShowLeftButton;//自定义显示左侧的返回按钮  和isPush  配合使用
@property (nonatomic, assign) BOOL isFromAD;
@property (nonatomic, assign) BOOL isFromPay;

/**
 设置黑色的背景
 
 @param titleNav 当前的导航的名称
 @param isUploadToken  是否上传token
 */
- (void)setCustomNavTitle:(NSString *)titleNav  isUploadToken:(BOOL)isUploadToken;

- (void)setUpLongPressAction;
@end
