//
//  ZZVideoCommentViewController.h
//  zuwome
//
//  Created by angBiu on 16/8/17.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZViewController.h"
/**
 *  视频 评论页
 */
@interface ZZVideoCommentViewController : ZZViewController

@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, copy) void(^touchComment)(NSString *content);

@end
