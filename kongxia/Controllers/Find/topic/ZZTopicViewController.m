//
//  ZZTopicViewController.m
//  zuwome
//
//  Created by angBiu on 2017/4/14.
//  Copyright © 2017年 zz. All rights reserved.
//

#import "ZZTopicViewController.h"
#import "ZZTopicDetailViewController.h"

#import "ZZTopicCell.h"
#import "ZZAnimationTableView.h"

#import "ZZTopicModel.h"

@interface ZZTopicViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) ZZAnimationTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ZZTopicViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"全部话题";
    self.view.backgroundColor = HEXCOLOR(0xf5f5f5);
    [self createViews];
    [self loadData];
}

- (void)createViews
{
    [self.view addSubview:self.tableView];
}

- (void)loadData
{
    WeakSelf;
    self.tableView.mj_header = [ZZRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf pullRequest:nil];
    }];
    self.tableView.mj_footer = [ZZRefreshFooter footerWithRefreshingBlock:^{
        ZZTopicModel *model = [weakSelf.dataArray lastObject];
        [weakSelf pullRequest:model.sort_value];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)pullRequest:(NSString *)sort_value
{
    NSMutableDictionary *aDict = [@{} mutableCopy];
    if (sort_value) {
        [aDict setObject:sort_value forKey:@"sort_value"];
    }
    [ZZTopicModel getTopicsWithParam:aDict next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [self dataCallBack:error data:data task:task sort_value:sort_value];
    }];
}

- (void)dataCallBack:(ZZError *)error data:(id)data task:(NSURLSessionDataTask *)task sort_value:(NSString *)sort_value
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_footer resetNoMoreData];
    if (error) {
        [ZZHUD showErrorWithStatus:error.message];
    } else {
        NSMutableArray *array = [ZZTopicModel arrayOfModelsFromDictionaries:data error:nil];
        
        if (array.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (!sort_value) {
            _dataArray = array;
            if (_requestNewData) {
                _requestNewData(array);
            }
        } else {
            [_dataArray addObjectsFromArray:array];
        }
        
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewMethod

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"mycell";
    ZZTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ZZTopicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setData:self.dataArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (SCREEN_WIDTH - 10)/2.3 + 8;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZTopicModel *model = self.dataArray[indexPath.row];
    ZZTopicDetailViewController *controller = [[ZZTopicDetailViewController alloc] init];
    controller.groupModel = model.group;
    [self.navigationController pushViewController:controller animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableView scrollViewDidScroll:scrollView Animation:YES];
}

#pragma mark - lazyload

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[ZZAnimationTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT-SafeAreaBottomHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
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
