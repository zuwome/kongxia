//
//  ZZUserVideoViewController.m
//  zuwome
//
//  Created by angBiu on 2017/3/28.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZUserVideoViewController.h"
#import "ZZPlayerViewController.h"
#import "ZZRecordViewController.h"

#import "ZZUserVideoSuccessCell.h"
#import "ZZUserVideoFailureCell.h"

#import "ZZVideoHeadView.h"
#import "ZZVideoUploadStatusView.h"
#import "ZZUserVideoEmptyView.h"

#import "ZZUserVideoListModel.h"
#import "ZZDateHelper.h"
#import "XRWaterfallLayout.h"

@interface ZZUserVideoViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, XRWaterfallLayoutDelegate>

@property (nonatomic, strong) ZZVideoHeadView *headView;
@property (nonatomic, strong) NSMutableArray<ZZUserVideoListModel *> *dataArray;
@property (nonatomic, strong) NSMutableArray *videoArray;
@property (nonatomic, strong) NSMutableDictionary *imageDict;
@property (nonatomic, strong) NSMutableDictionary *percentDict;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) XRWaterfallLayout *waterfall;

@end

@implementation ZZUserVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createViews];
    [self reloadVideoArray];
    [self loadData];
    [self addNotifications];
}

- (void)createViews
{
//    CGFloat width = (SCREEN_WIDTH - 15)/2.0;
//    _layout = [[UICollectionViewFlowLayout alloc] init];
//    _layout.itemSize = CGSizeMake(width, width*13/9);
//    _layout.minimumLineSpacing = 5;
//    _layout.minimumInteritemSpacing = 5;
//    _layout.sectionInset = UIEdgeInsetsMake(0, 5, 5, 5);
//    _layout.headerReferenceSize = CGSizeMake(self.headViewHeight+40, 0.1);
    
    self.waterfall = [XRWaterfallLayout waterFallLayoutWithColumnCount:2];
    //设置各属性的值
    //    waterfall.rowSpacing = 10;
    //    waterfall.columnSpacing = 10;
    //    waterfall.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    //或者一次性设置
    [self.waterfall setColumnSpacing:5 rowSpacing:5 sectionInset:UIEdgeInsetsMake(self.headViewHeight + 40, 5, 5, 5)];
    self.waterfall.delegate = self;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.waterfall];
//    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = kBGColor;
    [self.collectionView registerClass:[ZZUserVideoEmptyView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.collectionView registerClass:[ZZUserVideoSuccessCell class] forCellWithReuseIdentifier:@"success"];
    [self.collectionView registerClass:[ZZUserVideoFailureCell class] forCellWithReuseIdentifier:@"failure"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    _headView = [[ZZVideoHeadView alloc] initWithFrame:CGRectMake(0, self.headViewHeight, SCREEN_WIDTH, 35)];
    _headView.leftLabel.text = [NSString stringWithFormat:@"已发布%ld个作品",self.user.video_count];
    _headView.rightLabel.text = [NSString stringWithFormat:@"共获得%ld个赞",self.user.get_like_count];
    [self.collectionView addSubview:_headView];
}

- (void)loadData
{
    __weak typeof(self)weakSelf = self;
    self.collectionView.mj_header = [ZZRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf pullRequest:nil];
    }];
    self.collectionView.mj_footer = [ZZRefreshFooter footerWithRefreshingBlock:^{
        ZZUserVideoListModel *model = [weakSelf.dataArray lastObject];
        [weakSelf pullRequest:model.sort_value];
    }];
    [self pullRequest:nil];
}

- (void)pullRequest:(NSString *)sort_value
{
    NSDictionary *aDict = nil;
    if (sort_value) {
        aDict = @{@"sort_value":sort_value};
    }
    [ZZUserVideoListModel getUserVideoList:aDict uid:[ZZUserHelper shareInstance].loginerId next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [self dataCallBack:error data:data task:task sort_value:sort_value];
    }];
}

- (void)dataCallBack:(ZZError *)error data:(id)data task:(NSURLSessionDataTask *)task sort_value:(NSString *)sort_value
{
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    [self.collectionView.mj_footer resetNoMoreData];
    if (error) {
        [ZZHUD showErrorWithStatus:error.message];
    } else {
        NSMutableArray *array = [ZZUserVideoListModel arrayOfModelsFromDictionaries:data error:nil];
        
        if (array.count == 0) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        BOOL isFirstLoad = NO;
        if (!sort_value) {
            if (!_dataArray) {
                isFirstLoad = YES;
            }
            _dataArray = array;
        } else {
            [_dataArray addObjectsFromArray:array];
        }
        
        [self.collectionView reloadData];
        if (isFirstLoad) {
            [self getImages];
        }
        [self managerEmpty];
    }
}

- (void)managerEmpty
{
    if (_dataArray.count == 0) {
        self.collectionView.backgroundColor = kBGColor;
//        _layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, self.headViewHeight + SCREEN_HEIGHT - 64);
        _headView.hidden = YES;
        self.collectionView.mj_header = nil;
        self.collectionView.mj_footer = nil;
    } else {
        _headView.hidden = NO;
        self.collectionView.backgroundColor = kBGColor;
//        _layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, self.headViewHeight+40);
    }
}

- (void)getImages
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        for (NSInteger i=0; i<self.videoArray.count; i++) {
            NSDictionary *aDict = self.videoArray[i];
            [self.percentDict setObject:[NSNumber numberWithFloat:0.0] forKey:[NSNumber numberWithInteger:i]];
            [self getImageWithDict:aDict];
        }
    });
}

- (void)getImageWithDict:(NSDictionary *)aDict
{
    NSString *url = [aDict objectForKey:@"url"];
    url = [NSString stringWithFormat:@"%@/%@",[ZZFileHelper createPathWithChildPath:video_savepath],url];
    UIImage *thumb = [ZZUtils getThumbImageWithVideoUrl:[NSURL fileURLWithPath:url]];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.videoArray indexOfObject:aDict] inSection:0];
    if (thumb) {
        [self.imageDict setObject:thumb forKey:[aDict objectForKey:@"tagId"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        });
    }
}

- (void)addNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoProgressNotification:) name:kMsg_VideoUploadProgress object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoUploadSuccess:) name:kMsg_SuccessUploadVide object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoUploadFailure:) name:kMsg_FailureUploadVide object:nil];
}

#pragma mark - Private methods

- (IBAction)zanClick:(NSIndexPath *)indexPath {
    
    [MobClick event:Event_click_player_zan];
    ZZUserVideoListModel *model = _dataArray[indexPath.row - self.videoArray.count];
    if (model.like_status) {
        // 取消赞
        if (model.sk.skId) {
            // 时刻视频
            [self skUnLisk:indexPath];
        } else {
            // 么么哒视频
            [self mmdUnLike:indexPath];
        }
    } else {
        // 赞
        if (model.sk.skId) {
            // 时刻视频
            [self skLike:indexPath];
        } else {
            // 么么哒视频
            [self mmdLike:indexPath];
        }
    }
}

- (IBAction)commentClick:(NSIndexPath *)indexPath {
    
    WEAK_SELF();
    ZZUserVideoListModel *model = _dataArray[indexPath.row - self.videoArray.count];
    ZZPlayerViewController *controller = [[ZZPlayerViewController alloc] init];
    if (model.mmd.mid) {
        controller.mid = model.mmd.mid;
        controller.firstMMDModel = model.mmd;
    } else {
        controller.skId = model.sk.skId;
        controller.firstSkModel = model.sk;
    }
    controller.isShowTextField = YES;
    controller.userVideo = model;
    controller.playType = PlayTypeUserVideo;
    controller.deleteCallBack = ^{
        [weakSelf.dataArray removeObject:model];
        [weakSelf.collectionView reloadData];
        [weakSelf managerEmpty];
    };
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)skLike:(NSIndexPath *)indexPath {
    ZZUserVideoListModel *model = _dataArray[indexPath.row - self.videoArray.count];
    [ZZSKModel zanSkWithModel:model.sk next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
            model.like_status = YES;
            [ZZHUD showSuccessWithStatus:@"点赞成功"];
        }
    }];
}

- (void)skUnLisk:(NSIndexPath *)indexPath {
    ZZUserVideoListModel *model = _dataArray[indexPath.row - self.videoArray.count];
    [ZZSKModel zanSkWithModel:model.sk next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
            model.like_status = NO;
            [ZZHUD showSuccessWithStatus:@"取消赞"];
        }
    }];
}

- (void)mmdLike:(NSIndexPath *)indexPath {
    ZZUserVideoListModel *model = _dataArray[indexPath.row - self.videoArray.count];
    [ZZMemedaModel zanMemeda:model.mmd next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
            model.like_status = YES;
            [ZZHUD showSuccessWithStatus:@"点赞成功"];
        }
    }];
}

- (void)mmdUnLike:(NSIndexPath *)indexPath {
    ZZUserVideoListModel *model = _dataArray[indexPath.row - self.videoArray.count];
    [ZZMemedaModel zanMemeda:model.mmd next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
            model.like_status = NO;
            [ZZHUD showSuccessWithStatus:@"取消赞"];
        }
    }];
}

#pragma mark - XRWaterfallLayoutDelegate methods

- (CGFloat)waterfallLayout:(XRWaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.videoArray.count) {
        CGFloat width = (SCREEN_WIDTH - 15)/2.0;
        return width * 13 / 9;
    }
    //根据图片的原始尺寸，及显示宽度，等比例缩放来计算显示高度
    ZZUserVideoListModel *model = _dataArray[indexPath.row - self.videoArray.count];
    // 区分 瞬间 和 么么哒视频
    CGFloat imageHeight = 0;
    NSString *content = @"";
    if (model.sk.skId) {
        imageHeight = [INT_TO_STRING(model.sk.video.height) floatValue] / [INT_TO_STRING(model.sk.video.width) floatValue] * itemWidth;
        content = model.sk.content;
    } else {
        ZZMMDAnswersModel *mmd = model.mmd.answers.firstObject;
        imageHeight = [INT_TO_STRING(mmd.video.height) floatValue] / [INT_TO_STRING(mmd.video.width) floatValue] * itemWidth;
        content = model.mmd.content;
    }
    //有一个最大比例高度，height不能太大
    if (imageHeight >= VIDEO_MAX_HEIGHT || isnan(imageHeight)) {
        imageHeight = VIDEO_MAX_HEIGHT;
    }
    CGFloat textHeight = [ZZUtils heightForCellWithText:content fontSize:12 labelWidth:itemWidth - 20];
    return imageHeight + (textHeight == 0 ? 58 : (textHeight + 68));
}

#pragma mark - UICollectionViewMethod

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray ? self.dataArray.count + self.videoArray.count : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf;
    if (indexPath.row < self.videoArray.count) {
        ZZUserVideoFailureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"failure" forIndexPath:indexPath];
        NSDictionary *aDict = self.videoArray[indexPath.row];
        UIImage *image = [self.imageDict objectForKey:[aDict objectForKey:@"tagId"]];
        if (image) {
            cell.imgView.image = image;
        } else {
            cell.imgView.image = nil;
        }
        NSInteger type = [[aDict objectForKey:@"type"] integerValue];
        NSInteger interval = 0;
        NSTimeInterval nowInterval = [[NSDate date] timeIntervalSince1970];
        NSString *expiredTime = [aDict objectForKey:@"expiredTime"];
        if (type == 0 || !expiredTime) {
            NSTimeInterval expiredInterval = [[aDict objectForKey:@"tagId"] integerValue]/(1000*1000) + 24*60*60;
            interval = expiredInterval - nowInterval;
        } else {
            NSDate *expiredDate = [[ZZDateHelper shareInstance] getDateWithDateString:expiredTime];
            NSTimeInterval expiredInterval = [expiredDate timeIntervalSince1970];
            interval = expiredInterval - nowInterval;
        }
        if (interval/60 < 60) {
            cell.timeLabel.text = [NSString stringWithFormat:@"仅保留%ld分钟",interval/60];
        } else {
            cell.timeLabel.text = [NSString stringWithFormat:@"仅保留%ld小时",interval/3600];
        }
        CGFloat percent = [[self.percentDict objectForKey:[NSNumber numberWithInteger:indexPath.row]] floatValue];
        if (percent == 0.0 && ![self isVideoUploading:indexPath]) {
            [cell showViews];
        } else {
            [cell hideViews];
        }
        cell.coverView.height = cell.height*(1- percent);
        __weak typeof(cell) weakCell = cell;
        
        cell.touchRetry = ^{
            [weakSelf retryBtnClick:weakCell];
        };
        cell.touchDelete = ^{
            [weakSelf deleteBtnClick:weakCell];
        };
        return cell;
    }
    else {
        ZZUserVideoSuccessCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"success" forIndexPath:indexPath];
        
        [cell setData:self.dataArray[indexPath.row - self.videoArray.count]];
        [cell setZanBlock:^{
            //赞
            [weakSelf zanClick:indexPath];
        }];
        [cell setCommentBlock:^{
            //评论
            [weakSelf commentClick:indexPath];
        }];
        return cell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        ZZUserVideoEmptyView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath: indexPath];
        headView.topOffset = self.headViewHeight;
        if (_dataArray && _dataArray.count == 0) {
            [headView showViews];
        } else {
            [headView hideViews];
        }
        headView.touchRecord = ^{
            [self gotoRecordView];
        };
        return headView;
    }
    
    return [UICollectionReusableView new];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.videoArray.count) {
        WeakSelf;
        ZZUserVideoListModel *model = self.dataArray[indexPath.row - self.videoArray.count];
        ZZPlayerViewController *controller = [[ZZPlayerViewController alloc] init];
        if (model.mmd.mid) {
            controller.mid = model.mmd.mid;
            controller.firstMMDModel = model.mmd;
        } else {
            controller.skId = model.sk.skId;
            controller.firstSkModel = model.sk;
        }
        controller.userVideo = model;
        controller.playType = PlayTypeUserVideo;
        controller.deleteCallBack = ^{
            [weakSelf.dataArray removeObject:model];
            [weakSelf.collectionView reloadData];
            [weakSelf managerEmpty];
        };
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (BOOL)isVideoUploading:(NSIndexPath *)indexPath
{
    NSDictionary *aDict = self.videoArray[indexPath.row];
    NSInteger type = [[aDict objectForKey:@"type"] integerValue];
    NSString *tagId = [aDict objectForKey:@"tagId"];
    NSString *mid = [aDict objectForKey:@"mid"];
    if (type == 0) {
        return [[ZZUserHelper shareInstance].uploadVideoArray containsObject:tagId];
    } else {
        return [[ZZUserHelper shareInstance].uploadVideoArray containsObject:mid];
    }
}

#pragma mark - private

- (void)retryBtnClick:(UICollectionViewCell *)cell
{
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    if (indexPath.row < self.videoArray.count) {
        NSDictionary *aDict = self.videoArray[indexPath.row];
        ZZVideoUploadStatusView *statusView = [ZZVideoUploadStatusView sharedInstance];
        statusView.videoDict = aDict;
        statusView.isIntroduceVideo = NO;
        [statusView showBeginStatusView];
    }
}

- (void)deleteBtnClick:(UICollectionViewCell *)cell
{
    [self showOKCancelAlertWithTitle:@"确认删除" message:@"您确定要放弃上传并删除本视频？" cancelTitle:@"取消" cancelBlock:^{
        
    } okTitle:@"确定" okBlock:^{
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        NSDictionary *aDict = self.videoArray[indexPath.row];
        [self.imageDict removeObjectForKey:[aDict objectForKey:@"tagId"]];
        [self.videoArray removeObjectAtIndex:indexPath.row];
        [self.collectionView performBatchUpdates:^{
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        } completion:^(BOOL finished) {
            [self.collectionView reloadData];
            [self managerEmpty];
        }];
        
        NSString *key = [NSString stringWithFormat:@"%@%@",[ZZStoreKey sharedInstance].uploadFailureVideo,[ZZUserHelper shareInstance].loginerId];
        [ZZKeyValueStore saveValue:self.videoArray key:key tableName:kTableName_VideoSave];
        NSString *url = [aDict objectForKey:@"url"];
        url = [NSString stringWithFormat:@"%@/%@",[ZZFileHelper createPathWithChildPath:video_savepath],url];
        [[NSFileManager defaultManager] removeItemAtURL:[NSURL fileURLWithPath:url] error:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_DeleteFailureVide object:nil];
    }];
}

- (void)reloadVideoArray {
    if (!_videoArray) {
        _videoArray = @[].mutableCopy;
    }
    [self.videoArray removeAllObjects];
    NSString *key = [NSString stringWithFormat:@"%@%@",[ZZStoreKey sharedInstance].uploadFailureVideo,[ZZUserHelper shareInstance].loginerId];
    NSArray *array = [ZZKeyValueStore getValueWithKey:key tableName:kTableName_VideoSave];
    for (NSDictionary *aDict in array) {
        NSInteger type = [[aDict objectForKey:@"type"] integerValue];
        NSString *url = [aDict objectForKey:@"url"];
        url = [NSString stringWithFormat:@"%@/%@",[ZZFileHelper createPathWithChildPath:video_savepath],url];
        NSString *expiredTime = [aDict objectForKey:@"expiredTime"];
        if (type == 0 || !expiredTime) {
            NSTimeInterval expiredInterval = [[aDict objectForKey:@"tagId"] integerValue]/(1000*1000) + 24*60*60;
            NSTimeInterval nowInterval = [[NSDate date] timeIntervalSince1970];
            if (nowInterval < expiredInterval) {
                [self.videoArray addObject:aDict];
            }
            else {
                [[NSFileManager defaultManager] removeItemAtURL:[NSURL fileURLWithPath:url] error:nil];
            }
        }
        else {
            NSDate *expiredDate = [[ZZDateHelper shareInstance] getDateWithDateString:expiredTime];
            if ([[NSDate date] compare:expiredDate] == NSOrderedAscending) {
                [self.videoArray addObject:aDict];
            }
            else {
                [[NSFileManager defaultManager] removeItemAtURL:[NSURL fileURLWithPath:url] error:nil];
            }
        }
    }
    [ZZKeyValueStore saveValue:self.videoArray key:key tableName:kTableName_VideoSave];
}

- (void)updateFailureData
{
    [self reloadVideoArray];
    [self.collectionView reloadData];
}

- (void)gotoRecordView
{
    if ([ZZUtils isAllowRecord]) {
        [ZZUtils checkRecodeAuth:^(BOOL authorized) {
            if (authorized) {
                ZZRecordViewController *controller = [[ZZRecordViewController alloc] init];
                ZZNavigationController *navCtl = [[ZZNavigationController alloc] initWithRootViewController:controller];
                [self presentViewController:navCtl animated:YES completion:nil];
            }
        }];
    }
}

#pragma mark - notification

- (void)videoProgressNotification:(NSNotification *)notification
{
    CGFloat percent = [[notification.userInfo objectForKey:@"percent"] floatValue];
    NSString *tagId = [notification.userInfo objectForKey:@"tagId"];
    
    for (NSDictionary *aDict in self.videoArray) {
        if ([[aDict objectForKey:@"tagId"] isEqualToString:tagId]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.videoArray indexOfObject:aDict] inSection:0];
            [self showCellProgress:percent indexPath:indexPath];
            break;
        }
    }
}

- (void)showCellProgress:(CGFloat)percent indexPath:(NSIndexPath *)indexPath
{
    dispatch_async(dispatch_get_main_queue(), ^{
        ZZUserVideoFailureCell *cell = (ZZUserVideoFailureCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.coverView.height = cell.height * (1 - percent);
        });
        [self.percentDict setObject:[NSNumber numberWithFloat:percent] forKey:[NSNumber numberWithInteger:indexPath.row]];
    });
    
}

- (void)videoUploadSuccess:(NSNotification *)notification
{
    NSString *tagId = [notification.userInfo objectForKey:@"tagId"];
    NSArray *array = [NSArray arrayWithArray:self.videoArray];
    for (NSDictionary *aDict in array) {
        if ([[aDict objectForKey:@"tagId"] isEqualToString:tagId]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.videoArray indexOfObject:aDict] inSection:0];
            [self.videoArray removeObject:aDict];
            if (self.collectionView.visibleCells.count != 0) {
                [self.collectionView performBatchUpdates:^{
                    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
                } completion:^(BOOL finished) {
                    [self pullRequest:nil];
                }];
            }
            break;
        }
    }
}

- (void)videoUploadFailure:(NSNotification *)notification
{
    [self reloadVideoArray];
    NSString *tagId = [notification.userInfo objectForKey:@"tagId"];
    for (NSDictionary *aDict in self.videoArray) {
        if ([[aDict objectForKey:@"tagId"] isEqualToString:tagId]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.videoArray indexOfObject:aDict] inSection:0];
            [self.percentDict setObject:[NSNumber numberWithFloat:0.0] forKey:[NSNumber numberWithInteger:indexPath.row]];
            [self getImageWithDict:notification.userInfo];
            break;
        }
    }
    [self.collectionView reloadData];
}

#pragma mark - lazyload
- (NSMutableDictionary *)imageDict
{
    if (!_imageDict) {
        _imageDict = [NSMutableDictionary dictionary];
    }
    return _imageDict;
}

- (NSMutableDictionary *)percentDict
{
    if (!_percentDict) {
        _percentDict = [NSMutableDictionary dictionary];
    }
    return _percentDict;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
