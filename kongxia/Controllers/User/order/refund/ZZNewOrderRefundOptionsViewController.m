//
//  ZZNewOrderRefundOptionsViewController.m
//  zuwome
//
//  Created by 潘杨 on 2018/5/25.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ZZNewOrderRefundOptionsViewController.h"
#import "ZZRuleHelper.h"
#import "ZZCancelOrderDetailCell.h"
#import "ZZNewOrderResonCell.h"
#import "ZZPlatformRentRulesFootView.h"
#import "ZZOrderOptionModel.h"
#import "ZZLinkWebViewController.h"
#import "ZZOrderApplyRefundReasonVC.h"//选择理由并上传证据界面
#import "ZZOrderChooseReasonHeaderView.h"

static NSString *cancelOrderDetailCellID = @"ZZCancelOrderDetailCellID";
static NSString *newOrderResonCellID = @"ZZNewOrderResonCellID";

@interface ZZNewOrderRefundOptionsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
/**
 第二区的标题
 */
@property(nonatomic,strong) NSArray *secondArray;
@property (nonatomic,strong) ZZOrderRefundModel *refundModel;
@end

@implementation ZZNewOrderRefundOptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择理由";
    [self setUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)setUI {
    
    [self.tableView registerClass:[ZZCancelOrderDetailCell class] forCellReuseIdentifier:cancelOrderDetailCellID];
    [self.tableView registerClass:[ZZNewOrderResonCell class] forCellReuseIdentifier:newOrderResonCellID];
    [self.tableView  registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterViewID"];
    [self.view addSubview:self.tableView];
    [self.tableView  registerClass:[ZZOrderChooseReasonHeaderView class] forHeaderFooterViewReuseIdentifier:@"ZZOrderChooseReasonHeaderViewID"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [self loadData];

}

#pragma mark - UITableViewMethod

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section==1?2:1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        ZZCancelOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cancelOrderDetailCellID];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.order = self.order;
        WS(weakSelf);
        cell.goToOrderInfo = ^{
            [weakSelf goToOrderInfo];
        };
        return cell;
    }else {
        ZZNewOrderResonCell *cell  = [tableView dequeueReusableCellWithIdentifier:newOrderResonCellID];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [cell setModel:self.secondArray[indexPath.row]];
        return cell;
    }
    
 }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 171;
    }else  {
        if (indexPath.row==0) {
            return 75;
        }else{
            return 85;
        }
        
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 6.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==1) {
        return 50;
    }else{
        return 0;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section ==1) {
        ZZOrderChooseReasonHeaderView *footView = (ZZOrderChooseReasonHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ZZOrderChooseReasonHeaderViewID"];
        return footView;
    }else{
        return nil;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterViewID"];
    footView.backgroundColor = HEXCOLOR(0xf5f5f5);
    return footView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section==1) {
        
        ZZOrderApplyRefundReasonVC *orderDetailVC = [[ZZOrderApplyRefundReasonVC alloc]init];
        orderDetailVC.order = self.order;
        orderDetailVC.callBack  = self.callBack;
        orderDetailVC.isFromChat = self.isFromChat;
        orderDetailVC.isModify = self.isModify;
        ZZNewOrderResonCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
        orderDetailVC.model = cell.model;
        orderDetailVC.navigationItem.title = @"申请退款";
        [self.navigationController pushViewController:orderDetailVC animated:YES];
    }
}

- (void)loadData {
    NSDictionary *aDict = @{@"type":@"refund_deposit"};
    if (![self.order.status isEqualToString:@"paying"]) {
        aDict = @{@"type":@"refund"};
    }
    [ZZRuleHelper pullRefund:aDict next:^(ZZError *error, id data, NSURLSessionDataTask *task) {
        if (error) {
            [ZZHUD showErrorWithStatus:error.message];
        } else {
            self.navigationRightDoneBtn.userInteractionEnabled = YES;
            _refundModel = [[ZZOrderRefundModel alloc] initWithDictionary:data error:nil];
            
            /**第二个区域*/
            ZZInvitationModel *myModel = [[ZZInvitationModel alloc]init];
            myModel.title = @"自己的原因";
            myModel.detailTitle = @"为保证双方的公平性，达人同意后将不会惩罚达人";
            myModel.detailArray = _refundModel.mine;
            ZZInvitationModel *otherModel = [[ZZInvitationModel alloc]init];
            otherModel.title = @"对方的原因";
            otherModel.detailTitle = @"需上传证据，对方同意或申诉后可退租金并对达人做出相应惩罚";
            otherModel.detailArray = _refundModel.yours;
            
            self.secondArray = @[myModel,otherModel];

            /**footView*/
             NSLog(@"PY_ 选择理由接口 达人 %@\n",_refundModel.illegal_to);
            ZZPlatformRentRulesFootView *view = [[ZZPlatformRentRulesFootView alloc]init];
            if ([[ZZUserHelper shareInstance].loginer.uid isEqualToString:self.order.from.uid]) {
                    //用户查看违规行为手册
                [view setRentRulesString:_refundModel.illegal_to];

            }else{    //达人查看违规行为手册
                [view setRentRulesString:_refundModel.illegal_from];
            }
            WS(weakSelf);
            view.touchHead = ^{
                [weakSelf goToRuleInfo];
            };
            _tableView.tableFooterView  = view;
            
            [self.tableView reloadData];
        }
    }];
}

/**
 违规行为手册
 */
- (void)goToRuleInfo {
    NSString *urlString = H5Url.violationManual;
    ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc] init];
    controller.urlString = urlString;
    controller.isPush = YES;
    controller.isShowLeftButton = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 订单详情
 */
- (void)goToOrderInfo {
    NSString *urlString = [NSString stringWithFormat:@"%@/api/order/price_detail/page?access_token=%@&oid=%@",kBase_URL,[ZZUserHelper shareInstance].oAuthToken,_order.id];
//    if (_isEdit) {
//        urlString = [NSString stringWithFormat:@"%@&&oid=%@",urlString,_order.id];
//    }
    ZZLinkWebViewController *controller = [[ZZLinkWebViewController alloc] init];
    controller.urlString = urlString;
    controller.navigationItem.title = @"价格详情";
    [self.navigationController pushViewController:controller animated:YES];

}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
