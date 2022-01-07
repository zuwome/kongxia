//
//  ZZHelpCenterVC.h
//  zuwome
//
//  Created by YuTianLong on 2017/12/27.
//  Copyright © 2017年 TimoreYu. All rights reserved.
//

#import "ZZViewController.h"

/* 帮助中心 这个页面 只给帮助中心H5使用 */

@interface ZZHelpCenterVC : ZZViewController

@property (nonatomic, strong) NSString *urlString;
//@property (nonatomic, assign) BOOL isPresent;
@property (nonatomic, assign) BOOL showShare;
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSString *shareTitle;
@property (nonatomic, strong) NSString *shareContent;
@property (nonatomic, assign) BOOL isHideBar;

@end
