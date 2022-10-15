//
//  ZZPlayerViewController+ZZUIColletionView.m
//  zuwome
//
//  Created by 潘杨 on 2018/2/1.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZPlayerViewController+ZZUIColletionView.h"
#import "ZZPlayerViewController+ZZProxys.h"
#import "ZZPlayerCell.h"
#import "JPVideoPlayerPlayVideoTool.h"
@implementation ZZPlayerViewController (ZZUIColletionView)

#pragma mark - UITableViewMethod

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.canLoadMore?self.videoArray.count:1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"\n PY_播放器调用5 _%s --%@\n",__func__,indexPath);

    ZZPlayerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:playerCellID forIndexPath:indexPath];
    cell.tableView.scrollEnabled = !self.isBaseVideo;
    WeakSelf;
    cell.indexPath = indexPath;
    cell.weakCtl = weakSelf;
    cell.firstInto = ^(BOOL isFirst) {
        [weakSelf dealWithContentViewWhenFirstIntoPlayer:isFirst];
    };

    
    if (self.canLoadMore) {
        ZZFindVideoModel *model = self.videoArray[indexPath.row];
        [cell setData:model];
    }
    //这个是cell的展示视频下方的显示的
   else if (self.currentSkModel) {
        cell.topicModel = self.currentSkModel;
   }
   else if (self.currentMMDModel) {
        cell.mMDDataModel = self.currentMMDModel;
    }
   else if (self.chatBaseModel) {
       cell.chatBaseModel = self.chatBaseModel;
   }
    [self setCellData:cell dict:[self getCurrentDictionary]];
    cell.loadMore = ^{
        [weakSelf loadComment:indexPath];
    };
    cell.touchContribution = ^{
        [weakSelf gotoContributionView];
    };
    cell.viewScroll = ^(CGFloat cellY,BOOL isLongVideo){
        [weakSelf viewOffset:cellY isLongVideo:isLongVideo];
    };
    
    cell.touchComment = ^(ZZCommentModel *model) {
        if (![ZZUserHelper shareInstance].isLogin) {
            [weakSelf gotoLoginView];
            return;
        }
        [weakSelf.commentView setCommentModel:model];
    };
    cell.touchHead = ^(NSString *uid) {
        [weakSelf gotoUserPageWithUid:uid];
    };
    cell.touchPlayView = ^{
        [weakSelf oneClickTableView];
    };
    cell.doubleClick = ^{
        [weakSelf doubleClickTableView];
    };
    cell.gotoReportView = ^{
        weakSelf.isPushView = YES;
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self handleQuickScroll];
    ZZPlayerCell *playerCell = (ZZPlayerCell *)cell;
    if (playerCell.tableView.contentOffset.y > 0.5) {
        playerCell.tableView.contentOffset = CGPointMake(0, 0);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.isScrolling = YES;
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    self.isScrolling = NO;
    if (!self.scrollCannotPlay) {
        [self handleScrollStop];
    }
    
   self.scrollCannotPlay = NO;
    //进行加载更多视频
    NSInteger row = self.currentVideoPath.row + 1;
    if (self.videoArray.count>=5 && self.canLoadMore && self.viewDidAppear && !self.noMoreData && !self.isLoadingData) {
        if (row>self.videoArray.count - 4) {
            [self loadMoreData];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}
#pragma mark - 滚动事件处理

-(void)handleScrollStop
{
    //如果发现x的偏移大于等于当前屏幕的宽
    if (self.collectionView.contentOffset.x>=SCREEN_WIDTH) {
        NSInteger currentInteger = (NSInteger)(self.collectionView.contentOffset.x/SCREEN_WIDTH);
        NSLog(@"PY_发现x的偏移 %ld",currentInteger);
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentInteger inSection:0];
        self.currentVideoPath = indexPath;
        ZZPlayerCell *finnalCell = (ZZPlayerCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
        [self watchVideoCell:finnalCell];
    }else{
        NSArray *visiableCells = [self.collectionView visibleCells];
        if (visiableCells.count) {
            ZZPlayerCell *finnalCell = (ZZPlayerCell*)[visiableCells firstObject];
            [self watchVideoCell:finnalCell];
        }
    }
}

- (void)watchVideoCell:(ZZPlayerCell *)finnalCell {
    
    if (finnalCell != nil) {
        [self stopPlay];
        self.playingCell = finnalCell;
        self.currentVideoPath = finnalCell.indexPath;
        [self managerData];
//        //这个是cell的展示视频下方的显示的
        if (self.canLoadMore) {
            ZZFindVideoModel *model = self.videoArray[finnalCell.indexPath.row];
            [finnalCell setData:model];
        }
        if (self.currentSkModel) {
            finnalCell.topicModel = self.currentSkModel;

        } else {
            finnalCell.topicModel = self.currentMMDModel;
        }
        NSMutableDictionary *dict = [self getCurrentDictionary];
        [self setCellData:finnalCell dict:dict];
        [self dealWithContentViewWhenFirstIntoPlayer:finnalCell.isLongVideo];
        finnalCell.imgView.jp_videoPlayerDelegate = self;
        [self beginPlayerCell:finnalCell];
        [self setInfomation];
        [self calculateReadCount];
        [self resetData];
        [self loadComment:self.currentVideoPath];

    } else {
    }
}

/**
 播放视频
 */
- (void)beginPlayerCell:(ZZPlayerCell *)finnalCell {
    NSLog(@"PY_播放视频的背景 %@",   NSStringFromCGRect(finnalCell.imgView.frame));
    
    if (self.isBaseVideo) {
        [finnalCell.imgView jp_playVideoWithURL:[self getUrlWithString:finnalCell.playerUrlStr] options:JPVideoPlayerContinueInBackground |JPVideoPlayerLayerVideoGravityResizeAspect  | JPVideoPlayerShowActivityIndicatorView progress:nil completed:^(NSString * _Nullable fullVideoCachePath, NSError * _Nullable error, JPVideoPlayerCacheType cacheType, NSURL * _Nullable videoURL) {
            if (error == nil) {
                NSInteger status = [JPVideoPlayerPlayVideoTool sharedTool].currentPlayVideoItem.player.status;
                if ( status!= 1) {
                    [finnalCell.imgView  jp_resume];
                };
            }
        }];
    }
    else {
        [finnalCell.imgView jp_playVideoWithURL:[self getUrlWithString:finnalCell.playerUrlStr] options:JPVideoPlayerContinueInBackground | JPVideoPlayerLayerVideoGravityResizeAspect| JPVideoPlayerShowActivityIndicatorView progress:nil completed:^(NSString * _Nullable fullVideoCachePath, NSError * _Nullable error, JPVideoPlayerCacheType cacheType, NSURL * _Nullable videoURL) {
            NSLog(@"PY_当前的播放的url是 1  %@ %ld %@",error,(long)cacheType,videoURL);
            if (error == nil) {
                NSInteger status = [JPVideoPlayerPlayVideoTool sharedTool].currentPlayVideoItem.player.status;
                if ( status!= 1) {
                    [finnalCell.imgView jp_resume];
                };
            }
        }];
    }
    [finnalCell.imgView bringSubviewToFront:finnalCell.playerTopicView];
}
- (NSURL *)getUrlWithString:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
     NSLog(@"PY_ 当前的旧播放数据%@",urlString);
    return url;
}
- (void)calculateReadCount
{
    if (self.currentSkModel) {
        [self addSkReadCount:self.currentSkModel.id];
    } else if (self.currentMMDModel) {
        [self addMmdReadCount:self.currentMMDModel.mid];
    }
}
#pragma mark - 添加阅读量

- (void)addSkReadCount:(NSString *)skId
{
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/sk/%@/browser_count/inc",skId] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            
        }
    }];
}
- (void)addMmdReadCount:(NSString *)mid
{
    [ZZRequest method:@"POST" path:[NSString stringWithFormat:@"/mmd/%@/browser_count/inc",mid] params:nil next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            
        }
    }];
}
@end
