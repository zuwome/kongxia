//
//  ZZRentMemedaQuestionViewController.m
//  zuwome
//
//  Created by angBiu on 16/8/11.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZRentMemedaQuestionViewController.h"

#import "ZZRentMemedaQuestionCell.h"

#import "ZZMemedaQuestionModel.h"

@interface ZZRentMemedaQuestionViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView                     *_tableView;
    NSMutableArray                  *_dataArray;
}

@end

@implementation ZZRentMemedaQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"选择问题";
    
    [self createViews];
    [self loadData];
}

- (void)createViews
{
    _tableView = [[UITableView alloc] init];
    [_tableView registerClass:[ZZRentMemedaQuestionCell class] forCellReuseIdentifier:@"mycell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark - Data

- (void)loadData
{
    NSDictionary *aDict = nil;
    if (_isPrivate) {
        aDict = @{@"type":[NSNumber numberWithInteger:2]};
    }
    [ZZMemedaQuestionModel getMemedaQuestions:aDict next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            _dataArray = [ZZMemedaQuestionModel arrayOfModelsFromDictionaries:data error:nil];
            [_tableView reloadData];
        }
    }];
}

#pragma mark - UITableViewMethod

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZRentMemedaQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    [self setupCell:cell indexPath:indexPath];
    return cell;
}

- (void)setupCell:(ZZRentMemedaQuestionCell *)cell indexPath:(NSIndexPath *)indexPath
{
    [cell setData:_dataArray[indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    return [tableView fd_heightForCellWithIdentifier:@"mycell" cacheByIndexPath:indexPath configuration:^(id cell) {
        [weakSelf setupCell:cell indexPath:indexPath];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZMemedaQuestionModel *model = _dataArray[indexPath.row];
    if (_selectCallBack) {
        _selectCallBack(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
