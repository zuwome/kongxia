//
//  ZZAllTopicsViewController.m
//  zuwome
//
//  Created by MaoMinghui on 2018/10/10.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZAllTopicsViewController.h"
#import "ZZTopicClassifyViewController.h"
#import "ZZPostTaskBasicInfoController.h"
#import "ZZSkillsSelectResponseModel.h"
#import "ZZAllTopicsCell.h"

#import "ZZSkillThemesHelper.h"
#import "ZZHomeModel.h"

@interface ZZAllTopicsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView *tableView;

@property (nonatomic) NSArray *topicsArray;

@property (nonatomic, strong) ZZSkillsSelectResponseModel *responseModel;

@end

@implementation ZZAllTopicsViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isFromSkillSelectView = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (isNullString(self.navigationItem.title)) {
        self.navigationItem.title = @"全部分类";
    }
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    if (_isFromSkillSelectView) {
        [self fetchAllSkills];
    }
    else {
        [self loadAllTopics];
    }
    
}

- (void)goToPost:(ZZSkill *)skill {
    ZZPostTaskBasicInfoController *vc = [[ZZPostTaskBasicInfoController alloc] initWithSkill:skill taskType:_taskType];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadAllTopics {
    [[ZZSkillThemesHelper shareInstance] getSkillsCatalogList:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (data) {
            NSMutableArray *tempArray = [NSMutableArray array];
            for (NSDictionary *catalogDict in data) {
                ZZHomeCatalogModel *catalog = [[ZZHomeCatalogModel alloc] initWithDictionary:catalogDict error:nil];
                [tempArray addObject:catalog];
            }
            self.topicsArray = [tempArray copy];
            [self.tableView reloadData];
        }
    }];
}

- (void)fetchAllSkills {
    [ZZRequest method:@"GET" path:@"/api/pd/getSkillWriting" params:@{@"gender" : @(UserHelper.loginer.gender), @"type": @2} next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        }
        else {
            _responseModel = [[ZZSkillsSelectResponseModel alloc] initWithDictionary:data error:nil];
            [self.tableView reloadData];
            //            [self fetchSkillslist];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isFromSkillSelectView) {
        return self.responseModel.skills.count;
    }
    return self.topicsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZAllTopicsCell *cell = [tableView dequeueReusableCellWithIdentifier:AllTopicsCellId forIndexPath:indexPath];
    if (_isFromSkillSelectView) {
        [cell configureData:_responseModel.skills[indexPath.row]];
    }
    else {
        ZZHomeCatalogModel *catalog = self.topicsArray[indexPath.row];
        cell.catalog = catalog;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_isFromSkillSelectView) {
        if (_shouldPopBack) {
           if (self.delegate && [self.delegate respondsToSelector:@selector(allTopicsController:didChooseSkill:)]) {
               [self.delegate allTopicsController:self didChooseSkill:_responseModel.skills[indexPath.row]];
           }
           [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [self goToPost:_responseModel.skills[indexPath.row]];
        }
        
    }
    else {
        ZZHomeCatalogModel *topic = self.topicsArray[indexPath.row];
        ZZTopicClassifyViewController *controller = [[ZZTopicClassifyViewController alloc] init];
        controller.topic = topic;
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (UITableView *)tableView {
    if (nil == _tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 90;
        [_tableView registerClass:[ZZAllTopicsCell class] forCellReuseIdentifier:AllTopicsCellId];
    }
    return _tableView;
}

- (NSArray *)topicsArray {
    if (nil == _topicsArray) {
        _topicsArray = [NSArray array];
    }
    return _topicsArray;
}

@end
