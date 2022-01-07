//
//  ZZTopicHotViewController.m
//  zuwome
//
//  Created by angBiu on 2017/4/14.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZTopicHotViewController.h"
#import "ZZPlayerViewController.h"

#import "ZZFindNewCell.h"

#import "ZZFindVideoModel.h"
#import "XRWaterfallLayout.h"

@interface ZZTopicHotViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, XRWaterfallLayoutDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
//@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) XRWaterfallLayout *waterfall;

@end

@implementation ZZTopicHotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createViews];
    if (_groupModel) {
        [self loadData];
    }
}

- (void)createViews
{
//    CGFloat width = (SCREEN_WIDTH - 15)/2.0;
//    _layout = [[UICollectionViewFlowLayout alloc] init];
//    _layout.itemSize = CGSizeMake(width, width*13/9);
//    _layout.sectionInset = UIEdgeInsetsMake(self.headViewHeight+5, 5.0f, 5.0f, 5.0f);
//    _layout.minimumLineSpacing = 5;
//    _layout.minimumInteritemSpacing = 5;
    //创建瀑布流布局
    self.waterfall = [XRWaterfallLayout waterFallLayoutWithColumnCount:2];
    //设置各属性的值
    //    waterfall.rowSpacing = 10;
    //    waterfall.columnSpacing = 10;
    //    waterfall.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    //或者一次性设置
    [self.waterfall setColumnSpacing:5 rowSpacing:5 sectionInset:UIEdgeInsetsMake(self.headViewHeight + 5, 5, 5, 5)];
    self.waterfall.delegate = self;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.waterfall];
    [self.collectionView registerClass:[ZZFindNewCell class] forCellWithReuseIdentifier:@"mycell"];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (void)setGroupModel:(ZZTopicGroupModel *)groupModel
{
    _groupModel = groupModel;
    if (groupModel && !self.collectionView.mj_footer) {
        [self loadData];
    }
}

- (void)updateHeadHeight {
//    _layout.sectionInset = UIEdgeInsetsMake(self.headViewHeight+5, 5.0f, 5.0f, 5.0f);
    self.waterfall.sectionInset = UIEdgeInsetsMake(self.headViewHeight+5, 5.0f, 5.0f, 5.0f);
    [self.collectionView reloadData];
}

#pragma mark - Data

- (void)loadData
{
    WeakSelf;
    self.collectionView.mj_footer = [ZZRefreshFooter footerWithRefreshingBlock:^{
        ZZFindVideoModel *model = [weakSelf.dataArray lastObject];
        [weakSelf pullRequest:model.sort_value1 sort_value2:model.sort_value2];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.collectionView.mj_footer beginRefreshing];
    });
}

- (void)pullRequest:(NSString *)sort_value1 sort_value2:(NSString *)sort_value2
{
    NSMutableDictionary *aDict = [@{@"type":@"hot"} mutableCopy];
    if (sort_value1 && sort_value2) {
        [aDict setObject:sort_value1 forKey:@"sort_value1"];
        [aDict setObject:sort_value2 forKey:@"sort_value2"];
    }
    [ZZFindVideoModel getTopicVideoList:aDict groupId:self.groupModel.groupId next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [self dataCallBack:error data:data task:task sort_value1:sort_value1 sort_value2:sort_value2];
    }];
}

- (void)dataCallBack:(ZZError *)error data:(id)data task:(NSURLSessionDataTask *)task sort_value1:(NSString *)sort_value1 sort_value2:(NSString *)sort_value2
{
//    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    [self.collectionView.mj_footer resetNoMoreData];
    if (error) {
        [ZZHUD showErrorWithStatus:error.message];
    } else {
        NSMutableArray *array = [ZZFindVideoModel arrayOfModelsFromDictionaries:data error:nil];
        
        if (array.count == 0) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        if (!sort_value1) {
            _dataArray = array;
        } else {
            [_dataArray addObjectsFromArray:array];
        }
        
        [self.collectionView reloadData];
    }
}

#pragma mark - Private methods

- (IBAction)zanClick:(NSIndexPath *)indexPath {
    
    [MobClick event:Event_click_player_zan];
    ZZFindVideoModel *model = _dataArray[indexPath.row];
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
    ZZFindVideoModel *model = self.dataArray[indexPath.row];
    ZZPlayerViewController *controller = [[ZZPlayerViewController alloc] init];
    controller.groupId = self.groupModel.groupId;
    controller.canLoadMore = YES;
    controller.dataArray = self.dataArray;
    controller.dataIndexPath = indexPath;
    controller.hidesBottomBarWhenPushed = YES;
    controller.playType = PlayTypeTopicHot;
    controller.deleteCallBack = ^{
        [weakSelf pullRequest:nil sort_value2:nil];
    };
    controller.firstFindModel = model;
    controller.isShowTextField = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)skLike:(NSIndexPath *)indexPath {
    ZZFindVideoModel *model = _dataArray[indexPath.row];
    [ZZSKModel zanSkWithModel:model.sk next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
            model.like_status = YES;
            [ZZHUD showSuccessWithStatus:@"点赞成功"];
        }
    }];
}

- (void)skUnLisk:(NSIndexPath *)indexPath {
    ZZFindVideoModel *model = _dataArray[indexPath.row];
    [ZZSKModel zanSkWithModel:model.sk next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
            model.like_status = NO;
            [ZZHUD showSuccessWithStatus:@"取消赞"];
        }
    }];
}

- (void)mmdLike:(NSIndexPath *)indexPath {
    ZZFindVideoModel *model = _dataArray[indexPath.row];
    [ZZMemedaModel zanMemeda:model.mmd next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
            model.like_status = YES;
            [ZZHUD showSuccessWithStatus:@"点赞成功"];
        }
    }];
}

- (void)mmdUnLike:(NSIndexPath *)indexPath {
    ZZFindVideoModel *model = _dataArray[indexPath.row];
    [ZZMemedaModel zanMemeda:model.mmd next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
            model.like_status = NO;
            [ZZHUD showSuccessWithStatus:@"取消赞"];
        }
    }];
}

#pragma mark - XRWaterfallLayoutDelegate methods

- (CGFloat)waterfallLayout:(XRWaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath {
    //根据图片的原始尺寸，及显示宽度，等比例缩放来计算显示高度
    ZZFindVideoModel *model = _dataArray[indexPath.row];

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
    if (imageHeight >= (SCREEN_WIDTH - 15) / 2.0 * 13 / 9.0 || isnan(imageHeight)) {
        imageHeight = (SCREEN_WIDTH - 15) / 2.0 * 13 / 9.0;
    }
    CGFloat textHeight = [ZZUtils heightForCellWithText:content fontSize:12 labelWidth:itemWidth - 20];
    return imageHeight + (textHeight == 0 ? 58 : (textHeight + 68));
}

#pragma mark - UICollectionViewMethod

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WEAK_SELF();
    ZZFindVideoModel *model = self.dataArray[indexPath.row];
    ZZFindNewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mycell" forIndexPath:indexPath];
    if (model.sk.skId) {
        [cell setSkData:model];
    } else {
        [cell setMMDData:model];
    }
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WeakSelf;
    ZZFindVideoModel *model = self.dataArray[indexPath.row];
    ZZPlayerViewController *controller = [[ZZPlayerViewController alloc] init];
    controller.groupId = self.groupModel.groupId;
    controller.canLoadMore = YES;
    controller.dataArray = self.dataArray;
    controller.dataIndexPath = indexPath;
    controller.hidesBottomBarWhenPushed = YES;
    controller.playType = PlayTypeTopicHot;
    controller.deleteCallBack = ^{
        [weakSelf pullRequest:nil sort_value2:nil];
    };
    controller.firstFindModel = model;
    [self.navigationController pushViewController:controller animated:YES];
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
