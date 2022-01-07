//
//  ZZPlayerViewController+ZZUIColletionView.h
//  zuwome
//
//  Created by 潘杨 on 2018/2/1.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//ColletionView 的处理滑动和赋值的

#import "ZZPlayerViewController.h"
#import "UIView+WebVideoCache.h"
@interface ZZPlayerViewController (ZZUIColletionView)<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,JPVideoPlayerDelegate>

-(void)handleScrollStop;
- (NSURL *)getUrlWithString:(NSString *)urlString;
- (void)calculateReadCount;
/**
 播放视频
 */
- (void)beginPlayerCell:(ZZPlayerCell *)finnalCell ;
@end
