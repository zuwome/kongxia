//
//  ZZMemedaAskViewController.m
//  zuwome
//
//  Created by angBiu on 16/8/8.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZMemedaAskViewController.h"
#import "ZZPlayerViewController.h"
#import "ZZRentViewController.h"

#import "ZZMemedaAskCell.h"
#import "ZZVideoHeadView.h"
#import "ZZMemedaAskEmptyView.h"
#import "XRWaterfallLayout.h"
#import "ZZMemedaModel.h"

@interface ZZMemedaAskViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, XRWaterfallLayoutDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL pushVideoShow;
@property (nonatomic, strong) ZZVideoHeadView *headView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) XRWaterfallLayout *waterfall;

@end

@implementation ZZMemedaAskViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _pushVideoShow = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_pushVideoShow) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createViews];
    [self loadData];
}

- (void)createViews
{
//    _layout = [[UICollectionViewFlowLayout alloc] init];
//    _layout.minimumLineSpacing = 0;
//    _layout.headerReferenceSize = CGSizeMake(self.headViewHeight+40, 0.1);

    self.waterfall = [XRWaterfallLayout waterFallLayoutWithColumnCount:1];
    //设置各属性的值
    //    waterfall.rowSpacing = 10;
    //    waterfall.columnSpacing = 10;
    //    waterfall.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    //或者一次性设置
    [self.waterfall setColumnSpacing:5 rowSpacing:5 sectionInset:UIEdgeInsetsMake(self.headViewHeight + 40, 5, 5, 5)];
    self.waterfall.delegate = self;

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.waterfall];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[ZZMemedaAskEmptyView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.collectionView registerClass:[ZZMemedaAskCell class] forCellWithReuseIdentifier:@"mycell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.delaysContentTouches = NO;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    _headView = [[ZZVideoHeadView alloc] initWithFrame:CGRectMake(0, self.headViewHeight, SCREEN_WIDTH, 35)];
    _headView.leftLabel.text = [NSString stringWithFormat:@"已被回答%ld个问题，支出¥%.1f",self.user.answer_count_myask,self.user.give_hb_price_myask];
    _headView.rightLabel.text = [NSString stringWithFormat:@"收入¥%.1f",self.user.get_hb_price_myask];
    [self.collectionView addSubview:_headView];
}

#pragma mark - XRWaterfallLayoutDelegate methods

- (CGFloat)waterfallLayout:(XRWaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath {
    ZZMemedaModel *model = _dataArray[indexPath.row];
    CGFloat contentHeight = [ZZUtils heightForCellWithText:model.mmd.content fontSize:15 labelWidth:(SCREEN_WIDTH - 40)];
    
    return 10+20+50+0.5+20+contentHeight;
}

#pragma mark - Data

- (void)loadData
{
    [ZZUserHelper shareInstance].unreadModel.my_ask_mmd = NO;
    __weak typeof(self)weakSelf = self;
    [self.collectionView.mj_footer resetNoMoreData];
    self.collectionView.mj_header = [ZZRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf.collectionView.mj_footer resetNoMoreData];
        [weakSelf pullWithSort_value:nil];
    }];
    self.collectionView.mj_footer = [ZZRefreshFooter footerWithRefreshingBlock:^{
        ZZMemedaModel *lastModel = [weakSelf.dataArray lastObject];
        [weakSelf pullWithSort_value:lastModel.sort_value];
    }];
    [self pullWithSort_value:nil];
}

- (void)pullWithSort_value:(NSString *)sort_value
{
    NSMutableDictionary *aDict = [@{@"query_type":@"from"} mutableCopy];
    if (sort_value) {
        [aDict setObject:sort_value forKey:@"sort_value"];
    }
    ZZMemedaModel *model = [[ZZMemedaModel alloc] init];
    [model getUserMemedaList:aDict next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView.mj_footer resetNoMoreData];
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else if (data) {
            NSMutableArray *d = [ZZMemedaModel arrayOfModelsFromDictionaries:data error:nil];
            if (d.count == 0) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
            if (sort_value) {
                [_dataArray addObjectsFromArray:d];
            } else {
                _dataArray = d;
            }
            [self.collectionView reloadData];
            
            [self managerEmpty];
        }
    }];
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
        self.collectionView.backgroundColor = [UIColor whiteColor];
        _headView.hidden = NO;
//        _layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, self.headViewHeight+40);
    }
}

#pragma mark - UICollectionViewMethod

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZMemedaAskCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mycell" forIndexPath:indexPath];
    [cell setData:_dataArray[indexPath.row]];
    WeakSelf;
    cell.headImgView.touchHead = ^{
        [weakSelf headBtnClick:indexPath];
    };
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZMemedaModel *model = _dataArray[indexPath.row];
    CGFloat contentHeight = [ZZUtils heightForCellWithText:model.mmd.content fontSize:15 labelWidth:(SCREEN_WIDTH - 40)];
    
    return CGSizeMake(SCREEN_WIDTH, 10+20+50+0.5+20+contentHeight);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        ZZMemedaAskEmptyView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath: indexPath];
        headView.topOffset = self.headViewHeight;
        if (_dataArray && _dataArray.count == 0) {
            [headView showViews];
        } else {
            [headView hideViews];
        }
        return headView;
    }
    
    return [[UIView alloc] init];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZMemedaModel *model = _dataArray[indexPath.row];
    if ([model.mmd.status isEqualToString:@"answered"]) {
        _pushVideoShow = YES;
        ZZMemedaModel *model = _dataArray[indexPath.row];
        WeakSelf;
        ZZPlayerViewController *controller = [[ZZPlayerViewController alloc] init];
        controller.mid = model.mmd.mid;
        controller.deleteCallBack = ^{
            [weakSelf.dataArray removeObject:model];
            [weakSelf.collectionView reloadData];
            [weakSelf managerEmpty];
        };
        [self.navigationController pushViewController:controller animated:YES];
        controller.firstMMDModel = model.mmd;
    }
}

#pragma mark - UIButtonMethod

- (void)headBtnClick:(NSIndexPath *)indexPath
{
    ZZMemedaModel *model = _dataArray[indexPath.row];
    
    ZZRentViewController *controller = [[ZZRentViewController alloc] init];
    controller.uid = model.mmd.to.uid;
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
