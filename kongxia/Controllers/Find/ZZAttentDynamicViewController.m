//
//  ZZMessageAttentDynamicViewController.m
//  zuwome
//
//  Created by angBiu on 16/8/22.
//  Copyright © 2016年 zz. All rights reserved.
//

static NSString *VideoIdentifier = @"videocell";
static NSString *ContentIdentifier = @"contentcell";
static NSString *TextIdentifier = @"textcell";

#import "ZZAttentDynamicViewController.h"
#import "ZZRentViewController.h"
#import "ZZPlayerViewController.h"

#import "ZZDynamicVideoCell.h"
#import "ZZDynamicContentCell.h"
#import "ZZDynamicTextCell.h"

#import "ZZMessageAttentDynamicModel.h"
#import "NJKScrollFullScreen.h"
//网络占位图
#import "ZZNotNetEmptyView.h"
#import "ZZAlertNotNetEmptyView.h"
#import "HttpDNS.h"
/**
 关注人的动态
 */
@interface ZZAttentDynamicViewController () <UITableViewDataSource,UITableViewDelegate,NJKScrollFullscreenDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *cellHeightArray;
@property (nonatomic, strong) NJKScrollFullScreen *scrollProxy;
//网络占位图
@property (nonatomic, strong)  ZZNotNetEmptyView *emptyView ;
@property (nonatomic, strong)  ZZAlertNotNetEmptyView *alertEmptyView;
@end

@implementation ZZAttentDynamicViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([ZZUserHelper shareInstance].updateAttentList) {
        if (self.tableView.mj_header != nil) {
            [self.tableView.mj_header beginRefreshing];
        } else {
            [self loadData];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createViews];
    [self loadData];
    self.view.backgroundColor = kBGColor;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadViews)
                                                 name:kMsg_UserLogin
                                               object:nil];
    //    当网络从没网状态到有网状态判断如果当前请求数据为空  就重新请求
    WS(weakSelf);
    [HttpDNS shareInstance].netWorkStatus = ^(NetworkStatus status) {
        if (status != NotReachable &&weakSelf.emptyView.hidden ==NO) {
            [weakSelf.tableView.mj_header beginRefreshing];
        }
    };
}

- (void)createViews
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    [_tableView registerClass:[ZZDynamicVideoCell class] forCellReuseIdentifier:VideoIdentifier];
    [_tableView registerClass:[ZZDynamicContentCell class] forCellReuseIdentifier:ContentIdentifier];
    [_tableView registerClass:[ZZDynamicTextCell class] forCellReuseIdentifier:TextIdentifier];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor clearColor];
    _scrollProxy = [[NJKScrollFullScreen alloc] initWithForwardTarget:self];
    self.tableView.delegate = (id)_scrollProxy;
    _scrollProxy.delegate = self;
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - Data

- (void)loadData
{
    [ZZUserHelper shareInstance].unreadModel.dynamic_following = NO;
    __weak typeof(self)weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.tableView.mj_footer resetNoMoreData];
        [weakSelf pullRequest:nil];
    }];
    _tableView.mj_footer = [ZZRefreshFooter footerWithRefreshingBlock:^{
        ZZMessageAttentDynamicModel *lastModel = [weakSelf.dataArray lastObject];
        [weakSelf pullRequest:lastModel.sort_value];
    }];
    [_tableView.mj_header beginRefreshing];
}

- (void)pullRequest:(NSString *)sort_value
{
    NSDictionary *aDict = nil;
    if (sort_value) {
        aDict = @{@"sort_value":sort_value};
    }
    [ZZMessageAttentDynamicModel getAttentDynamic:aDict next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
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

            [ZZUserHelper shareInstance].updateAttentList = NO;
            NSMutableArray *array = [ZZMessageAttentDynamicModel arrayOfModelsFromDictionaries:data error:nil];
            if (sort_value) {
                [_dataArray addObjectsFromArray:array];
                if (array.count == 0) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            } else {
                [self.cellHeightArray removeAllObjects];
                _dataArray = array;
            }
            [self calculateCellHeight:array];
            [_tableView reloadData];
        }
       
    }];
}

- (void)reloadViews
{
    [ZZUserHelper shareInstance].unreadModel.dynamic_following = NO;
    if (_tableView.mj_header) {
        [_tableView.mj_header beginRefreshing];
    } else {
        [self loadData];
    }
}

- (void)calculateCellHeight:(NSMutableArray *)array
{
    for (ZZMessageAttentDynamicModel *model in array) {
        CGFloat height = [self calculateRowHeight:model];
        [self.cellHeightArray addObject:[NSNumber numberWithFloat:height]];
    }
}

- (CGFloat)calculateRowHeight:(ZZMessageAttentDynamicModel *)model
{
    NSInteger type = [self getCellTypeWithModel:model];
    CGFloat cellHeight = 0;
    switch (type) {
        case 0:
        {
            CGFloat nameHeight = [ZZUtils heightForCellWithText:model.from.nickname fontSize:13 labelWidth:SCREEN_WIDTH];
            CGFloat contentHeight = [ZZUtils heightForCellWithText:model.content fontSize:14 labelWidth:(SCREEN_WIDTH - 90 - 10)];
            cellHeight = 15 + nameHeight + 8 + contentHeight + 10 + SCREEN_WIDTH - 10 + 56;
        }
            break;
        case 1:
        {
            CGFloat nameHeight = [ZZUtils heightForCellWithText:model.from.nickname fontSize:13 labelWidth:SCREEN_WIDTH];
            if (model.star == 1) {
                CGFloat contentHeight = [ZZUtils heightForCellWithText:model.content fontSize:14 labelWidth:(SCREEN_WIDTH - 90 - 10 - 55)];
                cellHeight = 15 + nameHeight + 8 + contentHeight + 30;
            } else {
                CGFloat contentHeight = [ZZUtils heightForCellWithText:model.content fontSize:14 labelWidth:(SCREEN_WIDTH - 90 - 10)];
                cellHeight = 15 + nameHeight + 8 + contentHeight + 15;
            }
        }
            break;
        case 2:
        {
            CGFloat nameHeight = [ZZUtils heightForCellWithText:model.from.nickname fontSize:13 labelWidth:SCREEN_WIDTH];
            CGFloat contentHeight = [ZZUtils heightForCellWithText:model.content fontSize:14 labelWidth:(SCREEN_WIDTH - 90 - 10 - 55)];
            CGFloat scale = SCREEN_WIDTH/375.0;
            CGFloat itemWidth = (SCREEN_WIDTH - 10 - 40 - 18 - 1.5 - 10 - 3*15*scale)/4.0;
            NSInteger count = 0;
            if (model.users.count != 0) {
                count = model.users.count/4.1 + 1;
            }else if (model.mmds.count != 0) {
                count = model.mmds.count/4.1 + 1;
            }else if (model.sks.count != 0) {
                count = model.sks.count/4.1 + 1;
            }
            if (model.show && count > 1) {
                cellHeight = 15 + nameHeight + 8 + contentHeight + 10 + 15 + (count - 1)*10 + count*itemWidth;
            } else {
                cellHeight = 15 + nameHeight + 8 + contentHeight + 10 + 15 + MIN(count, 1)*itemWidth;
            }
        }
            break;
        default:
            break;
    }
    return cellHeight;
}

#pragma mark - UITableViewMethod

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZMessageAttentDynamicModel *model = _dataArray[indexPath.row];
    NSInteger type = [self getCellTypeWithModel:model];
    switch (type) {
        case 0:
        {
            ZZDynamicVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:VideoIdentifier];
            [cell setData:model];
            cell.touchHead = ^{
                [self gotoUserPage:model.from];
            };
            return cell;
        }
            break;
        case 1:
        {
            ZZDynamicTextCell *cell = [tableView dequeueReusableCellWithIdentifier:TextIdentifier];
            [cell setData:model];
            cell.touchHead = ^{
                [self gotoUserPage:model.from];
            };
            return cell;
        }
            break;
        default:
        {
            ZZDynamicContentCell *cell = [tableView dequeueReusableCellWithIdentifier:ContentIdentifier];
            [self setupCell:cell indexPath:indexPath];
            return cell;
        }
            break;
    }
}

- (void)setupCell:(ZZDynamicContentCell *)cell indexPath:(NSIndexPath *)indexPath
{
    ZZMessageAttentDynamicModel *model = _dataArray[indexPath.row];
    [cell setData:model];
    cell.touchStatus = ^{
        [self statusBtnClick:indexPath];
    };
    cell.userSelectIndex = ^(NSInteger index) {
        [self gotoUserPage:indexPath index:index];
    };
    cell.mmdSelectIndex = ^(NSInteger index) {
        [self gotoVideoShow:indexPath index:index];
    };
    cell.skSelectIndex = ^(NSInteger index) {
        ZZSKModel *skModel = model.sks[index];
        [self gotoPlayerDetailWithSkId:skModel];
    };
    cell.touchHead = ^{
        [self gotoUserPage:model.from];
    };
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.cellHeightArray[indexPath.row] floatValue];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    
    if (_dataArray && _dataArray.count == 0) {
        footView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"icon_wx_read_empty"];
        [footView addSubview:imgView];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(footView.mas_centerY).offset(-20);
            make.centerX.mas_equalTo(footView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(185, 154));
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = HEXCOLOR(0xD8D8D8);
        label.font = [UIFont systemFontOfSize:15];
        label.text = @"关注其他人，去发现更多新鲜事";
        [footView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(footView.mas_centerX);
            make.top.mas_equalTo(imgView.mas_bottom).offset(30);
        }];
    }
    
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_dataArray && _dataArray.count == 0) {
        return SCREEN_HEIGHT - 64;
    } else {
        return 0.1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZMessageAttentDynamicModel *model = _dataArray[indexPath.row];
    if ([model.type isEqualToString:@"mmd_answer"]) {
        ZZMMDModel *mmdModel = model.mmds[0];
        [self gotoVideoShowWithMid:mmdModel];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else if ([model.type isEqualToString:@"sk"]) {
        ZZSKModel *skModel = model.sks[0];
        [self gotoPlayerDetailWithSkId:skModel];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (NSInteger)getCellTypeWithModel:(ZZMessageAttentDynamicModel *)model
{
    NSInteger type = 0;
    
    if ([model.type isEqualToString:@"mmd_answer"] || [model.type isEqualToString:@"sk"]) {
        type = 0;
    } else if ([model.type isEqualToString:@"city_change"] || [model.type isEqualToString:@"rp_take"] || [model.type isEqualToString:@"rp_add"] || [model.type isEqualToString:@"sys_rp_add"] || [model.type isEqualToString:@"new_user"]) {
        type = 1;
    } else {
        type = 2;
    }
    
    return type;
}

#pragma mark - UIButtonMethod

- (void)statusBtnClick:(NSIndexPath *)indexPath
{
    ZZMessageAttentDynamicModel *model = _dataArray[indexPath.row];
    if (model.show) {
        model.show = NO;
    } else {
        model.show = YES;
    }
    CGFloat height = [self calculateRowHeight:model];
    [self.cellHeightArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithFloat:height]];
    [_tableView beginUpdates];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    [_tableView endUpdates];
}

#pragma mark NJKScrollFullScreen

- (void)scrollFullScreen:(NJKScrollFullScreen *)proxy scrollViewDidScrollUp:(CGFloat)deltaY
{
    if (_didScroll) {
        _didScroll(deltaY);
    }
}

- (void)scrollFullScreen:(NJKScrollFullScreen *)proxy scrollViewDidScrollDown:(CGFloat)deltaY
{
    if (_didScroll) {
        _didScroll(deltaY);
    }
}

- (void)scrollFullScreenScrollViewDidEndDraggingScrollUp:(NJKScrollFullScreen *)proxy
{
    if (_didScrollStatus) {
        _didScrollStatus(NO);
    }
}

- (void)scrollFullScreenScrollViewDidEndDraggingScrollDown:(NJKScrollFullScreen *)proxy
{
    if (_didScrollStatus) {
        _didScrollStatus(YES);
    }
}

#pragma mark - Navigation

- (void)gotoUserPage:(NSIndexPath *)indexPath index:(NSInteger)index
{
    ZZMessageAttentDynamicModel *model = _dataArray[indexPath.row];
    ZZUser *user = model.users[index];
    [self gotoUserPage:user];
}

- (void)gotoUserPage:(ZZUser *)user
{
    ZZRentViewController *controller = [[ZZRentViewController alloc] init];
    controller.uid = user.uid;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    
    if (_pushCallBack) {
        _pushCallBack();
    }
}

- (void)gotoVideoShow:(NSIndexPath *)indexPath index:(NSInteger)index
{
    ZZMessageAttentDynamicModel *model = _dataArray[indexPath.row];
    ZZMMDModel *mmdModel = model.mmds[index];
    [self gotoVideoShowWithMid:mmdModel];
}

- (void)gotoVideoShowWithMid:(ZZMMDModel *)model
{
    ZZPlayerViewController *controller = [[ZZPlayerViewController alloc] init];
    controller.mid = model.mid;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    controller.firstMMDModel = model;
    if (_pushCallBack) {
        _pushCallBack();
    }
}

- (void)gotoPlayerDetailWithSkId:(ZZSKModel *)sk
{
    ZZPlayerViewController *controller = [[ZZPlayerViewController alloc] init];
    controller.skId = sk.id;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    controller.firstSkModel = sk;
    
    if (_pushCallBack) {
        _pushCallBack();
    }
}

#pragma mark - 

- (NSMutableArray *)cellHeightArray
{
    if (!_cellHeightArray) {
        _cellHeightArray = [NSMutableArray array];
    }
    return _cellHeightArray;
}
/**
 无网络弹窗
 */
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
