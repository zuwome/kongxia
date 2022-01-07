//
//  ZZMessageSystemViewController.h
//  zuwome
//
//  Created by angBiu on 16/7/27.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZViewController.h"
/**
 *  系统消息界面
 */
@interface ZZMessageSystemViewController : ZZViewController

@property (nonatomic, copy) dispatch_block_t successCallBack;
@property (nonatomic, copy) void (^isUploadVideoBlock)(BOOL is);

@end
