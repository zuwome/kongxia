//
//  ZZRentDynamicViewController.m
//  zuwome
//
//  Created by angBiu on 16/8/2.
//  Copyright © 2016年 zz. All rights reserved.
//

static NSString *VideoIdentifier = @"videocell";
static NSString *ContentIdentifier = @"contentcell";
static NSString *TextIdentifier = @"textcell";

#import "ZZRentDynamicViewController.h"
#import "ZZPlayerViewController.h"
#import "ZZRentViewController.h"
#import "ZZRecordViewController.h"

#import "ZZRentDynamicTextCell.h"
#import "ZZRentDynamicVideoCell.h"
#import "ZZRentDynamicContentCell.h"

#import "ZZUserVideoEmptyView.h"

#import "ZZUserVideoListModel.h"

@interface ZZRentDynamicViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *footer;

@property (nonatomic, assign) BOOL isLoadCompleted;//是否加载完成

@end

@implementation ZZRentDynamicViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [ZZUserHelper shareInstance].upDateVideoList = NO;
    self.view.backgroundColor = kBGColor;
    self.isLoadCompleted = NO;
    [self createViews];
//    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ( [ZZUserHelper shareInstance].upDateVideoList) {
        self.dataArray = nil;
         [self loadMoreData];
    }
}

- (void)createViews {
    self.tableView = [[UITableView alloc] init];
    //动态视屏
    [self.tableView registerClass:[ZZRentDynamicVideoCell class] forCellReuseIdentifier:VideoIdentifier];

    [self.tableView registerClass:[ZZRentDynamicContentCell class] forCellReuseIdentifier:ContentIdentifier];

    [self.tableView registerClass:[ZZRentDynamicTextCell class] forCellReuseIdentifier:TextIdentifier];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 50;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (void)setUser:(ZZUser *)user {
    [super setUser:user];
    [self loadData];
}

#pragma mark - Data

- (void)loadData {
    _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer = _footer;
    [self loadMoreData];
}

- (void)loadMoreData {
    ZZUserVideoListModel *lastModel = [self.dataArray lastObject];
    [self pullWithSort_value:lastModel.sort_value];
}

- (void)pullWithSort_value:(NSString *)sort_value {
    NSDictionary *aDict = nil;
    if (sort_value) {
        aDict = @{@"sort_value":sort_value};
    } else {
//        [ZZHUD show];//第一次加载需要Loading
    }
    [ZZUserVideoListModel getUserPageVideoList:aDict uid:self.user.uid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        self.isLoadCompleted = YES;
        [self getData:data error:error sort_value:sort_value];
    }];
}

- (void)getData:(id)data error:(ZZError *)error sort_value:(NSString *)sort_value {
    [self.tableView.mj_footer endRefreshing];
    if (error) {
        [ZZHUD showErrorWithStatus:error.message];
    } else if (data) {
        [ZZHUD dismiss];
        NSMutableArray *array = [ZZUserVideoListModel arrayOfModelsFromDictionaries:data error:nil];
        if (array.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (sort_value) {
            [self.dataArray addObjectsFromArray:array];
        } else {
            self.dataArray = array;
        }
        if (self.dataArray.count>0) {
            NSLog(@"PY_刷新");
             [self.tableView reloadData];
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewMethod
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZRentDynamicVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:VideoIdentifier];
    if (indexPath.row>=self.dataArray.count) {
        return cell;
    }
    [cell setData:_dataArray[indexPath.row]];
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    WeakSelf;
//    return [tableView fd_heightForCellWithIdentifier:VideoIdentifier cacheByIndexPath:indexPath configuration:^(ZZRentDynamicVideoCell *cell) {
//        [cell setData:weakSelf.dataArray[indexPath.row]];
//    }];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row>=self.dataArray.count) {
        return;
    }
    [self gotoPlayerDetail:self.dataArray[indexPath.row]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_dataArray && _dataArray.count == 0) {
        return 300;
    }
    else {
        return 0.1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_dataArray && _dataArray.count == 0) {
        if (!self.isLoadCompleted) {
            return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
        }
        _footer.stateLabel.hidden = YES;
        ZZUserVideoEmptyView *emptyView = [[ZZUserVideoEmptyView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
        emptyView.topOffset = -10;
        if ([self.user.uid isEqualToString:[ZZUserHelper shareInstance].loginer.uid]) {
            emptyView.contentLabel.text = @"快去发个瞬间吧";
            emptyView.recordBtn.hidden = NO;
        } else {
            emptyView.contentLabel.text = @"TA还没有视频";
            emptyView.recordBtn.hidden = YES;
        }
        emptyView.touchRecord = ^{
            [self gotoRecordView];
        };
        return emptyView;
    } else {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (_scrollLock) {
        [scrollView setContentOffset:CGPointZero];
    }
    if (self.scrollToTop && offsetY <= 0) {  //滑到顶部时通知父列表
        _scrollLock = YES;
        [scrollView setContentOffset:CGPointZero];
        !self.scrollToTop ? : self.scrollToTop();
    }
}

#pragma mark - Navigation
- (void)gotoPlayerDetail:(ZZUserVideoListModel *)model {
    if (_pushBarHide) {
        _pushBarHide();
    }
    WeakSelf;
    ZZPlayerViewController *controller = [[ZZPlayerViewController alloc] init];
    controller.canPop = YES;
    controller.fromLiveStream = _fromLiveStream;
    controller.canLoadMore = YES;
    controller.dataArray = _dataArray;
    NSIndexPath *path = [NSIndexPath indexPathForRow:[_dataArray indexOfObject:model] inSection:0];
    controller.dataIndexPath = path;
    controller.uid = self.user.uid;
    controller.playType = PlayTypeUserVideo;
    controller.deleteCallBack = ^{
        //这个地方都没有刷新一说
        weakSelf.dataArray = nil;
        [weakSelf loadMoreData];
    };
    controller.buyWxCallBack = ^{
        if (weakSelf.buyWxCallBack) {
            weakSelf.buyWxCallBack();
        }
    };
    controller.userVideo = model;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)gotoRecordView {
    [ZZUtils checkRecodeAuth:^(BOOL authorized) {
        if (authorized) {
            ZZRecordViewController *controller = [[ZZRecordViewController alloc] init];
            ZZNavigationController *navCtl = [[ZZNavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:navCtl animated:YES completion:nil];
        }
    }];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
    
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
