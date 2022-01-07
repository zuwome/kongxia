//
//  ZZMessageCommentViewController.m
//  zuwome
//
//  Created by angBiu on 16/9/19.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZMessageCommentViewController.h"
#import "ZZRentViewController.h"
#import "ZZVideoCommentViewController.h"
#import "ZZPlayerViewController.h"
#import "ZZRecordViewController.h"

#import "ZZMessageCommentCell.h"
#import "ZZMessageCommentEmptyView.h"

#import "ZZMessageDynamicModel.h"
#import "ZZMessageCommentModel.h"
#import "ZZNotNetEmptyView.h" //没网络的占位图
#import "ZZAlertNotNetEmptyView.h" // 已经加载过数据下拉加载的时候显示的
#import "HttpDNS.h"
@interface ZZMessageCommentViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) ZZMessageCommentModel *commentModel;
@property (nonatomic, strong) ZZMessageCommentEmptyView *emptyView;
@property (nonatomic, strong)  ZZNotNetEmptyView *emptyNotWorkView ;
@property (nonatomic, strong)  ZZAlertNotNetEmptyView *alertEmptyView;
@end

@implementation ZZMessageCommentViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"评论";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = kBGColor;
    [self createViews];
    [self loadData];
}

- (void)createViews
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    [_tableView registerClass:[ZZMessageCommentCell class] forCellReuseIdentifier:@"mycell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    _emptyNotWorkView =    [ZZNotNetEmptyView showNotNetWorKEmptyViewWithTitle:nil imageName:nil frame:_tableView.frame viewController:self];
    //    当网络从没网状态到有网状态判断如果当前请求数据为空  就重新请求
    WS(weakSelf);
    [HttpDNS shareInstance].netWorkStatus = ^(NetworkStatus status) {
        if (status != NotReachable &&weakSelf.emptyView.hidden ==NO) {
            [weakSelf.tableView.mj_header beginRefreshing];
        }
    };

}

#pragma mark - Data

- (void)loadData
{
    __weak typeof(self)weakSelf = self;
    _tableView.mj_header = [ZZRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf.tableView.mj_footer resetNoMoreData];
        [weakSelf pullRequest:nil];
    }];
    _tableView.mj_footer = [ZZRefreshFooter footerWithRefreshingBlock:^{
        ZZMessageDynamicModel *lastModel = [weakSelf.dataArray lastObject];
        [weakSelf pullRequest:lastModel.sort_value];
    }];
    [_tableView.mj_header beginRefreshing];
}

- (void)pullRequest:(NSString *)sort_value
{
    NSMutableDictionary *aDict = [@{@"type":@"all_reply"} mutableCopy];
    if (sort_value) {
        [aDict setObject:sort_value forKey:@"sort_value"];
    }
    [ZZMessageDynamicModel getMyDynamicList:aDict next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [_tableView.mj_footer resetNoMoreData];
        if (error) {
            if (error.code ==1111) {
                if (self.dataArray.count<=0) {
                    self.emptyView.hidden = NO;
                }else{
                    self.emptyView.hidden = YES;
                    [self.alertEmptyView showView:self];
                }
            }else{
                [ZZHUD showErrorWithStatus:error.message];
            }
        } else if (data) {
            self.emptyView.hidden = YES;

            NSMutableArray *d = [ZZMessageCommentModel arrayOfModelsFromDictionaries:data error:nil];
            if (d.count == 0) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }
            if (sort_value) {
                [_dataArray addObjectsFromArray:d];
            } else {
                _dataArray = d;
            }
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
    ZZMessageCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    [self setupCell:cell indexPath:indexPath];
    return cell;
}

- (void)setupCell:(ZZMessageCommentCell *)cell indexPath:(NSIndexPath *)indexPath
{
    [cell setData:_dataArray[indexPath.row]];
    cell.touchHead = ^{
        [self headBtnClick:indexPath];
    };
    cell.touchNickname = ^{
        [self nicknameBtnClick:indexPath];
    };
    cell.touchComment = ^{
        [self commentBtnClick:indexPath];
    };
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:@"mycell" cacheByIndexPath:indexPath configuration:^(id cell) {
        [self setupCell:cell indexPath:indexPath];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZMessageDynamicModel *model = _dataArray[indexPath.row];
    
    if (model.message.mmd.mid) {
        [self gotoMmdDetail:model];
    } else if (model.message.sk.skId) {
        [self gotoSKDetail:model];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIButtonMethod

- (void)headBtnClick:(NSIndexPath *)indexPath
{
    ZZMessageCommentModel *model = _dataArray[indexPath.row];
    [self gotoUserPage:model.message.from];
}

- (void)nicknameBtnClick:(NSIndexPath *)indexPath
{
    ZZMessageCommentModel *model = _dataArray[indexPath.row];
    [self gotoUserPage:model.message.reply.reply_which_reply.user];
}

- (void)gotoMmdDetail:(ZZMessageDynamicModel *)model
{
    ZZPlayerViewController *controller = [[ZZPlayerViewController alloc] init];
    controller.mid = model.message.mmd.mid;
    [self.navigationController pushViewController:controller animated:YES];
    controller.firstMMDModel = model.message.mmd;
}

- (void)gotoSKDetail:(ZZMessageDynamicModel *)model
{
    ZZPlayerViewController *controller = [[ZZPlayerViewController alloc] init];
    controller.skId = model.message.sk.skId;
    [self.navigationController pushViewController:controller animated:YES];
    controller.firstSkModel = model.message.sk;
}

- (void)gotoUserPage:(ZZUser *)user
{
    ZZRentViewController *controller = [[ZZRentViewController alloc] init];
    controller.uid = user.uid;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)commentBtnClick:(NSIndexPath *)indexPath
{
    WeakSelf;
    _commentModel = _dataArray[indexPath.row];
    ZZVideoCommentViewController *controller = [[ZZVideoCommentViewController alloc] init];
    controller.nickName = _commentModel.message.from.nickname;
    controller.touchComment = ^(NSString *content) {
        [weakSelf commentWithContent:content];
    };
    [self presentViewController:controller animated:YES completion:nil];
}

//评论
- (void)commentWithContent:(NSString *)content
{
    NSString *replyId = _commentModel.message.reply.replyId;
    if (!replyId) {
        replyId = _commentModel.message.sk_reply.replyId;
    }
    NSMutableDictionary *aDict = [@{@"content":content} mutableCopy];
    [aDict setObject:replyId forKey:@"reply_which_reply"];
    if (_commentModel.message.sk.skId) {
        [ZZSKModel commentMememdaParam:aDict skId:_commentModel.message.sk.skId next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else {
                if (error) {
                    [ZZHUD showErrorWithStatus:error.message];
                } else {
                    [ZZHUD showSuccessWithStatus:@"评论成功"];
                }
            }
        }];
    } else {ZZMemedaModel *model = [[ZZMemedaModel alloc] init];
        [model commentMememdaParam:aDict mid:_commentModel.message.mmd.mid next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
            if (error) {
                [ZZHUD showErrorWithStatus:error.message];
            } else {
                [ZZHUD showSuccessWithStatus:@"评论成功"];
            }
        }];
    }
}

- (void)gotoRecord
{
    [ZZUtils checkRecodeAuth:^(BOOL authorized) {
        if (authorized) {
            ZZRecordViewController *controller = [[ZZRecordViewController alloc] init];
            ZZNavigationController *navCtl = [[ZZNavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:navCtl animated:YES completion:nil];
        }
    }];
}

#pragma mark - lazyload

- (ZZMessageCommentEmptyView *)emptyView
{
    WeakSelf;
    if (!_emptyView) {
        _emptyView = [[ZZMessageCommentEmptyView alloc] init];
        [self.view addSubview:_emptyView];
        
        [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
        
        _emptyView.touchRecord = ^{
            [weakSelf gotoRecord];
        };
    }
    return _emptyView;
}

- (ZZAlertNotNetEmptyView *)alertEmptyView {
    if (!_alertEmptyView) {
        _alertEmptyView = [[ZZAlertNotNetEmptyView alloc]init];
        [_alertEmptyView alertShowViewController:self];
    }
    return _alertEmptyView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
