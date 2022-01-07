//
//  ZZPlayerViewController+ZZProxys.h
//  zuwome
//
//  Created by 潘杨 on 2018/2/1.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//用于和服务器交互的

#import "ZZPlayerViewController.h"

@interface ZZPlayerViewController (ZZProxys)
//更新余额
- (void)loadBalance;
- (void)loadMoreData;

- (void)mmdUnlikeMethod;
- (void)getSKDetail;
- (void)getMMDDetail:(BOOL)isUpdate;
//获取打赏
//- (void)loadContribution:(NSIndexPath *)indexPath;
- (void)skLikeMethod;
- (void)touchWXWithUid:(NSString *)uid;
#pragma mark - 评论、贡献榜
//获取评论
- (void)loadComment:(NSIndexPath *)indexPath;
- (void)skUnlikeMethod;
#pragma mark - 分享事件

- (void)setShareInfomation;
- (void)getWXNumber:(NSString *)channel;
- (void)managerPlayStatusWithPlayerCell:(ZZPlayerCell *)finnalCell;
- (void)mmdLikeMethod;
// 显示购买微信/更余额
- (void)showBuyWX;
@end
