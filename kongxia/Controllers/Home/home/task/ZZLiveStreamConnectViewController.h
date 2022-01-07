//
//  ZZLiveStreamConnectViewController.h
//  zuwome
//
//  Created by angBiu on 2017/7/14.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZViewController.h"

/**
 1V1连麦
 */
@interface ZZLiveStreamConnectViewController : ZZViewController

@property (nonatomic, assign) BOOL acceped;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, assign) BOOL isDisableVideo;//是否要关闭摄像头(发单人才有的)
@property (nonatomic, assign) BOOL smallVideoChangeBigVideo;//小窗口变为大窗口  YES,

@end
