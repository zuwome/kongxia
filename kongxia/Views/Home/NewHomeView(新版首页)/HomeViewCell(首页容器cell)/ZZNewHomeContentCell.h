//
//  ZZNewHomeContentCell.h
//  zuwome
//
//  Created by MaoMinghui on 2018/8/16.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZNewHomeBaseCell.h"
#import "ZZNewHomeContentScroll.h"

/**
 *  新版首页 -- 附近、推荐、新鲜等内容容器cell
 */
@interface ZZNewHomeContentCell : ZZNewHomeBaseCell

@property (nonatomic, strong) ZZNewHomeContentScroll *scrollView;
@property (nonatomic, assign) BOOL canScroll;

@end
