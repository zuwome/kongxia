//
//  ZZOrdeListViewController.m
//  zuwome
//
//  Created by angBiu on 16/8/31.
//  Copyright © 2016年 zz. All rights reserved.
//

#import "ZZOrderListViewController.h"
#import "ZZOrderDetailViewController.h"
#import "ZZOrderLiveStreamDetailVC.h"

#import "ZZOrderListHeadView.h"
#import "ZZOrderListCell.h"
#import "ZZOrderEmptyView.h"
#import "ZZNotNetEmptyView.h" //没网络的占位图
#import "ZZAlertNotNetEmptyView.h" // 已经加载过数据下拉加载的时候显示的
#import "HttpDNS.h"
@interface ZZOrderListViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZZOrderListHeadView *headView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) ZZOrderEmptyView *emptyView;
@property (nonatomic, strong)  ZZNotNetEmptyView *emptyNotWorkView ;
@property (nonatomic, strong)  ZZAlertNotNetEmptyView *alertEmptyView;
@end

@implementation ZZOrderListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self mangerRedPoint];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的档期";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = kBGColor;

    [self createViews];
}

- (void)createViews {
    [self.view addSubview:self.headView];
    [self.view addSubview:self.tableView];
 
    _emptyNotWorkView =   [ZZNotNetEmptyView showNotNetWorKEmptyViewWithTitle:nil imageName:nil frame:_tableView.frame viewController:self];

    [self.view bringSubviewToFront:self.headView];
    //    当网络从没网状态到有网状态判断如果当前请求数据为空  就重新请求
    WS(weakSelf);
    [HttpDNS shareInstance].netWorkStatus = ^(NetworkStatus status) {
        if (status != NotReachable &&weakSelf.emptyView.hidden ==NO) {
            [weakSelf.tableView.mj_header beginRefreshing];
        }
    };

    switch (_type) {
        case OrderListTypeAll:
        {
            [self.headView setSelectIndex:0];
        }
            break;
        case OrderListTypeIng:
        {
            [self.headView setSelectIndex:1];
        }
            break;
        case OrderListTypeComment:
        {
            [self.headView setSelectIndex:2];
        }
            break;
        case OrderListTypeDone:
        {
            [self.headView setSelectIndex:3];
        }
            break;
        default:
            break;
    }
    
    [self loadData];
}

#pragma mark - Data

- (void)loadData
{
    WeakSelf;
    self.tableView.mj_header = [ZZRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf pullWithStatus:[weakSelf status] lt:nil];
    }];
    self.tableView.mj_footer = [ZZRefreshFooter footerWithRefreshingBlock:^{
        ZZOrder *order = [weakSelf.dataArray lastObject];
        [weakSelf pullWithStatus:[weakSelf status] lt:order.created_at];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)managerType:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            _type = OrderListTypeAll;
        }
            break;
        case 1:
        {
            _type = OrderListTypeIng;
        }
            break;
        case 2:
        {
            _type = OrderListTypeComment;
        }
            break;
        case 3:
        {
            _type = OrderListTypeDone;
        }
            break;
        default:
            break;
    }
}

- (NSString *)status
{
    NSString *s = @"";
    switch (_type) {
        case OrderListTypeIng:
        {
            s = @"ing";
        }
            break;
        case OrderListTypeComment:
        {
            s = @"commenting";
            [ZZUserHelper shareInstance].unreadModel.order_commenting = NO;
        }
            break;
        case OrderListTypeDone:
        {
            s = @"done";
            [ZZUserHelper shareInstance].unreadModel.order_done = NO;
        }
            break;
        default:
            break;
    }
    [self mangerRedPoint];
    return s;
}

- (void)pullWithStatus:(NSString *)status lt:(NSString *)lt {
    [ZZOrder pullAllWithStatus:status lt:lt next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_footer resetNoMoreData];
        if (error) {
            if (error.code ==1111) {
                if (self.dataArray.count<=0) {
                    self.emptyNotWorkView.hidden = NO;
                }else{
                    self.emptyNotWorkView.hidden = YES;
                    [self.alertEmptyView showView:self];
                }
            }else{
                [ZZHUD showErrorWithStatus:error.message];
            }
        
        } else if (data) {
            self.emptyNotWorkView.hidden = YES;

            NSMutableArray *d = [ZZOrder arrayOfModelsFromDictionaries:data error:nil];
            if (d.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            if (lt) {
                [self.dataArray addObjectsFromArray:d];
            } else {
                self.dataArray = d;
            }
            [self.tableView reloadData];
            
            if (_type == OrderListTypeAll) {
                if (_dataArray.count == 0) {
                    self.emptyView.hidden = NO;
                    self.tableView.hidden = YES;
                } else {
                    self.emptyView.hidden = YES;
                    self.tableView.hidden = NO;
                }
            }
        }
    }];
}

- (void)mangerRedPoint {
    NSInteger count = [ZZUserHelper shareInstance].unreadModel.order_ongoing_count;
    if (count) {
        _headView.ingBadgeView.count = count;
        _headView.ingBadgeView.hidden = NO;
    } else {
        _headView.ingBadgeView.hidden = YES;
    }
    if ([ZZUserHelper shareInstance].unreadModel.order_commenting) {
        _headView.commentRedPointView.hidden = NO;
    } else {
        _headView.commentRedPointView.hidden = YES;
    }
    if ([ZZUserHelper shareInstance].unreadModel.order_done) {
        _headView.doneRedPointView.hidden = NO;
    } else {
        _headView.doneRedPointView.hidden = YES;
    }
}

#pragma mark - UITableViewMethod
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"mycell";
    
    ZZOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[ZZOrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    ZZOrder *order = _dataArray[indexPath.row];
    NSLog(@"order total price is %@, pure total price: %f", order.totalPrice, [order pureTotalPrice]);
    [cell setData:order];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;//默认没有编辑风格
    ZZOrder *order = self.dataArray[indexPath.row];
    if ([self canDelete:order]) {
        result = UITableViewCellEditingStyleDelete;
    }
    return result;
}

- (BOOL)canDelete:(ZZOrder *)order {
    if ([order.status isEqualToString:@"cancel"]) {
        return YES;
    }
    if ([order.status isEqualToString:@"refused"]) {
        return YES;
    }
    if ([order.status isEqualToString:@"commenting"]) {
        return YES;
    }
    if ([order.status isEqualToString:@"commented"]) {
        return YES;
    }
    if ([order.status isEqualToString:@"refusedRefund"]) {
        return YES;
    }
    if ([order.status isEqualToString:@"refunded"]) {
        return YES;
    }
    if ([order.status isEqualToString:@"video_completed"]) {
        return YES;
    }
    return NO;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle ==UITableViewCellEditingStyleDelete) {
        [UIAlertView showWithTitle:@"删除本条记录" message:@"删除本条记录后无法恢复，您将无法对本次邀约进行操作" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                ZZOrder *order = _dataArray[indexPath.row];
                [ZZOrder deleteOrderWithOrderId:order.id next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
                    if (data) {
                        [_dataArray removeObjectAtIndex:indexPath.row];
                        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                    }
                }];
            }
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAK_SELF();
    ZZOrder *order = _dataArray[indexPath.row];
    if (order.type == 1) {  //1、正常订单
        ZZOrderDetailViewController *controller = [[ZZOrderDetailViewController alloc] init];
        controller.orderId = order.id;
        controller.orderChange = ^(ZZOrder *order) {
            [self.tableView reloadData];
        };
        controller.callBack = ^(NSString *status) {
            if ([status isEqualToString:@"commenting"] || [status isEqualToString:@"refused"] || [status isEqualToString:@"commented"]) {
                [_dataArray removeObject:order];
            }
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:controller animated:YES];
    } else if (order.type == 2) {   //2、派单线上视频
    
        ZZOrderLiveStreamDetailVC *vc = [ZZOrderLiveStreamDetailVC new];
        vc.orderId = order.id;
        [vc setUpdateListBlock:^{
            [weakSelf pullWithStatus:[weakSelf status] lt:nil];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (order.type == 3) {
        
        ZZOrderDetailViewController *controller = [[ZZOrderDetailViewController alloc] init];
        controller.orderId = order.id;
        controller.orderChange = ^(ZZOrder *order) {
            [self.tableView reloadData];
        };
        controller.callBack = ^(NSString *status) {
            if ([status isEqualToString:@"commenting"] || [status isEqualToString:@"refused"] || [status isEqualToString:@"commented"]) {
                [_dataArray removeObject:order];
            }
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:controller animated:YES];
    } else if (order.type == 4) {//闪聊
        ZZOrderLiveStreamDetailVC *vc = [ZZOrderLiveStreamDetailVC new];
        vc.orderId = order.id;
        [vc setUpdateListBlock:^{
            [weakSelf pullWithStatus:[weakSelf status] lt:nil];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - lazy
- (ZZOrderListHeadView *)headView
{
    if (!_headView) {
        WeakSelf;
        _headView = [[ZZOrderListHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _headView.selectedIndex = ^(NSInteger index){
            [weakSelf managerType:index];
            [weakSelf.tableView.mj_header beginRefreshing];
        };
    }
    
    return _headView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _headView.height, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - _headView.height-SafeAreaBottomHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    }
    
    return _tableView;
}

- (ZZOrderEmptyView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[ZZOrderEmptyView alloc] init];
        [self.view addSubview:_emptyView];
        
        [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self.view);
            make.top.mas_equalTo(_headView.mas_bottom);
        }];
    }
    return _emptyView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
